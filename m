Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384B6C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 20:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE6E8208E7
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 20:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alhGozqo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE6E8208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbeLEUNe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 15:13:34 -0500
Received: from mail-ua1-f47.google.com ([209.85.222.47]:37333 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbeLEUNd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 15:13:33 -0500
Received: by mail-ua1-f47.google.com with SMTP id u19so7581294uae.4;
        Wed, 05 Dec 2018 12:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=MhpYDwACaTS7wYqKmFIHUuM21dSdjD6Z6yyx6QLtiJA=;
        b=alhGozqoWcglny6/gh21OeCh3ac+Zqlt9REMiz1Dg7vUDRwVgzqUcCaTOgFM5K9LSe
         ec3JikmErQWytboScAEG6HuyjDagaIbkTsAxb6kvEW3d25F9/SpKPk7FjHtOXNROVvBh
         nth/tpNN6w5gfCFMUObxSVH24umEpdyljrCxGBWPoibiIZZ4wHrpgYiWGjHcZb+YmfHQ
         izGvihX4wGwgaUgSb0j3M0oP3ZBXOTZCTqIDRyHZrLri86g2cly9hf3a4vq7hsNr0cSV
         ImQ+0uQEl/aT0Goli3Jdtgohz9vzti3AzUyApPK4QVEOq/UtLWz9GjUx21W1tjaHnsmD
         XNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=MhpYDwACaTS7wYqKmFIHUuM21dSdjD6Z6yyx6QLtiJA=;
        b=IENOArgr5Ym4wKr254lwSX3UhNJJZWwNFmJHEgpNK69JTDfgZtKJIoIOZOulC1uYlV
         DlO5mPwEXIFepAbYLO/ijeCL+xY0mvG3ugvq87rsEOL+hodvVucUYeq4tv2hmtt+EctU
         2qYUejmAwkOLeAJfxvKGGn919hPw0ksEzlMTEF9fNHZ9fOc1JzawJYLRZL/8mWt7TcpN
         4ivBN+isZsgRqYurGGyaBHpvKwT8nzcg+/ebd2EZRi06nt1tpdGha6/ZVAOrA2IN7EqV
         /r3fF8tidCKXivZbRbiXn95vAkGl0GpiK7O8RkKsbcJPCyO9Lr4fFkRv+vLX/PcLRiQI
         1HFA==
X-Gm-Message-State: AA+aEWbxdl9I06S76jnGxagVOqCA+4dMJCikNekW3fOqEsO1VVgDCB/1
        eJuLd+leON97XwE8P0ywMZg5e3wnHyQeND8giaPHkQ==
X-Google-Smtp-Source: AFSGD/UD6zW3Ap/odJly/1jvf/rWxe6+xPyNZE5tcDozS/r6WjEbkigXW330rY/WYCdUwgCrLMhhNfP1Ya+sFjoZrLk=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr10465699uao.36.1544040811832;
 Wed, 05 Dec 2018 12:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20181205171221.28777-1-josef@toxicpanda.com>
In-Reply-To: <20181205171221.28777-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 5 Dec 2018 20:13:20 +0000
Message-ID: <CAL3q7H4a-Roey45q41bscKkYRRFk0sibpJcBkzvxayv73Jk8iA@mail.gmail.com>
Subject: Re: [PATCH][v2] btrfs: run delayed items before dropping the snapshot
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 5, 2018 at 5:14 PM Josef Bacik <josef@toxicpanda.com> wrote:
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

Looks good now. Thanks.

> ---
> v1->v2:
> - check for errors from btrfs_run_delayed_items.
> - Dave I can reroll the series, but the second version of patch 1 is the =
same,
>   let me know what you want.
>
>  fs/btrfs/extent-tree.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dcb699dd57f3..473084eb7a2d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9330,6 +9330,10 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 goto out_free;
>         }
>
> +       err =3D btrfs_run_delayed_items(trans);
> +       if (err)
> +               goto out_end_trans;
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
