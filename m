From: Chris Mason <chris.mason@oracle.com>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 13:42:03 -0400
Message-ID: <1300383616-sup-9254@think>
References: <4D821ED3.5050605@jan-o-sch.net> <AANLkTi=ckrr4BNSPxkMCveLAY7NyQ6SF6OzYHMnxC-rD@mail.gmail.com> <4D8246F2.8080104@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8246F2.8080104@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Jan Schmidt's message of 2011-03-17 13:37:54 -0400:
> On 03/17/2011 06:09 PM, Andrey Kuzmin wrote:
> > On Thu, Mar 17, 2011 at 5:46 PM, Jan Schmidt <list.btrfs@jan-o-sch.net
> > <mailto:list.btrfs@jan-o-sch.net>> wrote:
> >     - Is it acceptable to retry reading a block immediately after the disk
> >     said it won't work? Or in case of a successful read followed by a
> >     checksum error? (Which is already being done right now in btrfs.)
> > 
> > 
> > These are two pretty different cases. When disk firmware fails read, it
> > means it has retried number of times but gave up (suggesting media
> > error), so an upper layer retry would hardly make sense. Checksum error
> > catches on-disk EDC fault, so retry is on the contrary quite reasonable.
> 
> Agreed.
> 
> >     - Is it acceptable to always write both mirrors if one is found to be
> >     bad (also consider ssds)?
> > 
> > 
> > Writing on read path bypassing file-system transaction mechanism doesn't
> > seem a good idea to me. Just imaging loosing power while overwriting
> > last good copy.
> 
> Okay, sounds reasonable to me. Let's say we're bypassing transaction
> mechanism in the same rude manner, but only write the bad mirror. Does
> that seem reasonable?

The bad mirror is fair game.  Write away, as long as you're sure you're
excluding nodatacow and you don't allow that block to get reallocated
elsewhere.  You don't actually need to bypass the transaction
mechanism, just those two things.

-chris
