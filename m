Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53141 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3JIQBa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 12:01:30 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5B6789A06B2
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 10:01:30 -0600 (MDT)
Date: Wed, 9 Oct 2013 12:01:27 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eryu Guan <guaneryu@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:2255!
Message-ID: <20131009160127.GF16461@localhost.localdomain>
References: <20131009155323.GA11404@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131009155323.GA11404@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 11:53:23PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I hit a BUG_ON while playing with btrfs balance. Kernel is
> 3.12-rc4.
> 
> The reproducer is a script doing subvolume create/mount/umount/delete
> in loop at back ground and do balance at the same time.
> 
> It's reproducable everytime. And seems like this is a regression, I
> cannot reproduce it on 3.10 kernel. (I'll write a test case for
> xfstests.)
> 
> Reproducer:
> 
> # cat test.sh
> #!/bin/bash
> 
> btrfs_dev=$1
> btrfs_mnt=$2
> pid=$$
> subvol_mnt=/mnt/subvol_$pid
> 
> mkdir -p $subvol_mnt
> 
> trap "umount $subvol_mnt; btrfs sub del $btrfs_mnt/sub_$pid; rmdir $subvol_mnt; exit 0" 0 1 2 3 15
> 
> while true;do
>         btrfs subvolume create $btrfs_mnt/sub_$pid
>         mount -o subvol=sub_$pid $btrfs_dev $subvol_mnt
>         umount $subvol_mnt
>         btrfs subvolume delete $btrfs_mnt/sub_$pid
> done
> 
> and do
> 
> # mkfs -t btrfs -f /dev/loop0 /dev/loop1
> # mount /dev/loop0 /mnt/btrfs
> # ./test.sh /dev/loop0 /mnt/btrfs >/dev/null &
> # btrfs fi balance /mnt/btrfs
> 

Fixed by Miao's patches in btrfs-next.  Thanks,

Josef
