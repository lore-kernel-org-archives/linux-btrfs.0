From: Josef Bacik <jbacik@redhat.com>
Subject: [TESTCASE] orphan link/unlink race test
Date: Thu, 24 Jul 2008 15:40:42 -0400
Message-ID: <20080724194041.GB28414@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is for whoever is doing the QA suite (not it!), it tests the orphan code to
make sure two threads unlinking/linking a file doesn't blow up.  A successfull
run of this should result in no output at all.  Thanks,

Josef

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

static int link_thread()
{
	int i, ret;

	for (i = 0; i < 1000; i++) {
		int fd;

		ret = link("foo", "bar");
		if (ret) {
			if (errno == ENOENT)
				continue;
			fprintf(stderr, "FAILED: could not link foo to bar: "
				"%d\n", errno);
			break;
		}
		fd = open("bar", O_RDWR);
		if (fd < 0) {
			fprintf(stderr, "FAILED: could not open bar: %d\n",
				errno);
			break;
		}
		ret = unlink("bar");
		if (ret) {
			fprintf(stderr, "FAILED: could not unlink bar: %d\n",
				errno);
			break;
		}
		ret = fsync(fd);
		if (ret) {
			fprintf(stderr, "FAILED: could not fsync bar: %d\n",
				errno);
			break;
		}
		ret = close(fd);
		if (ret) {
			fprintf(stderr, "FAILED: could not close bar: %d\n",
				errno);
			break;
		}
	}
}

static void unlink_thread()
{
	int fd, i, ret;

	for (i = 0; i < 1000; i++) {
		fd = open("foo", O_CREAT | O_RDWR, 0666);
		if (fd < 0) {
			fprintf(stderr, "FAILED: could not create foo: %d\n",
				errno);
			break;
		}
		ret = fsync(fd);
		if (ret) {
			fprintf(stderr, "FAILED: could not fsync foo after "
				"create: %d\n", errno);
			break;
		}
		ret = unlink("foo");
		if (ret) {
			fprintf(stderr, "FAILED: could not unlink foo: %d\n",
				errno);
			break;
		}
		ret = fsync(fd);
		if (ret) {
			fprintf(stderr, "FAILED: could not fsync foo after "
				"unlink: %d\n", errno);
			break;
		}
		ret = close(fd);
		if (ret) {
			fprintf(stderr, "FAILED: could not close foo: %d\n",
			       errno);
			break;
		}
	}
}

int main(int argc, char **argv)
{
	pid_t child;
	int ret;

	child = fork();
	if (!child) {
		link_thread();
	} else if (child > 0) {
		int status;

		unlink_thread();
		ret = waitpid(child, &status, 0);
	} else {
		fprintf(stderr, "Error forking child: %d\n", errno);
	}

	return 0;
}
