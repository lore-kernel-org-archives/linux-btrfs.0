Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50755 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932940AbcLPVha (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 16:37:30 -0500
Date: Fri, 16 Dec 2016 22:37:20 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: corrupt leaf on just-created filesystem
Message-ID: <20161216213720.GA26707@angband.pl>
References: <20161216091830.GA13211@angband.pl>
 <6f32ce83-e930-13ed-0a98-bd2bd086b213@suse.com>
 <20161216185348.GA2002@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161216185348.GA2002@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 10:53:48AM -0800, Liu Bo wrote:
> On Fri, Dec 16, 2016 at 10:44:11AM -0500, Jeff Mahoney wrote:
> > On 12/16/16 4:18 AM, Adam Borowski wrote:
> > > Got a 100% reproducible splat on 4.9.
> > > 
> > > So I plopped in a fresh 4TB disk:
> > > 
> > > dd if=/dev/zero of=meow bs=1 seek=4000785104895 count=1
> > > mkfs -t btrfs meow
> > > mount -onoatime meow /mnt/vol1
> > > cd /mnt/vol1
> > > btrfs subv create foo
> > 
> > The check here is still broken.  There's no corruption on disk.  The big
> > thing is that we need to audit when we mark the buffer dirty.
> > 
> > I do my testing with integrity checking enabled and that means that I
> > need to #if 0 out the check in cheak_leaf for now.
> 
> Hi Adam and Jeff,
> 
> Chris just sent out the git pull for 4.10 merge window, which contains
> the two fixes that can address your problems

Confirmed, the pull fixes this zonk, cool!

> I'm not surprised that we may have more corner cases to report false
> corruption around this ASSERT, and I agree with Jeff, it's always better
> to hit a ASSERT rather than spending days in figuring out where
> corruption comes from.

Aye, I'm religious about keeping asserts when possible, even in production
-- much better to have a noisy crash than silent data loss.


Meow!
-- 
u-boot problems can be solved with the help of your old SCSI manuals, the
parts that deal with goat termination.  You need a black-handled knife, and
an appropriate set of candles (number and color matters).  Or was it a
silver-handled knife?  Crap, need to look that up.
