Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab3JUP3o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 11:29:44 -0400
Message-ID: <52654863.9050503@redhat.com>
Date: Mon, 21 Oct 2013 10:29:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 5/8] xfstests: generic/274 increase scratch fs size to
 2g
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com> <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/18/13 1:26 PM, Josef Bacik wrote:
> With 1 gig btrfs defaults to mixed block groups, so we ENOSPC in this test
> because we run out of metadata space, not data space.  Increasing to 2g allows
> us to use our normal setup and allows us to pass this test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Doubles the test time on xfs, but from 16s to 30s on a single spindle sata
disk; I think we can handle it.

ext4 fails w/ or w/o the patch, so *shrug*

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/274 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/274 b/tests/generic/274
> index da45fab..7c4887f 100755
> --- a/tests/generic/274
> +++ b/tests/generic/274
> @@ -57,7 +57,7 @@ echo "------------------------------"
>  rm -f $seqres.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  # Create a 4k file and Allocate 4M past EOF on that file
> 

