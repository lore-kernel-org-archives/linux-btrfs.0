Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:42504 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaAGLzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 06:55:10 -0500
Date: Tue, 7 Jan 2014 12:55:06 +0100
From: Sander <sander@humilis.net>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: correct way to rollback a root filesystem?
Message-ID: <20140107115506.GA1919@panda>
Reply-To: sander@humilis.net
References: <52C73987.7000106@jrs-s.net>
 <52C87A41.9030701@jrs-s.net>
 <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com>
 <1416119.lWHlh5idGF@quad>
 <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
 <52CB0484.8030806@jrs-s.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52CB0484.8030806@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter wrote (ao):
> I tried a kernel upgrade with moderately disastrous
> (non-btrfs-related) results this morning; after the kernel upgrade
> Xorg was completely borked beyond my ability to get it working
> properly again through any normal means. I do have hourly snapshots
> being taken by cron, though, so I'm successfully X'ing again on the
> machine in question right now.
> 
> It was quite a fight getting back to where I started even so, though
> - I'm embarassed to admit I finally ended up just doing a cp
> --reflink=all /mnt/@/.snapshots/snapshotname /mnt/@/ from the
> initramfs BusyBox prompt.  Which WORKED well enough, but obviously
> isn't ideal.
> 
> I tried the btrfs sub set-default command - again from BusyBox - and
> it didn't seem to want to work for me; I got an inappropriate ioctl
> error (which may be because I tried to use / instead of /mnt, where
> the root volume was CURRENTLY mounted, as an argument?). Before
> that, I'd tried setting subvol=@root (which is the writeable
> snapshot I created from the original read-only hourly snapshot I
> had) in GRUB and in fstab... but that's what landed me in BusyBox to
> begin with.
> 
> When I DID mount the filesystem in BusyBox on /mnt, I saw that @ and
> @home were listed under /mnt, but no other "directories" were -
> which explains why mounting -o subvol=@root didn't work. I guess the
> question is, WHY couldn't I see @root in there, since I had a
> working, readable, writeable snapshot which showed its own name as
> "root" when doing a btrfs sub show /.snapshots/root ?

I don't quite get how your setup is.

In my setup, all subvolumes and snapshots are under /.root/

# cat /etc/fstab
LABEL=panda   /  btrfs  subvol=rootvolume,space_cache,inode_cache,compress=lzo,ssd  0  0
LABEL=panda   /home           btrfs   subvol=home                                   0  0
LABEL=panda   /root           btrfs   subvol=root                                   0  0
LABEL=panda   /var            btrfs   subvol=var                                    0  0
LABEL=panda   /holding        btrfs   subvol=.holding                               0  0
LABEL=panda   /.root          btrfs   subvolid=0                                    0  0
/Varlib       /var/lib        none    bind                                          0  0


In case of an OS upgrade gone wrong, I would mount subvolid=0, move
subvolume 'rootvolume' out of the way, and move (rename) the last known
good snapshot to 'rootvolume'.

Not sure if that works though. Never tried.

	Sander
