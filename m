Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdJ0RBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 13:01:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA7D8AB5D
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 17:01:12 +0000 (UTC)
Date: Fri, 27 Oct 2017 18:59:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal
 device size is valid
Message-ID: <20171027165924.GN3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171027005324.17950-1-wqu@suse.com>
 <20171027005324.17950-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171027005324.17950-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 08:53:24AM +0800, Qu Wenruo wrote:
> New test case to test if the minimal device size given by "mkfs.btrfs"
> failure case is valid.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/mkfs-tests/010-small-image/test.sh | 49 ++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100755 tests/mkfs-tests/010-small-image/test.sh
> 
> diff --git a/tests/mkfs-tests/010-small-image/test.sh b/tests/mkfs-tests/010-small-image/test.sh
> new file mode 100755
> index 000000000000..f55760df061f
> --- /dev/null
> +++ b/tests/mkfs-tests/010-small-image/test.sh
> @@ -0,0 +1,49 @@
> +#!/bin/bash
> +# test if the reported minimal size of mkfs.btrfs is valid
> +
> +source "$TOP"/tests/common
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +
> +do_test()
> +{
> +	# Well, 1M small enough to fail, we just use the output
> +	# to get the minimal device size
> +	prepare_test_dev 1M
> +	output=$(run_mustfail_stdout "mkfs.btrfs for small image" \
> +		 "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV")
> +	good_size=$(echo "$output" | grep -oP "(?<=is )\d+")
> +
> +	prepare_test_dev "$good_size"
> +	run_check "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV"
> +	run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
> +	run_check $SUDO_HELPER umount "$TEST_MNT"

There are helpers for the default mounts, you can use them to save some
typing: run_check_mount_test_dev and run_check_umount_test_dev.

> +}
> +
> +do_test -n 4k	-m single	-d single

I don't seem to get this test to work, it fails with this in the log:

=== Entering btrfs-progs/tests/mkfs-tests/010-small-image
$TEST_DEV not given, use btrfs-progs/test/test.img as fallback
############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single btrfs-progs/tests/test.img
btrfs-progs v4.13.3-61-g0615ffa351c2
See http://btrfs.wiki.kernel.org for more information.

failed (expected): btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single btrfs-progs/tests/test.img
############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single btrfs-progs/tests/test.img
btrfs-progs v4.13.3-61-g0615ffa351c2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               b9b55b1b-4096-46ee-acd0-15151a8050d6
Node size:          4096
Sector size:        4096
Filesystem size:    16.00MiB
Block group profiles:
  Data:             single            1.56MiB
  Metadata:         single            1.56MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    16.00MiB  btrfs-progs/tests/test.img

############### root_helper mount btrfs-progs/tests/test.img btrfs-progs/tests/mnt
############### root_helper umount btrfs-progs/tests/mnt
############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-progs/tests/test.img
btrfs-progs v4.13.3-61-g0615ffa351c2
See http://btrfs.wiki.kernel.org for more information.

failed (expected): btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-progs/tests/test.img
############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-progs/tests/test.img
ERROR: not enough free space to allocate chunk
btrfs-progs v4.13.3-61-g0615ffa351c2
See http://btrfs.wiki.kernel.org for more information.

failed: btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-progs/tests/test.img
test failed for case 010-small-image
---

The output is unexpected and does not contain the minimal size. The tested
branch is current devel (7141063af3c9a423dda), your mkfs --rootdir rework
patches are there. Can you please have a look?
