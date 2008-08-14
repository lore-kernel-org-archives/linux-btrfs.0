From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs day 1
Date: Thu, 14 Aug 2008 13:26:00 -0400
Message-ID: <1218734760.15342.381.camel@think.oraclecorp.com>
References: <20080814001120.4f1fea7a@speedy>
	 <1218709514.15342.370.camel@think.oraclecorp.com>
	 <20080814091937.470f42ed@speedy>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080814091937.470f42ed@speedy>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-14 at 09:19 -0700, Stephen Hemminger wrote:
> On Thu, 14 Aug 2008 06:25:14 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Thu, 2008-08-14 at 00:11 -0700, Stephen Hemminger wrote:
> > > Setup new 60G home partition on laptop as a real life test of 0.16.
> > > Using Ubuntu standard kernel 2.6.24-19-generic on i386
> > > 
> > 
> > Thanks for giving things a try
> > 
> > > I notice that during normal (busy time) everything seems fine, but after going away
> > > for a while and coming back, it seems sluggish. Lots of errors in log:
> > > 
> > >  btrfs csum failed ino 139988 off 4583424 csum 3821684403 private 0
> > >  btrfs csum failed ino 139988 off 4579328 csum 3233603900 private 0
> > >  btrfs csum failed ino 139988 off 4575232 csum 306171610 private 0
> > > 
> > > Maybe it isn't handleing spindown properly? or something like that?
> > 
> > Were these the only errors in the log, or did you have other errors
> > about not being able to find specific csums?
> > 
> > What does 'going away for a while and coming back' include?
> 
> 1. Start kernel build
> 2. Come back 2+ hrs later
> 
> (So problem could be in step 1 or 2)
> 
> All failures are on the same inode

Ok, my guess is that if you find . -inum 13998 you'll get some form of
vmlinux or .tmp_vmlinux*

So, the question is why the kernel compile workload works for me.  What
kind of hardware are you running (ram, cpu, disks?)

-chris


