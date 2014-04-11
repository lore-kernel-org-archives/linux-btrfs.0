Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDKReR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:34:17 -0400
Date: Fri, 11 Apr 2014 19:34:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Marc MERLIN <marc@merlins.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
Message-ID: <20140411173415.GF29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140411091621.GB26503@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140411091621.GB26503@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 05:16:22PM +0800, Liu Bo wrote:
> > +DEVICE MANAGEMENT
> > +-----------------
> > +Btrfs filesystem is capable to manage multiple devices.
> > +
> > +Btrfs filesystem use different profiles to manage different RAID level, and
> > +use balance to rebuild chunks, also devices can be added/removed/replace
> > +online.
> 
> s/use/uses/g
> 
> > +
> > +Profile::
> > +Btrfs filesystem use data/metadata profiles to manage allocation/duplication
> > +mechanism. Profiles like RAID level can be assigned to data and metadata separately.
> 
> ditto.

Both fixed at commit time.

Thanks.
