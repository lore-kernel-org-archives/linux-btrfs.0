Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48381 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751036AbdHRP5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 11:57:07 -0400
Date: Fri, 18 Aug 2017 17:55:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Message-ID: <20170818155543.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 04, 2017 at 09:51:44PM +0000, Nick Terrell wrote:
> > + * @type_level is encoded algorithm and level, where level 0 means whatever
> > + * default the algorithm chooses and is opaque here;
> > + * - compression algo are 0-3
> > + * - the level are bits 4-7
> 
> zstd has 19 levels, but we can either only allow the first 15 + default, or
> provide a mapping from zstd-level to BtrFS zstd-level.

19 levels sounds too much to me, I hoped that 15 should be enough for
everybody. When I teste various zlib level, there were only small
compression gains at a high runtime cost from levels 6-9. So some kind
of mapping would be desirable if the levels 16+ prove to be better than
< 15 under the btrfs contraints.

> >   * @out_pages is an in/out parameter, holds maximum number of pages to allocate
> >   * and returns number of actually allocated pages
> >   *
> > @@ -880,7 +885,7 @@ static void free_workspaces(void)
> >   * @max_out tells us the max number of bytes that we're allowed to
> >   * stuff into pages
> >   */
> > -int btrfs_compress_pages(int type, struct address_space *mapping,
> > +int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
> >  			 u64 start, struct page **pages,
> >  			 unsigned long *out_pages,
> >  			 unsigned long *total_in,
> > @@ -888,9 +893,11 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
> >  {
> >  	struct list_head *workspace;
> >  	int ret;
> > +	int type = type_level & 0xF;
> >  
> >  	workspace = find_workspace(type);
> >  
> > +	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
> 
> zlib uses the same amount of memory independently of the compression level,
> but zstd uses a different amount of memory for each level.

We could extend the code to provide 2 types of workspaces, one to cover
the "fast" levels and one for the "high compression" levels. And the
larger one can be used for 'fast' so it does not just idle around.

> zstd will have
> to allocate memory here if it doesn't have enough (or has way to much),
> will that be okay?

This would be a problem. Imagine that the system is short on free
memory, starts to flush dirty data and now some filesystem starts asking
for hundreds of kilobytes of new memory just to write the data (and free
resources and the memory in turn). That's the case we need to
preallocate when there's enough memory, at least one workspace, so
there's a guarantee of forward progress.
