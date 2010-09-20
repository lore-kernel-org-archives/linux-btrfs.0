From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Question of stability
Date: Mon, 20 Sep 2010 08:13:07 -0400
Message-ID: <20100920121307.GD27633@think>
References: <7280394.123.1284845879623.JavaMail.root@zimbra>
 <4C96B682.5080900@csamuel.org>
 <i77ero$lja$1@dough.gmane.org>
 <20100920113057.GC27633@think>
 <i77iv0$9a5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i77iv0$9a5$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 20, 2010 at 12:10:08PM +0000, Lubos Kolouch wrote:
> On Mon, 20 Sep 2010 07:30:57 -0400, Chris Mason wrote:
> 
> > On Mon, Sep 20, 2010 at 11:00:08AM +0000, Lubos Kolouch wrote:
> >> No, not stable!
> >> 
> >> Again, after powerloss, I have *two* damaged btrfs filesystems.
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
> > 
> 
> Hello Chris,
> 
> The system is running with 128GB SDD Samsung disk. The partition is 
> encrypted with LUKS and on top btrfs filesystem is created.

Ok, we're seeing consistent reports of corruptions after power failure
with dm-crypt.  The barriers must not be getting down to the device.

> 
> The backup disk is a 160GB WD notebook disk connected via IDE->USB cable,
> whole formatted with LUKS and btrfs on top.
> 
> Actually, if there was any way (non-standard) how to mount the system and 
> recover even part of the data, I would be very grateful.

We can definitely try.  Please send me email with the errors from
btrfsck and I'll work on a patch that gets you read only access.

