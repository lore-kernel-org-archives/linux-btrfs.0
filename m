Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F13C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8157C2083A
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZRJhU29"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8157C2083A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbeJVSLv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 14:11:51 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46321 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbeJVSLu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 14:11:50 -0400
Received: by mail-ua1-f66.google.com with SMTP id z8so9720221uap.13
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 02:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=DWJN/n/4wmRbxsbgNQ4/WQ3rpisaZg9s0nPdFlcwZJ8=;
        b=WZRJhU295nySsPGSSKcQAbcrh4LMD5/EuphdQW8sY090lJoDpIHk72L6z7bUQ6BmaY
         HPLNooJ8VhxIc4UEo3TX6BKtNPhLX1+ZiHr3mYOInByG2wVv6ZPE5cbZ3DPUgyYy9MCZ
         hxNokw7P/qD5DyI28ptPO3bOTS8NffuwASVNZInr9g0QzRj6HeiPZC78fJIuY8kN6uWk
         6tBnPWprkX8o48d1yGxC77NDZJJOd50Detveu8Dd09AKcPNaaUIMmuIgjoE9Lzazd7HE
         /vEUnJMVyWnocDkV84wELSkidYUG/AdQGvFIRi+CfYfLr2mtOzwGI4DNhBF/DGEsWh66
         AyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=DWJN/n/4wmRbxsbgNQ4/WQ3rpisaZg9s0nPdFlcwZJ8=;
        b=Mx3DPb8UW/9DVceZy/tN09Iw33DNGUWEnYF0XYdv1AJcTX+siMxJePQMpCA4NSyeEH
         ziutYoMgkc64OpD5e3mCHB8GZ6lbP20dzYjHn7SZdw3dAc9gFFB/81shZpPfCWIcZjZn
         JJDVkSTK3t9LOZpCMJrewqnPLqP205CkKkIJg1DCexTgTkikGI46v9TJ/gYBeO2dxkOE
         MiQ/6YbwYdyQAyltHtjvqRdt0MaZJxvhCL/FHYUV6/cYa8ddLekzR40HBtXLg1yX69cE
         qsSrj+rLWwf0/nPS3ROIWPJAb36HQFVDK8YB6UfNOpjOpBj/b+acg9lClejW8vKNe5Mb
         +Bcw==
X-Gm-Message-State: ABuFfoiN4QMzf+5iE7PA0eB/Zb7xwi0uv2VxviVJcURoD7f8ECSDpaoC
        M5D9/Y6c+A/z6EebmEQ3YAy2Ej6/ZpDMoT5pqEOk8AL/
X-Google-Smtp-Source: ACcGV60Lj/P2brm5QtJPSoO88wJxwVQPps7FgCIaVtIhdl8iDw3+6IoLrbJpr9j9hKNIIeRNF2zVACcR3N6+gA1YPC8=
X-Received: by 2002:ab0:2101:: with SMTP id d1mr18596558ual.108.1540202040416;
 Mon, 22 Oct 2018 02:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org>
In-Reply-To: <20181022090946.1150-1-fdmanana@kernel.org>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 22 Oct 2018 10:53:49 +0100
Message-ID: <CAL3q7H5CVXtHsg3NMbiP8Y8uwqQppKkkAZ1X72VXF-qe_ymz2w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock on tree root leaf when finding free extent
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 10:10 AM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> When we are writing out a free space cache, during the transaction commit
> phase, we can end up in a deadlock which results in a stack trace like th=
e
> following:
>
>  schedule+0x28/0x80
>  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
>  ? finish_wait+0x80/0x80
>  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
>  btrfs_search_slot+0xf6/0x9f0 [btrfs]
>  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
>  ? inode_insert5+0x119/0x190
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_iget+0x113/0x690 [btrfs]
>  __lookup_free_space_inode+0xd8/0x150 [btrfs]
>  lookup_free_space_inode+0x5b/0xb0 [btrfs]
>  load_free_space_cache+0x7c/0x170 [btrfs]
>  ? cache_block_group+0x72/0x3b0 [btrfs]
>  cache_block_group+0x1b3/0x3b0 [btrfs]
>  ? finish_wait+0x80/0x80
>  find_free_extent+0x799/0x1010 [btrfs]
>  btrfs_reserve_extent+0x9b/0x180 [btrfs]
>  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
>  __btrfs_cow_block+0x11d/0x500 [btrfs]
>  btrfs_cow_block+0xdc/0x180 [btrfs]
>  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_update_inode_item+0x46/0x100 [btrfs]
>  cache_save_setup+0xe4/0x3a0 [btrfs]
>  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
>  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
>
> At cache_save_setup() we need to update the inode item of a block group's
> cache which is located in the tree root (fs_info->tree_root), which means
> that it may result in COWing a leaf from that tree. If that happens we
> need to find a free metadata extent and while looking for one, if we find
> a block group which was not cached yet we attempt to load its cache by
> calling cache_block_group(). However this function will try to load the
> inode of the free space cache, which requires finding the matching inode
> item in the tree root - if that inode item is located in the same leaf as
> the inode item of the space cache we are updating at cache_save_setup(),
> we end up in a deadlock, since we try to obtain a read lock on the same
> extent buffer that we previously write locked.
>
> So fix this by skipping the loading of free space caches of any block
> groups that are not yet cached (rare cases) if we are updating the inode
> of a free space cache. This is a rare case and its downside is failure to
> find a free extent (return -ENOSPC) when all the already cached block
> groups have no free extents.
>
> Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8v=
yiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Andrew Nelson <andrew.s.nelson@gmail.com>


> ---
>  fs/btrfs/ctree.h       |  3 +++
>  fs/btrfs/disk-io.c     |  2 ++
>  fs/btrfs/extent-tree.c | 22 +++++++++++++++++++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2cddfe7806a4..d23ee26eb17d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1121,6 +1121,9 @@ struct btrfs_fs_info {
>         u32 sectorsize;
>         u32 stripesize;
>
> +       /* The task currently updating a free space cache inode item. */
> +       struct task_struct *space_cache_updater;
> +
>  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
>         spinlock_t ref_verify_lock;
>         struct rb_root block_tree;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 05dc3c17cb62..aa5e9a91e560 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2782,6 +2782,8 @@ int open_ctree(struct super_block *sb,
>         fs_info->sectorsize =3D 4096;
>         fs_info->stripesize =3D 4096;
>
> +       fs_info->space_cache_updater =3D NULL;
> +
>         ret =3D btrfs_alloc_stripe_hash_table(fs_info);
>         if (ret) {
>                 err =3D ret;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 577878324799..e93040449771 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3364,7 +3364,9 @@ static int cache_save_setup(struct btrfs_block_grou=
p_cache *block_group,
>          * time.
>          */
>         BTRFS_I(inode)->generation =3D 0;
> +       fs_info->space_cache_updater =3D current;
>         ret =3D btrfs_update_inode(trans, root, inode);
> +       fs_info->space_cache_updater =3D NULL;
>         if (ret) {
>                 /*
>                  * So theoretically we could recover from this, simply se=
t the
> @@ -7366,7 +7368,25 @@ static noinline int find_free_extent(struct btrfs_=
fs_info *fs_info,
>
>  have_block_group:
>                 cached =3D block_group_cache_done(block_group);
> -               if (unlikely(!cached)) {
> +               /*
> +                * If we are updating the inode of a free space cache, we=
 can
> +                * not start the caching of any block group because we co=
uld
> +                * deadlock on an extent buffer of the root tree.
> +                * At cache_save_setup() we update the inode item of a fr=
ee
> +                * space cache, so we may need to COW a leaf of the root =
tree,
> +                * which implies finding a free metadata extent. So if wh=
en
> +                * searching for such an extent we find a block group tha=
t was
> +                * not yet cached (which is unlikely), we can not start l=
oading
> +                * or building its free space cache because that implies =
reading
> +                * its inode from disk (load_free_space_cache()) which im=
plies
> +                * searching the root tree for its inode item, which can =
be
> +                * located in the same leaf that we previously locked at
> +                * cache_save_setup() for updating the inode item of the =
former
> +                * free space cache, therefore leading to an attempt to l=
ock the
> +                * same leaf twice.
> +                */
> +               if (unlikely(!cached) &&
> +                   fs_info->space_cache_updater !=3D current) {
>                         have_caching_bg =3D true;
>                         ret =3D cache_block_group(block_group, 0);
>                         BUG_ON(ret < 0);
> --
> 2.11.0
>

--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
