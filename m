Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40592 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbeILAPc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 20:15:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id s17-v6so11762413plp.7
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 12:14:49 -0700 (PDT)
Date: Tue, 11 Sep 2018 12:14:47 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: tests: polish ifdefs around testing helper
Message-ID: <20180911191447.GA26631@vader>
References: <cover.1536599879.git.dsterba@suse.com>
 <7a6c4814d8467999d9a9eb12906ff28a3f90b284.1536599879.git.dsterba@suse.com>
 <20180910234329.GD16436@vader>
 <20180911092250.GC24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911092250.GC24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 11:22:51AM +0200, David Sterba wrote:
> On Mon, Sep 10, 2018 at 04:43:29PM -0700, Omar Sandoval wrote:
> > On Mon, Sep 10, 2018 at 07:22:31PM +0200, David Sterba wrote:
> > > Avoid the inline ifdefs and use two sections for self-tests enabled and
> > > disabled.
> > > 
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > ---
> > >  fs/btrfs/ctree.h | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > > index 32d2fce4ac53..8dafc7bb6ad8 100644
> > > --- a/fs/btrfs/ctree.h
> > > +++ b/fs/btrfs/ctree.h
> > > @@ -3708,17 +3708,20 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
> > >  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> > >  void btrfs_test_inode_set_ops(struct inode *inode);
> > >  void btrfs_test_destroy_inode(struct inode *inode);
> > > -#endif
> > >  
> > >  static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
> > >  {
> > > -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> > >  	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
> > >  			      &fs_info->fs_state)))
> > >  		return 1;
> > > -#endif
> > >  	return 0;
> > 
> > How about just:
> > 
> > 	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
> > 
> > We can probably get away without the unlikely() considering that no one
> > sane is going to run a kernel with CONFIG_BTRFS_FS_RUN_SANITY_TESTS in
> > production.
> 
> The unlikely can go away, sure.
> 
> I would still like to remove the test_bit call when tests are compiled
> out. There are about 10 calls to btrfs_is_testing in various core
> functions, followed by further statements. This would have a
> (negligible) runtime penalty but generates effectively unused code on
> production builds.
> 
> The static inline function returning 0 allows to optimize out the unused
> code, so smaller code, fewer inctructions, etc.

Absolutely, I just mean that the CONFIG_BTRFS_FS_RUN_SANITY_TESTS
version can be cleaner:

#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
{
	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
}
#else
static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
{
	return 0;
}
#endif

I find `if (1) return 1; else return 0;` really icky.
