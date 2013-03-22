Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56509 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422811Ab3CVSHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 14:07:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 900797C0643
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 12:07:07 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <orhak8fm0u.fsf@livre.home>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
Message-ID: <20130322180705.27874.96638@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Fri, 22 Mar 2013 14:07:05 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ mmap corruptions with leveldb and btrfs compression ]

I ran this a number of times with compression off and wasn't able to
trigger problems.  With compress=lzo, I see errors on every run.

Compile: gcc -Wall -o mmap-trunc mmap-trunc.c
Run: ./mmap-trunc file_name

The basic idea is to create a 256MB file in steps.  Each step ftruncates
the file larger, and then mmaps a region for writing.  It dirties some
unaligned bytes (a little more than 8K), and then munmaps.

Then a verify stage goes back through the file to make sure the data we
wrote is really there.  I'm using a simple rotating pattern of chars
that compress very well.

I run it in batches of 100 with some memory pressure on the side:

for x in `seq 1 100` ; do (mmap-trunc f$x &) ; done

#define _FILE_OFFSET_BITS 64
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#define FILE_SIZE ((loff_t)256 * 1024 * 1024)
/* make a painfully unaligned chunk size */
#define CHUNK_SIZE (8192 + 932)

#define mmap_align(x) (((x) + 4095) & ~4095)

char *file_name = NULL;

void mmap_one_chunk(int fd, loff_t *cur_size, unsigned char *file_buf)
{
	int ret;
	loff_t new_size = *cur_size + CHUNK_SIZE;
	loff_t pos = *cur_size;
	unsigned long map_size = mmap_align(CHUNK_SIZE) + 4096;
	char val = file_buf[0];
	char *p;
	int extra;

	/* step one, truncate out a hole */
	ret = ftruncate(fd, new_size);
	if (ret) {
		perror("truncate");
		exit(1);
	}

	if (val == 0 || val == 'z')
		val = 'a';
	else
		val++;

	memset(file_buf, val, CHUNK_SIZE);

	extra = pos & 4095;
	p = mmap(0, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
		 pos - extra);
	if (p == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	memcpy(p + extra, file_buf, CHUNK_SIZE);

	ret = munmap(p, map_size);
	if (ret) {
		perror("munmap");
		exit(1);
	}
	*cur_size = new_size;
}

void check_chunks(int fd)
{
	char *p;
	loff_t checked = 0;
	char val = 'a';
	int i;
	int errors = 0;
	int ret;
	int extra;
	unsigned long map_size = mmap_align(CHUNK_SIZE) + 4096;

	fprintf(stderr, "checking chunks\n");
	while (checked < FILE_SIZE) {
		extra = checked & 4095;
		p = mmap(0, map_size, PROT_READ,
			 MAP_SHARED, fd, checked - extra);
		if (p == MAP_FAILED) {
			perror("mmap");
			exit(1);
		}
		for (i = 0; i < CHUNK_SIZE; i++) {
			if (p[i + extra] != val) {
				fprintf(stderr, "%s: bad val %x wanted %x offset 0x%llx\n",
					file_name, p[i + extra], val,
					(unsigned long long)checked + i);
				errors++;
			}
		}
		if (val == 'z')
			val = 'a';
		else
			val++;
		ret = munmap(p, map_size);
		if (ret) {
			perror("munmap");
			exit(1);
		}
		checked += CHUNK_SIZE;
	}
	printf("%s found %d errors\n", file_name, errors);
	if (errors)
		exit(1);
}

int main(int ac, char **av)
{
	unsigned char *file_buf;
	loff_t pos = 0;
	int ret;
	int fd;

	if (ac < 2) {
		fprintf(stderr, "usage: mmap-trunc filename\n");
		exit(1);
	}

	ret = posix_memalign((void **)&file_buf, 4096, CHUNK_SIZE);
	if (ret) {
		perror("cannot allocate memory\n");
		exit(1);
	}

	file_buf[0] = 0;

	file_name = av[1];

	fprintf(stderr, "running test on %s\n", file_name);

	unlink(file_name);
	fd = open(file_name, O_RDWR | O_CREAT, 0600);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	fprintf(stderr, "writing chunks\n");
	while (pos < FILE_SIZE) {
		mmap_one_chunk(fd, &pos, file_buf);
	}
	check_chunks(fd);
	return 0;
}
