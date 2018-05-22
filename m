Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37528 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751036AbeEVM52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 08:57:28 -0400
Date: Tue, 22 May 2018 14:54:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180522125440.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e59e9745f1c052ae0df24378455ad3e74eed7f3a.1526679483.git.osandov@fb.com>
 <20180522115340.GF6649@twin.jikos.cz>
 <e44974d6-e363-8935-a50a-1b3978480c6c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e44974d6-e363-8935-a50a-1b3978480c6c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 03:11:04PM +0300, Nikolay Borisov wrote:
> 
> 
> On 22.05.2018 14:53, David Sterba wrote:
> > On Fri, May 18, 2018 at 02:43:02PM -0700, Omar Sandoval wrote:
> >> From: Omar Sandoval <osandov@fb.com>
> >>
> >> Jun Wu at Facebook reported that an internal service was seeing a return
> >> value of 1 from ftruncate() on Btrfs when compression is enabled. This
> >> is coming from the NEED_TRUNCATE_BLOCK return value from
> >> btrfs_truncate_inode_items().
> >>
> >> btrfs_truncate() uses two variables for error handling, ret and err (if
> >> this sounds familiar, it's because btrfs_truncate_inode_items() does
> >> something similar).
> > 
> > This err/ret pattern is widely used in btrfs code and IIRC mostly
> > consistently, where err is the global return and ret is local.
> 
> And as a matter of fact it's a bad pattern, precisely because of the
> type of errors this and one of the patches in the orphan items fix.
> Everytime I hear "global state" I cringe, since it just opens avenues
> for bugs.

If we do the single point of return in the function, then the single
global (function-scope) ret value makes sense.

Arguably one can do the same sort of mistakes with the ret/ret2 pattern,
we still need to correctly propagate the local to the function-scope, so
switching is not strictly neccessary and not an all-cure.

> >> When btrfs_truncate_inode_items() returns non-zero,
> >> we set err to the return value, but we don't reset it to zero in the
> >> successful NEED_TRUNCATE_BLOCK case. We only have err because we don't
> >> want to mask an error if we call btrfs_update_inode() and
> >> btrfs_end_transaction(), so let's make that its own scoped return
> >> variable and use ret everywhere else.
> > 
> > That's an alternative pattern when 'ret' is the global return and ret2
> > are locals. Either way, it would be good to unify that.
> 
> FWIW I prefer the style put forth in this patch, since it's easier to
> reason about ret2 because it's defined in a narrower context (the single
> if (trans)) which helps spot problems more easily.

Yeah, consistency POV, keeping the meaning of 'ret' same everywhere
would be better, and we can add any number of ret2, ret3 if we have more
nested contexts.

I did a quick and dirty grep where 'err' is used as the function-scope
and it's in low-tens, so I think it's doable.
