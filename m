Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34157 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbCaXp4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 19:45:56 -0400
Received: by pactp5 with SMTP id tp5so34064429pac.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 16:45:56 -0700 (PDT)
Received: from lenny.home.zabbo.net (c-24-22-122-160.hsd1.or.comcast.net. [24.22.122.160])
        by mx.google.com with ESMTPSA id o4sm96027pdh.6.2015.03.31.16.45.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 31 Mar 2015 16:45:55 -0700 (PDT)
Date: Tue, 31 Mar 2015 16:45:53 -0700
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: readdir tree/page lock inversion
Message-ID: <20150331234553.GA20542@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've known for eons that it's not great that readdir holds tree locks
while calling mkwrite by way of dir_emit().  I fiddled around and found
a reliable if goofy deadlock reproducer.  It typically takes a few
seconds on modest hardware here (single package, dual core/ht, single
spindle.)

I made a quick attempt at refactoring readdir to stage entries in a
locally allocated page before releasing the locks and emitting them but
unfortunately my eyeballs fell out and one of the cats ran off with
them.  Maybe someone else will have more luck.

- z

#define _GNU_SOURCE
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/mman.h>

#define LEN 300
static char junk[LEN];

int main(int argc, char **argv)
{
	int dir_fd;
	void *ptr;
	pid_t pid;
	int fd;
	int ret;

	/* create our own convenient dir and file for convenience */
	fd = open("./file", O_RDWR | O_CREAT, 0644);
	if (fd < 0) {
		perror("open file");
		exit(1);
	}

	if (mkdir("./dir", 0755)) {
		perror("mkdir");
		exit(1);
	}

	dir_fd = open("./dir", O_RDONLY);
	if (dir_fd < 0) {
		perror("open dir");
		exit(1);
	}

	pid = fork();
	if (pid < 0) {
		perror("fork");
		exit(1);
	}

	if (!pid) {
		/* first child spins modifying entries in the dir */
		if (chdir("./dir")) {
			perror("chdir");
			exit(1);
		}

		for (;;) {
			if (link("../file", "./link")) {
				perror("link");
				exit(1);
			}
			if (unlink("./link")) {
				perror("link");
				exit(1);
			}
		}
	}

	pid = fork();
	if (pid < 0) {
		perror("fork");
		exit(1);
	}

	if (!pid) {
		/* second child spins reading entries into mapped file */
		ret = write(fd, junk, LEN);
		if (ret != LEN) {
			perror("write");
			exit(1);
		}

		ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
			   fd, 0);
		if (ptr == MAP_FAILED) {
			perror("mmap");
			exit(1);
		}

		for(;;) {
			if (posix_fadvise(fd, 0, 4096, POSIX_FADV_DONTNEED)) {
				perror("fadvise");
				exit(1);
			}

			if (lseek(dir_fd, 0, SEEK_SET)) {
				perror("lseek");
				exit(1);
			}

			ret = syscall(SYS_getdents, dir_fd, ptr, LEN);
			if (ret <= 0) {
				perror("getdents");
				exit(1);
			}
		}
	}

	/* and the parent spins doing a system-wide sync */
	while (1)
		sync();

	return 0;
}
