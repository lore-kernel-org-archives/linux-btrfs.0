Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752490AbeC3UQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 16:16:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5052FAD4A
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 20:16:30 +0000 (UTC)
Date: Fri, 30 Mar 2018 22:14:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: tests/misc: Test if btrfs-image can
 handle RAID1 missing device
Message-ID: <20180330201403.GV30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180330073528.20650-1-wqu@suse.com>
 <20180330073528.20650-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180330073528.20650-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 03:35:28PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied with the fixes below, thanks.

> ---
>  tests/misc-tests/030-missing-device-image/test.sh | 57 +++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>  create mode 100755 tests/misc-tests/030-missing-device-image/test.sh
> 
> diff --git a/tests/misc-tests/030-missing-device-image/test.sh b/tests/misc-tests/030-missing-device-image/test.sh
> new file mode 100755
> index 000000000000..b8ae3a950cc9
> --- /dev/null
> +++ b/tests/misc-tests/030-missing-device-image/test.sh
> @@ -0,0 +1,57 @@
> +#!/bin/bash
> +# Test that btrfs-image can dump image correctly for missing device (RAID1)
> +#
> +# At least for RAID1, btrfs-image should be able to handle one missing device
> +# without any problem
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq btrfs-image
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +setup_loopdevs 2
> +prepare_loopdevs
> +dev1=${loopdevs[1]}
> +dev2=${loopdevs[2]}
> +
> +# $1:	device number to remove (either 1 or 2)
> +tmp=$(mktemp --tmpdir -d btrfs-progs-misc-test-XXXXXXX)

Not necessary.

> +test_missing()
> +{
> +	bad_num=$1
> +	bad_dev=${loopdevs[$bad_num]}
> +	good_num=$((3 - $bad_num))
> +	good_dev=${loopdevs[$good_num]}

All of them should be declared as local

> +
> +	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -d raid1 -m raid1 \
> +		"$dev1" "$dev2"
> +	
> +	# fill the fs with some data, we could create space cache
> +	run_check $SUDO_HELPER mount "$dev1" "$TEST_MNT"
> +	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/a" bs=1M count=10
> +	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/b" bs=4k count=1000 conv=sync
> +	run_check $SUDO_HELPER umount "$TEST_MNT"
> +	
> +	# make sure we have space cache
> +	run_check_stdout "$TOP/btrfs" inspect dump-tree -t root "$dev1" \
> +		> "$tmp/output"
> +	if ! grep -q "EXTENT_DATA" "$tmp/output" ; then

this can be glued to one line, making the tmp files unnecessry

> +		# normally above operation should create space cache.
> +		# if not, it may means we have migrated to v2 cache by default
> +		_not_run "unable to create v1 space cache"
> +	fi
> +
> +	# now wipe the device
> +	run_check wipefs -fa "$bad_dev"
> +
> +	# we don't care about the image but btrfs-image must not fail
> +	run_check "$TOP/btrfs-image" "$good_dev" /dev/null
> +}
> +
> +# Test with either device missing, so we're ensured to hit missing device
> +test_missing 1
> +test_missing 2
> +cleanup_loopdevs
> +rm $tmp -rf
