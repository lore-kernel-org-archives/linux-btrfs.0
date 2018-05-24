Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965756AbeEXRjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 13:39:10 -0400
Date: Thu, 24 May 2018 19:36:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix memory and mount leak in
 btrfs_ioctl_rm_dev_v2()
Message-ID: <20180524173622.GJ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <78fcd50378fec419da9f60086ce8331e12c7563d.1527028634.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <78fcd50378fec419da9f60086ce8331e12c7563d.1527028634.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 03:44:01PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> If we have invalid flags set, when we error out we must drop our writer
> counter and free the buffer we allocated for the arguments. This bug is
> trivially reproduced with the following program:
> 
> 	#include <fcntl.h>
> 	#include <stdint.h>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
> 	#include <sys/ioctl.h>
> 	#include <sys/stat.h>
> 	#include <sys/types.h>
> 	#include <linux/btrfs.h>
> 	#include <linux/btrfs_tree.h>
> 
> 	int main(int argc, char **argv)
> 	{
> 		struct btrfs_ioctl_vol_args_v2 vol_args = {
> 			.flags = UINT64_MAX,
> 		};
> 		int ret;
> 		int fd;
> 
> 		if (argc != 2) {
> 			fprintf(stderr, "usage: %s PATH\n", argv[0]);
> 			return EXIT_FAILURE;
> 		}
> 
> 		fd = open(argv[1], O_WRONLY);
> 		if (fd == -1) {
> 			perror("open");
> 			return EXIT_FAILURE;
> 		}
> 
> 		ret = ioctl(fd, BTRFS_IOC_RM_DEV_V2, &vol_args);
> 		if (ret == -1)
> 			perror("ioctl");
> 
> 		close(fd);
> 		return EXIT_SUCCESS;
> 	}
> 
> When unmounting the filesystem, we'll hit the
> WARN_ON(mnt_get_writers(mnt)) in cleanup_mnt().
> 
> Fixes: 6b526ed70cf1 ("btrfs: introduce device delete by devid")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> Sigh, I keep stepping in these ioctl bugs just trying to get my swap
> file series ready.

This was the last one, pinky swear.

> This one is based on top of my "Btrfs: fix partly
> checksummed file races" series, although it should apply to for-next
> without it +/- some moved lines.

Applies cleanly, thanks.
