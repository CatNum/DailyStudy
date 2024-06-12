
- 什么是DTO
  - DDD中哪些对象是DTO？ DTO-Data Transfer Object，数据传输对象，用作数据传输。 在落地DDD的实践中，由于采用CQRS模式，所以会有大量的Command对象、Query对象以及返回给前端用的ViewModel对象，和其他系统交互的DTO对象，这些对象都应该归类为DTO对象。2021年9月10日