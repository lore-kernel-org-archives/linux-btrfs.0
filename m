From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Subject: [BUG] btrfs 2.6.39(vanilla): files created with a particular pattern
 result in error 400
Date: Sun, 29 May 2011 15:54:40 +0000
Message-ID: <BANLkTimAuvsy=MBR5EarasErXOTdS1+-eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec520ea254b5e8304a46c3071
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--bcaec520ea254b5e8304a46c3071
Content-Type: text/plain; charset=UTF-8

Hi, since I switched to vanilla kernel version 2.6.39(from latest
stable 2.6.38), a lot of errors started appearing on my btrfs
partitions, without any hardware failure, power outages or crashes.
The errors look all the same "root 5 inode <inode_number> errors 400"
for all the partitions. I've produced a little c program that is
consistently produces these seemingly faulty files on my system. I've
done so by tracing vuze(a torrent app), which I noticed was the app
that created those files. If I cp those files, the result doesn't have
those errors.
the code creates files which result in this btrfsck output:

root 5 inode 705986 errors 400
found 339059101696 bytes used err is 1
total csum bytes: 330286628
total tree bytes: 845594624
total fs tree bytes: 250171392
btree space waste bytes: 191048782
file data blocks allocated: 402010976256
 referenced 331993735168

P.S. I'm not subscribed to the list.

The code is in the attachment and appended here(don't know if gmail is
gonna mess it up, so I'm attacching it too):

#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define FILE_SIZE 325443890
#define WRT_BYTES 4096

int main(void)
{
	struct stat stat_buf;
	int fd = 0, flag = 0;
	const size_t cnt = FILE_SIZE / WRT_BYTES;
	char arr[WRT_BYTES];
	
	fd = open("this_file_name.mp4",
		O_RDWR|O_CREAT, 0666);
	
	fstat(fd, &stat_buf);
	
	flag = fcntl(fd, F_GETFD);
	fcntl(fd, F_SETFD, flag | FD_CLOEXEC);
	
	lseek(fd, 0, SEEK_CUR);
	
	ftruncate(fd, FILE_SIZE);
	
	lseek(fd, 0, SEEK_SET);
	
	for (int i = 0; i < cnt; ++i) {
		write(fd, arr, WRT_BYTES);
	}
	
	write(fd, arr, FILE_SIZE - (WRT_BYTES * cnt));
	
	close(fd);
	
	return 0;
}

--
Giangiacomo

--bcaec520ea254b5e8304a46c3071
Content-Type: text/x-csrc; charset=US-ASCII; name="main.c"
Content-Disposition: attachment; filename="main.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goa61qjl0

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZjbnRs
Lmg+CiNpbmNsdWRlIDxzdGRpby5oPgoKI2RlZmluZSBGSUxFX1NJWkUgMzI1NDQzODkwCiNkZWZp
bmUgV1JUX0JZVEVTIDQwOTYKCmludCBtYWluKHZvaWQpCnsKCXN0cnVjdCBzdGF0IHN0YXRfYnVm
OwoJaW50IGZkID0gMCwgZmxhZyA9IDA7Cgljb25zdCBzaXplX3QgY250ID0gRklMRV9TSVpFIC8g
V1JUX0JZVEVTOwoJY2hhciBhcnJbV1JUX0JZVEVTXTsKCQoJZmQgPSBvcGVuKCJ0aGlzX2ZpbGVf
bmFtZS5tcDQiLAoJCU9fUkRXUnxPX0NSRUFULCAwNjY2KTsKCQoJZnN0YXQoZmQsICZzdGF0X2J1
Zik7CgkKCWZsYWcgPSBmY250bChmZCwgRl9HRVRGRCk7CglmY250bChmZCwgRl9TRVRGRCwgZmxh
ZyB8IEZEX0NMT0VYRUMpOwoJCglsc2VlayhmZCwgMCwgU0VFS19DVVIpOwoJCglmdHJ1bmNhdGUo
ZmQsIEZJTEVfU0laRSk7CgkKCWxzZWVrKGZkLCAwLCBTRUVLX1NFVCk7CgkKCWZvciAoaW50IGkg
PSAwOyBpIDwgY250OyArK2kpIHsKCQl3cml0ZShmZCwgYXJyLCBXUlRfQllURVMpOwoJfQoJCgl3
cml0ZShmZCwgYXJyLCBGSUxFX1NJWkUgLSAoV1JUX0JZVEVTICogY250KSk7CgkKCWNsb3NlKGZk
KTsKCQoJcmV0dXJuIDA7Cn0KCg==
--bcaec520ea254b5e8304a46c3071--
