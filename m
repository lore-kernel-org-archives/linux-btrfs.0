Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51172 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3JUT7f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 15:59:35 -0400
Message-ID: <526587A5.4000602@sandeen.net>
Date: Mon, 21 Oct 2013 14:59:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: use -F for mkfs.ext4 in btrfs/012
References: <1382371516-13720-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382371516-13720-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/13 11:05 AM, Josef Bacik wrote:
> I noticed this test was hanging because mkfs.ext4 wanted to make sure it was ok
> to mkfs an entire device.  We need -F so it doesn't ask this question.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/012 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> index de90149..f7e5da5 100755
> --- a/tests/btrfs/012
> +++ b/tests/btrfs/012
> @@ -65,7 +65,7 @@ _require_command $E2FSCK_PROG e2fsck
>  rm -f $seqres.full
>  
>  # Create & populate an ext4 filesystem
> -$MKFS_EXT4_PROG -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
> +$MKFS_EXT4_PROG -F -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
>  	_notrun "Could not create ext4 filesystem"
>  # Manual mount so we don't use -t btrfs or selinux context
>  mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
> 

