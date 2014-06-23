Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:38379 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFWKse (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 06:48:34 -0400
Message-ID: <53A805EF.6060906@jp.fujitsu.com>
Date: Mon, 23 Jun 2014 19:48:15 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <lczerner@redhat.com>
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

(2014/06/23 19:28), Filipe David Borba Manana wrote:
> In btrfs the block size (called sector size in btrfs) can not be
> smaller then the page size. Therefore skip block sizes smaller
> then page size if the fs is btrfs, so that the test can succeed
> on btrfs (testing only with block sizes of 4kb on systems with a
> page size of 4Kb).
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

I consider it doesn't work since this test is not for Btrfs.
Please see the following code.

tests/generic/017:
===
for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do

	length=$(($BLOCKS * $BSIZE))
	case $FSTYP in
	xfs)
	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
	;;
	ext4)
	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
	;;
	esac
	_scratch_mount >> $seqres.full 2>&1
===

There is no btrfs here.

This test was moved to shared/005 to generic/017
at 21723cdbf303e031d6429f67fec9768750a5db7d.

Original supported fs is here.
===============================================================================
supported_fs xfs ext4
===============================================================================

I suspect that Lukas moved this test to generic/ by mistake or forgot to
add "$FSTYP == btrfs" case.

Thanks,
Satoru

> ---
>   tests/generic/017 | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/tests/generic/017 b/tests/generic/017
> index 13b7254..6495be5 100755
> --- a/tests/generic/017
> +++ b/tests/generic/017
> @@ -51,6 +51,14 @@ BLOCKS=10240
>   
>   for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>   
> +	# btrfs doesn't support block size smaller then page size
> +	if [ "$FSTYP" == "btrfs" ]; then
> +		if (( $BSIZE < `getconf PAGE_SIZE` )); then
> +			echo "80"
> +			continue
> +		fi
> +	fi
> +
>   	length=$(($BLOCKS * $BSIZE))
>   	case $FSTYP in
>   	xfs)
> 

