From: Josef Bacik <josef@redhat.com>
Subject: O_DIRECT and Btrfs == checksumming nightmare
Date: Fri, 08 Apr 2011 15:01:01 -0400
Message-ID: <4D9F5B6D.1070102@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010802010000090501080801"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org, npiggin@kernel.dk, eparis@redhat.com,
	Chris Mason <chris.mason@oracle.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010802010000090501080801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

So I've been trying to track down checksumming errors Eric Paris was 
getting while running Windows 7 in qemu.  Turns out we had one valid 
problem (we don't deal well with reading with an iovec with two 
iov_base's that are the same), and we have a problem with the pages 
being changed in flight.  I'm not entirely sure the second thing is what 
is happening, but I'm looking at finding that out for sure soon.  But in 
the meantime I've crafted a fun little reproducer that will blow btrfs 
up quickly.  It just mmaps an anonymous range, fork()'s, and then one 
thread does writes/reads with the anonymous map and then the other one 
just sits there and loops and changes the anonymous map.  This will 
result in getting a -EIO on the reader thread pretty quickly and you get 
a bunch of checksum errors in your messages.

This is going to screw anybody who needs the pages to be stable during 
IO, and since its O_DIRECT we don't get to do any of our normal tricks 
to make sure things stay stable.  I even tried using set_memory_ro() to 
see if I could catch userspace modifying the page and it didn't do 
anything.  For now in btrfs the plan is to check the crc of the page 
when the IO completes (for writes) and if it's not create a bounce 
buffer and re-submit that.  This sucks, it would be good to have a way 
to make sure the pages were stable throughout the IO like we can with 
normal pages.  Nick, Chris said you had something in mind for this?  If 
you don't have time to do the actual work I can try and put together a 
fix if you can describe what to do.  I'm attaching my reproducer here in 
case anybody else wants to try it.  Thanks,

Josef

--------------010802010000090501080801
Content-Type: text/plain;
 name="modify-dio-in-flight.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="modify-dio-in-flight.c"

#define _GNU_SOURCE
#define _XOPEN_SOURCE  600

#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static pid_t pid;
static int finished = 0;

static void child(char *buf, size_t size)
{
	char c = 'b';

	printf("child: Buf is %p\n", buf);
	while (1) {
		memset(buf, c, size);
		c++;
		sleep(1);
	}
}

void sig_handler(int sig)
{
	kill(pid, SIGINT);
	finished = 1;
	printf("Caught signal\n");
}

int main(int argc, char **argv)
{
	char *obuf, *ibuf;
	size_t size = 1024 * 1024 * 1;
	int err;
	int fd;
	int status;
	sighandler_t handler;

	err = posix_memalign((void **)&ibuf, 4096, size);
	if (err) {
		fprintf(stderr, "Error allocating buf: %d\n", err);
		return 1;
	}

	obuf = mmap(0, size, PROT_READ | PROT_WRITE,
		    MAP_ANONYMOUS | MAP_SHARED, -1, 0);
	if (obuf == MAP_FAILED) {
		free(obuf);
		fprintf(stderr, "Error allocating buf: %d\n", err);
		return 1;
	}

	pid = fork();
	if (pid < 0) {
		fprintf(stderr, "Problem forking: %d\n", errno);
		return 1;
	}

	if (pid == 0) {
		child(obuf, size);
		return 0;
	}

	handler = signal(SIGINT, sig_handler);

	fd = open("testfile", O_RDWR|O_CREAT|O_DIRECT, 0644);
	if (fd < 0) {
		fprintf(stderr, "Error opening file: %d\n", errno);
		err = 1;
		goto out;
	}

	printf("obuf is %p\n", obuf);

	while (!finished) {
		ssize_t copied;

		memset(obuf, 'a', size);
		lseek(fd, 0, SEEK_SET);
		copied = write(fd, obuf, size);
		if (copied < 0) {
			fprintf(stderr, "Error writing: %d\n", errno);
			err = 1;
			break;
		} else if (copied < size) {
			fprintf(stderr, "Weird, short write: %d\n", copied);
		}

		lseek(fd, 0, SEEK_SET);
		copied = read(fd, ibuf, copied);
		if (copied < 0) {
			fprintf(stderr, "Read failed: %d\n", copied);
			err = 1;
			break;
		}
	}

out:
	if (err)
		kill(pid, SIGINT);

	waitpid(pid, &status, 0);
	close(fd);
	munmap(obuf, 4096);
	free(ibuf);

	return err;
}

--------------010802010000090501080801--
