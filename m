From: Sander <sander@humilis.net>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Fri, 30 Mar 2012 19:49:56 +0200
Message-ID: <20120330174956.GA770@panda>
References: <20120329105235.GA1198@panda>
 <20120329135324.GA1899@zambezi.lan>
 <20120329151422.GC29741@panda>
 <20120329154154.GA3891@zambezi.lan>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120329154154.GA3891@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ilya,

Ilya Dryomov wrote (ao):
> > > I'm definitely intrested in reproducing it. Could you please umount this
> > > filesystem, capture the output of 'btrfs-debug-tree -d <dev>' and post it
> > > somewhere ?
> > 
> > Will do. It is the / filesystem, so I'll need to reboot.
> 
> I need this to confirm that balance item is on disk.

I'm sorry it took so long. I'll mail the output to you directly.

> > > After that mount it back and see if there is "btrfs: continuing
> > > balance" line in dmesg (and if btrfs-balance kthread shows up)?

There is no such line in dmesg, and currently no btrfs-balance kthread
is running. I've pulled Chris Masons for-linus and booted with the
resulting kernel.

> > > If so, just let it run, it should finish the balance and remove
> > > on-disk item. (You can query the status of running balance with 'btrfs
> > > balance status <mnt>')
> > 
> > Do I need newer tools for that? This is Debian Sid (unstable):
> 
> Yeah, you do. That command is in master now, but it's not really
> needed. If btrfs-balance shows up, just wait for it to finish, it
> should get rid of the balance item. If it doesn't show up but the item
> is there we will have to dig deeper.

Ok :-)

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
