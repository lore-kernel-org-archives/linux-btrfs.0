Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84C53ACEED
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802099; cv=none; b=rdXeMZ0VrJ//k9IwkOvy8uMGVaZ4hhMPSGHbk5+d92mW4+y+MQ5/b0nhT/V87Fc82KE3L8Q1t9u8wemiD9BNqcn56IvGcfdc2OnDd3YzuwTHM0QzZSO4hH96XqFI8H9dRK9jeAI1N04m8iL0DnVOnxZxFyQ4xlB1/r5aGHSA9p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802099; c=relaxed/simple;
	bh=tbx7nVIA41LU75v4yUrONlPkVS4w/NecnyPGwZVkUB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+xZyMw48v9BbtwYGqRIl9k2JiCkBt6lOpCHwN/1XDondueETLQlyyjTkpXkH1uuGAjo4or6kwjN1+3/62rVxTFkdlJOXuOK+1rTvaNmkMZoqJl16CHMQ0sZilsT7g9/Vz+fbbuCoxm7vPyLasutyU6eL/j14WfLdXEZ7vGnZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbZnrAmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbZnrAmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D08C1F0089C
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 10:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802098;
	bh=WcdWXpLvkFFkSvL+lWwxPPOEy/dBZ8FznkBBSy7pRMM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EbZnrAmxEWVL3c6k/OJ+/MXcElrEzE5i/9Y0LtJQgyBKXkRG6I5tdtka3YFkPGqVI
	 d/oVHt7yduQGeHqriEX0UwGe+pVHHkejSH/tg5EcHcZTfdpEBROqzYuZxS7RjhzE1Y
	 jLEN+3yvhWfj4VwO0NXPr2WkXZbvD9uQunzOQ8DBciNvIXSzrZgggKZzQ9rekheFxT
	 5sTnyir202nS95alfJDPwFTad3T/0kv6rzQHei0rbXa6DOeQnGwCUHkojHI+2+kkKM
	 MjlFhaE3s1WAW6eJ+XDrBCpCygPIvy53uErenU8vLTRi/AJ0I5CZoq4SATHdQh5U5p
	 pgMXJVpUP+QEA==
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7bf5f3736d2so1186649137.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 03:48:18 -0700 (PDT)
X-Gm-Message-State: AFq9FYJyatGBGf6azd9rI2mhuBYpT1yXykik5cgGLP/wTAgOdnpp+BWK
	6544b+56MCUHchWqr8FsJ/UEIbiCxGBMXtdb0AJB0UeLb1kpe3Xm7LpXnttjgkOdSS4wUXx1lEF
	5WfInaGeAKBRSDBhBZEU9ieP7/tasTi4=
X-Received: by 2002:a05:6102:424f:b0:7a6:85d6:84c3 with SMTP id
 ada2fe7eead31-7cb3678832dmr2758793137.3.1791802097498; Mon, 12 Oct 2026
 03:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791706855.git.wqu@suse.com> <f6c20a7063b1f67881a61cdbd707f4634df9ed0c.1791706855.git.wqu@suse.com>
In-Reply-To: <f6c20a7063b1f67881a61cdbd707f4634df9ed0c.1791706855.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 12 Oct 2026 11:47:40 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7TaX8EfOqxKvagAEO0D33f+hGWxQvnC91hhiSQJTja4A@mail.gmail.com>
X-Gm-Features: AclHuK_UletaRnPNUqk3aUFsEgdEK1oekhlkHOnos1hYCSkyEddjgHjnUAkZ0Ng
Message-ID: <CAL3q7H7TaX8EfOqxKvagAEO0D33f+hGWxQvnC91hhiSQJTja4A@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] btrfs: fix use-after-free on quota enable
 allocation failure
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>, 
	syzbot+947286c775f432b073a8@syzkaller.appspotmail.com, 
	Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 9:22=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>
> [BUG]
> There is a syzbot report that a use-after-free bug is triggered after a
> failed btrfs_quota_enable():
>
>  loop0: detected capacity change from 32768 to 0
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x4e/0x130=
 lib/list_debug.c:29
>  Read of size 8 at addr ffff888040e0a528 by task syz.0.0/5324
>
>  CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(f=
ull)
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1=
.16.3-2 04/01/2014
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>   print_report+0x58/0x70 mm/kasan/report.c:482
>   kasan_report+0x117/0x150 mm/kasan/report.c:595
>   __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
>   __list_add_valid include/linux/list.h:104 [inline]
>   __list_add include/linux/list.h:169 [inline]
>   list_add include/linux/list.h:192 [inline]
>   list_move include/linux/list.h:345 [inline]
>   add_root_to_dirty_list+0x38b/0x470 fs/btrfs/ctree.c:232
>   btrfs_force_cow_block+0xf09/0x1bf0 fs/btrfs/ctree.c:553
>   btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
>   btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
>   btrfs_search_prev_slot fs/btrfs/free-space-tree.c:134 [inline]
>   remove_free_space_extent fs/btrfs/free-space-tree.c:732 [inline]
>   __btrfs_remove_from_free_space_tree fs/btrfs/free-space-tree.c:837 [inl=
ine]
>   btrfs_remove_from_free_space_tree+0x4d6/0xda0 fs/btrfs/free-space-tree.=
c:866
>   alloc_reserved_extent+0x4a/0x2b0 fs/btrfs/extent-tree.c:4976
>   alloc_reserved_tree_block fs/btrfs/extent-tree.c:5155 [inline]
>   run_delayed_tree_ref fs/btrfs/extent-tree.c:1815 [inline]
>   run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
>   btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
>   __btrfs_run_delayed_refs+0x18b5/0x43b0 fs/btrfs/extent-tree.c:2134
>   btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
>   btrfs_commit_transaction+0x28a/0x3170 fs/btrfs/transaction.c:2267
>   sync_filesystem+0x1d2/0x240 fs/sync.c:66
>   btrfs_reconfigure+0x2dc/0x2100 fs/btrfs/super.c:1511
>   reconfigure_super+0x232/0x8f0 fs/super.c:1128
>   do_remount fs/namespace.c:3410 [inline]
>   path_mount+0xd4e/0x1050 fs/namespace.c:4160
>   do_mount fs/namespace.c:4181 [inline]
>   __do_sys_mount fs/namespace.c:4397 [inline]
>   __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>   do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  RIP: 0033:0x7f9c8dd9f3ca
>   </TASK>
>
>  Allocated by task 5323:
>   kasan_save_stack mm/kasan/common.c:57 [inline]
>   kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>   poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
>   __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
>   kasan_kmalloc include/linux/kasan.h:263 [inline]
>   __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
>   _kmalloc_noprof include/linux/slab.h:991 [inline]
>   _kzalloc_noprof include/linux/slab.h:1312 [inline]
>   btrfs_alloc_root+0x75/0x840 fs/btrfs/disk-io.c:638
>   btrfs_create_tree+0xa8/0x5c0 fs/btrfs/disk-io.c:832
>   btrfs_quota_enable+0x3d6/0x1e20 fs/btrfs/qgroup.c:1074
>   btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:597 [inline]
>   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>   do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>  Freed by task 5323:
>   kasan_save_stack mm/kasan/common.c:57 [inline]
>   kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>   kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>   poison_slab_object mm/kasan/common.c:264 [inline]
>   __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
>   kasan_slab_free include/linux/kasan.h:235 [inline]
>   slab_free_hook mm/slub.c:2748 [inline]
>   slab_free mm/slub.c:6508 [inline]
>   kfree+0x1c5/0x650 mm/slub.c:6801
>   btrfs_quota_enable+0x1208/0x1e20 fs/btrfs/qgroup.c:1292
>   btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:597 [inline]
>   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>   do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> [CAUSE]
> During btrfs_quota_enable(), a temporary quota_root is created, then
> qgroup items are created for each subvolume and inserted into that root.
>
> If there are enough subvolumes, the level of quota_root will be bumped,
> and add_root_to_dirty_list() will be called, adding
> quota_root->dirty_list into fs_info->dirty_cowonly_roots.
>
> But if a problem is hit during btrfs_quota_enable() later, that
> quota_root will be released through btrfs_put_root(), causing the whole
> quota_root structure to be released, while leaving
> fs_info->dirty_cowonly_roots still pointing to the released
> quota_root->dirty_list.
>
> Later access through fs_info->dirty_cowonly_roots will trigger a
> use-after-free bug.
>
> [FIX]
> We can just call list_del_init(&root->dirty_list) when
> btrfs_quota_enable() failed.
>
> Also to follow the existing error handling behavior, abort the
> transaction when the memory preallocation failed.
>
> Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6ac5a5e1.9ad129c8.3ce5b3.0010.G=
AE@google.com/
> Closes: https://syzkaller.appspot.com/bug?extid=3D947286c775f432b073a8
> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> [ Change the commit message to include a proper analysis. ]
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index cf8dfd5c692b..a0651fbfe778 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1207,6 +1207,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_inf=
o,
>         prealloc =3D kzalloc_obj(*prealloc, GFP_NOFS);
>         if (!prealloc) {
>                 ret =3D -ENOMEM;
> +               btrfs_abort_transaction(trans, ret);
>                 goto out;
>         }
>         qgroup =3D add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTI=
D);
> @@ -1296,6 +1297,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_in=
fo,
>                  * sysfs entries.
>                  */
>                 btrfs_free_qgroup_config(fs_info);
> +
> +               if (quota_root) {
> +                       spin_lock(&fs_info->trans_lock);
> +                       list_del_init(&quota_root->dirty_list);
> +                       spin_unlock(&fs_info->trans_lock);
> +               }
>                 btrfs_put_root(quota_root);

It looks a bit odd to have left btrfs_put_root() outside the if block
that tests for a non NULL quota root.
While's harmless, it feels odd.

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

>         }
>         mutex_unlock(&fs_info->qgroup_ioctl_lock);
> --
> 2.56.0
>
>
