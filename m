From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs failing fsx-linux
Date: Wed, 9 Sep 2009 09:13:49 -0400
Message-ID: <20090909131349.GB4522@think>
References: <20090818172641.GC30325@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090818172641.GC30325@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2009 at 07:26:41PM +0200, Nick Piggin wrote:
> Hi Chris,
> 
> Don't know if this is a known issue, but I have btrfs (after my previous
> inode_tree fixup patch) failing fsx-linux in Linus's current git tree.
> 
> This makes it a bit hard for me to test my btrfs truncate conversion patch
> unfortunately, though it does seem pretty stable so I will probably just
> send it out anyway.
> 
> Anyway, just a head's up. Oh, the way I reproduce is to create btrfs
> on 1GB rd, run 4 instances of fsx-linux on different files in the root
> directory, and run `while true ; do sync ; echo 3 > /proc/sys/vm/drop_caches;
> done` at the same time.

Just an update, I think I've tracked this down.  Our fixup code for when
set_page_dirty was called without page_mkwrite wasn't catching every
case.  I'm hitting other problems because I'm testing on my new
performance code, but hopefully this will all be nailed down soon.

-chris

