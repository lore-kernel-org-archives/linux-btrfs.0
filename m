Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8C8C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C1A2064D
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56C1A2064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbeLJR2d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:28:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:56104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbeLJR2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:28:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1401FACA4
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 17:28:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 08DF2DAB58; Mon, 10 Dec 2018 18:28:09 +0100 (CET)
Date:   Mon, 10 Dec 2018 18:28:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/8] btrfs: extent-tree: Use btrfs_ref to refactor
 btrfs_inc_extent_ref()
Message-ID: <20181210172809.GK23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-8-wqu@suse.com>
 <cfd001a5-f0af-3729-48e8-b82d831ce21d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfd001a5-f0af-3729-48e8-b82d831ce21d@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 10, 2018 at 11:52:25AM +0200, Nikolay Borisov wrote:
> On 6.12.18 г. 8:59 ч., Qu Wenruo wrote:
> > Now we don't need to play the dirty game of reusing @owner for tree block
> > level.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >  fs/btrfs/ctree.h       |  6 ++---
> >  fs/btrfs/extent-tree.c | 58 ++++++++++++++++++++++--------------------
> >  fs/btrfs/file.c        | 20 ++++++++++-----
> >  fs/btrfs/inode.c       | 10 +++++---
> >  fs/btrfs/ioctl.c       | 17 ++++++++-----
> >  fs/btrfs/relocation.c  | 44 ++++++++++++++++++++------------
> >  fs/btrfs/tree-log.c    | 12 ++++++---
> >  7 files changed, 100 insertions(+), 67 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 6f4b1e605736..db3df5ce6087 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -40,6 +40,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
> >  extern struct kmem_cache *btrfs_path_cachep;
> >  extern struct kmem_cache *btrfs_free_space_cachep;
> >  struct btrfs_ordered_sum;
> > +struct btrfs_ref;
> >  
> >  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
> >  
> > @@ -2682,10 +2683,7 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
> >  void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
> >  int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
> >  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> > -			 struct btrfs_root *root,
> > -			 u64 bytenr, u64 num_bytes, u64 parent,
> > -			 u64 root_objectid, u64 owner, u64 offset,
> > -			 bool for_reloc);
> > +			 struct btrfs_ref *generic_ref);
> >  
> >  int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
> >  int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 70c05ca30d9a..ff60091aef6b 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2026,36 +2026,28 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
> >  
> >  /* Can return -ENOMEM */
> >  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> > -			 struct btrfs_root *root,
> > -			 u64 bytenr, u64 num_bytes, u64 parent,
> > -			 u64 root_objectid, u64 owner, u64 offset,
> > -			 bool for_reloc)
> > +			 struct btrfs_ref *generic_ref)
> >  {
> > -	struct btrfs_fs_info *fs_info = root->fs_info;
> > -	struct btrfs_ref generic_ref = { 0 };
> > +	struct btrfs_fs_info *fs_info = trans->fs_info;
> >  	int old_ref_mod, new_ref_mod;
> >  	int ret;
> >  
> > -	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
> > -	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
> > +	BUG_ON(generic_ref->type == BTRFS_REF_NOT_SET ||
> > +	       !generic_ref->action);
> 
> Ouch, we should be removing BUG_ONs and not introducing new ones. Make
> it an assert
> 
> > +	BUG_ON(generic_ref->type == BTRFS_REF_METADATA &&
> > +	       generic_ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID);
> 
> Ideally this should also be converted to an assert. I guess it could
> only happen if the filesystem is corrupted so perhaps is redundant now?

I think we need more types of assert, not all BUG_ONs can be replaced by
ASSERT as behaviour would change depending ond CONFIG_BTRFS_ASSERTS. IMO
the asserts are best suited for development-time checks and cannot
replace runtime-checks where the BUG_ON is a big hammer to stop
execution otherwise it would cause worse things later.

This was mentioned in the past a few times, what we really don't want
are new BUG_ONs instead of proper error handling. The rest would be nice
to annotate by comments why it's there and that there's really no other
way around that.

I don't recall all the ideas so am not saying either way for the asserts
or bugons. Both would be ok here and full audit of BUG_ONs is one of my
long-term projects so it would get sorted eventually.
