Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbeIKNtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 09:49:09 -0400
Date: Tue, 11 Sep 2018 10:50:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: tests: add separate stub for
 find_lock_delalloc_range
Message-ID: <20180911085033.GB24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1536599879.git.dsterba@suse.com>
 <42d07540b52556af89366c9fee628829148bffac.1536599879.git.dsterba@suse.com>
 <20180910234055.GB16436@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180910234055.GB16436@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 04:40:55PM -0700, Omar Sandoval wrote:
> On Mon, Sep 10, 2018 at 07:22:24PM +0200, David Sterba wrote:
> > The helper find_lock_delalloc_range is now conditionally built static,
> > dpending on whether the self-tests are enabled or not. There's a macro
> > that is suppsed to hide the export, used only once. To discourage
> > further use, drop it an add a public stub for the helper required by
> > tests.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/ctree.h                 |  6 ------
> >  fs/btrfs/extent_io.c             | 13 ++++++++++++-
> >  fs/btrfs/extent_io.h             |  2 +-
> >  fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
> >  4 files changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 2cddfe7806a4..45b7029d0f23 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -41,12 +41,6 @@ extern struct kmem_cache *btrfs_path_cachep;
> >  extern struct kmem_cache *btrfs_free_space_cachep;
> >  struct btrfs_ordered_sum;
> >  
> > -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> > -#define STATIC noinline
> > -#else
> > -#define STATIC static noinline
> > -#endif
> > -
> >  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
> >  
> >  #define BTRFS_MAX_MIRRORS 3
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 4dd6faab02bb..06e280d8750c 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -1568,7 +1568,7 @@ static noinline int lock_delalloc_pages(struct inode *inode,
> >   *
> >   * 1 is returned if we find something, 0 if nothing was in the tree
> >   */
> > -STATIC u64 find_lock_delalloc_range(struct inode *inode,
> > +static u64 find_lock_delalloc_range(struct inode *inode,
> 
> Now this won't be noinline, was that intentional? It has been since way
> back in d352ac68148b ("Btrfs: add and improve comments"), presumably
> because Chris wanted it in stack traces.

Heh, the commit is from 2008, besides others removes the original TODO,
I think there were way more important things to do at that time than
noinline, but you're right.

Removing noinline was not intentional and it would be better to see it
on the stack. As there's only one caller, the function will most likely
be inlined from writepage_delalloc. I'll update it to
noinline_for_stack.
