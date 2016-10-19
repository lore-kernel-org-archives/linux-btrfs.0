Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943321AbcJSPEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 11:04:23 -0400
Date: Wed, 19 Oct 2016 17:04:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: fsck-tests: Check if clear space cache
 works
Message-ID: <20161019150421.GU11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
 <20161013092227.19761-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161013092227.19761-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 05:22:27PM +0800, Qu Wenruo wrote:
> +check_prereq mkfs.btrfs
> +
> +setup_root_helper
> +prepare_test_dev 1G
> +
> +tmp=$(mktemp)
> +run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
> +run_check_mount_test_dev
> +
> +# Create files that takes at least 3 data chunks, while 
> +# can still be removed to create free space inside one chunk.
> +
> +for i in $(seq 0 6); do
> +	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file_${i} bs=1M \
> +		count=64 > /dev/null 2>&1
> +done
> +sync
> +
> +# Remove file 1 3 5 to create holes
> +for i in $(seq 1 2 6); do

Use of seq in this case is questionable :)

> +	run_check $SUDO_HELPER rm $TEST_MNT/file_${i}
> +done
> +
> +sync
> +
> +run_check_umount_test_dev
> +
> +# Clear space cache and re-check fs
> +run_check $TOP/btrfs check --clear-space-cache v1 $TEST_DEV
> +run_check $TOP/btrfs check $TEST_DEV
> +
> +# Manually recheck space cache and super space cache generation
> +run_check_stdout $TOP/btrfs inspect-internal dump-tree -t root $TEST_DEV \
> +	> $tmp
> +grep -q FREE_SPACE $tmp

I've noticed you use the temporary file pattern. Please don't, unless
the temporary file is really used for some purpose.  I've
fixed that in previous patches.

> +if [ $? -eq 0 ]; then
> +	rm $tmp
> +	_fail "clear space cache doesn't clear all space cache"
> +fi
> +
> +run_check_stdout $TOP/btrfs inspect-internal dump-super $TEST_DEV |\
> +       	grep cache_generation > $tmp
> +
> +grep -q 18446744073709551615 $tmp

Same here.

> +if [ $? -ne 0 ]; then
> +	rm $tmp
> +	_fail "clear space cache doesn't set cache_generation correctly"
> +fi
> +rm $tmp
