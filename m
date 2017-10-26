Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZRrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:47:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4424ADF4
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 17:47:12 +0000 (UTC)
Date: Thu, 26 Oct 2017 19:45:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 3/3] btrfs-progs: test/mkfs: Test if the minimal
 device size is valid
Message-ID: <20171026174523.GC3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171016082258.27815-1-wqu@suse.com>
 <20171016082258.27815-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016082258.27815-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:22:58PM +0800, Qu Wenruo wrote:
> New test case to test if the minimal device size given by "mkfs.btrfs"
> failure case is valid.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> v2:
>   Nothing
> ---
>  tests/common                             | 57 +++++++++++++++++++++++++++++++-

Please split this change from the patch.

>  tests/mkfs-tests/010-small-image/test.sh | 51 ++++++++++++++++++++++++++++
>  2 files changed, 107 insertions(+), 1 deletion(-)
>  create mode 100755 tests/mkfs-tests/010-small-image/test.sh
> 
> diff --git a/tests/common b/tests/common
> index eb525a4d02c5..e026cc2f4d30 100644
> --- a/tests/common
> +++ b/tests/common
> @@ -236,6 +236,57 @@ run_mustfail()
>  	fi
>  }
>  
> +run_mustfail_stdout()
> +{
> +	local spec
> +	local ins
> +	local cmd
> +	local msg
> +	local ret
> +
> +	# We don't use pipefail to avoid disturbing other script, so here we
> +	# use temporary output file.
> +	# So it doesn't support pipeline in the @cmd

This would be good as the function comment, plus the 1st argument
requirement, simlar to run_mustfail.

> +	local tmp_output
> +
> +	tmp_output=$(mktemp --tmpdir btrfs-progs-test--mustfail-stdtout.XXXXXX)
> +
> +	msg="$1"
> +	shift
> +
> +	if _is_file_or_command "$msg"; then
> +		echo "ASSERTION FAIL: 1st argument of run_mustfail_stdout must be a message"
> +		exit 1
> +	fi
> +
> +	ins=$(_get_spec_ins "$@")
> +	spec=$(($ins-1))
> +	cmd=$(eval echo "\${$spec}")
> +	spec=$(_cmd_spec "${@:$spec}")
> +	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
> +	echo "############### $@" >> "$RESULTS" 2>&1
> +	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(mustfail): $@" > /dev/tty; fi
> +	if [ "$1" = 'root_helper' ]; then
> +		"$@" 2>&1 > "$tmp_output"
> +	else
> +		$INSTRUMENT "$@" 2>&1 > "$tmp_output"
> +	fi
> +	ret=$?
> +
> +	cat "$tmp_output" >> "$RESULTS"
> +	cat "$tmp_output"
> +	rm "$tmp_output"
> +
> +	if [ "$ret" != 0 ]; then
> +		echo "failed (expected): $@" >> "$RESULTS"
> +		return 0
> +	else
> +		echo "succeeded (unexpected!): $@" >> "$RESULTS"
> +		_fail "unexpected success: $msg"
> +		return 1
> +	fi
> +}
> +
>  check_prereq()
>  {
>  	if ! [ -f "$TOP/$1" ]; then
> @@ -389,7 +440,11 @@ prepare_test_dev()
>  	# num[K/M/G/T...]
>  	local size="$1"
>  
> -	[[ "$TEST_DEV" ]] && return
> +	# Still truncate it to new size
> +	if [[ "$TEST_DEV" ]]; then
> +		truncate -s "$size" "$TEST_DEV"

You use $size before it gets checked that's not empty a few lines below.

> +		return;
> +	fi
>  	[[ "$size" ]] || size='2G'
>  
>  	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
> diff --git a/tests/mkfs-tests/010-small-image/test.sh b/tests/mkfs-tests/010-small-image/test.sh
> new file mode 100755
> index 000000000000..2ed379f9b66f
> --- /dev/null
> +++ b/tests/mkfs-tests/010-small-image/test.sh
> @@ -0,0 +1,51 @@
> +#!/bin/bash
> +# test if the reported minimal size of mkfs.btrfs is valid
> +
> +source $TOP/tests/common
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +
> +pagesize=$(getconf PAGESIZE)

Not used?

> +
> +do_test()
> +{
> +	# Well, 1M small enough to fail, we just use the output
> +	# to get the minimal device size
> +	prepare_test_dev 1M
> +	output=$(run_mustfail_stdout "mkfs.btrfs for small image" \
> +		 $TOP/mkfs.btrfs -f $@ "$TEST_DEV")
> +	good_size=$(echo $output | grep -oP "(?<=is )\d+")
> +
> +	prepare_test_dev "$good_size"
> +	run_check $TOP/mkfs.btrfs -f $@ "$TEST_DEV"
> +	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
> +	run_check $SUDO_HELPER umount $TEST_MNT

Please add quotes around all variables that could come from an external
source (TEST_MNT, TEST_DEV, TOP).

> +}
> +
> +do_test -n 4k	-m single	-d single
> +do_test -n 4k	-m single	-d dup
> +do_test -n 4k	-m dup		-d single
> +do_test -n 4k	-m dup		-d dup
> +
> +do_test -n 8k	-m single	-d single
> +do_test -n 8k	-m single	-d dup
> +do_test -n 8k	-m dup		-d single
> +do_test -n 8k	-m dup		-d dup
> +
> +do_test -n 16k	-m single	-d single
> +do_test -n 16k	-m single	-d dup
> +do_test -n 16k	-m dup		-d single
> +do_test -n 16k	-m dup		-d dup
> +
> +do_test -n 32k	-m single	-d single
> +do_test -n 32k	-m single	-d dup
> +do_test -n 32k	-m dup		-d single
> +do_test -n 32k	-m dup		-d dup
> +
> +do_test -n 64k	-m single	-d single
> +do_test -n 64k	-m single	-d dup
> +do_test -n 64k	-m dup		-d single
> +do_test -n 64k	-m dup		-d dup
