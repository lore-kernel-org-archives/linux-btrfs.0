From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Thu, 29 Mar 2012 18:41:54 +0300
Message-ID: <20120329154154.GA3891@zambezi.lan>
References: <20120329105235.GA1198@panda>
 <20120329135324.GA1899@zambezi.lan>
 <20120329151422.GC29741@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120329151422.GC29741@panda>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2012 at 05:14:22PM +0200, Sander wrote:
> Ilya Dryomov wrote (ao):
> > On Thu, Mar 29, 2012 at 12:52:35PM +0200, Sander wrote:
> > > After a reboot, I tried again, with the same result:
> > > 
> > > [   81.048767] ------------[ cut here ]------------
> > > [   81.053619] kernel BUG at fs/btrfs/volumes.c:2733!
> > > [   81.053619] Internal error: Oops - BUG: 0 [#1] SMP
> > > [   81.059295] Modules linked in:
> > > [   81.059295] CPU: 1    Not tainted  (3.3.0 #8)
> > > [   81.071411] PC is at btrfs_balance+0x312/0xb04
> > > [   81.074890] LR is at btrfs_run_delayed_iputs+0x2d/0xac
> 
> > So you have balance item on disk, but the kernel doesn't seem to know
> > about it in advance, which is odd and so when you try to run balance it
> > panics on one of the safety checks.
> > 
> > > The system is a pandaboard running a plain Linus kernel 3.3.0 with a
> > > btrfs filesystem, over two Intel 320 600GB ssd's, connected via usb (on
> > > an usb hub), on top of md_crypt. Mount options:
> > > "subvol=rootvolume,space_cache,inode_cache,compress=lzo,ssd"
> > > 
> > > Before the balance, I deleted about 2500 snapshots and waited for the
> > > btrfs kernel threads to calm down. Then I initiated a btrfs filesystem
> > > scrub. Unfortunately during the scrub, the filesystem balance started.
> > > Might be related.
> > 
> > That's indeed pretty cool, I wonder how that could happen.
> 
> I create 5 snapshots of 5 different subvolumes every 5 minutes, and the
> system is low on memory:
> 
>              total       used       free     shared    buffers     cached
> Mem:           745        712         33          0          0        480
> -/+ buffers/cache:        231        514
> Swap:            0          0          0
> 
> There is ample space on the fileystem:
> panda:~# df -h /
> Filesystem                                              Size  Used Avail Use% Mounted on
> /dev/mapper/ata-INTEL_SSDSA2CW600G3_CVPR112405AJ600FGN  1.1T   17G  1.1T   2% /
> 
> panda:~# btrfs filesystem df /
> Data, RAID0: total=24.00GB, used=15.69GB
> System, RAID1: total=64.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=23.00GB, used=231.26MB
> 
> Do you need more information?

No, that's enough for now.

> 
> > I'm definitely intrested in reproducing it. Could you please umount this
> > filesystem, capture the output of 'btrfs-debug-tree -d <dev>' and post it
> > somewhere ?
> 
> Will do. It is the / filesystem, so I'll need to reboot.

I need this to confirm that balance item is on disk.

> 
> > After that mount it back and see if there is "btrfs: continuing
> > balance" line in dmesg (and if btrfs-balance kthread shows up)?
> 
> There was none after the first reboot, but I'll pay extra attention to
> that after the next reboot.
> 
> > If so, just let it run, it should finish the balance and remove
> > on-disk item. (You can query the status of running balance with 'btrfs
> > balance status <mnt>')
> 
> Do I need newer tools for that? This is Debian Sid (unstable):

Yeah, you do.  That command is in master now, but it's not really
needed.  If btrfs-balance shows up, just wait for it to finish, it
should get rid of the balance item.  If it doesn't show up but the item
is there we will have to dig deeper.

Thanks,

		Ilya
