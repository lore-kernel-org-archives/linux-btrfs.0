Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3737C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9779C2145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKsTRyNR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9779C2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeLAEWn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:22:43 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:43514 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeLAEWm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:22:42 -0500
Received: by mail-vk1-f195.google.com with SMTP id o130so1436390vke.10;
        Fri, 30 Nov 2018 09:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=FfCxMIDR8QNT5TN07pFH5AjALNx+TrHPocUrKre81vQ=;
        b=KKsTRyNRWx/N++NjFroj0RY4M0FkxMOsIoa/VoSg8J1q6ghHceOZSA2syBoZ7/uEys
         TIxyZuDozbZYr8Hls7FqvqnGW6VQI7eRlyP009O7k03mR1S5DjjVrncn6uNTp9LuFBk1
         LrMnRBNBgdAN2RqP3AFjQo5mtYrgV7K7pmUSmtyWh4vVF7CsH/CPBO8VgZT3uNTMyhkG
         xLopxgUqSPeOY7iJgUZqE2pjFWlJBAKlhZItFJ9ksDMo/xldFEC4sVDctpwH/gmscGZj
         MFLpgPwSwilGG6ZaeNdU8U/8wAouudJyVmB8f9MA8reBa9orOvKqU9raJjHCTJNWHwKt
         HJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=FfCxMIDR8QNT5TN07pFH5AjALNx+TrHPocUrKre81vQ=;
        b=AlYLfbpBWOS7kzYxgSIB6TzWWfuPwOpuptw1KBCcPqAWqFFb+aMpyT1zfwBpwWo9ne
         M8SGRoCHM03T+u8ldkBt4Xa0UmyffxDDys709fJrD/7lbkjf7cobv1FWPKzTRSUxxiru
         QY9EpoGA4hn8fGA0V74oVwrx4f6d0llW1z1mtRk9cbipYRiM5AQ+VNtsZ808SMLuDgOd
         w4ggukLyfSHm3/bUj/7+ctYL3/uMefowiPa7wfpfuCXM10KcvCrqNT7NtzacK7ftJJ8H
         LuKcMYKnsGc5BroESxdEsbA4pZk/zuq9ZtvqeIRFizb6BmjypOokcA1V3tAiV0KiKDYV
         yFMA==
X-Gm-Message-State: AA+aEWZXu32YZQmkkDu1zGnIEreCfhfvsK7gvleezI6aAxQWd+uJLnhz
        U+Eos7ukyUuqkIFc+tMYWnOyg4UeI2bBVjZZoRmom7ta
X-Google-Smtp-Source: AFSGD/UikPeaZNA44BAM1NnbkOla9pMBfHhirybQ6+6erRCpQtdUlSzK2BQrNeMqSR1fUAKYrZwwtXb/zD5w27C239o=
X-Received: by 2002:a1f:4982:: with SMTP id w124mr2850208vka.4.1543597963670;
 Fri, 30 Nov 2018 09:12:43 -0800 (PST)
MIME-Version: 1.0
References: <20181130165214.17883-1-josef@toxicpanda.com> <20181130165214.17883-3-josef@toxicpanda.com>
In-Reply-To: <20181130165214.17883-3-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 30 Nov 2018 17:12:31 +0000
Message-ID: <CAL3q7H7N8ozNzhkTmt=s30SLaH-TptHZNv3b_Wv_Tif_c_nJVg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: run delayed items before dropping the snapshot
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 4:53 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> From: Josef Bacik <jbacik@fb.com>
>
> With my delayed refs patches in place we started seeing a large amount
> of aborts in __btrfs_free_extent
>
> BTRFS error (device sdb1): unable to find ref byte nr 91947008 parent 0 r=
oot 35964  owner 1 offset 0
> Call Trace:
>  ? btrfs_merge_delayed_refs+0xaf/0x340
>  __btrfs_run_delayed_refs+0x6ea/0xfc0
>  ? btrfs_set_path_blocking+0x31/0x60
>  btrfs_run_delayed_refs+0xeb/0x180
>  btrfs_commit_transaction+0x179/0x7f0
>  ? btrfs_check_space_for_delayed_refs+0x30/0x50
>  ? should_end_transaction.isra.19+0xe/0x40
>  btrfs_drop_snapshot+0x41c/0x7c0
>  btrfs_clean_one_deleted_snapshot+0xb5/0xd0
>  cleaner_kthread+0xf6/0x120
>  kthread+0xf8/0x130
>  ? btree_invalidatepage+0x90/0x90
>  ? kthread_bind+0x10/0x10
>  ret_from_fork+0x35/0x40
>
> This was because btrfs_drop_snapshot depends on the root not being modifi=
ed
> while it's dropping the snapshot.  It will unlock the root node (and real=
ly
> every node) as it walks down the tree, only to re-lock it when it needs t=
o do
> something.  This is a problem because if we modify the tree we could cow =
a block
> in our path, which free's our reference to that block.  Then once we get =
back to
> that shared block we'll free our reference to it again, and get ENOENT wh=
en
> trying to lookup our extent reference to that block in __btrfs_free_exten=
t.
>
> This is ultimately happening because we have delayed items left to be pro=
cessed
> for our deleted snapshot _after_ all of the inodes are closed for the sna=
pshot.
> We only run the delayed inode item if we're deleting the inode, and even =
then we
> do not run the delayed insertions or delayed removals.  These can be run =
at any
> point after our final inode does it's last iput, which is what triggers t=
he
> snapshot deletion.  We can end up with the snapshot deletion happening an=
d then
> have the delayed items run on that file system, resulting in the above pr=
oblem.
>
> This problem has existed forever, however my patches made it much easier =
to hit
> as I wake up the cleaner much more often to deal with delayed iputs, whic=
h made
> us more likely to start the snapshot dropping work before the transaction
> commits, which is when the delayed items would generally be run.  Before,
> generally speaking, we would run the delayed items, commit the transactio=
n, and
> wakeup the cleaner thread to start deleting snapshots, which means we wer=
e less
> likely to hit this problem.  You could still hit it if you had multiple
> snapshots to be deleted and ended up with lots of delayed items, but it w=
as
> definitely harder.
>
> Fix for now by simply running all the delayed items before starting to dr=
op the
> snapshot.  We could make this smarter in the future by making the delayed=
 items
> per-root, and then simply drop any delayed items for roots that we are go=
ing to
> delete.  But for now just a quick and easy solution is the safest.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Great catch!
I've hit this error from  __btrfs_free_extent() a handful of times
over the years, but never managed
to reproduce it on demand or figure out it was related to snapshot deletion=
.

> ---
>  fs/btrfs/extent-tree.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dcb699dd57f3..965702034b22 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9330,6 +9330,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 goto out_free;
>         }
>
> +       btrfs_run_delayed_items(trans);
> +
>         if (block_rsv)
>                 trans->block_rsv =3D block_rsv;
>
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
