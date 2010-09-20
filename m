From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Question of stability
Date: Mon, 20 Sep 2010 08:27:45 -0400
Message-ID: <20100920122745.GF27633@think>
References: <7280394.123.1284845879623.JavaMail.root@zimbra>
 <4C96B682.5080900@csamuel.org>
 <i77ero$lja$1@dough.gmane.org>
 <20100920113057.GC27633@think>
 <20100920142115.d05ac284.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lubos Kolouch <lubos.kolouch@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100920142115.d05ac284.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 20, 2010 at 02:21:15PM +0200, Stephan von Krawczynski wrote:
> On Mon, 20 Sep 2010 07:30:57 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Mon, Sep 20, 2010 at 11:00:08AM +0000, Lubos Kolouch wrote:
> > > No, not stable!
> > > 
> > > Again, after powerloss, I have *two* damaged btrfs filesystems.
> > 
> > Please tell me more about your system.  I do extensive power fail
> > testing here without problems, and corruptions after powerloss are very
> > often caused by the actual hardware.
> > 
> > So, what kind of drives do you have, do they have writeback caching on,
> > and what are you layering on top of the drive between btrfs and the
> > kernel?
> > 
> > -chris
> 
> Chris, the actual way how a fs was damaged must not be relevant. From a new fs
> design one should expect the tree can be mounted no matter what corruption took
> place up to the case where the fs is indeed empty after mounting because it
> was completely corrupted. If parts were corrupt then the fs should either be
> able to assist the user in correcting the damages _online_ or at least simply
> exclude the damaged fs parts from the actual mounted fs tree. The basic
> thought must be "show me what you have" and not "shit, how do I get access to
> the working but not mountable fs parts again?".
> Would you buy a car that refuses to drive if the ash tray is broken?

Definitely, this has always been one of our goals.  Step one is a better
btrfsck, which is in progress now.

Step two is being able to do more of this online.

-chris

