Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60359 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbeEVL40 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 07:56:26 -0400
Date: Tue, 22 May 2018 13:53:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180522115340.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e59e9745f1c052ae0df24378455ad3e74eed7f3a.1526679483.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e59e9745f1c052ae0df24378455ad3e74eed7f3a.1526679483.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 02:43:02PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Jun Wu at Facebook reported that an internal service was seeing a return
> value of 1 from ftruncate() on Btrfs when compression is enabled. This
> is coming from the NEED_TRUNCATE_BLOCK return value from
> btrfs_truncate_inode_items().
> 
> btrfs_truncate() uses two variables for error handling, ret and err (if
> this sounds familiar, it's because btrfs_truncate_inode_items() does
> something similar).

This err/ret pattern is widely used in btrfs code and IIRC mostly
consistently, where err is the global return and ret is local.

> When btrfs_truncate_inode_items() returns non-zero,
> we set err to the return value, but we don't reset it to zero in the
> successful NEED_TRUNCATE_BLOCK case. We only have err because we don't
> want to mask an error if we call btrfs_update_inode() and
> btrfs_end_transaction(), so let's make that its own scoped return
> variable and use ret everywhere else.

That's an alternative pattern when 'ret' is the global return and ret2
are locals. Either way, it would be good to unify that.

> Fixes: ddfae63cc8e0 ("btrfs: move btrfs_truncate_block out of trans handle")
> Reported-by: Jun Wu <quark@fb.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> This is based on Linus' master rather than my orphan ENOSPC fixes
> because I think we want to get this in for v4.17 and stable, and rebase
> my fixes on top of this.

For a 4.17-rc the patch would need to be smaller. You describe the
actual bug as a missing reset of the err, so if it's just that, we can
consider that for 4.17, but the patch as it is changes the error value
propagatin in not so trivial way.
