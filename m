Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964821AbeEYOxk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 10:53:40 -0400
Date: Fri, 25 May 2018 16:50:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 4/6] Btrfs: prevent ioctls from interfering with a
 swap file
Message-ID: <20180525145055.GN6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527197312.git.osandov@fb.com>
 <296f04a07350c9cc2032e03f78c1a7284747fb50.1527197312.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <296f04a07350c9cc2032e03f78c1a7284747fb50.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2018 at 02:41:28PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> When a swap file is active, we must make sure that the extents of the
> file are not moved and that they don't become shared. That means that
> the following are not safe:
> 
> - chattr +c (enable compression)
> - reflink
> - dedupe
> - snapshot
> - defrag
> - balance
> - device remove/replace/resize
> 
> Don't allow those to happen on an active swap file. Balance and device
> remove/replace/resize in particular are disallowed entirely; in the
> future, we can relax this so that relocation skips/errors out only on
> chunks containing an active swap file.

Hm, disabling the entire balance is too intrusive. It's clear that the
swapfile causes a lot of trouble when it goes against the dynamic
capabilities of btrfs (relocation and the functionality that builds on
it).

Skipping the swapfile extents should be implemented at minimum. We can
add some heuristics that will group the swap extents to a small number
of chunks so the impact of unmovable chunks is limited.

I haven't looked at the implementation, but it might be possible to
internally find a different location for the swap extent once it's not
used for the actual paged data.

In an ideal case, the swap extents could span entire chunks (1G) and not
mix with regular data/metadata.

> Note that we don't have to worry about chattr -C (disable nocow), which
> we ignore for non-empty files, because an active swapfile must be
> non-empty and can't be truncated. We also don't have to worry about
> autodefrag because it's only done on COW files. Truncate and fallocate
> are already taken care of by the generic code. Device add doesn't do
> relocation so it's not an issue, either.

Ok, fine the remaining easy cases are covered.

I don't know if you mentioned that elsewhere (as design questions are
in this patch), the allocation profile is single, or is it also possible
to have striped or duplicated swap extents?
