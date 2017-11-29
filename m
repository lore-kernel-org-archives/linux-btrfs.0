Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752314AbdK2QtG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 11:49:06 -0500
Date: Wed, 29 Nov 2017 17:47:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] retry write on error
Message-ID: <20171129164708.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171128192236.GE3553@twin.jikos.cz>
 <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
 <23069.62530.53658.314350@tree.ty.sabi.co.uk>
 <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:09:29PM +0800, Anand Jain wrote:
> On 11/29/2017 07:41 AM, pg@btrfs.list.sabi.co.UK wrote:
> >>>> If the underlying protocal doesn't support retry and there
> >>>> are some transient errors happening somewhere in our IO
> >>>> stack, we'd like to give an extra chance for IO.
> > 
> >>> A limited number of retries may make sense, though I saw some
> >>> long stalls after retries on bad disks.
> > 
> > Indeed! One of the major issues in actual storage administration
> > is to find ways to reliably disable most retries, or to shorten
> > them, both at the block device level and the device level,
> > because in almost all cases where storage reliability matters
> > what is important is simply swapping out the failing device
> > immediately and then examining and possible refreshing it
> > offline.
> > 
> > To the point that many device manufacturers deliberately cripple
> > in cheaper products retry shortening or disabling options to
> > force long stalls, so that people who care about reliability
> > more than price will buy the more expensive version that can
> > disable or shorten retries.
> > 
> >> Seems preferable to avoid issuing retries when the underlying
> >> transport layer(s) has already done so, but I am not sure
> >> there is a way to know that at the fs level.
> > 
> > Inded, and to use an euphemism, a third layer of retries at the
> > filesystem level are currently a thoroughly imbecilic idea :-),
> > as whether retries are worth doing is not a filesystem dependent
> > issue (but then plugging is done at the block io level when it
> > is entirely device dependent whether it is worth doing, so there
> > is famous precedent).
> > 
> > There are excellent reasons why error recovery is in general not
> > done at the filesystem level since around 20 years ago, which do
> > not need repeating every time. However one of them is that where
> > it makes sense device firmware does retries, and the block
> > device layer does retries too, which is often a bad idea, and
> > where it is not, the block io level should be do that, not the
> > filesystem.
> > 
> > A large part of the above discussion would not be needed if
> > Linux kernel "developers" exposed a clear notion of hardware
> > device and block device state machine and related semantics, or
> > even knew that it were desirable, but that's an idea that is
> > only 50 years old, so may not have yet reached popularity :-).
> 
>   I agree with Ed and Peter, similar opinion was posted here [1].
>      https://www.spinics.net/lists/linux-btrfs/msg70240.html

All the points in this thread speak against retries on the filesystem
level and I agree. Without an interface to query the block layer if the
retries make sense, it's just guessing, likely to be wrong.
