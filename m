Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33956 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbJYQva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 12:51:30 -0400
Date: Sun, 25 Oct 2015 19:50:55 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: zero out delayed node upon allocation
Message-ID: <20151025195055.GA5021@gmail.com>
References: <20151025174820.GA24972@gmail.com>
 <562CFE51.8080700@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <562CFE51.8080700@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > This allows us to trim out half of btrfs_init_delayed_node() which
> > is now reduntant.
> 
> It's redundant if kmem_cache_zalloc is used, but you haven't
> documented that doing so is now required.  For all of these changes
> you've posted, if they're to be accepted, I'd really prefer to set up
> the slab with a constructor instead.  Then we don't need to worry
> about such guarantees.  The object returned via kmem_cache_alloc will
> always be properly initialized.

Well I wouldn't say it's *required* just makes this particular piece
of code neater, since we memset-zero the node's inode_item _anyways_.
I like the constructor idea though, do you suggest I should invest in
that idea?

> 
> This makes assumptions about atomic_t and what atomic_set does that
> aren't guaranteed to be true.  When accessors/mutators are part of the
> API they should be used.
> 
> - -Jeff

You're right, taking out that atomic_set was really stupid. I'll
resent the patch with a proper explanation in the commit message and
put the atomic_set back.

Unless you feel that the change is rather pointless, I'll gladly back
off :-).

Regards,
	Alex
