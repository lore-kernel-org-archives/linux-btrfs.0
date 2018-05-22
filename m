Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40517 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbeEVRhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:37:16 -0400
Received: by mail-pl0-f66.google.com with SMTP id t12-v6so11316392plo.7
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 10:37:16 -0700 (PDT)
Date: Tue, 22 May 2018 10:37:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180522173714.GB9536@vader>
References: <d181fa0f3fc581208a0258132c8dc3305b01be1a.1527007575.git.osandov@fb.com>
 <20180522171748.GY6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522171748.GY6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 07:17:48PM +0200, David Sterba wrote:
> On Tue, May 22, 2018 at 09:47:58AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Jun Wu at Facebook reported that an internal service was seeing a return
> > value of 1 from ftruncate() on Btrfs in some cases.
> 
> Do you have a reproducer? To estimate how likely is to hit the problem
> in practice.

This reproduces it every time when mounted with compress-force=zstd:

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

int main() {
	int i;

	for (i = 0; i < 2; i++) {
		char buf[256] = { 0 };
		int fd, ret;
		char *p;

		fd = open("test", O_CREAT | O_WRONLY | O_TRUNC, 0666);
		if (fd == -1) {
			perror("open");
			return EXIT_FAILURE;
		}
		if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
			perror("write");
			close(fd);
			return EXIT_FAILURE;
		}
		close(fd);

		fd = open("test", O_RDONLY, 0666);
		if (fd == -1) {
			perror("open");
			return EXIT_FAILURE;
		}
		p = mmap(NULL, 256, PROT_READ, MAP_SHARED, fd, 0);
		if (p == MAP_FAILED) {
			perror("mmap");
			close(fd);
			return EXIT_FAILURE;
		}
		if (p[0] != 0)
			return 1;
		close(fd);

		fd = open("test", O_WRONLY, 0666);
		if (fd == -1) {
			perror("open");
			return EXIT_FAILURE;
		}
		ret = ftruncate(fd, 128);
		if (ret) {
			printf("ftruncate() returned %d\n", ret);
			close(fd);
			return EXIT_FAILURE;
		}
		close(fd);
	}

	return EXIT_SUCCESS;
}

This happens any time NEED_TRUNCATE_BLOCK is returned. The file has to
be inline and compressed, and there's some other condition that I
haven't figured out yet which the mmap() is there for.
