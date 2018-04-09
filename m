Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50703 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbeDIOdk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:33:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AD0EEAE21
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 14:33:38 +0000 (UTC)
Date: Mon, 9 Apr 2018 16:31:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: tests/fsck: Add test case to check if
 btrfs check can skip data csum verfication for metadata dump
Message-ID: <20180409143109.GS8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180403053947.5908-1-wqu@suse.com>
 <20180403053947.5908-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180403053947.5908-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 01:39:47PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  .../031-metadatadump-check-data-csum/test.sh       | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100755 tests/fsck-tests/031-metadatadump-check-data-csum/test.sh
> 
> diff --git a/tests/fsck-tests/031-metadatadump-check-data-csum/test.sh b/tests/fsck-tests/031-metadatadump-check-data-csum/test.sh
> new file mode 100755
> index 000000000000..9f14c4122f4b
> --- /dev/null
> +++ b/tests/fsck-tests/031-metadatadump-check-data-csum/test.sh
> @@ -0,0 +1,32 @@
> +#!/bin/bash
> +# To check if "btrfs check" can detect metadata dump (restored by btrfs-iamge)
> +# and ignore --check-data-csum option
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq btrfs
> +check_prereq mkfs.btrfs
> +check_prereq btrfs-image
> +setup_root_helper
> +prepare_test_dev
> + 
> +tmp=$(mktemp --tmpdir btrfs-progs-fsck.XXXXXXX)

For a single temporary file I'd suggest not to use mktemp, so I'll remove
the line.

> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
> +run_check_mount_test_dev
> +
> +run_check $SUDO_HELPER dd if=/dev/urandom of="$TEST_MNT/file" bs=4k count=16
> +run_check_umount_test_dev
> +
> +run_check $SUDO_HELPER "$TOP/btrfs-image" "$TEST_DEV" "$tmp.image"
> +
> +# use prepare_test_dev() to wipe all existing data on $TEST_DEV
> +# so there is no way that restored image could have mathcing data csum
> +prepare_test_dev
> +
> +run_check $SUDO_HELPER "$TOP/btrfs-image" -r "$tmp.image" "$TEST_DEV"
> +
> +# Should not report any error
> +run_check "$TOP/btrfs" check --check-data-csum "$TEST_DEV"
> +
> +rm -rf -- "$tmp*"
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
