Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41653 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756519AbdJJRhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 13:37:53 -0400
Date: Tue, 10 Oct 2017 19:36:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB
 restriction
Message-ID: <20171010173608.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
 <20171003150604.19596-5-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003150604.19596-5-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 06:06:04PM +0300, Timofey Titovets wrote:
> At now btrfs_dedupe_file_range() restricted to 16MiB range for
> limit locking time and memory requirement for dedup ioctl()
> 
> For too big input rage code silently set range to 16MiB
> 
> Let's remove that restriction by do iterating over dedup range.
> That's backward compatible and will not change anything for request
> less then 16MiB.

This would make the ioctl more pleasant to use. So far I haven't found
any problems to do the iteration. One possible speedup could be done to
avoid the repeated allocations in btrfs_extent_same if we're going to
iterate more than once.

As this would mean the 16MiB length restriction is gone, this needs to
bubble up to the documentation
(http://man7.org/linux/man-pages/man2/ioctl_fideduperange.2.html)

Have you tested the behaviour with larger ranges?
