From: Paul Komkoff <i@stingr.net>
Subject: btrfs fallocate woes
Date: Thu, 14 Jan 2010 11:28:39 +0000
Message-ID: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Oh hai

Sorry if it's already fixed, but at least in fedora's
2.6.32.3-10.fc12.i686.PAE btrfs has a regression which can be
illustrated by running the following dumb test:

=== cut here ===
#define _GNU_SOURCE
#define _FILE_OFFSET_BITS 64
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
  int fd = open("testfile", O_CLOEXEC | O_CREAT | O_NOATIME | O_WRONLY, 0666);

  fallocate(fd, 0, 0, 100);

  write(fd, "test", 4);

  close(fd);
}
=== cut here ===

if you run it on ext4, it will create a 4-byte file with "test" in it.
On btrfs, however, the file size would be 4096, and the remaining
space will be filled with zeroes.

I will try more recent kernels with that though.
-- 
This message represents the official view of the voices in my head
