Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34237 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbeBZRVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 12:21:19 -0500
Date: Mon, 26 Feb 2018 18:18:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
Message-ID: <20180226171859.GX1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <20180209045739.GA5420@magnolia>
 <20180212152305.GC25827@dhcp-10-159-140-209.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212152305.GC25827@dhcp-10-159-140-209.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 07:23:05AM -0800, Liu Bo wrote:
> On Thu, Feb 08, 2018 at 08:57:39PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 05, 2018 at 04:15:02PM -0700, Liu Bo wrote:
> > > Btrfs tries its best to tolerate write errors, but kind of silently
> > > (except some messages in kernel log).
> > > 
> > > For raid1 and raid10, this is usually not a problem because there is a
> > > copy as backup, while for parity based raid setup, i.e. raid5 and
> > > raid6, the problem is that, if a write error occurs due to some bad
> > > sectors, one horizonal stripe becomes degraded and the number of write
> > > errors it can tolerate gets reduced by one, now if two disk fails,
> > > data may be lost forever.
> > > 
> > > One way to mitigate the data loss pain is to expose 'bad chunks',
> > > i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> > > to relocate the whole chunk and get the full raid6 protection again
> > > (if the relocation works).
> > > 
> > > This introduces 'bad_chunks' in btrfs's per-fs sysfs directory.  Once
> > > a chunk of raid5 or raid6 becomes degraded, it will appear in
> > > 'bad_chunks'.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > > - In this patch, 'bad chunks' is not persistent on disk, but it can be
> > >   added if it's thought to be a good idea.
> > > - This is lightly tested, comments are very welcome.
> > 
> > Hmmm... sorry to be late to the party and dump a bunch of semirelated
> > work suggestions, but what if you implemented GETFSMAP for btrfs?  Then
> > you could define a new 'defective' fsmap type/flag/whatever and export
> > it for whatever metadata/filedata/whatever is now screwed up?  Existing
> > interface, you don't have to kludge sysfs data, none of this string
> > interpretation stuff...
> 
> By checking FSGETMAP semantics, I think I can give it a shot.

Using GETFSMAP sounds good to me, if not best of all the options
mentioned in the thread.
