From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs failing fsx-linux
Date: Fri, 11 Sep 2009 15:36:18 -0400
Message-ID: <20090911193618.GD2894@think>
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

Thanks for your help on this Nick, I've got my current fixes for fsx in
the master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

If you're curious, the 3 most relevant commits are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=93c82d575055f1bd0277acae6f966bebafd80dd5

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=50a9b214bc6c052caa05a210ebfc1bdf0d7085b2

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=a1ed835e1ab5795f91b198d08c43e2f56848dcf3

But these fixes are built on top of my performance work (which was sure
to break fsx on its own).

-chris
