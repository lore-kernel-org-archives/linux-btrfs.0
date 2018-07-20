Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732083AbeGTRb6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:31:58 -0400
Date: Fri, 20 Jul 2018 18:42:45 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Message-ID: <20180720164245.GG26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531503452.git.dsterba@suse.com>
 <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
 <e0870bdd-be7d-b91a-e22c-a6b840b8dd64@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e0870bdd-be7d-b91a-e22c-a6b840b8dd64@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 07:47:23AM -0400, Austin S. Hemmelgarn wrote:
> > So this special level will be used for RAID56 for now?
> > Or it will also be possible for metadata usage just like current RAID1?
> > 
> > If the latter, the metadata scrub problem will need to be considered more.
> > 
> > For more copies RAID1, it's will have higher possibility one or two
> > devices missing, and then being scrubbed.
> > For metadata scrub, inlined csum can't ensure it's the latest one.
> > 
> > So for such RAID1 scrub, we need to read out all copies and compare
> > their generation to find out the correct copy.
> > At least from the changeset, it doesn't look like it's addressed yet.
> > 
> > And this also reminds me that current scrub is not as flex as balance, I
> > really like we could filter block groups to scrub just like balance, and
> > do scrub in a block group basis, other than devid basis.
> > That's to say, for a block group scrub, we don't really care which
> > device we're scrubbing, we just need to ensure all device in this block
> > is storing correct data.
> > 
> This would actually be rather useful for non-parity cases too.  Being 
> able to scrub only metadata when the data chunks are using a profile 
> that provides no rebuild support would be great for performance.
> 
> On the same note, it would be _really_ nice to be able to scrub a subset 
> of the volume's directory tree, even if it were only per-subvolume.

https://github.com/kdave/drafts/blob/master/btrfs/scrub-subvolume.txt
https://github.com/kdave/drafts/blob/master/btrfs/scrub-custom.txt

The idea is to build in-memory tree of block ranges that span the given
subvolume or files and run scrub only there.  The selective scrub on the
block groups of a given type would be a special case of the above.
