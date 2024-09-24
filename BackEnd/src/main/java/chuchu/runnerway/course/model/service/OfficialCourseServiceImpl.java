package chuchu.runnerway.course.model.service;

import chuchu.runnerway.course.dto.RecommendationDto;
import chuchu.runnerway.course.dto.response.OfficialDetailResponseDto;
import chuchu.runnerway.course.dto.response.OfficialListResponseDto;
import chuchu.runnerway.course.entity.Course;
import chuchu.runnerway.course.mapper.CourseMapper;
import chuchu.runnerway.course.model.repository.OfficialCourseRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OfficialCourseServiceImpl implements OfficialCourseService{

    private final WebClient webClient;

    private final OfficialCourseRepository officialCourseRepository;
    private final CourseMapper courseMapper;
    private final RedisTemplate<String, Object> redisTemplate;

    @Override
    public List<OfficialListResponseDto> findAllOfiicialCourse(double lat, double lng) {
        List<Course> courses = officialCourseRepository.findAll(lat, lng);
        getRecommendation();
        return courseMapper.toOfficialListResponseDtoList(courses);
    }

    @Override
    @Cacheable(value = "courseCache", key = "#courseId", unless = "#result == null")
    public OfficialDetailResponseDto getOfficialCourse(Long courseId) {
        Course course = officialCourseRepository.findById(courseId)
                .orElseThrow(NoSuchElementException::new);

        return courseMapper.toOfficialDetailResponseDto(course);
    }

    // 내일 아침에 잘 되는지 확인ㄱㄱ
    @Override
    @Scheduled(cron = "0 0 3 * * *")
    @Transactional
    public void updateAllCacheCountsToDB() {
        Set<String> keys = redisTemplate.keys("courseCache::*");

        if(keys != null && !keys.isEmpty()) {
            // 키에 해당하는 데이터를 가져와, 리스트로 변환
            List<Course> courseList = keys.stream()
                    .map(key -> (Course) redisTemplate.opsForValue().get(key))
                    .filter(course -> course != null)
                    .collect(Collectors.toList());

            officialCourseRepository.saveAll(courseList);

            // 캐시 삭제
            redisTemplate.delete(keys);
        }

    }
































    public void getRecommendation () {
        Flux<RecommendationDto> dto = webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/recommendation")
                        .queryParam("member_id", 13)
                        .build())
                .retrieve()
                .bodyToFlux(RecommendationDto.class);

        dto.subscribe(
                recommendationDto -> {
                    // 추천 DTO의 필드를 출력
                    System.out.println("Course ID: " + recommendationDto.getCourseId());
                    System.out.println("Recommendation Score: " + recommendationDto.getRecommendationScore());
                },
                error -> {
                    // 에러 처리
                    System.err.println("Error occurred: " + error.getMessage());
                },
                () -> {
                    // 완료 시 호출되는 메소드
                    System.out.println("Recommendation retrieval completed.");
                }
        );
    }
}
