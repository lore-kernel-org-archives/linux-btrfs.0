Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3LQPfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:35:46 -0500
Date: Tue, 17 Dec 2013 16:35:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: saeed bishara <saeed.bishara@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: subpagesize-blocksize: Define
 extent_buffer_head
Message-ID: <20131217153544.GS6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
 <1386805122-23972-2-git-send-email-sekharan@us.ibm.com>
 <CAMAG_ecWBoFJ_vap2iFBvvW99iHVVTuMdVvaNycaFLzqt5fNUg@mail.gmail.com>
 <1387210638.4241.213.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387210638.4241.213.camel@chandra-dt.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 10:17:18AM -0600, Chandra Seetharaman wrote:
> On Mon, 2013-12-16 at 14:32 +0200, saeed bishara wrote:
> > On Thu, Dec 12, 2013 at 1:38 AM, Chandra Seetharaman
> > <sekharan@us.ibm.com> wrote:
> > > In order to handle multiple extent buffers per page, first we
> > > need to create a way to handle all the extent buffers that
> > > are attached to a page.
> > >
> > > This patch creates a new data structure eb_head, and moves
> > > fields that are common to all extent buffers in a page from
> > > extent buffer to eb_head.
> > >
> > > This also adds changes that are needed to handle multiple
> > > extent buffers per page case.
> > >
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > ---
> 
> <snip>
> 
> > > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > > index 54ab861..02de448 100644
> > > --- a/fs/btrfs/ctree.h
> > > +++ b/fs/btrfs/ctree.h
> > > @@ -2106,14 +2106,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,     \
> > >  #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)            \
> > >  static inline u##bits btrfs_##name(struct extent_buffer *eb)           \
> > >  {                                                                      \
> > > -       type *p = page_address(eb->pages[0]);                           \
> > > +       type *p = page_address(eb_head(eb)->pages[0]) +                 \
> > > +                               (eb->start & (PAGE_CACHE_SIZE -1));     \
> > you can use PAGE_CACHE_MASK instead of PAGE_CACHE_SIZE - 1
> 
> PAGE_CACHE_MASK get the page part of the value, not the offset in the
> page, i.e it is defined as
> 
> #define PAGE_MASK (~(PAGE_SIZE-1))

Use ~PAGE_CACHE_MASK to get the offset. It's common, though not obvious
at first.
