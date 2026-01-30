#include <iostream>
#include <memory>
#include <mutex>

class StreamMem {
private:
  std::mutex buffer_mutex;
  std::shared_ptr<uint32_t> buffer = std::make_shared<uint32_t>(0);

public:
  void reset();
  void update() {
    std::unique_lock lock(buffer_mutex);
    *buffer = 10;
  };
};