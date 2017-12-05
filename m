Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbdLES7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:59:31 -0500
Date: Tue, 5 Dec 2017 19:57:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] retry write on error
Message-ID: <20171205185731.GT3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171128192236.GE3553@twin.jikos.cz>
 <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
 <23069.62530.53658.314350@tree.ty.sabi.co.uk>
 <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
 <20171129164708.GH3553@twin.jikos.cz>
 <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 30, 2017 at 12:22:53PM -0800, Liu Bo wrote:
> > >   I agree with Ed and Peter, similar opinion was posted here [1].
> > >      https://www.spinics.net/lists/linux-btrfs/msg70240.html
> > 
> > All the points in this thread speak against retries on the filesystem
> > level and I agree. Without an interface to query the block layer if the
> > retries make sense, it's just guessing, likely to be wrong.
> 
> I do agree that filesystem doesn't need to retry at its own level, but
> btrfs incorporates disk management which is actually a version of md
> layer, adding retry for this layer can gain robustness for us.
> 
> It's true that scsi's sd layer has done SD_MAX_RETRIES(5) retries, but
> can we really depend on other layers for all robustness?

I'm afraid that we have to. We don't really want to dive too much to the
storage layer that's beneath the filesystem. If there was an interface
like "blk_queue_retries_make_sense", then letting the upper layer could
improve robustness, but otherwise I see it as false hopes an just
wasting time retrying.

> In terms of raid56 scenario, typically filesystem doens't fail the
> raid/disk, but btrfs does, doing retry _may_ save us a lot of time of
> rebuilding raid.
> 
> Anyway, this is for a corner case, not for everyone, I think I need to
> make it configurable so that at least we can provide some extra
> robustness for people who super care about their data.

This should be IMHO solved by redundancy. If the storage layer is not
reliable it's not wise to continue using the underlying devices and rely
on the retries.
