Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445BF36C9F0
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780699918; cv=none; b=oIMvrnUazDcvUr0MeAPg16O3fro9gEni3KcIMme80kYZ2zJX7wxClL5ItMwS+dFi7OpqOG+qwkInUXffEcYk5m89r0+adBGEmpbndycMEAC7UiOCPW7ojAMGh5XvlMfeMuxgtyd2eszfOfjIQUVoSdFJCG26pr6PxVp0ksaCu18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780699918; c=relaxed/simple;
	bh=hIfF75hxlLq0hTMiFrHdl6KsFwH1DC633cj5NB6J8eE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j3ig9H+8OdgRTRJddvPcoQi4hUq8YRHLwF1eIMCHbtC3p0TsH2dH32tAfguk1VXVWELwFfy1p68OAhQnAIOdfp2PBvNxIv+u0CQOXSSssA03YXwuriNtsYoGQzClDJnGy0nE/1b1RhbJ+TvVXh+pNIxgZolJhrz5PR/dInPBxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=CMHZiH66; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="CMHZiH66"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780699913; x=1781304713; i=quwenruo.btrfs@gmx.com;
	bh=VLKZ1e46BvyphvV4CNfKunSf+Xi0Z3TqJ0Bd+vDYqLQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=CMHZiH66FnXK/ZSaYqVgCtQuFnsluBq83FUWy82YLjpm57l2bZX9FkNYMM2sReAo
	 ugawAOPMru91bCKx1tWTU8C7uIY2QOyA+heBgBo1UeRMk9uxQ+zt9QrpgSd3I8DKN
	 lgzuoKw0qghH0H/rV6lUdlpbyeC6XjzkkuykjfwVcoC3SpM0/otRDb2UQmz038yOM
	 OAtAlpqIy43s/9F1pI3vK2QDOj0G81X+gar7klqriJODMHDV0mYvchqdBQiZSJgYr
	 b+tb4sdInMjxUatmGqvSXD1i/7HuAeYoF3ONNdlpk4GuLnO/Jdja8j5Xiqmh3jMOj
	 OLq/dZUY8DhjSAHWew==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N8XPt-1xHqH32zrt-00totp; Sat, 06
 Jun 2026 00:51:53 +0200
Message-ID: <c8508e84-8525-402c-aa57-e4e15df712bf@gmx.com>
Date: Sat, 6 Jun 2026 08:21:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free after relocation failure with
 concurrent COW
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3d57517e6e8ace7f1294277b0f03baa1150be55c.1780677297.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <3d57517e6e8ace7f1294277b0f03baa1150be55c.1780677297.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Eh5iM4yPwOjnN/8YagigPCWOwpUy1N1PIAUKs2McuWLLekuxJ/r
 +U4GcB+EBNMH+D3ySU+ndYz0wNfsFq+WZdkSAdP0lJhUkUdDh062w2b0rcXQrAbn8kpkB3U
 ZzC4Gn3LH1hhqAl275744iVzkchcg6qIxEMl60DQOf6Tkcg+jXbUkn3UjObyE9iLlvmn1d6
 FN0SbHqAQVVFr01Hi8imw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hLJh8x3ubbo=;5Lp/txixheNCiHWeDWldhgJ8WqT
 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



=E5=9C=A8 2026/6/6 02:08, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we get a failure during relocation, before we update all the extent
> buffers that have file extent items pointing to extents from the block
> group being relocated, we can trigger a user-after-free on the reloc
> control structure (fs_info->reloc_control) if we have a concurrent task
> that is COWing a subvolume leaf.
>=20
> This happens like this:
>=20
> 1) Relocation of data block group X starts;
>=20
> 2) Relocation changes its state to UPDATE_DATA_PTRS;
>=20
> 3) A task doing a rename for example, COWs leaf A from a subvolume tree
>     and ends up at btrfs_reloc_cow_block() and extracts fs_info->reloc_c=
tl
>     into a local variable, which then passes to replace_file_extents();
>=20
> 4) The relocation task gets an error and under the label 'out_put_bg' in
>     btrfs_relocate_block_group() calls free_reloc_control(), which frees
>     the reloc control structure that the rename task is using;
>=20
> 5) The rename task triggers a use-after-free on the reloc control
>     structure that was just freed.
>=20
> Syzbot reported this recently, with the following stack trace:
>=20
>     [   88.389822][ T5325] BTRFS error (device loop0 state A): Transacti=
on aborted (error -5)
>     [   88.389842][ T5325] BTRFS: error (device loop0 state A) in cleanu=
p_transaction:2067: errno=3D-5 IO failure
>     [   88.389864][ T5325] BTRFS info (device loop0 state EA): forced re=
adonly
>     [   88.392277][ T5324] BTRFS: error (device loop0 state EA) in btrfs=
_sync_log:3572: errno=3D-5 IO failure
>     [   88.396630][ T5325] BTRFS info (device loop0 state EA): balance: =
ended with status: -5
>     [   88.400135][ T5346] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>     [   88.400148][ T5346] BUG: KASAN: slab-use-after-free in replace_fi=
le_extents+0x85f/0x1590
>     [   88.400288][ T5346] Read of size 8 at addr ffff888012312010 by ta=
sk syz.0.0/5346
>     [   88.400299][ T5346]
>     [   88.400306][ T5346] CPU: 0 UID: 0 PID: 5346 Comm: syz.0.0 Not tai=
nted syzkaller #0 PREEMPT(full)
>     [   88.400319][ T5346] Hardware name: QEMU Standard PC (Q35 + ICH9, =
2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     [   88.400325][ T5346] Call Trace:
>     [   88.400331][ T5346]  <TASK>
>     [   88.400336][ T5346]  dump_stack_lvl+0xe8/0x150
>     [   88.400351][ T5346]  print_address_description+0x55/0x1e0
>     [   88.400364][ T5346]  ? replace_file_extents+0x85f/0x1590
>     [   88.400378][ T5346]  print_report+0x58/0x70
>     [   88.400389][ T5346]  kasan_report+0x117/0x150
>     [   88.400405][ T5346]  ? replace_file_extents+0x85f/0x1590
>     [   88.400420][ T5346]  replace_file_extents+0x85f/0x1590
>     [   88.400440][ T5346]  ? __pfx_replace_file_extents+0x10/0x10
>     [   88.400452][ T5346]  ? update_ref_for_cow+0xa71/0x1270
>     [   88.400473][ T5346]  btrfs_force_cow_block+0xa4d/0x2450
>     [   88.400492][ T5346]  ? __pfx_btrfs_force_cow_block+0x10/0x10
>     [   88.400508][ T5346]  ? __pfx_btrfs_get_32+0x10/0x10
>     [   88.400523][ T5346]  btrfs_cow_block+0x3c4/0xa90
>     [   88.400542][ T5346]  push_leaf_left+0x2ac/0x4a0
>     [   88.400561][ T5346]  split_leaf+0xd16/0x12e0
>     [   88.400574][ T5346]  ? btrfs_bin_search+0x924/0xc70
>     [   88.400592][ T5346]  ? __pfx_split_leaf+0x10/0x10
>     [   88.400602][ T5346]  ? leaf_space_used+0x177/0x1e0
>     [   88.400618][ T5346]  ? btrfs_leaf_free_space+0x14a/0x2f0
>     [   88.400634][ T5346]  btrfs_search_slot+0x2641/0x2d20
>     [   88.400654][ T5346]  ? __pfx_btrfs_search_slot+0x10/0x10
>     [   88.400669][ T5346]  ? rcu_is_watching+0x15/0xb0
>     [   88.400681][ T5346]  ? trace_kmem_cache_alloc+0x29/0xe0
>     [   88.400694][ T5346]  btrfs_insert_empty_items+0x9c/0x190
>     [   88.400711][ T5346]  btrfs_insert_inode_ref+0x229/0xcb0
>     [   88.400724][ T5346]  ? __pfx_btrfs_insert_inode_ref+0x10/0x10
>     [   88.400736][ T5346]  ? __pfx_btrfs_qgroup_convert_reserved_meta+0=
x10/0x10
>     [   88.400751][ T5346]  ? btrfs_record_root_in_trans+0x124/0x180
>     [   88.400767][ T5346]  ? start_transaction+0x8a0/0x1820
>     [   88.400778][ T5346]  ? btrfs_set_inode_index+0x5e/0x100
>     [   88.400787][ T5346]  btrfs_rename2+0x17bb/0x40d0
>     [   88.400800][ T5346]  ? check_noncircular+0xda/0x150
>     [   88.400814][ T5346]  ? add_lock_to_list+0xc7/0x100
>     [   88.400828][ T5346]  ? __pfx_btrfs_rename2+0x10/0x10
>     [   88.400842][ T5346]  ? lockdep_hardirqs_on+0x7a/0x110
>     [   88.400901][ T5346]  ? lock_acquire+0x221/0x350
>     [   88.400915][ T5346]  ? down_write_nested+0x174/0x210
>     [   88.400931][ T5346]  ? __pfx_down_write_nested+0x10/0x10
>     [   88.400941][ T5346]  ? do_raw_spin_unlock+0x4d/0x210
>     [   88.400952][ T5346]  ? try_break_deleg+0x5b/0x180
>     [   88.400963][ T5346]  ? __pfx_btrfs_rename2+0x10/0x10
>     [   88.400973][ T5346]  vfs_rename+0xa96/0xeb0
>     [   88.400992][ T5346]  ? __pfx_vfs_rename+0x10/0x10
>     [   88.401010][ T5346]  ovl_fill_super+0x46b7/0x5e20
>     [   88.401030][ T5346]  ? __pfx_ovl_fill_super+0x10/0x10
>     [   88.401042][ T5346]  ? xas_create+0x1902/0x1b90
>     [   88.401060][ T5346]  ? __pfx___mutex_trylock_common+0x10/0x10
>     [   88.401076][ T5346]  ? trace_contention_end+0x3d/0x140
>     [   88.401094][ T5346]  ? shrinker_register+0x124/0x230
>     [   88.401111][ T5346]  ? __mutex_unlock_slowpath+0x1be/0x6f0
>     [   88.401127][ T5346]  ? shrinker_register+0x61/0x230
>     [   88.401143][ T5346]  ? __pfx___mutex_lock+0x10/0x10
>     [   88.401158][ T5346]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
>     [   88.401177][ T5346]  ? __raw_spin_lock_init+0x45/0x100
>     [   88.401196][ T5346]  ? sget_fc+0x962/0xa40
>     [   88.401208][ T5346]  ? __pfx_set_anon_super_fc+0x10/0x10
>     [   88.401222][ T5346]  ? __pfx_ovl_fill_super+0x10/0x10
>     [   88.401241][ T5346]  get_tree_nodev+0xbb/0x150
>     [   88.401257][ T5346]  vfs_get_tree+0x92/0x2a0
>     [   88.401272][ T5346]  do_new_mount+0x341/0xd30
>     [   88.401283][ T5346]  ? apparmor_capable+0x126/0x170
>     [   88.401301][ T5346]  ? __pfx_do_new_mount+0x10/0x10
>     [   88.401311][ T5346]  ? ns_capable+0x89/0xe0
>     [   88.401322][ T5346]  ? path_mount+0x690/0x10e0
>     [   88.401333][ T5346]  ? user_path_at+0xd4/0x160
>     [   88.401346][ T5346]  __se_sys_mount+0x31d/0x420
>     [   88.401358][ T5346]  ? __pfx___se_sys_mount+0x10/0x10
>     [   88.401370][ T5346]  ? __x64_sys_mount+0x20/0xc0
>     [   88.401381][ T5346]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401391][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401403][ T5346]  ? trace_irq_disable+0x3b/0x140
>     [   88.401413][ T5346]  ? clear_bhb_loop+0x40/0x90
>     [   88.401421][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401429][ T5346] RIP: 0033:0x7fa1ff79ce59
>     [   88.401436][ T5346] Code: ff c3 66 (...)
>     [   88.401443][ T5346] RSP: 002b:00007fa2005affe8 EFLAGS: 00000246 O=
RIG_RAX: 00000000000000a5
>     [   88.401456][ T5346] RAX: ffffffffffffffda RBX: 00007fa1ffa16180 R=
CX: 00007fa1ff79ce59
>     [   88.401464][ T5346] RDX: 0000200000000100 RSI: 0000200000002240 R=
DI: 0000000000000000
>     [   88.401474][ T5346] RBP: 00007fa1ff832d6f R08: 0000200000000440 R=
09: 0000000000000000
>     [   88.401481][ T5346] R10: 0000000000000000 R11: 0000000000000246 R=
12: 0000000000000000
>     [   88.401488][ T5346] R13: 00007fa1ffa16218 R14: 00007fa1ffa16180 R=
15: 00007ffc734fba78
>     [   88.401500][ T5346]  </TASK>
>     [   88.401506][ T5346]
>     [   88.401510][ T5346] Allocated by task 5325:
>     [   88.401516][ T5346]  kasan_save_track+0x3e/0x80
>     [   88.401529][ T5346]  __kasan_kmalloc+0x93/0xb0
>     [   88.401542][ T5346]  __kmalloc_cache_noprof+0x31c/0x660
>     [   88.401554][ T5346]  btrfs_relocate_block_group+0x217/0xc40
>     [   88.401568][ T5346]  btrfs_relocate_chunk+0x115/0x820
>     [   88.401577][ T5346]  __btrfs_balance+0x1db0/0x2ae0
>     [   88.401587][ T5346]  btrfs_balance+0xaf3/0x11b0
>     [   88.401596][ T5346]  btrfs_ioctl_balance+0x3d3/0x610
>     [   88.401612][ T5346]  __se_sys_ioctl+0xfc/0x170
>     [   88.401626][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401640][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401650][ T5346]
>     [   88.401653][ T5346] Freed by task 5325:
>     [   88.401659][ T5346]  kasan_save_track+0x3e/0x80
>     [   88.401671][ T5346]  kasan_save_free_info+0x46/0x50
>     [   88.401680][ T5346]  __kasan_slab_free+0x5c/0x80
>     [   88.401692][ T5346]  kfree+0x1c5/0x640
>     [   88.401703][ T5346]  btrfs_relocate_block_group+0x95d/0xc40
>     [   88.401715][ T5346]  btrfs_relocate_chunk+0x115/0x820
>     [   88.401724][ T5346]  __btrfs_balance+0x1db0/0x2ae0
>     [   88.401733][ T5346]  btrfs_balance+0xaf3/0x11b0
>     [   88.401742][ T5346]  btrfs_ioctl_balance+0x3d3/0x610
>     [   88.401757][ T5346]  __se_sys_ioctl+0xfc/0x170
>     [   88.401770][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401785][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401795][ T5346]
>     [   88.401798][ T5346] The buggy address belongs to the object at ff=
ff888012312000
>     [   88.401798][ T5346]  which belongs to the cache kmalloc-2k of siz=
e 2048
>     [   88.401807][ T5346] The buggy address is located 16 bytes inside =
of
>     [   88.401807][ T5346]  freed 2048-byte region [ffff888012312000, ff=
ff888012312800)
>     [   88.401819][ T5346]
>     [   88.401822][ T5346] The buggy address belongs to the physical pag=
e:
>     [   88.401829][ T5346] page: refcount:0 mapcount:0 mapping:000000000=
0000000 index:0x0 pfn:0x12310
>     [   88.401840][ T5346] head: order:3 mapcount:0 entire_mapcount:0 nr=
_pages_mapped:0 pincount:0
>     [   88.401849][ T5346] flags: 0xfff00000000040(head|node=3D0|zone=3D=
1|lastcpupid=3D0x7ff)
>     [   88.401860][ T5346] page_type: f5(slab)
>     [   88.401871][ T5346] raw: 00fff00000000040 ffff88801ac42000 dead00=
0000000100 dead000000000122
>     [   88.401881][ T5346] raw: 0000000000000000 0000000800080008 000000=
00f5000000 0000000000000000
>     [   88.401892][ T5346] head: 00fff00000000040 ffff88801ac42000 dead0=
00000000100 dead000000000122
>     [   88.401902][ T5346] head: 0000000000000000 0000000800080008 00000=
000f5000000 0000000000000000
>     [   88.401913][ T5346] head: 00fff00000000003 fffffffffffffe01 00000=
000ffffffff 00000000ffffffff
>     [   88.401923][ T5346] head: ffffffffffffffff 0000000000000000 00000=
000ffffffff 0000000000000008
>     [   88.401929][ T5346] page dumped because: kasan: bad access detect=
ed
>     [   88.401935][ T5346] page_owner tracks the page as allocated
>     [   88.401941][ T5346] page last allocated via order 3, migratetype =
Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|_=
_GFP_COMP|__GFP_NOMEMALLOC), pid 9, tgid 9 (kworker/0:0), ts 83905464494, =
free_ts 83674944822
>     [   88.401961][ T5346]  post_alloc_hook+0x231/0x280
>     [   88.401975][ T5346]  get_page_from_freelist+0x24ba/0x2540
>     [   88.401990][ T5346]  __alloc_frozen_pages_noprof+0x18d/0x380
>     [   88.402004][ T5346]  allocate_slab+0x77/0x660
>     [   88.402019][ T5346]  refill_objects+0x339/0x3d0
>     [   88.402033][ T5346]  __pcs_replace_empty_main+0x321/0x720
>     [   88.402043][ T5346]  __kmalloc_node_track_caller_noprof+0x572/0x7=
b0
>     [   88.402055][ T5346]  __alloc_skb+0x2c1/0x7d0
>     [   88.402067][ T5346]  mld_newpack+0x14c/0xc90
>     [   88.402080][ T5346]  add_grhead+0x5a/0x2a0
>     [   88.402093][ T5346]  add_grec+0x1452/0x1740
>     [   88.402105][ T5346]  mld_ifc_work+0x6e6/0xe70
>     [   88.402116][ T5346]  process_scheduled_works+0xb5d/0x1860
>     [   88.402127][ T5346]  worker_thread+0xa53/0xfc0
>     [   88.402138][ T5346]  kthread+0x389/0x470
>     [   88.402150][ T5346]  ret_from_fork+0x514/0xb70
>     [   88.402161][ T5346] page last free pid 5282 tgid 5282 stack trace=
:
>     [   88.402168][ T5346]  __free_frozen_pages+0xbc7/0xd30
>     [   88.402180][ T5346]  __slab_free+0x274/0x2c0
>     [   88.402191][ T5346]  qlist_free_all+0x99/0x100
>     [   88.402201][ T5346]  kasan_quarantine_reduce+0x148/0x160
>     [   88.402211][ T5346]  __kasan_slab_alloc+0x22/0x80
>     [   88.402221][ T5346]  __kmalloc_cache_noprof+0x2ba/0x660
>     [   88.402231][ T5346]  kernfs_fop_open+0x3f0/0xda0
>     [   88.402253][ T5346]  do_dentry_open+0x785/0x14e0
>     [   88.402262][ T5346]  vfs_open+0x3b/0x340
>     [   88.402270][ T5346]  path_openat+0x2e08/0x3860
>     [   88.402281][ T5346]  do_file_open+0x23e/0x4a0
>     [   88.402292][ T5346]  do_sys_openat2+0x113/0x200
>     [   88.402300][ T5346]  __x64_sys_openat+0x138/0x170
>     [   88.402309][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.402326][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.402336][ T5346]
>     [   88.402339][ T5346] Memory state around the buggy address:
>     [   88.402345][ T5346]  ffff888012311f00: fc fc fc fc fc fc fc fc fc=
 fc fc fc fc fc fc fc
>     [   88.402352][ T5346]  ffff888012311f80: fc fc fc fc fc fc fc fc fc=
 fc fc fc fc fc fc fc
>     [   88.402359][ T5346] >ffff888012312000: fa fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [   88.402365][ T5346]                          ^
>     [   88.402370][ T5346]  ffff888012312080: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [   88.402380][ T5346]  ffff888012312100: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [   88.402385][ T5346] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
> Fix this by:
>=20
> 1) Making the reloc control structure ref counted;
>=20
> 2) Make revery place that access fs_info->reloc_ctl outside the relocati=
on
>     code, which at the moment it's only replace_file_extents() and
>     btrfs_init_reloc_root(), get a reference count on the structure;
>=20
> 3) Add a spinlock to protect fs_info->reloc_ctl, since we can not take t=
he
>     fs_info->reloc_mutex as that would cause a deadlock since that lock =
is
>     taken in the transaction commit path. That spinlock is taken before
>     setting fs_info->reloc_ctl to an allocated structure, setting it to
>     NULL and reading fs_info->reloc_ctl;
>=20
> 4) Make sure the structure is freed only when its reference count drops =
to
>     zero.
>=20
> Reported-by: syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a1df323.bb0696ed.125a22.000a.=
GAE@google.com/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/disk-io.c    |   1 +
>   fs/btrfs/fs.h         |   2 +
>   fs/btrfs/relocation.c | 230 +++++++++++++++++++++++++-----------------
>   3 files changed, 139 insertions(+), 94 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 97f99f830795..0a7d80da9c94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2796,6 +2796,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_i=
nfo)
>   	mutex_init(&fs_info->unused_bg_unpin_mutex);
>   	mutex_init(&fs_info->reclaim_bgs_lock);
>   	mutex_init(&fs_info->reloc_mutex);
> +	spin_lock_init(&fs_info->reloc_ctl_lock);
>   	mutex_init(&fs_info->delalloc_root_mutex);
>   	mutex_init(&fs_info->zoned_meta_io_lock);
>   	mutex_init(&fs_info->zoned_data_reloc_io_lock);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index da87292420fa..5f0cfb0b5466 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -657,6 +657,8 @@ struct btrfs_fs_info {
>   	 * to protect us from the relocation code.
>   	 */
>   	struct mutex reloc_mutex;
> +	/* Protects setting, clearing and getting fs_info->reloc_ctl. */
> +	spinlock_t reloc_ctl_lock;
>  =20
>   	struct list_head trans_list;
>   	struct list_head dead_roots;
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 80aac9fcd627..1af5d0d67af3 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -178,8 +178,92 @@ struct reloc_control {
>   	bool create_reloc_tree;
>   	bool merge_reloc_tree;
>   	bool found_file_extent;
> +
> +	refcount_t refs;
>   };
>  =20
> +static struct reloc_control *get_reloc_control(struct btrfs_fs_info *fs=
_info)
> +{
> +	struct reloc_control *rc;
> +
> +	/* Quick path, avoid lock contention on fs_info->reloc_ctl_lock. */
> +	if (!data_race(fs_info->reloc_ctl))
> +		return NULL;

Do we really need this quick path?

The critical section is pretty small thus I'm not sure if the quick path=
=20
is going to change anything, but just for the sake of consistency I'd=20
prefer to have spinlock protect reloc_ctl fully.

> +
> +	spin_lock(&fs_info->reloc_ctl_lock);
> +	rc =3D fs_info->reloc_ctl;
> +	if (rc)
> +		refcount_inc(&rc->refs);
> +	spin_unlock(&fs_info->reloc_ctl_lock);
> +
> +	return rc;
> +}
> +
> +/* Helper to delete the 'address of tree root -> reloc tree' mapping. *=
/
> +static void __del_reloc_root(struct btrfs_root *root)
> +{
> +	struct btrfs_fs_info *fs_info =3D root->fs_info;
> +	struct rb_node *rb_node;
> +	struct mapping_node AUTO_KFREE(node);
> +	struct reloc_control *rc =3D fs_info->reloc_ctl;

Sashiko is giving this a critical level review.
Maybe you want to take it a look:

https://sashiko.dev/#/patchset/3d57517e6e8ace7f1294277b0f03baa1150be55c.17=
80677297.git.fdmanana%40suse.com

Personally speaking, I think this is a little strange, all other=20
reloc_ctl users are using reloc_ctl in a refcounted way, but not here.

Thanks,
Qu

