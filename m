Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337AbbI2DyT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 23:54:19 -0400
Date: Tue, 29 Sep 2015 11:54:11 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>, Martin Raiber <martin@urbackup.org>
Subject: Re: [PATCH] fstests: test for btrfs incremental send after replacing
 a file
Message-ID: <20150929035411.GE30949@dhcp-13-216.nay.redhat.com>
References: <1443267613-9453-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443267613-9453-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2015 at 12:40:13PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that an incremental send works after a file from the parent snapshot
> gets replaced in the send snapshot by another one at the same exact
> location, with the same name and with the same inode number.
> 
> This test used to fail after the linux kernel commit 8b191a684968
> ("Btrfs: incremental send, check if orphanized dir inode needs delayed
> rename") and it's fixed by patch titled:
> 
>   "Btrfs: send, fix corner case for reference overwrite detection"

I got "btrfs receive" error when testing this, with 4.3-rc1 kernel and
btrfs-progs v4.2, not sure if this is expected

At subvol /mnt/testarea/scratch/mysnap2_ro
# /usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/1.snap
At subvol mysnap1
# /usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/2.snap
ERROR: unlink o258-7-0 failed. No such file or directory
At snapshot mysnap2_ro
failed: '/usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/2.snap'

Thanks,
Eryu
