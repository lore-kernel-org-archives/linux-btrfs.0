Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932832AbeAJI5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 03:57:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8C8C7AD41
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 08:57:32 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs-progs: mkfs-tests: Add test case to check if
 the first device extent is occupying reserved 0~1M range
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180110045648.3239-1-wqu@suse.com>
 <20180110045648.3239-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <18fc1f6c-0c75-c64d-efb1-36fe05260d4c@suse.com>
Date: Wed, 10 Jan 2018 10:57:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180110045648.3239-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.01.2018 06:56, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  .../mkfs-tests/010-reserved-1M-for-single/test.sh  | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100755 tests/mkfs-tests/010-reserved-1M-for-single/test.sh
> 
> diff --git a/tests/mkfs-tests/010-reserved-1M-for-single/test.sh b/tests/mkfs-tests/010-reserved-1M-for-single/test.sh
> new file mode 100755
> index 000000000000..1a4936eaf72e
> --- /dev/null
> +++ b/tests/mkfs-tests/010-reserved-1M-for-single/test.sh
> @@ -0,0 +1,37 @@
> +#!/bin/bash
> +# Test if "-m single" or "-M" can cause dev extent to use reserved 1M range
> +#
> +# Other profiles will cause mkfs.btrfs to allocate new meta/sys chunks
> +# using btrfs_alloc_chunk() which won't use 0~1M range, so other profiles
> +# are safe.
> +
> +source "$TOP/tests/common"
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +prepare_test_dev
> +
> +do_one_test ()
> +{
> +	run_check "$TOP/mkfs.btrfs" -f $@ "$TEST_DEV"
> +
> +	# Use dev-extent tree to find first device extent
> +	first_dev_extent=$(run_check_stdout "$TOP/btrfs" inspect-internal \
> +		dump-tree -t device "$TEST_DEV" | \
> +		grep -oP '(?<=DEV_EXTENT )[[:digit:]]*' | head -n1)
> +
> +	if [ -z $first_dev_extent ]; then
> +		_fail "Failed to get first device extent"
> +	fi
> +
> +	echo "First dev extent starts at $first_dev_extent" >> "$RESULTS"
> +	echo "Reserved range is [0, $(( 1024 * 1024)))" >> "$RESULTS"
> +	# First device extent should not start below 1M
> +	if [ $first_dev_extent -lt $(( 1024 * 1024 )) ]; then
> +		_fail "First device extent occupies reserved 0~1M range"
> +	fi
> +}
> +
> +do_one_test "-M"
> +do_one_test "-m single"
> 
