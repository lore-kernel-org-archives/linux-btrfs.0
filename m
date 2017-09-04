Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753885AbdIDRpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 13:45:06 -0400
Date: Mon, 4 Sep 2017 19:43:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: test/mkfs: Add test case for rootdir
 parameter
Message-ID: <20170904174338.GE31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170904034320.25744-1-quwenruo.btrfs@gmx.com>
 <20170904034320.25744-2-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170904034320.25744-2-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 12:43:20PM +0900, Qu Wenruo wrote:
> Add test case which checks if -r|--rootdir mount option can handle
> softlink/char/block/fifo files.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Patch 1 applied, please fix up the test as commented below.

> ---
>  .../009-special-files-for-rootdir/test.sh          | 40 ++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100755 tests/mkfs-tests/009-special-files-for-rootdir/test.sh
> 
> diff --git a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
> new file mode 100755
> index 00000000..bc5297d0
> --- /dev/null
> +++ b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
> @@ -0,0 +1,40 @@
> +#!/bin/bash
> +# Check if --rootdir can handle special files (socket/fifo/char/block) correctly
> +#
> +# --rootdir had a problem of filling dir items/indexes with wrong type
> +# and caused btrfs check to report such error
> +
> +source "$TOP/tests/common"
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper		# For mknod
> +prepare_test_dev 128M

Device size should be default (ie. no size), unless really required.

> +
> +# mknod can create FIFO/CHAR/BLOCK file but not SOCK.
> +# No neat tool to create socket file, unless using python or similar.
> +# So no SOCK is tested here

Ok, we can live without that.

> +check_global_prereq mknod
> +
> +# Also check regular file
> +check_global_prereq dd
> +
> +# And dir
> +check_global_prereq mkdir

We can assume the base utilities to exist, so cp, rm, mkdir, and several
more.

> +tmp="/tmp/btrfs_selftest_$$"

Please use something like $(mktemp --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)

> +
> +run_check mkdir $tmp
> +run_check mkdir $tmp/dir
> +run_check mkdir -p $tmp/dir/in/dir
> +run_check mknod $tmp/fifo p
> +run_check $SUDO_HELPER mknod $tmp/char c 1 1
> +run_check $SUDO_HELPER mknod $tmp/block b 1 1
> +run_check dd if=/dev/zero bs=1M count=1 of=$tmp/regular
> +
> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -r "$tmp" $TEST_DEV
> +
> +rm "$tmp" -rf

This should be options first, then arguments.

> +
> +run_check $SUDO_HELPER "$TOP/btrfs" check $TEST_DEV
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
