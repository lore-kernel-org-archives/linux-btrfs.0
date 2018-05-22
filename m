Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35125 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbeEVRsk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:48:40 -0400
Received: by mail-pl0-f67.google.com with SMTP id i5-v6so11338458plt.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 10:48:39 -0700 (PDT)
Date: Tue, 22 May 2018 10:48:38 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180522174838.GD9536@vader>
References: <d181fa0f3fc581208a0258132c8dc3305b01be1a.1527007575.git.osandov@fb.com>
 <20180522171748.GY6649@twin.jikos.cz>
 <20180522173714.GB9536@vader>
 <20180522174111.GC9536@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522174111.GC9536@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 10:41:11AM -0700, Omar Sandoval wrote:
> On Tue, May 22, 2018 at 10:37:14AM -0700, Omar Sandoval wrote:
> > On Tue, May 22, 2018 at 07:17:48PM +0200, David Sterba wrote:
> > > On Tue, May 22, 2018 at 09:47:58AM -0700, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > 
> > > > Jun Wu at Facebook reported that an internal service was seeing a return
> > > > value of 1 from ftruncate() on Btrfs in some cases.
> > > 
> > > Do you have a reproducer? To estimate how likely is to hit the problem
> > > in practice.

Okay last one, I promise, we just need the extent items to be on disk:

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
	char buf[256] = { 0 };
	int ret;
	int fd;

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

	if (fsync(fd) == -1) {
		perror("fsync");
		close(fd);
		return EXIT_FAILURE;
	}

	ret = ftruncate(fd, 128);
	if (ret) {
		printf("ftruncate() returned %d\n", ret);
		close(fd);
		return EXIT_FAILURE;
	}

	close(fd);

	return EXIT_SUCCESS;
}

Basically, any time we truncate a compressed, inline file, as long as
its extents are already on disk, we get the erroneous return value.
