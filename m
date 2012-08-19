Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41000 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752747Ab2HSO7H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 10:59:07 -0400
Message-ID: <5030FF4C.8080103@gmx.net>
Date: Sun, 19 Aug 2012 16:59:24 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Robert Buhren <robert@robertbuhren.de>
CC: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Subject: Re: Testing new send/receive: "ERROR: could not resolve root_id for"
References: <5028D57F.5090803@robertbuhren.de>
In-Reply-To: <5028D57F.5090803@robertbuhren.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem here is that you nest multiple mounts of the same fs.
This confuses find_mount_root which determines the upper-level
mount as the mountpoint instead of the lower-level one.
It does that because it searches upwards for the first change in
the fsid. As you nested the name fs, the fsid does not change when
it crosses the boundary, so it misses the mountpoint.

What is the accepted way to find a mountpoint? I've seen lots of
code that searches the mnttab, is there a more convenient way?

-Arne

On 08/13/2012 12:22 PM, Robert Buhren wrote:
> Hello,
> 
> i wanted to test the new send/receive feature and i can't manage to send
> a snapshot to a file. I always get the error
> "ERROR: could not resolve root_id for".
> 
> I'm using kernel 3.6-rc1 and the latest btrfs progs from git.
> 
> This is what i'm doing:
> 
> mount -o subvolid=0,discard,compress=lzo /dev/sda4 /mnt/ROOT_BTRFS
> 
> [root@robert-laptop mnt]# /home/robert/ArchLinux/btrfs-progs/btrfs
> subvolume list ROOT_BTRFS/
> ID 256 top level 5 path btrfs_root <--- my rootfs subvolume
> ID 265 top level 5 path btrfs_root-11082012-0023      <--- a "normal"
> snapshot"
> ID 268 top level 5 path root_send <--- a read only snapshot i try to use
> with send
> 
> [root@robert-laptop ~]# cd /mnt/ROOT_BTRFS/
> [root@robert-laptop ROOT_BTRFS]#
> /home/robert/ArchLinux/btrfs-progs/btrfs send root_send > outROOT
> At subvol root_send
> ERROR: could not resolve root_id for /mnt/ROOT_BTRFS/root_send
> 
> Am i somehow misunderstanding how the send/receive feature should work?
> My idea is to send the "root_send" snapshot to a file and then replay
> that file later on a backup btrfs partition. Once i've done that i can
> just send incremental differences to the backup partition. Is that how
> "send/receive" is supposed to work?
> 
> If you need further information just tell me.
> 
> Thanks in advance,
> 
> Robert
> 
> 
> PS: Please respond to my email address as i'm not subscribed to the list.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

