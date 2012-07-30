Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58523 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab2G3NqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 09:46:10 -0400
Date: Mon, 30 Jul 2012 09:46:07 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/1] Btrfs: Explicitly include vmalloc.h in send.c
Message-ID: <20120730134607.GA15396@localhost.localdomain>
References: <1343514003-10942-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1343514003-10942-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 28, 2012 at 04:20:02PM -0600, Mitch Harder wrote:
> When compiling without SMP and generic x86_64, I encountered the
> following errors due to vmalloc.h not being implicitly included:
> 
>   CC      fs/btrfs/send.o
> fs/btrfs/send.c: In function ‘fs_path_free’:
> fs/btrfs/send.c:185:4: error: implicit declaration of function ‘vfree’
> fs/btrfs/send.c: In function ‘fs_path_ensure_buf’:
> fs/btrfs/send.c:215:4: error: implicit declaration of function ‘vmalloc’
> fs/btrfs/send.c:215:12: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:225:12: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:233:13: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c: In function ‘iterate_dir_item’:
> fs/btrfs/send.c:900:10: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:909:11: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c: In function ‘btrfs_ioctl_send’:
> fs/btrfs/send.c:4462:17: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:4468:17: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:4474:2: error: implicit declaration of function ‘vzalloc’
> fs/btrfs/send.c:4474:20: warning: assignment makes pointer from integer without a cast
> fs/btrfs/send.c:4482:21: warning: assignment makes pointer from integer without a cast
> make[2]: *** [fs/btrfs/send.o] Error 1
> make[1]: *** [fs/btrfs] Error 2 
> 
> If it makes sense, please feel free to include this minor change in with
> other send/receive fixes.
> 
> Mitch Harder (1):
>   Btrfs: Explicitly include vmalloc.h in send.c
> 
>  fs/btrfs/send.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 

Already fixed by the linux-next maintainer.  Thanks,

Josef
