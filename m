Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030186AbcFBQzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 12:55:37 -0400
Date: Thu, 2 Jun 2016 18:54:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Insert needed holes for superblock
 migration
Message-ID: <20160602165456.GI29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160601082943.10364-1-quwenruo@cn.fujitsu.com>
 <20160601134949.GZ29147@twin.jikos.cz>
 <6893954b-48d9-21c9-9e65-59821de855fa@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6893954b-48d9-21c9-9e65-59821de855fa@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 08:38:03AM +0800, Qu Wenruo wrote:
> 
> 
> At 06/01/2016 09:49 PM, David Sterba wrote:
> > On Wed, Jun 01, 2016 at 04:29:43PM +0800, Qu Wenruo wrote:
> >> New convert doesn't insert holes for superblock migration range.
> >>
> >> Unlike old design, which only relocate 4K(superblock size) to other
> >> places.
> >> In new design, to make sure convert can handle different page size and
> >> align chunk bytenr, we relocate the whole 64K range.
> >
> > This looks like a potential backward compatibility problem. In the
> > unlikely scenario, mixing old and new convert to do conversion and
> > rollback. Did you try that?
> 
> Tried, old convert + new rollback is fine.
> Although for new convert + old rollback, it may fail to rollback some 
> converted case.
> 
> But I didn't consider new convert + old rollback will be a normal use case.

It's not meant to be a normal use case, but such thing can happen so I
want to know how it behaves. If old convert rollback fails on new image,
then it's ok, ie. we want to prevent accidental damage.

> For old converted fs, it's pretty strict for may_rollback().
> Almost all ext2 image file extent must be 1:1 mapped, except the first 
> 1M and backup superblocks.
> 
> While for new convert, it exception range is larger, 0~1M is the same, 
> while for backup superblocks, its range is extended from 4K to 64K.
> 
> So new convert is compatible with old convert and is able to rollback 
> old converted fs.

This could possibly happen so good that it works in that direction.
