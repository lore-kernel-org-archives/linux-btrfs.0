Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750870AbdAQPHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 10:07:20 -0500
Date: Tue, 17 Jan 2017 16:06:27 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck-tests: missing csum test script
Message-ID: <20170117150627.GR12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170105192636.GA11297@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170105192636.GA11297@fedori>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not clear from the test what's the purpose. There's one corrupted
csum but the whole csum tree rebuild option is used. This is a pretty
basic check that the --init-csum-tree works, so it should be mentioned
somewhere in the test script.

On Thu, Jan 05, 2017 at 08:26:36PM +0100, Lakshmipathi.G wrote:
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> ---
>  tests/fsck-tests/027-missing-data-csum/test.sh | 39 ++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100755 tests/fsck-tests/027-missing-data-csum/test.sh
> 
> diff --git a/tests/fsck-tests/027-missing-data-csum/test.sh b/tests/fsck-tests/027-missing-data-csum/test.sh
> new file mode 100755
> index 0000000..6d1dc97
> --- /dev/null
> +++ b/tests/fsck-tests/027-missing-data-csum/test.sh
> @@ -0,0 +1,39 @@
> +#!/bin/bash
> +
> +source $TOP/tests/common
> +
> +check_prereq btrfs-corrupt-block
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +prepare_test_dev 512M
> +
> +
> +# simulate missing csum error and repair using init-csum option
> +test_csum_corruption()
> +{
> +	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
> +
> +	run_check_mount_test_dev
> +
> +	export DATASET_SIZE=1
> +	generate_dataset small
> +
> +	run_check_umount_test_dev
> +
> +	# find bytenr
> +	bytenr=`$SUDO_HELPER $TOP/btrfs-debug-tree $TEST_DEV | \

Please don't use btrfs-debug-tree, it's been obsoleted by the dump-tree
subcommand. And you can use the '-t csum' option to dump just the csum
tree.

> +	grep "EXTENT_CSUM EXTENT_CSUM" | \
> +	cut -f1 -d')' | awk '{print $6}'`

This can be simplified to one sed command.

> +
> +	# corrupt csum bytenr
> +	run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -C $bytenr $TEST_DEV
> +
> +	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
> +			_fail "btrfs check failed to detect missing csum."

Here we want to capture the output from 'check' for analysis in case of
problems.

> +	run_check $SUDO_HELPER $TOP/btrfs check --repair --init-csum $TEST_DEV
> +	run_check $SUDO_HELPER $TOP/btrfs check  $TEST_DEV
> +}
> +
> +test_csum_corruption
