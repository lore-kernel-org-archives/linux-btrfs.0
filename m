From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs failing fsx-linux
Date: Tue, 18 Aug 2009 13:59:50 -0400
Message-ID: <20090818175950.GA2348@localhost.localdomain>
References: <20090818172641.GC30325@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
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
> 

Nick,

I'll take a look at this later today and see what I can come up with.  Thanks
for reporting it.

Josef
