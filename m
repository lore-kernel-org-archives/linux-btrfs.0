Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF98C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5568F21902
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPcCeMvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfBGMGd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:06:33 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:44927 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfBGMGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 07:06:33 -0500
Received: by mail-ua1-f67.google.com with SMTP id v9so2006123uar.11
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 04:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=XOXp6d/bp033Ukjp2G1Hb76mlj+cCa5y/1ggwolPNvE=;
        b=jPcCeMvDfgMJzl9u9F9sI/U0pe0wpcfY6r9J9OTK19cPn10eMjL7mjQiyK4ZMQomIp
         2xfwXpCNgfPIv39zt7Mj+44bD+9IHFr4zAPEr/s3ew3qBR81WowQhCKTSyg/Xrz38EP1
         1AvfJ5+CPBzQe+OCG7zLKkKkkUNpppFZ9Lg2cLTjjo7sAR8DFTmUO0EEPe56nAZ73a2R
         S2KW7Xt2B8ruaizIFA0gpHJ1LqlzEli21et6qHqQwMD3RYD/QMbiymAQdW0SHI2WLscZ
         gbhB5jZmQyS6Of4Puok6CdD/SqXur0neKt18405ejxF3Wk2MwA0lKPA9+5nGNtF5f8WE
         3t1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=XOXp6d/bp033Ukjp2G1Hb76mlj+cCa5y/1ggwolPNvE=;
        b=pV2vQEUYkyuEoTLRfvjFXN2ezaYAxhHYmoDLUmlS1MrOuK02vHaMYnIY8KEJjkJoyc
         bGrtsqdU+lP42Zr+jgF/Dpq3k7p4EZFSVG0s9TOQQrIPAo5nP/RwRPDyiF3zdNFRhPkJ
         IstY+Rkcso9z1cGuCyLsVOtr1eTLqORiQ1cbPG1TB8PfNstRJhWPFFHmgK3P3agnJrbS
         O8JZRQyTAsj4TQRnfUvEiuSUXLBSM+DAH3HacL/mR7xW1LCLzERUFxnht+/q952gHE/L
         Jl0OAd/wZr7MF2T4Oh6mde0GQKgMyAGG3Bpb/OeFxMnlZi1TaRfGxkow/Tg7Jl8xG5jC
         qUeQ==
X-Gm-Message-State: AHQUAuam/qbDSr0qiLY2NboF3tvtawWoX/jmezhOiMUOViB2KfaUSLEk
        tEc0NXhZqZdhbpwTpJIVRnfZJRXOCDZolb0JnXhlUyq2
X-Google-Smtp-Source: AHgI3IbIqR20bwWss8hkIC2VtgzQw6VX0uTGGyZ1MreEw8bgTtwm/W6pw14TpdKH5Z/WudvNJnvKgmvRezx4qJ8g358=
X-Received: by 2002:ab0:5b9b:: with SMTP id y27mr5861091uae.30.1549541191700;
 Thu, 07 Feb 2019 04:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20190206204615.5862-1-josef@toxicpanda.com> <20190206204615.5862-2-josef@toxicpanda.com>
In-Reply-To: <20190206204615.5862-2-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 7 Feb 2019 12:06:20 +0000
Message-ID: <CAL3q7H4hTx6CNu3k1mOrnL5q5GrNts_EKc7bc+K9Jv4rVunZKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: check for refs on snapshot delete resume
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 6, 2019 at 8:47 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> There's a bug in snapshot deletion where we won't update the
> drop_progress key if we're in the UPDATE_BACKREF stage.  This is a
> problem because we could drop refs for blocks we know don't belong to
> ours.  If we crash or umount at the right time we could experience
> messages such as the following when snapshot deletion resumes
>
>  BTRFS error (device dm-3): unable to find ref byte nr 66797568 parent 0 =
root 258  owner 1 offset 0
>  ------------[ cut here ]------------
>  WARNING: CPU: 3 PID: 16052 at fs/btrfs/extent-tree.c:7108 __btrfs_free_e=
xtent.isra.78+0x62c/0xb30 [btrfs]
>  CPU: 3 PID: 16052 Comm: umount Tainted: G        W  OE     5.0.0-rc4+ #1=
47
>  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./890FX Delux=
e5, BIOS P1.40 05/03/2011
>  RIP: 0010:__btrfs_free_extent.isra.78+0x62c/0xb30 [btrfs]
>  Code: 45 90 48 8b 40 50 f0 48 0f ba a8 98 1a 00 00 02 0f 92 c0 84 c0 5e =
75 14 8b b5 7c ff ff ff 48 c7 c7 08 a7 b6 a0 e8 04 d0 63 e0 <0f> 0b 48 8b 7=
d 90 b9 fe ff ff ff ba c4 1b 00 00 48 c7 c6 a0 dd b5
>  RSP: 0018:ffffc90005cd7b18 EFLAGS: 00010286
>  RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>  RDX: ffff88842fade680 RSI: ffff88842fad6b18 RDI: ffff88842fad6b18
>  RBP: ffffc90005cd7bc8 R08: 0000000000000000 R09: 0000000000000001
>  R10: 0000000000000001 R11: ffffffff822696b8 R12: 0000000003fb4000
>  R13: 0000000000000001 R14: 0000000000000102 R15: ffff88819c9d67e0
>  FS:  00007f08bb138fc0(0000) GS:ffff88842fac0000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f8f5d861ea0 CR3: 00000003e99fe000 CR4: 00000000000006e0
>  Call Trace:
>  ? _raw_spin_unlock+0x27/0x40
>  ? btrfs_merge_delayed_refs+0x356/0x3e0 [btrfs]
>  __btrfs_run_delayed_refs+0x75a/0x13c0 [btrfs]
>  ? join_transaction+0x2b/0x460 [btrfs]
>  btrfs_run_delayed_refs+0xf3/0x1c0 [btrfs]
>  btrfs_commit_transaction+0x52/0xa50 [btrfs]
>  ? start_transaction+0xa6/0x510 [btrfs]
>  btrfs_sync_fs+0x79/0x1c0 [btrfs]
>  sync_filesystem+0x70/0x90
>  generic_shutdown_super+0x27/0x120
>  kill_anon_super+0x12/0x30
>  btrfs_kill_super+0x16/0xa0 [btrfs]
>  deactivate_locked_super+0x43/0x70
>  deactivate_super+0x40/0x60
>  cleanup_mnt+0x3f/0x80
>  __cleanup_mnt+0x12/0x20
>  task_work_run+0x8b/0xc0
>  exit_to_usermode_loop+0xce/0xd0
>  do_syscall_64+0x20b/0x210
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> To fix this simply mark dead roots we read from disk as DEAD and then
> set the walk_control->restarted flag so we know we have a restarted
> deletion.  From here whenever we try to drop refs for blocks we check to
> verify our ref is set on them, and if it is not we skip it.  Once we
> find a ref that is set we unset walk_control->restarted since the tree
> should be in a normal state from then on, and any problems we run into
> from there are different issues.  I tested this with an existing broken
> fs and my reproducer that creates a broken fs and it fixed both file
> systems.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, great catch!

> ---
>  fs/btrfs/ctree.h       |  1 +
>  fs/btrfs/extent-tree.c | 48 ++++++++++++++++++++++++++++++++++++++++++++=
+++-
>  fs/btrfs/root-tree.c   |  8 ++++++--
>  3 files changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9306925b6790..3d0bf91e1941 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1207,6 +1207,7 @@ enum {
>          * Set for the subvolume tree owning the reloc tree.
>          */
>         BTRFS_ROOT_DEAD_RELOC_TREE,
> +       BTRFS_ROOT_DEAD_TREE,
>  };
>
>  /*
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a53a2b9d49e9..f40d6086c947 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8772,6 +8772,7 @@ struct walk_control {
>         int keep_locks;
>         int reada_slot;
>         int reada_count;
> +       int restarted;
>  };
>
>  #define DROP_REFERENCE 1
> @@ -8934,6 +8935,33 @@ static noinline int walk_down_proc(struct btrfs_tr=
ans_handle *trans,
>         return 0;
>  }
>
> +/*
> + * This is used to verify a ref exists for this root to deal with a bug =
where we
> + * would have a drop_progress key that hadn't been updated properly.
> + */
> +static int check_ref_exists(struct btrfs_trans_handle *trans,
> +                           struct btrfs_root *root, u64 bytenr, u64 pare=
nt,
> +                           int level)
> +{
> +       struct btrfs_path *path;
> +       struct btrfs_extent_inline_ref *iref;
> +       int ret;
> +
> +       path =3D btrfs_alloc_path();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       ret =3D lookup_extent_backref(trans, path, &iref, bytenr,
> +                                   root->fs_info->nodesize, parent,
> +                                   root->root_key.objectid, level, 0);
> +       btrfs_free_path(path);
> +       if (ret =3D=3D -ENOENT)
> +               return 0;
> +       if (ret < 0)
> +               return ret;
> +       return 1;
> +}
> +
>  /*
>   * helper to process tree block pointer.
>   *
> @@ -9088,6 +9116,23 @@ static noinline int do_walk_down(struct btrfs_tran=
s_handle *trans,
>                         parent =3D 0;
>                 }
>
> +               /*
> +                * If we had a drop_progress we need to verify the refs a=
re set
> +                * as expected.  If we find our ref then we know that fro=
m here
> +                * on out everything should be correct, and we can clear =
the
> +                * ->restarted flag.
> +                */
> +               if (wc->restarted) {
> +                       ret =3D check_ref_exists(trans, root, bytenr, par=
ent,
> +                                              level - 1);
> +                       if (ret < 0)
> +                               goto out_unlock;
> +                       if (ret =3D=3D 0)
> +                               goto no_delete;
> +                       ret =3D 0;
> +                       wc->restarted =3D 0;
> +               }
> +
>                 /*
>                  * Reloc tree doesn't contribute to qgroup numbers, and w=
e have
>                  * already accounted them at merge time (replace_path),
> @@ -9109,7 +9154,7 @@ static noinline int do_walk_down(struct btrfs_trans=
_handle *trans,
>                 if (ret)
>                         goto out_unlock;
>         }
> -
> +no_delete:
>         *lookup_info =3D 1;
>         ret =3D 1;
>
> @@ -9426,6 +9471,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 }
>         }
>
> +       wc->restarted =3D test_bit(BTRFS_ROOT_DEAD_TREE, &root->state);
>         wc->level =3D level;
>         wc->shared_level =3D -1;
>         wc->stage =3D DROP_REFERENCE;
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 65bda0682928..02d1a57af78b 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -263,8 +263,10 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs=
_info)
>                 if (root) {
>                         WARN_ON(!test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED=
,
>                                           &root->state));
> -                       if (btrfs_root_refs(&root->root_item) =3D=3D 0)
> +                       if (btrfs_root_refs(&root->root_item) =3D=3D 0) {
> +                               set_bit(BTRFS_ROOT_DEAD_TREE, &root->stat=
e);
>                                 btrfs_add_dead_root(root);
> +                       }
>                         continue;
>                 }
>
> @@ -310,8 +312,10 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs=
_info)
>                         break;
>                 }
>
> -               if (btrfs_root_refs(&root->root_item) =3D=3D 0)
> +               if (btrfs_root_refs(&root->root_item) =3D=3D 0) {
> +                       set_bit(BTRFS_ROOT_DEAD_TREE, &root->state);
>                         btrfs_add_dead_root(root);
> +               }
>         }
>
>         btrfs_free_path(path);
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
