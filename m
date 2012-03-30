From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Fri, 30 Mar 2012 22:52:51 +0300
Message-ID: <20120330195251.GA1928@zambezi.lan>
References: <20120329105235.GA1198@panda>
 <20120329135324.GA1899@zambezi.lan>
 <20120329151422.GC29741@panda>
 <20120329154154.GA3891@zambezi.lan>
 <20120330174956.GA770@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120330174956.GA770@panda>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 07:49:56PM +0200, Sander wrote:
> Hello Ilya,
> 
> Ilya Dryomov wrote (ao):
> > > > I'm definitely intrested in reproducing it. Could you please umount this
> > > > filesystem, capture the output of 'btrfs-debug-tree -d <dev>' and post it
> > > > somewhere ?
> > > 
> > > Will do. It is the / filesystem, so I'll need to reboot.
> > 
> > I need this to confirm that balance item is on disk.
> 
> I'm sorry it took so long. I'll mail the output to you directly.

Thanks.  btrfs-debug-tree confirms that you've got a balance item on
media.

> 
> > > > After that mount it back and see if there is "btrfs: continuing
> > > > balance" line in dmesg (and if btrfs-balance kthread shows up)?
> 
> There is no such line in dmesg, and currently no btrfs-balance kthread
> is running. I've pulled Chris Masons for-linus and booted with the
> resulting kernel.

And given the above it's weird.  We are failing to locate the item
during mount for some reason and I would like to find out why.  So if
you are up for running debugging patches (really just compiling btrfs
module and sending me dmesg output) I would appreciate that.

If you don't want to do that you can try to compile btrfs-progs from
git, mount fs and run 'btrfs balance resume <mnt>'.  If that doesn't
work I'll send you a small util that will simply delete the item from
disk.

Thanks,

		Ilya
