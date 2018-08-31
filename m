Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34692 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbeHaSSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:18:30 -0400
Received: by mail-qt0-f193.google.com with SMTP id m13-v6so14690179qth.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:10:49 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:10:47 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/35] btrfs: only track ref_heads in delayed_ref_updates
Message-ID: <20180831141045.v4jfsuimyauuaolc@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-5-josef@toxicpanda.com>
 <162a5b6e-d361-9385-c95b-afc8bc25563c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <162a5b6e-d361-9385-c95b-afc8bc25563c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:52:55AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:41, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We use this number to figure out how many delayed refs to run, but
> > __btrfs_run_delayed_refs really only checks every time we need a new
> > delayed ref head, so we always run at least one ref head completely no
> > matter what the number of items on it.  So instead track only the ref
> > heads added by this trans handle and adjust the counting appropriately
> > in __btrfs_run_delayed_refs.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/delayed-ref.c | 3 ---
> >  fs/btrfs/extent-tree.c | 5 +----
> >  2 files changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > index 3a9e4ac21794..27f7dd4e3d52 100644
> > --- a/fs/btrfs/delayed-ref.c
> > +++ b/fs/btrfs/delayed-ref.c
> > @@ -234,8 +234,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
> >  	ref->in_tree = 0;
> >  	btrfs_put_delayed_ref(ref);
> >  	atomic_dec(&delayed_refs->num_entries);
> > -	if (trans->delayed_ref_updates)
> > -		trans->delayed_ref_updates--;
> 
> There was feedback on this particular hunk and you've completely ignored
> it, that's not nice:
> 
> https://www.spinics.net/lists/linux-btrfs/msg80514.html

I just missed it in the last go around (as is the case for the other ones).  I'm
not sure what part is confusing, we only want delayed_ref_updates to be how many
delayed ref heads there are, which is what this patch is changing.  I could
probably split this between these two changes and the count changing below since
they are slightly different things, I'll do that.  Thanks,

Josef
