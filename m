Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754774AbdFLQcw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 12:32:52 -0400
Date: Mon, 12 Jun 2017 18:31:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: btrfs_ioctl_search_key documentation
Message-ID: <20170612163101.GT25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
 <20170605222032.9207-1-hans.van.kranenburg@mendix.com>
 <20170612153846.GP25451@twin.jikos.cz>
 <0555ff61-2c1d-1de2-0978-fb82f1a64979@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0555ff61-2c1d-1de2-0978-fb82f1a64979@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 12, 2017 at 06:03:15PM +0200, Hans van Kranenburg wrote:
> >> Most interesting changes since v1:
> >>  - mention the special tree_id input value 0
> >>  - rewrite the part about min_key and max_key, trying to be more concise
> > 
> > I find the description instructive enough so the expanded expression to
> > describe the whole range is not IMHO needed.
> 
> You mean drop the extra line "All metadata..." ? Yeah, it's a bit
> redudant, stressing the fact, yes.

Ah, sorry I was not clear. I was referring to Goffredo's proposal with
the expression how the min_key and max_key are calculated. Your text in
v2 is fine. We know how to calculate one key and we know the where are
the limits.

> The main purpose is to stop users from thinking that setting min_type
> and max_type will filter the returned objects (like, only getting
> BLOCK_GROUP_ITEM_KEY or so). So as long as you think that's clear
> enough, I'm ok with anything.

The text looks good to me and I've added the patch to the queue. Further
refinements are welcome.
