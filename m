From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Still Problems with /dev/btrfs-control
Date: Sat, 9 Jan 2010 11:42:03 +0100
Message-ID: <20100109114203.70ae0c14@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the quick reply!

But I still have problems with btrfsctl:

> stat /dev/btrfs-control 
  File: `/dev/btrfs-control'
  Size: 0         	Blocks: 0          IO Block: 4096   block special file
Device: ch/12d	Inode: 659848      Links: 1     Device type: a,3e
Access: (0644/brw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2010-01-09 11:31:15.757979602 +0100
Modify: 2010-01-09 11:31:15.757979602 +0100
Change: 2010-01-09 11:31:15.757979602 +0100
> mount -l -t btrfs
/dev/sda3 on / type btrfs (rw,relatime,noacl) [Alpha4]
> btrfsctl -A /dev/sda3
failed to open /dev/btrfs-control: No such device or address

Remark: When the btrfs-filesystem is originally mounted (from the startup-code
in the initial ramdisk), /dev/btrfs-control is not yet existant, because the
dev-directory is contained in the btrfs-filesystem.

Everything else works fine.

Greetings, Michael
