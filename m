Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752640AbdK3RZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 12:25:15 -0500
Date: Thu, 30 Nov 2017 18:23:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, axboe@kernel.dk,
        jbacik@fb.com, kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCHSET v2] cgroup, writeback, btrfs: make sure btrfs issues
 metadata IOs from the root cgroup
Message-ID: <20171130172316.GM3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010155441.753966-1-tj@kernel.org>
 <20171129165608.GA26740@quack2.suse.cz>
 <20171129170330.GV983427@devbig577.frc2.facebook.com>
 <20171129170501.GW983427@devbig577.frc2.facebook.com>
 <fff25924-f632-8a6c-9e48-765971b09cca@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fff25924-f632-8a6c-9e48-765971b09cca@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 01:38:26PM -0500, Chris Mason wrote:
> On 11/29/2017 12:05 PM, Tejun Heo wrote:
> > On Wed, Nov 29, 2017 at 09:03:30AM -0800, Tejun Heo wrote:
> >> Hello,
> >>
> >> On Wed, Nov 29, 2017 at 05:56:08PM +0100, Jan Kara wrote:
> >>> What has happened with this patch set?
> >>
> >> No idea.  cc'ing Chris directly.  Chris, if the patchset looks good,
> >> can you please route them through the btrfs tree?
> > 
> > lol looking at the patchset again, I'm not sure that's obviously the
> > right tree.  It can either be cgroup, block or btrfs.  If no one
> > objects, I'll just route them through cgroup.
> 
> We'll have to coordinate a bit during the next merge window but I don't 
> have a problem with these going in through cgroup.  Dave does this sound 
> good to you?

There are only minor changes to btrfs code so cgroup tree would be
better.

> I'd like to include my patch to do all crcs inline (instead of handing 
> off to helper threads) when io controls are in place.  By the merge 
> window we should have some good data on how much it's all helping.

Are there any problems in sight if the inline crc and cgroup chnanges go
separately? I assume there's a runtime dependency, not a code
dependency, so it could be sorted by the right merge order.
