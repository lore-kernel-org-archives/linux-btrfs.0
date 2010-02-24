From: planetf1 <bugs@cherrybyte.me.uk>
Subject: Resizing a btrfs managed partition
Date: Wed, 24 Feb 2010 14:32:50 +0000
Message-ID: <hm3dai$pnl$1@dough.gmane.org>
Reply-To: bugs@cherrybyte.me.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
  Let me know if this is the wrong place to ask...

  I'm using Fedora 12 x86_64, mostly with the newer 21.6.32 kernel, and 
have a single btrfs filesystem within a 120Gb partition.

  I'd like to extend the space btrfs can use. One option is presumably 
add a new device to btrfs, but I was hoping to simple resize the 
existing partition to say 160Gb.

  With ext4 I might do this with gparted , although mostly I'd use LVM, 
with seperate LVs for /opt /home / etc and that's been the way I've done 
it for many years.

  With btrfs I'm unsure as to the safe steps and decided to skip on use 
of LVM giving the enhanced capabilities of btrfs itself.

  Is it ok to resize the partition with gparted?
  How do I make btrfs use the new partition size?
  Or are there other btrfs specific tools that can manage partitions
  Would I be better off still using lvm in conjunction with btrfs?
  Are there good pointers to useful user material on btrfs on these issues?
  Is creating new subvolumes to manage /home (say I want to limit that 
space, and create snapshots independently) appropriate, and if so what's 
the easiest way to do that -- I had trouble with getting the subvolume 
ops to work

Mostly rather than NEED btrfs per se, I'm using a clean laptop 
environment as a way to experiment with the new filesystem & understand 
how to manage it.

Thanks
Nigel.
bugs@cherrybyte.me.uk


