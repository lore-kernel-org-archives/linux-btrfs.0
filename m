Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933401AbeAHTlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:41:24 -0500
Date: Mon, 8 Jan 2018 20:39:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, adambahe@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: misc-test: Add test case to check if fi
 usage and show report consistent unallocated space
Message-ID: <20180108193916.GM13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180102063315.32382-1-wqu@suse.com>
 <20180102063315.32382-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180102063315.32382-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 02, 2018 at 02:33:15PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/misc-tests/028-fi-usage-cross-check/test.sh | 46 +++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100755 tests/misc-tests/028-fi-usage-cross-check/test.sh
> 
> diff --git a/tests/misc-tests/028-fi-usage-cross-check/test.sh b/tests/misc-tests/028-fi-usage-cross-check/test.sh
> new file mode 100755
> index 000000000000..bf438b60abf1
> --- /dev/null
> +++ b/tests/misc-tests/028-fi-usage-cross-check/test.sh
> @@ -0,0 +1,46 @@
> +#!/bin/bash
> +# check fi-usage is output correct unallocated space for RAID10
> +
> +source "$TOP/tests/common"
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +
> +setup_loopdevs 4
> +prepare_loopdevs
> +dev1=${loopdevs[1]}
> +
> +run_check "$TOP/mkfs.btrfs" -d raid10 -m raid10 -f ${loopdevs[@]}
> +run_check $SUDO_HELPER mount $dev1 "$TEST_MNT"

There's a helper macro for that, run_check_mount_test_dev, that expects
the TEST_DEV to be set. I suggest to use this variable instead of dev1,
and then the umount command can be replaced by
run_check_umount_test_dev.
> +
> +output_dir=$(mktemp -d --tmpdir btrfs-progs-misc.XXXXXXXX)

This is not IMO necessary, you get only one line from the fi show output
and check if it's not empty. A simple 'if grep ...' . The output is
reused so you can store it to a variable.

> +
> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem show --raw "$TEST_MNT" |\
> +	grep "$dev1" > "$output_dir/fi_show_output"
> +if [ ! -s "$output_dir/fi_show_output" ]; then
> +	_fail "failed to get correct fi show output"
> +fi
> +
> +dev1_total=$(cat "$output_dir/fi_show_output" | awk '{print $4}')
> +dev1_used=$(cat "$output_dir/fi_show_output" | awk '{print $6}')
> +dev1_fi_show_unallocated=$(( $dev1_total - $dev1_used))
> +
> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem usage --raw "$TEST_MNT" |\
> +	grep "$dev1" | tail -n1 > "$output_dir/fi_usage_output"
> +if [ ! -s "$output_dir/fi_usage_output" ]; then
> +	_fail "failed to get correct fi usage output"
> +fi
> +
> +dev1_fi_usage_unallocated=$(cat "$output_dir/fi_usage_output" | awk '{print $2}')
> +echo "fi usage unallocated for devid1 is $dev1_fi_usage_unallocated" >> "$RESULTS"
> +echo "fi show unallocated for devid1 is $dev1_fi_show_unallocated" >> "$RESULTS"
> +
> +if [ $dev1_fi_show_unallocated -ne $dev1_fi_usage_unallocated ]; then
> +	_fail "fi usage unallocated mismatch with fi show"
> +fi
> +
> +run_check $SUDO_HELPER umount "$TEST_MNT"
> +cleanup_loopdevs
> +rm $output_dir -rf

Please quote all arguments, namely if it's passed to 'rm', and options
should go before arugments.
