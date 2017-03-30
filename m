Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933356AbdC3Pw4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 11:52:56 -0400
Date: Thu, 30 Mar 2017 17:52:11 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: quwenruo@cn.fujitsu.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: fsck-tests: verify 'btrfs check
 --repair' fixes corrupted nlink field
Message-ID: <20170330155211.GK4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170202080502.GA6676@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202080502.GA6676@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 01:35:02PM +0530, Lakshmipathi.G wrote:
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> ---
>  tests/fsck-tests/026-check-inode-link/test.sh | 30 +++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100755 tests/fsck-tests/026-check-inode-link/test.sh
> 
> diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
> new file mode 100755
> index 0000000..6822ee2
> --- /dev/null
> +++ b/tests/fsck-tests/026-check-inode-link/test.sh
> @@ -0,0 +1,30 @@
> +#!/bin/bash
> +# verify that 'btrfs check --repair' fixes corrupted inode nlink field
> +
> +source $TOP/tests/common
> +
> +check_prereq btrfs-corrupt-block
> +check_prereq mkfs.btrfs
> +
> +setup_root_helper
> +prepare_test_dev 512M

Please use default size unless you really need 512M for the test
purposes.

> +
> +test_inode_nlink_field()
> +{
> +	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
> +
> +	run_check_mount_test_dev
> +	run_check $SUDO_HELPER touch $TEST_MNT/test_nlink.txt
> +
> +	# find inode_number
> +	inode_number=`stat -c%i $TEST_MNT/test_nlink.txt`
> +	run_check_umount_test_dev
> +
> +	# corrupt nlink field of inode object
> +        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -i $inode_number \
> +		-f nlink $TEST_DEV
> +
> +	check_image $TEST_DEV

The wrapper runs a pre-check that must detect errors, then runs --repair
and then again a plain check. Is this intended here?

I think we should try to mount the fixed image again and read the file
or check link count.

Please add shell quotation around all variables.
