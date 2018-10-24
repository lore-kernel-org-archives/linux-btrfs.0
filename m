Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C313C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 13:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D99EA20824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 13:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="tUE2faDw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D99EA20824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbeJXV4m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 17:56:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37016 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeJXV4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 17:56:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id p2-v6so2140783wmc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 06:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U4VcEXZcvk4hUiZeXFEvhwdmXPkCdGI7Gzppc5yUimA=;
        b=tUE2faDw9VxraN9fCQBp5lBiZDzTYj0pTcO2CKHt/6wNG5cCRqn4+11g/EXVhyDJNq
         +PH70PzpEEkuUekXf1TSroJ6XHFykpCTn8mVWcnQ2zZiVifEd6Bj6pjN5x3H273WSzcL
         GI/jDNHwwITPx/wTGMLWBr0X6a30uL9sLpFyBeIzDrsXr/yiONri1hLK/pHgreT1BNsl
         VXbQes47lOvF195dgueyJdi9dRkRk8G5nVP291t/gQR7c9jv/Xr41l/74MGnCNq2YVi1
         c9Of9wtlVhuSP10hKrYoYef/Zm6wSQ+Unz+UsxbkEKID+wubhe6Vbnt4FIVeHi3cq3il
         a3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U4VcEXZcvk4hUiZeXFEvhwdmXPkCdGI7Gzppc5yUimA=;
        b=heDGleyGiSSrHFZaGaKNVJRFbjMgcKzB5HrChg7HebaYLyRhE3d5W7IW8PO0HEbazp
         O66dBdtKw6GPF+CK5X8uLuubtpT/w0V9wLd7NpxkxHUGRQP5WDFJXo0RvonpqNdHvgIr
         KvQRw4YMlvASjlFgI9lcleBh3f5VL7uFUfLBeGhdlNYZXvIO6PsAxnFP1h4afi5V+hAR
         ara3kIc4VrxZPbXGxFbR71aiGdfsqfqx/jaTF9O/LhVwjCgIgiUtkhZEyPEfG9WVrZlb
         XFn+5Ct0F+5TMG8TjyhMk9pn4230wjJqox3Q7a/dh4FXJ1z3vNNrrFZZiX9ImAlXS5UY
         A25A==
X-Gm-Message-State: AGRZ1gITiAJU3AkkwQD/vPUnGRq5Y8xDqzi5ega/NTmWxeLv4WaeVg7t
        RM21BFQxQ3/4o4ypvEOS2UGN2Q==
X-Google-Smtp-Source: AJdET5cqOLRtYFa0vxPcDYt3fwEimghWwd640vR93YKaClxDQIzweGjZYgsylgBbZLHBwjvRi6cYuA==
X-Received: by 2002:a1c:b0c5:: with SMTP id z188-v6mr2736997wme.151.1540387713109;
        Wed, 24 Oct 2018 06:28:33 -0700 (PDT)
Received: from pathfinder (62-64-249-96.dynamic.dsl.as9105.com. [62.64.249.96])
        by smtp.gmail.com with ESMTPSA id u191-v6sm3741356wmd.31.2018.10.24.06.28.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Oct 2018 06:28:32 -0700 (PDT)
Date:   Wed, 24 Oct 2018 14:28:30 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     David Sterba <dsterba@suse.cz>
Cc:     clm@fb.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        jbacik@fb.com, dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH v2 10/10] btrfs: use common file type conversion
Message-ID: <20181024132830.GA23398@pathfinder>
References: <20181023201952.GA15676@pathfinder>
 <20181023211728.GA16584@pathfinder>
 <20181024101128.GS16290@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024101128.GS16290@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 12:11:28PM +0200, David Sterba wrote:
> On Tue, Oct 23, 2018 at 10:17:28PM +0100, Phillip Potter wrote:
> > Deduplicate the btrfs file type conversion implementation.
> 
> The per-filesystem changelogs need a brief explanation why this is done,
> like "Filesystems that use the same filetypes as defined by POSIX do not
> need to define their own versions and use the common defines in
> file_type.h", rephrase at you like.
> 
> > Original patch by Amir Goldstein.
> > 
> > v2:
> > - Rebased against Linux 4.19 by Phillip Potter
> > - Compile-time checks added by Phillip Potter to make
> >   sure the BTRFS_FT_x enum values stay same as FT_x values
> > 
> > v1:
> > - Initial implementation
> > 
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  fs/btrfs/btrfs_inode.h          |  2 --
> >  fs/btrfs/delayed-inode.c        |  2 +-
> >  fs/btrfs/inode.c                | 35 +++++++++++++++++----------------
> >  include/uapi/linux/btrfs_tree.h |  2 ++
> >  4 files changed, 21 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 1343ac57b438..c7c6db6b4a35 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -196,8 +196,6 @@ struct btrfs_inode {
> >  	struct inode vfs_inode;
> >  };
> >  
> > -extern unsigned char btrfs_filetype_table[];
> > -
> >  static inline struct btrfs_inode *BTRFS_I(const struct inode *inode)
> >  {
> >  	return container_of(inode, struct btrfs_inode, vfs_inode);
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index f51b509f2d9b..c1da34e3a775 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > @@ -1691,7 +1691,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
> >  		name = (char *)(di + 1);
> >  		name_len = btrfs_stack_dir_name_len(di);
> >  
> > -		d_type = btrfs_filetype_table[di->type];
> > +		d_type = fs_dtype(di->type);
> >  		btrfs_disk_key_to_cpu(&location, &di->location);
> >  
> >  		over = !dir_emit(ctx, name, name_len,
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3ea5339603cf..4cbdcba4799a 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -73,17 +73,6 @@ struct kmem_cache *btrfs_trans_handle_cachep;
> >  struct kmem_cache *btrfs_path_cachep;
> >  struct kmem_cache *btrfs_free_space_cachep;
> >  
> > -#define S_SHIFT 12
> > -static const unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
> > -	[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
> > -	[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
> > -	[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
> > -	[S_IFBLK >> S_SHIFT]	= BTRFS_FT_BLKDEV,
> > -	[S_IFIFO >> S_SHIFT]	= BTRFS_FT_FIFO,
> > -	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
> > -	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
> > -};
> > -
> >  static int btrfs_setsize(struct inode *inode, struct iattr *attr);
> >  static int btrfs_truncate(struct inode *inode, bool skip_writeback);
> >  static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
> > @@ -5803,10 +5792,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
> >  	return d_splice_alias(inode, dentry);
> >  }
> >  
> > -unsigned char btrfs_filetype_table[] = {
> > -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> > -};
> > -
> >  /*
> >   * All this infrastructure exists because dir_emit can fault, and we are holding
> >   * the tree lock when doing readdir.  For now just allocate a buffer and copy
> > @@ -5945,7 +5930,23 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  		name_ptr = (char *)(entry + 1);
> >  		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
> >  				   name_len);
> > -		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
> > +
> > +		/*
> > +		 * compile-time asserts that generic FT_x types
> > +		 * still match BTRFS_FT_x types - no need to list
> > +		 * in other functions as well as build will
> > +		 * fail either way
> > +		 */
> 
> Please format comments to 80 columns.
> 
> > +		BUILD_BUG_ON(BTRFS_FT_UNKNOWN != FT_UNKNOWN);
> > +		BUILD_BUG_ON(BTRFS_FT_REG_FILE != FT_REG_FILE);
> > +		BUILD_BUG_ON(BTRFS_FT_DIR != FT_DIR);
> > +		BUILD_BUG_ON(BTRFS_FT_CHRDEV != FT_CHRDEV);
> > +		BUILD_BUG_ON(BTRFS_FT_BLKDEV != FT_BLKDEV);
> > +		BUILD_BUG_ON(BTRFS_FT_FIFO != FT_FIFO);
> > +		BUILD_BUG_ON(BTRFS_FT_SOCK != FT_SOCK);
> > +		BUILD_BUG_ON(BTRFS_FT_SYMLINK != FT_SYMLINK);
> > +
> > +		put_unaligned(fs_dtype(btrfs_dir_type(leaf, di)),
> >  				&entry->type);
> >  		btrfs_dir_item_key_to_cpu(leaf, di, &location);
> >  		put_unaligned(location.objectid, &entry->ino);
> > @@ -6350,7 +6351,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> >  
> >  static inline u8 btrfs_inode_type(struct inode *inode)
> >  {
> > -	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
> > +	return fs_umode_to_ftype(inode->i_mode);
> >  }
> >  
> >  /*
> > diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> > index aff1356c2bb8..5747cffa09fa 100644
> > --- a/include/uapi/linux/btrfs_tree.h
> > +++ b/include/uapi/linux/btrfs_tree.h
> > @@ -307,6 +307,8 @@
> >   *
> >   * Used by:
> >   * struct btrfs_dir_item.type
> > + *
> > + * Values 0..7 should match common file type values in file_type.h.
> 
> I think it's rather 'must' than 'should' as there are the compile-time
> checks.

Dear David,

Good points, thank you, I will make these changes and republish as part of a new series.

Regards,
Phil
