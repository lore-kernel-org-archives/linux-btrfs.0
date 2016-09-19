Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33481 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932090AbcISUUB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 16:20:01 -0400
Date: Mon, 19 Sep 2016 22:18:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Nikolay Borisov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix handling of -ENOENT from btrfs_uuid_iter_rem
Message-ID: <20160919201804.GT16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <2c9c27c6-5e2d-5035-de11-0cf021dfd9a1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2c9c27c6-5e2d-5035-de11-0cf021dfd9a1@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 02:49:41PM -0400, Chris Mason wrote:
> On 09/19/2016 02:13 PM, David Sterba wrote:
> > On Wed, Sep 07, 2016 at 10:38:58AM +0300, Nikolay Borisov wrote:
> >> btrfs_uuid_iter_rem is able to return -ENOENT, however this condition
> >> is not handled in btrfs_uuid_tree_iterate which can lead to calling
> >> btrfs_next_item with freed path argument, leading to a null pointer
> >> dereference. Fix it by redoing the search but with an incremented
> >> objectid so we don't loop over the same key.
> >>
> >> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
> >> Suggested-by: Chris Mason <clm@fb.com>
> >> Link: https://lkml.kernel.org/r/57A473B0.2040203@kyup.com
> >
> > I'll queue the patch for 4.9, thanks.
> >
> 
> Not having a good test for this kept me from trying the patch cold.  I 
> think bumping the objectid will end up missing items.

Ok, so I can keep it in the branches that are not for the upcoming
merges but still in for-next.
