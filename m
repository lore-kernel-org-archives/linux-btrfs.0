Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3E3WgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 18:36:11 -0400
Date: Thu, 30 May 2013 15:36:10 -0700
From: Zach Brown <zab@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: testing stable pages being modified
Message-ID: <20130530223610.GA24721@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'stable' pages have always been a bit of a fiction.  It's easy to
intentionally modify stable pages under io with some help from page
references that ignore mappings and page state.

Here's little test that uses O_DIRECT to get the pinned aio ring pages
under IO and then has event completion stores modify them while they're
in flight.

It's a nice quick way to test the consequences of stable pages being
modified.  It can be used to burp out ratelimited csum failure kernel
messages with btrfs, for example.

- z

#define _GNU_SOURCE
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <assert.h>
#include <libaio.h>

int main(int argc, char **argv)
{
	size_t total = 1 * 1024 * 1024;
	size_t page_size = sysconf(_SC_PAGESIZE);
	struct iovec *iov;
	size_t iov_nr = total / page_size;
	void *junk;
	io_context_t ctx = NULL;
	int nr_iocbs = 3;
	struct iocb iocbs[nr_iocbs];
	struct iocb *iocb_ptrs[nr_iocbs];
	struct io_event events[nr_iocbs];
	int ret;
	int fd;
	int nr;
	int i;

	if (argc != 2) {
		fprintf(stderr, "usage: %s <file_to_overwrite>\n", argv[0]);
		exit(1);
	}

	iov = calloc(iov_nr, sizeof(*iov));
	junk = malloc(total);
	assert(iov && junk);

	fd = open(argv[1], O_RDWR|O_CREAT|O_DIRECT, 0644);
	assert(fd >= 0);

	ret = io_setup(nr_iocbs, &ctx);
	assert(ret >= 0);

	for (i = 0; i < iov_nr; i++) {
		iov[i].iov_base = ctx;
		iov[i].iov_len = page_size;
	}

	/* initial write to allocate the file region */
	ret = writev(fd, iov, iov_nr);
	assert(ret == total);

	/*
	 * Keep one of each of these iocbs in flight:
	 *
	 * [0]: hopefully fast 0 byte read to keep churning events
	 * [1]: dio read of file bytes to trigger csum verification
	 * [2]: dio write of unstable event pages
	 */
	io_prep_pread(&iocbs[0], fd, junk, 0, 0);
	io_prep_pread(&iocbs[1], fd, junk, total, 0);
	io_prep_pwritev(&iocbs[2], fd, iov, iov_nr, 0);

	for (i = 0; i < nr_iocbs; i++)
		iocb_ptrs[i] = &iocbs[i];
	nr = nr_iocbs;

	for(;;) {
		ret = io_submit(ctx, nr, iocb_ptrs);
		assert(ret == nr);

		nr = io_getevents(ctx, 1, nr_iocbs, events, NULL);
		assert(nr > 0);

		for (i = 0; i < nr; i++)
			iocb_ptrs[i] = events[i].obj;
	}

	return 0;
}
