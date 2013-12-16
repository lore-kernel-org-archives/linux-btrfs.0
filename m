Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46548 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab3LPQRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:17:24 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Mon, 16 Dec 2013 11:17:23 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4FB776E8041
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:17:17 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBGGHKnL9437502
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:17:20 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBGGHJtD020407
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:17:19 -0500
Subject: Re: [PATCH 1/7] btrfs: subpagesize-blocksize: Define
 extent_buffer_head
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: saeed bishara <saeed.bishara@gmail.com>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <CAMAG_ecWBoFJ_vap2iFBvvW99iHVVTuMdVvaNycaFLzqt5fNUg@mail.gmail.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
	 <1386805122-23972-2-git-send-email-sekharan@us.ibm.com>
	 <CAMAG_ecWBoFJ_vap2iFBvvW99iHVVTuMdVvaNycaFLzqt5fNUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Dec 2013 10:17:18 -0600
Message-ID: <1387210638.4241.213.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-16 at 14:32 +0200, saeed bishara wrote:
> On Thu, Dec 12, 2013 at 1:38 AM, Chandra Seetharaman
> <sekharan@us.ibm.com> wrote:
> > In order to handle multiple extent buffers per page, first we
> > need to create a way to handle all the extent buffers that
> > are attached to a page.
> >
> > This patch creates a new data structure eb_head, and moves
> > fields that are common to all extent buffers in a page from
> > extent buffer to eb_head.
> >
> > This also adds changes that are needed to handle multiple
> > extent buffers per page case.
> >
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---

<snip>

> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 54ab861..02de448 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -2106,14 +2106,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,     \
> >  #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)            \
> >  static inline u##bits btrfs_##name(struct extent_buffer *eb)           \
> >  {                                                                      \
> > -       type *p = page_address(eb->pages[0]);                           \
> > +       type *p = page_address(eb_head(eb)->pages[0]) +                 \
> > +                               (eb->start & (PAGE_CACHE_SIZE -1));     \
> you can use PAGE_CACHE_MASK instead of PAGE_CACHE_SIZE - 1

PAGE_CACHE_MASK get the page part of the value, not the offset in the
page, i.e it is defined as

#define PAGE_MASK (~(PAGE_SIZE-1))

> >         u##bits res = le##bits##_to_cpu(p->member);                     \
> >         return res;                                                     \

<snip>
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index ff43802..a1a849b 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c

<snip>

> > @@ -3367,17 +3376,27 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
> >          * under IO since we can end up having no IO bits set for a short period
> >          * of time.
> >          */
> > -       spin_lock(&eb->refs_lock);
> > -       if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
> > -               set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
> > -               spin_unlock(&eb->refs_lock);
> > -               btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
> > -               __percpu_counter_add(&fs_info->dirty_metadata_bytes,
> > -                                    -eb->len,
> > +       spin_lock(&ebh->refs_lock);
> > +       for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE; i++) {
> > +               ebtemp = &ebh->extent_buf[i];
> > +               dirty_arr[i] |= test_and_clear_bit(EXTENT_BUFFER_DIRTY, &ebtemp->ebflags);
> dirty_arr wasn't initialized, changing the "|=" to = fixed a crash
> issue when doing writes

Realized after posting the patch, not fixed in my tree.

Thanks
> > +               dirty = dirty || dirty_arr[i];
> > +       }
> > + 

<snip>
> > 1.7.12.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


