Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41797 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754630AbeDZOFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 10:05:49 -0400
Date: Thu, 26 Apr 2018 16:03:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] [RESEND] Btrfs: btrfs_dedupe_file_range() ioctl,
 remove 16MiB restriction
Message-ID: <20180426140314.GW21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424233717.31283-1-nefelim4ag@gmail.com>
 <20180424233717.31283-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424233717.31283-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 02:37:14AM +0300, Timofey Titovets wrote:
> At now btrfs_dedupe_file_range() restricted to 16MiB range for
> limit locking time and memory requirement for dedup ioctl()
> 
> For too big input range code silently set range to 16MiB
> 
> Let's remove that restriction by do iterating over dedup range.
> That's backward compatible and will not change anything for request
> less then 16MiB.
> 
> Changes:
>   v1 -> v2:
>     - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
>     - Store memory of pages array between iterations
>     - Lock inodes once, not on each iteration
>     - Small inplace cleanups

I think this patch should be split into more, there are several logical
changes mixed together.

I can add the patch to for-next to see if there are any problems caught
by the existing test, but will expect more revisions of the patch. I
don't see any fundamental problems so far.

Suggested changes:
* factor out __btrfs_extent_same
* adjust parameters if needed by the followup patches
* add the chunk counting logic
* any other cleanups
