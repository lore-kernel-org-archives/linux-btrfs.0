From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Fri, 10 Feb 2012 17:18:42 -0500
Message-ID: <20120210221842.GU8384@shiny>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: btrfs@nentwig.biz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2012 at 08:30:51PM +0100, btrfs@nentwig.biz wrote:
> Hi!
> 
> I used to have arch linux running on 1 btrfs partition (sda1, incl. /boot).
> When switching to 3.2.5 recently the system fails to boot:
> 
> (after udevd)
> /etc/rc.sysinit: line 15: 117 Bus error  mountpoint -q /proc
> and so on, no idea.
> 
> It used to boot with 3.2.4, but
> 
> 1) I obviously had some corruption in the tree, when I tried to delete a
> certain file I hit e.g. "kernel BUG at fs/btrfs/extent-tree.c" message.
> 
> 2) Even while running 3.2.4 I was unable to mount the partition from a
> parallel gentoo or live USB install and I still am:
> 
> # mount /dev/sda1 /mnt/arch/
> mount: /dev/sda1: can't read superblock
> 
> The strange thing is: when trying to boot from the partition the
> boot loader (syslinux) is
> obviously still able load the kernel from that partition.
> 
> Tried btrfs-zero-log and some deperate other things. Result: I can
> now actually
> execute btrfsck which previously used to fail:

Ok, step one:

Pull down the dangerdonteveruse branch of btrfs-progs:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git dangerdonteveruse

Run btrfs-debug-tree -r /dev/sda1 and send the output here please.

This block with bad transid is from your FS root.  We'll need to a root
that matches.  But we should be able to patch things up!

-chris
