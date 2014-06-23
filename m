Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaFWMf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 08:35:56 -0400
Date: Mon, 23 Jun 2014 14:35:50 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
In-Reply-To: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
Message-ID: <alpine.LFD.2.00.1406231413400.2169@localhost.localdomain>
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 23 Jun 2014, Filipe David Borba Manana wrote:

> Date: Mon, 23 Jun 2014 11:28:00 +0100
> From: Filipe David Borba Manana <fdmanana@gmail.com>
> To: fstests@vger.kernel.org
> Cc: linux-btrfs@vger.kernel.org,
>     Filipe David Borba Manana <fdmanana@gmail.com>
> Subject: [PATCH] generic/017: skip invalid block sizes for btrfs
> 
> In btrfs the block size (called sector size in btrfs) can not be
> smaller then the page size. Therefore skip block sizes smaller
> then page size if the fs is btrfs, so that the test can succeed
> on btrfs (testing only with block sizes of 4kb on systems with a
> page size of 4Kb).

The test itself is wrong, it's trying to do _scratch_mkfs with
different block size, but the block size might already be specified
by the user (in fact it should be user responsibility to test
different block sizes). In the case that mkfs can not handle
multiple of the same option like mkfs.xfs for example it will fail,
but the test will go on with the original file system.

The test needs to be fixed to just test the file system with options
specified by the user. Also we should change _scratch_mkfs() to fail
the test if the mkfs failed (no one is actually testing mkfs_status
variable anyway.

Once we do that this patch will no longer be needed.

Thanks!
-Lukas

> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  tests/generic/017 | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tests/generic/017 b/tests/generic/017
> index 13b7254..6495be5 100755
> --- a/tests/generic/017
> +++ b/tests/generic/017
> @@ -51,6 +51,14 @@ BLOCKS=10240
>  
>  for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>  
> +	# btrfs doesn't support block size smaller then page size
> +	if [ "$FSTYP" == "btrfs" ]; then
> +		if (( $BSIZE < `getconf PAGE_SIZE` )); then
> +			echo "80"
> +			continue
> +		fi
> +	fi
> +
>  	length=$(($BLOCKS * $BSIZE))
>  	case $FSTYP in
>  	xfs)
> 
