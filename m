From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Thu, 29 Mar 2012 18:44:39 +0300
Message-ID: <20120329154438.GB3891@zambezi.lan>
References: <20120329105235.GA1198@panda>
 <20120329131638.GA1942@localhost.localdomain>
 <20120329143929.GB29741@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120329143929.GB29741@panda>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2012 at 04:39:29PM +0200, Sander wrote:
> Hello Josef,
> 
> Josef Bacik wrote (ao):
> > On Thu, Mar 29, 2012 at 12:52:35PM +0200, Sander wrote:
> > > I can't seem to balance my btrfs filesystem. It segfaults, and gives a
> > > kernel bug:
> > > 
> > > [ 1355.139099] ------------[ cut here ]------------
> > > [ 1355.139099] kernel BUG at fs/btrfs/volumes.c:2733!
> > > [ 1355.149322] Internal error: Oops - BUG: 0 [#1] SMP
> > > [ 1355.149322] Modules linked in:
> > > [ 1355.154479] CPU: 0    Not tainted  (3.3.0 #8)
> > > [ 1355.162109] PC is at btrfs_balance+0x312/0xb04
> > > [ 1355.166778] LR is at btrfs_run_delayed_iputs+0x2d/0xac
> 
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
> > Well that's kind of cool.  So 2 options
> > 
> > 1) If you are in a hurry and need this stuff back right away run btrfs fi
> > balance resume / and it should work, buuutt
> > 
> > 2) If you aren't in a hurry I'd really like to try and reproduce this locally
> > and if I can't I'd like to be able to send you patches to help me figure out how
> > to fix this problem.
> 
> I am in no hurry at all. The filesystem seems just fine the way it is
> (after a reboot), so there is no "stuff to get back right away". Does
> the kernel bug suggest the filesystem is fubar?

No, as I said in another mail you are trapping over a simle sanity
check.  FS should be OK.

Thanks,

		Ilya
