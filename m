Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946154Ab3FUVx6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 17:53:58 -0400
Message-ID: <51C4CB72.9080705@redhat.com>
Date: Fri, 21 Jun 2013 16:53:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: make fs for 274 larger
References: <1371846648-21841-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1371846648-21841-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/21/13 3:30 PM, Josef Bacik wrote:
> Btrfs will default to mixed block groups for 1 gigabyte file systems and
> smaller, which means data and metadata share the same area.  This makes
> generic/274 fail for us because we cannot reserve enough metadata space to do
> our writes.  Bumping the scratch fs up to 2 gigabytes allows us to do our normal
> metadata/data seperation and allows us to pass this test.  Thanks,

It'd be nice if we could force btrfs into the other mode just for this
test, but it's probably harmless to just make everyone else bigger.
Makes the test take longer though, another gig to write.

Did you test other filesystems w/ the change?

Seems like a reasonable & expedient solution though, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/generic/274 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
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

