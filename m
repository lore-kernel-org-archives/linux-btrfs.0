From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk
Date: Mon, 18 Jul 2011 19:12:24 -0400
Message-ID: <1311030717-sup-3819@shiny>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com> <4E1FA968.1070703@jp.fujitsu.com> <20110718213657.GB6911@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110718213657.GB6911@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mark Fasheh's message of 2011-07-18 17:36:57 -0400:
> Hi Tsutomu,
> 
>     Thanks for the review, it is appreciated!
> 
> On Fri, Jul 15, 2011 at 11:43:52AM +0900, Tsutomu Itoh wrote:
> > > @@ -1037,7 +1037,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
> > >      struct btrfs_key found_key;
> > >  
> > >      path = btrfs_alloc_path();
> > > -    BUG_ON(!path);
> > > +    if (!path)
> > > +        return -ENOMEM;
> > 
> > If find_next_chunk() returns -ENOMEM, space_info->full becomes 1 by following code.
> > 
> > 3205 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
> > 3206                           struct btrfs_root *extent_root, u64 alloc_bytes,
> > 3207                           u64 flags, int force)
> > 3208 {
> > ...
> > 3277         ret = btrfs_alloc_chunk(trans, extent_root, flags);
> > 3278         spin_lock(&space_info->lock);
> > 3279         if (ret)
> > 3280                 space_info->full = 1;
> > 3281         else
> > 3282                 ret = 1;
> > 
> > Is it OK?
> 
> I don't think so actually. It looks like in this case we might want to
> bubble the error back up past do_chunk_alloc and leave space_info untouched.
> Chris, does that seem reasonable?

Yeah, once space_info->full is 1, we don't flip it back to zero until
more space is available somehow.  We should bubble the error up.

-chris
