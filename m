Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab3ECUPL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 16:15:11 -0400
Message-ID: <51841AC5.3090309@redhat.com>
Date: Fri, 03 May 2013 15:15:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: unmount scratch mnt in test 307
References: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/3/13 3:11 PM, Josef Bacik wrote:
> So if you have a mount command that doesn't use /etc/mtab then it will spit out
> a different device for the mounted device.  So say we have
> 
> SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc"
> 
> we will turn this into
> 
> SCRATCH_DEV="/dev/sda"
> SCRATCH_DEV_POOL="/dev/sdb /dev/sdc"
> 
> and then when you mkfs this you do _scratch_mkfs $SCRATCH_DEV_POOL which turns
> into this
> 
> mkfs.btrfs /dev/sdb /dev/sdc /dev/sda
> 
> becuase we do
> 
> mkfs $* $SCRATCH_DEV
> 
> Then btrfs will always show the lowest devid in /proc/mounts to maintain
> consistency, so even though we do mount /dev/sda $SCRATCH_MNT, you will see
> /dev/sdb as the mounted device in /proc/mounts.  So then say the next test wants
> to just use $SCRATCH_DEV, it will do _require_scratchdev which will check to see
> if $SCRATCH_DEV is mounted, which it will look like it is not because
> /proc/mounts shows /dev/sdb instead of /dev/sda, and so it won't umount
> $SCRATCH_MNT, and then that test will fail because we can't mkfs the device
> because it is busy.  I reproduced this on a box that doesn't use /etc/mtab by
> doing
> 
> ./check btrfs/307 generic/015
> 
> and 015 would fail.  With this patch it passes now.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/btrfs/307 |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/btrfs/307 b/tests/btrfs/307
> index 87314c6..15157b3 100644
> --- a/tests/btrfs/307
> +++ b/tests/btrfs/307
> @@ -35,6 +35,7 @@ _cleanup()
>  {
>      cd /
>      rm -f $tmp.*
> +    umount $SCRATCH_MNT
>  }
>  
>  # get standard environment, filters and checks
> 

This seems fine for this particular test.

Is it really a hard requirement that each test unmount SCRATCH_[DEV|MNT] if it used it?
If so, fine... the README does indicate this.

But I wonder if we can make it a little more foolproof by updating _require_scratch
to handle this situation more gracefully?

-Eric
