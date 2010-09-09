From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2642!
Date: Thu, 9 Sep 2010 23:30:52 +0800
Message-ID: <AANLkTi=QQdBkvhUamuKrM=vhkYc6=9Eu6_d14M3PciJF@mail.gmail.com>
References: <20100909223331.362dd906.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100909223331.362dd906.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
That's because btrfs_del_dir_entries_in_log() will return the real
errno after Andi's
commit, so btrfs_unlink_inode() has to check the return value more seri=
ously.
A patch for this has been sent out.

Regards,
Zhu Yanhai

2010/9/9 Itaru Kitayama <kitayama@cl.bb4u.ne.jp>:
> Hi Chris,
> The latest mmotm on a virtual machine boots, but when I log in I get:
>
> [ =C2=A0 82.276418] ------------[ cut here ]------------
> [ =C2=A0 82.277565] kernel BUG at fs/btrfs/inode.c:2643!
> [ =C2=A0 82.278692] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEA=
LLOC
> [ =C2=A0 82.280332] last sysfs file: /sys/devices/pci0000:00/0000:00:=
11.0/0000:02:00.0/usb2/devnum
> [ =C2=A0 82.282323] CPU 1
> [ =C2=A0 82.282790] Modules linked in: nfs lockd fscache nfs_acl auth=
_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables=
 ipv6 uinput snd_ens1371 gameport snd_rawmidi snd_ac97_codec ac97_bus s=
nd_seq snd_seq_device snd_pcm ppdev snd_timer microcode pcspkr snd soun=
dcore parport_pc snd_page_alloc i2c_piix4 floppy parport e1000 shpchp i=
2c_core mptspi mptscsih mptbase scsi_transport_spi [last unloaded: spee=
dstep_lib]
> [ =C2=A0 82.293369]
> [ =C2=A0 82.293818] Pid: 5572, comm: gconfd-2 Not tainted 2.6.35-rc6-=
mm1+ #12 440BX Desktop Reference Platform/VMware Virtual Platform
> [ =C2=A0 82.296661] RIP: 0010:[<ffffffff811b0e65>] =C2=A0[<ffffffff81=
1b0e65>] btrfs_unlink_inode+0x1bb/0x25e
> [ =C2=A0 82.298629] RSP: 0018:ffff880069f9fc18 =C2=A0EFLAGS: 00010282
> [ =C2=A0 82.299810] RAX: 00000000fffffffe RBX: ffff88005985b250 RCX: =
ffff880002840006
> [ =C2=A0 82.301394] RDX: 0000000000000006 RSI: 0000000000000003 RDI: =
ffff880079b0b0d8
> [ =C2=A0 82.302973] RBP: ffff880069f9fc98 R08: 0000000000000046 R09: =
ffff880069f9fac8
> [ =C2=A0 82.303244] old_dentry database~ new_dentry database
> [ =C2=A0 82.303283] seq number to delete is 14
> [ =C2=A0 82.303331] seq number to delete is 13
> [ =C2=A0 82.304260] old_dentry database~ new_dentry database
> [ =C2=A0 82.304298] seq number to delete is 16
> [ =C2=A0 82.304344] seq number to delete is 15
> [ =C2=A0 82.310183] R10: ffff880069f9fae8 R11: ffff880069f9fae8 R12: =
00000000fffffffe
> [ =C2=A0 82.311726] R13: ffff88005985b910 R14: ffff88007a232288 R15: =
ffff880079b0b0d8
> [ =C2=A0 82.313286] FS: =C2=A000007f27f4ea87c0(0000) GS:ffff880002840=
000(0000) knlGS:0000000000000000
> [ =C2=A0 82.315048] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 00000000800=
5003b
> [ =C2=A0 82.316305] CR2: 00007ff36b92fac0 CR3: 000000006a363000 CR4: =
00000000000006e0
> [ =C2=A0 82.317912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [ =C2=A0 82.319510] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: =
0000000000000400
> [ =C2=A0 82.321171] Process gconfd-2 (pid: 5572, threadinfo ffff88006=
9f9e000, task ffff88006a3e8000)
> [ =C2=A0 82.323026] Stack:
> [ =C2=A0 82.323485] =C2=A0ffff88000000000b 00000000ffffffff 000000000=
0000e03 ffff880068a260d0
> [ =C2=A0 82.325245] <0> 0000000b69f9fc68 ffff880078f13088 00000000004=
2ba39 0000000000000001
> [ =C2=A0 82.327290] <0>
> [ =C2=A0 82.327701] old_dentry .xsession-errors new_dentry .xsession-=
errors.old
> [ =C2=A0 82.329271] =C2=A0ffff880079b0b300 000000000000042b ffff88006=
9f9fc78 ffff88005986f4b8
> [ =C2=A0 82.331896] Call Trace:
> [ =C2=A0 82.332454] =C2=A0[<ffffffff811b16cd>] btrfs_rename+0x33b/0x4=
73
> [ =C2=A0 82.333662] =C2=A0[<ffffffff8112cb1f>] vfs_rename+0x225/0x369
> [ =C2=A0 82.334835] =C2=A0[<ffffffff81043bde>] ? get_parent_ip+0x11/0=
x41
> [ =C2=A0 82.336066] =C2=A0[<ffffffff8112e3cf>] sys_renameat+0x193/0x2=
0c
> [ =C2=A0 82.337274] =C2=A0[<ffffffff810adbcf>] ? check_for_new_grace_=
period+0xde/0xfa
> [ =C2=A0 82.338738] =C2=A0[<ffffffff810ae37e>] ? __call_rcu+0x138/0x1=
4b
> [ =C2=A0 82.340262] =C2=A0[<ffffffff810ae37e>] ? __call_rcu+0x138/0x1=
4b
> [ =C2=A0 82.341541] =C2=A0[<ffffffff810c6014>] ? time_hardirqs_off+0x=
1e/0x20
> [ =C2=A0 82.342907] =C2=A0[<ffffffff8148acf9>] ? retint_swapgs+0x13/0=
x1b
> [ =C2=A0 82.344264] =C2=A0[<ffffffff8148acf9>] ? retint_swapgs+0x13/0=
x1b
> [ =C2=A0 82.345554] =C2=A0[<ffffffff8107ed21>] ? trace_hardirqs_on_ca=
ller+0x11d/0x141
> [ =C2=A0 82.347181] =C2=A0[<ffffffff8112e463>] sys_rename+0x1b/0x1d
> [ =C2=A0 82.348391] =C2=A0[<ffffffff81009d32>] system_call_fastpath+0=
x16/0x1b
> [ =C2=A0 82.349818] Code: 74 08 85 c0 74 04 0f 0b eb fe 4c 8b 4d c8 8=
b 4d a4 49 89 d8 48 8b 55 98 48 8b 7d a8 4c 89 fe e8 35 23 02 00 85 c0 =
41 89 c4 74 12 <0f> 0b eb fe 41 bc f4 ff ff ff eb 06 41 bc fe ff ff ff =
4c 89 f7
> [ =C2=A0 82.356109] RIP =C2=A0[<ffffffff811b0e65>] btrfs_unlink_inode=
+0x1bb/0x25e
> [ =C2=A0 82.357522] =C2=A0RSP <ffff880069f9fc18>
> [ =C2=A0 82.358414] ---[ end trace fe6f359e73694983 ]---
>
> When looking into the log tree, btrfs_lookup_dir_item finds the dir i=
tem, but
> btrfs_lookup_dir_index_item fails.
>
> If I revert the following patch, I don't encounter the above problem.
> But I am not certain if I really should revert it as it looks mostly =
fine.
>
> commit 018db35864fd8d307066485a2753866240c3dace
> Author: Andi Kleen <andi@firstfloor.org>
> Date: =C2=A0 Wed Jul 21 00:29:24 2010 +0200
>
> =C2=A0 =C2=A0These are all the cases where a variable is set, but not
> =C2=A0 =C2=A0read which are really bugs.
>
> =C2=A0 =C2=A0- Couple of incorrect error handling fixed.
> =C2=A0 =C2=A0- One incorrect use of a allocation policy
> =C2=A0 =C2=A0- Some other things
>
> =C2=A0 =C2=A0Still needs more review.
>
> =C2=A0 =C2=A0Found by gcc 4.6's new warnings.
>
> =C2=A0 =C2=A0[akpm@linux-foundation.org: fix build. =C2=A0Might have =
been bitrot]
> =C2=A0 =C2=A0Signed-off-by: Andi Kleen <ak@linux.intel.com>
> =C2=A0 =C2=A0Cc: Chris Mason <chris.mason@oracle.com>
> =C2=A0 =C2=A0Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index e9103b3..f0cad5a 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -427,5 +427,5 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_=
handle *trans,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D btrfs_=
truncate_item(trans, root, path,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0item_len - sub_item_len, 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0}
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 32d0940..fb7effa 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3337,8 +3337,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(s=
truct btrfs_root *root)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_init_block_rsv(block_rsv);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0alloc_target =3D btrfs_get_alloc_profile(r=
oot, 0);
> - =C2=A0 =C2=A0 =C2=A0 block_rsv->space_info =3D __find_space_info(fs=
_info,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BTRFS_BLOCK_GROUP_METADATA);
> + =C2=A0 =C2=A0 =C2=A0 block_rsv->space_info =3D __find_space_info(fs=
_info, alloc_target);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return block_rsv;
> =C2=A0}
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d74e6af..609d67a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2823,6 +2823,8 @@ int extent_prepare_write(struct extent_io_tree =
*tree,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
NULL, 1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
end_bio_extent_preparewrite, 0,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret && !err)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0iocount++;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0block_start =3D block_start + iosize;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c038644..1dc5b96 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1372,7 +1372,7 @@ int btrfs_merge_bio_hook(struct page *page, uns=
igned long offset,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (map_length < length + size)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0}
>
> =C2=A0/*
> @@ -2672,8 +2672,8 @@ static int check_path_shared(struct btrfs_root =
*root,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct extent_buffer *eb;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int level;
> - =C2=A0 =C2=A0 =C2=A0 int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 refs =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 int uninitialized_var(ret);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (level =3D 0; level < BTRFS_MAX_LEVEL;=
 level++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!path->nod=
es[level])
> @@ -2686,7 +2686,7 @@ static int check_path_shared(struct btrfs_root =
*root,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (refs > 1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 return ret; /* XXX callers? */
> =C2=A0}
>
> =C2=A0/*
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index b37d723..5f225fe 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3099,6 +3099,8 @@ static int add_tree_block(struct reloc_control =
*rc,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(item_si=
ze !=3D sizeof(struct btrfs_extent_item_v0));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D get_re=
f_objectid_v0(rc, path, extent_key,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0&ref_owner, NULL);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(ref_own=
er >=3D BTRFS_MAX_LEVEL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0level =3D (int=
)ref_owner;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* FIXME: get =
real generation */
> @@ -4143,7 +4145,7 @@ int btrfs_reloc_clone_csums(struct inode *inode=
, u64 file_pos, u64 len)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_add_orde=
red_sum(inode, ordered, sums);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_put_ordered_extent(ordered);
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0}
>
> =C2=A0void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index fb102a9..224fb5b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2273,7 +2273,7 @@ fail:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_end_log_trans(root);
>
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 return err;
> =C2=A0}
>
> =C2=A0/* see comments for btrfs_del_dir_entries_in_log */
>
>
>
> --
> Itaru Kitayama <kitayama@cl.bb4.ne.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
