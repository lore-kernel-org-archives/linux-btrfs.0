Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34341 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751135AbdE2Pwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:52:46 -0400
Date: Mon, 29 May 2017 17:51:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v3.2 5/6] btrfs: qgroup: Introduce extent changeset
 for qgroup reserve functions
Message-ID: <20170529155145.GP14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
 <20170517025628.303-6-quwenruo@cn.fujitsu.com>
 <20170517153749.GH4065@suse.cz>
 <0652a2d4-746c-c8a9-dfef-ce212cbd96ff@cn.fujitsu.com>
 <20170518134531.GP4065@suse.cz>
 <4cbc5b03-7b8a-3f50-0eac-ba6f5d599369@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4cbc5b03-7b8a-3f50-0eac-ba6f5d599369@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 08:32:18AM +0800, Qu Wenruo wrote:
> At 05/18/2017 09:45 PM, David Sterba wrote:
> > On Thu, May 18, 2017 at 08:24:26AM +0800, Qu Wenruo wrote:
> >>>> +static inline void extent_changeset_init(struct extent_changeset *changeset)
> >>>> +{
> >>>> +	changeset->bytes_changed = 0;
> >>>> +	ulist_init(&changeset->range_changed);
> >>>> +}
> >>>> +
> >>>> +static inline struct extent_changeset *extent_changeset_alloc(void)
> >>>> +{
> >>>> +	struct extent_changeset *ret;
> >>>> +
> >>>> +	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
> >>>
> >>> I don't remember if we'd discussed this before, but have you evaluated
> >>> if GFP_KERNEL is ok to use in this context?
> >>
> >> IIRC you have informed me that I shouldn't abuse GFP_NOFS.
> > 
> > Use of GFP_NOFS or _KERNEL has to be evaluated case by case. So if it's
> > "let's use NOFS because everybody else does" or "he said I should not
> > use NOFS, then I'll use KERNEL", then it's wrong and I'll complain.
> > 
> > A short notice in the changelog or a comment above the allocation would
> > better signify that the patch author spent some time thinking about the
> > consequences.
> > 
> > Sometimes it can become pretty hard to find the potential deadlock
> > scenarios. Using GFP_NOFS in such case is a matter of precaution, but at
> > least would be nice to be explictly stated somewhere.
> 
> Yes it's hard to find such deadlock especially when lockdep will not 
> detect it.
> 
> And this makes the advantage of using stack memory in v3 patch more obvious.
> 
> I didn't realize the extra possible deadlock when memory pressure is 
> high, and to make completely correct usage of GFP_ flags we should let 
> caller to choose its GFP_ flag, which will introduce more modification 
> and more possibility to cause problem.
> 
> So now I prefer the stack version a little more.

The difference is that the stack version will always consume the stack
at runtime.  The dynamic allocation will not, but we have to add error
handling and make sure we use right gfp flags. So it's runtime vs review
trade off, I choose to spend time on review.

As catching all the gfp misuse is hard, we'll need some runtime
validation anyway, ie. marking the start and end of the context where
GFP_KERNEL must not be used.
