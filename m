Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39009 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3BVTD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 14:03:26 -0500
Date: Fri, 22 Feb 2013 11:03:25 -0800
From: Zach Brown <zab@zabbo.net>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug]  mkfs.btrfs reports device busy for ext4 mounted disk
Message-ID: <20130222190325.GC22221@lenny.home.zabbo.net>
References: <5127022B.6070200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5127022B.6070200@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  Next, since previously we had btrfs on sdb and mkfs.ext4
>  does not overwrite super-block mirror 1.. so
> 
>    btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64
> sb_bytenr)
> 
>  finds btrfs on sdb.

btrfs-progs shouldn't be unconditionally trusting the backup superblocks
if the primary is garbage.  It should only check the backups if the user
specifically asks it to.

>  unless I am missing something. wipefs (along with the below patch)
>     [PATCH][v2] Btrfs: wipe all the superblock [redhat bugzilla 889888]
>  seems to be only solution as of now.

This is good practice and will work around the bug in btrfs-progs for
now.

- z
