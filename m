Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756460AbdESTHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 15:07:40 -0400
Date: Fri, 19 May 2017 21:06:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io
Message-ID: <20170519190642.GB4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 05:02:15PM -0600, Liu Bo wrote:
> Before this, we use 'filled' mode here, ie. if all range has been filled
> with EXTENT_DEFRAG bits, get to clear it, but if the defrag range joins
> the adjacent delalloc range, then we'll leave EXTENT_DEFRAG bits until
> evicting inode.
>
> This clears the bit if any was found within the ordered extent.

What effects, good or bad, can this have?

Is it worth backporting to stable trees?
