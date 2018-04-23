Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755227AbeDWO3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 10:29:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91233ACF9
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:29:42 +0000 (UTC)
Date: Mon, 23 Apr 2018 16:27:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix wrong first_key parameter in replace_path
Message-ID: <20180423142709.GX21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180423093204.20943-1-wqu@suse.com>
 <20180423141622.GW21272@twin.jikos.cz>
 <f2b1f711-f484-e217-831c-7de2020d6f62@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f2b1f711-f484-e217-831c-7de2020d6f62@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2018 at 05:20:06PM +0300, Nikolay Borisov wrote:
> On 23.04.2018 17:16, David Sterba wrote:
> > On Mon, Apr 23, 2018 at 05:32:04PM +0800, Qu Wenruo wrote:
> >> Commit 581c1760415c ("btrfs: Validate child tree block's level and first
> >> key") introduced new @first_key parameter for read_tree_block(), however
> >> caller in replace_path() is parasing wrong key to read_tree_block().
> >>
> >> It should use parameter @first_key other than @key.
> >>
> >> Normally it won't expose problem as @key is normally initialzied to the
> >> same value of @first_key we expect.
> >> However in relocation recovery case, @key can be set to (0, 0, 0), and
> >> since no valid key in relocation tree can be (0, 0, 0), it will cause
> >> read_tree_block() to return -EUCLEAN and interrupt relocation recovery.
> >>
> >> Fix it by setting @first_key correctly.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > 
> > Added to next, thanks.
> 
> This is actually -rc2 material, right?

Yes, adding to next is the 1st stage as we want to start testing. What
will end up in the next rc pull is determined later if everything is
fine. For some patches it's obvious that they're fixing a regression,
the others are clear fixes that still qualify for rc. I can be more
specific about the target branch, but this should be transparent to
developers anyway once the patch is in the pool.
