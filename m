Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56826 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754148AbbDIBnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 21:43:06 -0400
Message-ID: <5525D926.1050405@cn.fujitsu.com>
Date: Thu, 9 Apr 2015 09:43:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: use local btrfs-image in leaf corruption
 test
References: <CALOYprWfYKJG-9d=J9WLEisWLcpcKwv4bPwfcjggw-EC4phbGA@mail.gmail.com>
In-Reply-To: <CALOYprWfYKJG-9d=J9WLEisWLcpcKwv4bPwfcjggw-EC4phbGA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Currently this test uses the system btrfs-image. If there isn't a
> btrfs-image on $PATH, the test fails. The test should be using the
> locally compiled btrfs-image, not the system one.
Good catch.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>
> diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh
> b/tests/fsck-tests/012-leaf-corruption/test.sh
> index 4db4710..98e3185 100755
> --- a/tests/fsck-tests/012-leaf-corruption/test.sh
> +++ b/tests/fsck-tests/012-leaf-corruption/test.sh
> @@ -37,7 +37,7 @@ generate_leaf_corrupt_no_data_ext()
>       echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULTS
>       tar xJf ./no_data_extent.tar.xz || \
>           _fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
> -    btrfs-image -r test.img.btrfs-image $dest || \
> +    $TOP/btrfs-image -r test.img.btrfs-image $dest || \
>           _fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
>
>       # leaf at 20832256 contains no regular data extent, clear its csum to
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
