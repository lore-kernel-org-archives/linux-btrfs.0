Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40070 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753129AbeDNAAS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 20:00:18 -0400
Received: by mail-qt0-f196.google.com with SMTP id g5so9759806qth.7
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Apr 2018 17:00:18 -0700 (PDT)
Date: Fri, 13 Apr 2018 20:00:16 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Message-ID: <20180414000015.3ozqafxa6u6u6na2@destiny>
References: <20180413202855.10453-1-josef@toxicpanda.com>
 <CANQeFDCw3VKam6zGsPhYxF_1VRUU1cG=iwuiy_uML0-kE8myVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANQeFDCw3VKam6zGsPhYxF_1VRUU1cG=iwuiy_uML0-kE8myVw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2018 at 04:52:25PM -0700, Liu Bo wrote:
> On Fri, Apr 13, 2018 at 1:28 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> > From: Josef Bacik <jbacik@fb.com>
> >
> > Since we're allocating under atomic we could every easily enomem, so if
> > that's the case and we can block then loop around and try to allocate
> > the prealloc not under a lock.
> >
> > We also saw this happen during try_to_release_page in production, in
> > which case it's completely valid to return ENOMEM so we can tell
> > try_to_release_page that we can't release this page.
> >
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent_io.c | 28 ++++++++++++++++++++++++----
> >  1 file changed, 24 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index fb32394fd830..1054dc0158b5 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -593,8 +593,9 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >         struct extent_state *prealloc = NULL;
> >         struct rb_node *node;
> >         u64 last_end;
> > -       int err;
> > +       int err = 0;
> >         int clear = 0;
> > +       bool need_prealloc = false;
> >
> >         btrfs_debug_check_extent_io_range(tree, start, end);
> >
> > @@ -617,6 +618,9 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >                  * If we end up needing a new extent state we allocate it later.
> >                  */
> >                 prealloc = alloc_extent_state(mask);
> > +               if (!prealloc && need_prealloc)
> > +                       return -ENOMEM;
> > +               need_prealloc = false;
> >         }
> >
> >         spin_lock(&tree->lock);
> > @@ -676,7 +680,15 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >
> >         if (state->start < start) {
> >                 prealloc = alloc_extent_state_atomic(prealloc);
> > -               BUG_ON(!prealloc);
> > +               if (!prealloc) {
> > +                       if (gfpflags_allow_blocking(mask)) {
> > +                               need_prealloc = true;
> > +                               spin_unlock(&tree->lock);
> > +                               goto again;
> 
> Could we simply 'goto search_again;' ?
>

We could, but I have another patch that's more involved that reworks this logic
and kills search_again, so I'm leaving it this way for now for this isolated
fix.  Thanks,

Josef 
