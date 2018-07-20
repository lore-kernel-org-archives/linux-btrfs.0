Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731556AbeGTRZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:25:03 -0400
Date: Fri, 20 Jul 2018 18:35:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Message-ID: <20180720163551.GF26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531503452.git.dsterba@suse.com>
 <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 03:27:17PM +0800, Qu Wenruo wrote:
> On 2018年07月14日 02:46, David Sterba wrote:
> > Hi,
> > 
> > I have some goodies that go into the RAID56 problem, although not
> > implementing all the remaining features, it can be useful independently.
> > 
> > This time my hackweek project
> > 
> > https://hackweek.suse.com/17/projects/do-something-about-btrfs-and-raid56
> > 
> > aimed to implement the fix for the write hole problem but I spent more
> > time with analysis and design of the solution and don't have a working
> > prototype for that yet.
> > 
> > This patchset brings a feature that will be used by the raid56 log, the
> > log has to be on the same redundancy level and thus we need a 3-copy
> > replication for raid6. As it was easy to extend to higher replication,
> > I've added a 4-copy replication, that would allow triple copy raid (that
> > does not have a standardized name).
> 
> So this special level will be used for RAID56 for now?
> Or it will also be possible for metadata usage just like current RAID1?

It's a new profile usable in the same way as is raid1, ie. for the data
or metadata. The patch that adds support to btrfs-progs has an mkfs
example.

The raid56 will use that to store the log, essentially data forcibly
stored on the n-copy raid1 chunk and used only for logging.

> If the latter, the metadata scrub problem will need to be considered more.
> 
> For more copies RAID1, it's will have higher possibility one or two
> devices missing, and then being scrubbed.
> For metadata scrub, inlined csum can't ensure it's the latest one.
> 
> So for such RAID1 scrub, we need to read out all copies and compare
> their generation to find out the correct copy.
> At least from the changeset, it doesn't look like it's addressed yet.

Nothing like this is implemented in the patches, but I don't understand
how this differs from the current raid1 and one missing device. Sure we
can't have 2 missing devices so the existing copy is automatically
considered correct and up to date.

There are more corner case recovery scenario when there could be 3
copies slightly out of date due to device loss and scrub attempt, so yes
this would need to be addressed.

> And this also reminds me that current scrub is not as flex as balance, I
> really like we could filter block groups to scrub just like balance, and
> do scrub in a block group basis, other than devid basis.
> That's to say, for a block group scrub, we don't really care which
> device we're scrubbing, we just need to ensure all device in this block
> is storing correct data.

Right, a subset of the balance filters would be nice.
