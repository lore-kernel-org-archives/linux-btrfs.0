Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbcFFJGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 05:06:21 -0400
Date: Mon, 6 Jun 2016 11:05:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: convert-tests: Add test case for
 backup superblock migration
Message-ID: <20160606090537.GW29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
 <20160603023426.25216-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160603023426.25216-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 10:34:26AM +0800, Qu Wenruo wrote:
> New convert introduced simpler chunk/extent allocation algorithm, at the
> cost of complex backup superblock migration codes.
> 
> Use specially built ext2 images to test if btrfs-convert can convert and
> rollback images without problem.
> 
> All these special ext2 image have blocks/holes across 2nd btrfs backup
> superblock.
> 
> The naming of test image is like the following:
> 	|<------superblock migration range----->|
> 	64M					64M + 64K
> |-Data--|-Data--|/Hole//|-Data--|/Hole//|-Data--|--Data--| = drdhdhdrd
> 
> These test cases should check all typical layouts and make sure new
> convert works.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.

> +	extracted=$(extract_image "$src")
> +	run_check $SUDO_HELPER e2fsck -n -f $extracted
> +	run_check $SUDO_HELPER $TOP/btrfs-convert $extracted
> +	run_check $SUDO_HELPER $TOP/btrfs check $extracted
> +	run_check $SUDO_HELPER $TOP/btrfs-show-super $extracted
> +
> +	run_check $SUDO_HELPER mount -o loop $extracted $TEST_MNT
> +	run_check $SUDO_HELPER e2fsck -n -f $TEST_MNT/ext2_saved/image
> +	run_check $SUDO_HELPER umount $TEST_MNT
> +
> +	run_check $SUDO_HELPER $TOP/btrfs check $extracted
> +	run_check $SUDO_HELPER $TOP/btrfs-convert -r $extracted
> +	run_check $SUDO_HELPER e2fsck -n -f $extracted

Most of the SUDO_HELPER calls are not necessary, and the tests failed
when run under user (on NFS where root cannot do everything), so I did
some additional changes. The separate convert dir should be now ready
for adding more images easily.
