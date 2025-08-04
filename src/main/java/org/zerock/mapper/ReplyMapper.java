package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.zerock.domain.ReplyDTO;

@Mapper
public interface ReplyMapper {
	
	List<ReplyDTO> getList(int num);
	
    void insert(ReplyDTO dto);
    
    void delete(int rnum);
    
    void update(ReplyDTO dto);
    
    List<ReplyDTO> getListPage(@Param("num") int num,
            @Param("offset") int offset,
            @Param("size") int size);

    int countReplies(@Param("num") int num);
}
