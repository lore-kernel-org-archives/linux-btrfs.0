From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Thu, 18 Feb 2010 10:02:38 -0500
Message-ID: <20100218150238.GL10559@think>
References: <loom.20100212T220341-877@post.gmane.org>
 <20100217141813.GH29430@think>
 <loom.20100218T013258-629@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100218T013258-629@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 12:35:18AM +0000, Alex Elsayed wrote:
> Chris Mason <chris.mason <at> oracle.com> writes:
> 
> > 
> > On Fri, Feb 12, 2010 at 09:04:39PM +0000, Alex Elsayed wrote:
> > > I'm getting a rather nasty BUG when I try to mount this filesystem, 
> > > _including_ when I specify -o ro. I'm unsure what caused it, but the problem 
> > > manifested after my computer hardlocked while reading my RSS feeds, complete 
> > > with flashing lights. After I rebooted it, the screen filled with panic 
> > > messages when the initramfs tried to mount it RO to pivot into. I am running 
> > > 2.6.33-rc6. The BUG message is as follows:
> > 
> > The good news is this looks like a bug that Yan Zheng fixed.  2.6.33-rc7
> > or later should mount without problems.  If you're having trouble
> > getting that image onto that box, I'll get a usb boot image up with it
> > running for you.
> > 
> > -chris
> 
> No such luck. -rc8 still BUGs. Trace below:

Ugh ok.  The first thing I'd like to do is give you a patch to
completely disable the tree log replay and give you the chance to backup
critical data.

Do you already have a backup of the critical things on this drive?  The
problem you're hitting is that tree-logging code is trying to replay an
fsync of a file, but it can't find the file to replay.  This could be a
small and localized corruption or it could be a larger problem.  We'll
have to fix things one at a time to figure it out.

The easiest way to move forward would be to save a complete copy of the
FS with dd, but that's probably not very easy given the size.

-chris
