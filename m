From: Josef Bacik <jbacik@redhat.com>
Subject: [TESTCASE] test orphan recovery code
Date: Thu, 24 Jul 2008 15:42:19 -0400
Message-ID: <20080724194219.GC28414@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Another one for the qa suite.  This will create 1001 files, unlink them, and
then do a sysrq+b which is like hitting the reset button on your box to make
sure that on mount when the box comes back up all the files are cleaned up.
Don't run this unless you expect the box to be reset.  Successfull running of
this testcase should result in no file_# files being left over and no orphan
records left.  Thanks,

Josef

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>

int main(void)
{
	int fd, i, proc_fd;
	char buf[80];

	for (i = 0; i <= 1000; i++) {
		snprintf(buf, 80, "file_%d", i);
		fd = open(buf, O_RDONLY | O_CREAT, 0666);
		unlink(buf);
	}

	fsync(fd);
	printf("rebooting...\n");

	proc_fd = open("/proc/sysrq-trigger", O_WRONLY);
	if (proc_fd < 0) {
		fprintf(stderr, "Error opening sysrq: %d\n", errno);
	}
	write(proc_fd, "b", 1);

	/* should be dead by now so no need to clean anything up */

	return 0;
}
