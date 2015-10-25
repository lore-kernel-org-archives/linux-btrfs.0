Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34101 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbJYRjU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 13:39:20 -0400
Date: Sun, 25 Oct 2015 20:38:46 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: zero out delayed node upon allocation
Message-ID: <20151025203846.GA10394@gmail.com>
References: <20151025174820.GA24972@gmail.com>
 <562CFE51.8080700@suse.com>
 <20151025195055.GA5021@gmail.com>
 <50EAEB85-05BF-4E5E-B074-BF5E522236DF@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EAEB85-05BF-4E5E-B074-BF5E522236DF@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 25, 2015 at 01:33:45PM -0400, Jeff Mahoney wrote:
> 
> On Oct 25, 2015, at 3:50 PM, Alexandru Moise <00moses.alexander00@gmail.com> wrote:
> 
> >>> This allows us to trim out half of btrfs_init_delayed_node() which
> >>> is now reduntant.
> >> 
> >> It's redundant if kmem_cache_zalloc is used, but you haven't
> >> documented that doing so is now required.  For all of these changes
> >> you've posted, if they're to be accepted, I'd really prefer to set up
> >> the slab with a constructor instead.  Then we don't need to worry
> >> about such guarantees.  The object returned via kmem_cache_alloc will
> >> always be properly initialized.
> > 
> > Well I wouldn't say it's *required* just makes this particular piece
> > of code neater, since we memset-zero the node's inode_item _anyways_.
> 
> But the rest of the delayed node still needs to be initialized. That's happening implicitly with your patch via zalloc but if anyone ever adds a new allocation from that cache, they'll need to know that zalloc is required for proper initializatiom. Documenting that is one approach. Constructors are another.
> 
> > I like the constructor idea though, do you suggest I should invest in
> > that idea?
> 
> Well, see below.
> 
> >> 
> >> This makes assumptions about atomic_t and what atomic_set does that
> >> aren't guaranteed to be true.  When accessors/mutators are part of the
> >> API they should be used.
> >> 
> >> - -Jeff
> > 
> > You're right, taking out that atomic_set was really stupid. I'll
> > resent the patch with a proper explanation in the commit message and
> > put the atomic_set back.
> > 
> > Unless you feel that the change is rather pointless, I'll gladly back
> > off :-).
> 
> I don't want to dissuade new contributors but there's plenty of work to be done before we start worrying about cleaning initializers. These aren't hot paths (but if they were, the implicit memset of the whole object might have negative effects.) The immediate impact of cleanup patches like these is code churn so that developers with outstanding patch sets need to rebase on top of new context. It's a normal part of the development cycle but it's more work for not a lot of benefit.
> 
> So, if your goal is to contribute to btrfs, I'd suggest digging into the code. Try out changes. Break it and figure out how you broke it. It's like learning how to navigate in a new city: by getting lost you learn more. :)
> 
> -Jeff

Yeah I see your point, I take back version 2 of this patch and will
follow your advice. Much appreciated!

	Alex
