From: Nick Piggin <npiggin@suse.de>
Subject: Re: btrfs failing fsx-linux
Date: Wed, 19 Aug 2009 10:50:40 +0200
Message-ID: <20090819085040.GE25721@wotan.suse.de>
References: <20090818172641.GC30325@wotan.suse.de> <20090818175950.GA2348@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090818175950.GA2348@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2009 at 01:59:50PM -0400, Josef Bacik wrote:
> On Tue, Aug 18, 2009 at 07:26:41PM +0200, Nick Piggin wrote:
> > Hi Chris,
> > 
> > Don't know if this is a known issue, but I have btrfs (after my previous
> > inode_tree fixup patch) failing fsx-linux in Linus's current git tree.
> > 
> > This makes it a bit hard for me to test my btrfs truncate conversion patch
> > unfortunately, though it does seem pretty stable so I will probably just
> > send it out anyway.
> > 
> > Anyway, just a head's up. Oh, the way I reproduce is to create btrfs
> > on 1GB rd, run 4 instances of fsx-linux on different files in the root
> > directory, and run `while true ; do sync ; echo 3 > /proc/sys/vm/drop_caches;
> > done` at the same time.
> > 
> 
> Nick,
> 
> I'll take a look at this later today and see what I can come up with.  Thanks
> for reporting it.
> 
> Josef

Thanks. After spending a good chunk of my life tracking down fsx-linux
problems in fsblock and mm code, I can't say I envy you :) It's a great
test to run though (especially syncing and dropping caches because that
hits writeback and bypasses caches far far more than fsx ever does
on its own).

Let me know if you need me to test any patches.

