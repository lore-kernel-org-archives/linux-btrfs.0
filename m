Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33912 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdK3UXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 15:23:01 -0500
Date: Thu, 30 Nov 2017 12:22:53 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] retry write on error
Message-ID: <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171128192236.GE3553@twin.jikos.cz>
 <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
 <23069.62530.53658.314350@tree.ty.sabi.co.uk>
 <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
 <20171129164708.GH3553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171129164708.GH3553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 05:47:08PM +0100, David Sterba wrote:
> On Wed, Nov 29, 2017 at 12:09:29PM +0800, Anand Jain wrote:
> > On 11/29/2017 07:41 AM, pg@btrfs.list.sabi.co.UK wrote:
> > >>>> If the underlying protocal doesn't support retry and there
> > >>>> are some transient errors happening somewhere in our IO
> > >>>> stack, we'd like to give an extra chance for IO.
> > > 
> > >>> A limited number of retries may make sense, though I saw some
> > >>> long stalls after retries on bad disks.
> > > 
> > > Indeed! One of the major issues in actual storage administration
> > > is to find ways to reliably disable most retries, or to shorten
> > > them, both at the block device level and the device level,
> > > because in almost all cases where storage reliability matters
> > > what is important is simply swapping out the failing device
> > > immediately and then examining and possible refreshing it
> > > offline.
> > > 
> > > To the point that many device manufacturers deliberately cripple
> > > in cheaper products retry shortening or disabling options to
> > > force long stalls, so that people who care about reliability
> > > more than price will buy the more expensive version that can
> > > disable or shorten retries.
> > > 
> > >> Seems preferable to avoid issuing retries when the underlying
> > >> transport layer(s) has already done so, but I am not sure
> > >> there is a way to know that at the fs level.
> > > 
> > > Inded, and to use an euphemism, a third layer of retries at the
> > > filesystem level are currently a thoroughly imbecilic idea :-),
> > > as whether retries are worth doing is not a filesystem dependent
> > > issue (but then plugging is done at the block io level when it
> > > is entirely device dependent whether it is worth doing, so there
> > > is famous precedent).
> > > 
> > > There are excellent reasons why error recovery is in general not
> > > done at the filesystem level since around 20 years ago, which do
> > > not need repeating every time. However one of them is that where
> > > it makes sense device firmware does retries, and the block
> > > device layer does retries too, which is often a bad idea, and
> > > where it is not, the block io level should be do that, not the
> > > filesystem.
> > > 
> > > A large part of the above discussion would not be needed if
> > > Linux kernel "developers" exposed a clear notion of hardware
> > > device and block device state machine and related semantics, or
> > > even knew that it were desirable, but that's an idea that is
> > > only 50 years old, so may not have yet reached popularity :-).
> > 
> >   I agree with Ed and Peter, similar opinion was posted here [1].
> >      https://www.spinics.net/lists/linux-btrfs/msg70240.html
> 
> All the points in this thread speak against retries on the filesystem
> level and I agree. Without an interface to query the block layer if the
> retries make sense, it's just guessing, likely to be wrong.

I do agree that filesystem doesn't need to retry at its own level, but
btrfs incorporates disk management which is actually a version of md
layer, adding retry for this layer can gain robustness for us.

It's true that scsi's sd layer has done SD_MAX_RETRIES(5) retries, but
can we really depend on other layers for all robustness?

In terms of raid56 scenario, typically filesystem doens't fail the
raid/disk, but btrfs does, doing retry _may_ save us a lot of time of
rebuilding raid.

Anyway, this is for a corner case, not for everyone, I think I need to
make it configurable so that at least we can provide some extra
robustness for people who super care about their data.

Thanks,

-liubo
