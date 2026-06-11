Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15C2F6577
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 05:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781156978; cv=none; b=jOgnNqZCVZlhrpZAdqONOIgV97XfzuDxoz42TMs6vhCTgtq1FL2CL00Wl/YTFppencOl+DSb+lFWXKYJXqrw0TFqCOE9tR/bTRHEz8fIhMISIvttpwK9Jm0aycA4yX0fKqlmXcoNOh+HqRRsXmkl5KUVPPGSQoCvUjc9JTFeSNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781156978; c=relaxed/simple;
	bh=zKYBM94HagXo5cCy0L0dhCfOyIuYfQZ98o+n6qxImgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YKzXuWKj2CMRRE1YfQtPDWQ+9SH8OoaTQScYFU3B/+XFK2b2rc8K+TyPiArR+BeithfSzSVK/BFjqdumPn+XjMBLUtSs5NQpy4NIZ1dI2LoV+UoN/RprXGszzqqy0zRwES5Yws4z+/zEwjepTVEHEOlYELUieazHpZiKqklNNqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Yb1AgNUq; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Yb1AgNUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781156966; x=1781761766; i=quwenruo.btrfs@gmx.com;
	bh=9/SqItAvLExh5xyWTO26uGY9UFXE38n6t0rgBvXxixc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Yb1AgNUqCOyGirKx5LxT9ZP4HnGcEhscegcbmpEzUG3Ao6ITNzGy4wlAYnGjO2Fm
	 lOIh7LJvIKBZRLRrfVXbLJtDLOa6BmiJaDyM2s6BdL4n5PEzehP3s9b0ChQWXZM8J
	 hedqOoGHE/zqb7+vT5wcsk4IrCZX9E5m0K0telZKj5CydZhQMQD2OGyXO981DRoD0
	 D+7cg9UrxSgn0wzW2kqe4nDNHXn1thAB1NsCEg7k3ncFVlKz5eprF9gKCck/1WDYG
	 9S/h/7ZWaZnA20WbCFKKFHxUkM2LAGyIzPurYjUk3/298faBwyc0AGAilgWqEq6UM
	 JMDOiQb12KF8jHuFfg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNKhm-1wqk6m0OjK-00XAoh; Thu, 11
 Jun 2026 07:49:26 +0200
Message-ID: <099e6146-e239-45f0-82b6-4a4c98f265eb@gmx.com>
Date: Thu, 11 Jun 2026 15:19:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free on reloc root after error in
 insert_dirty_subvol()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <910f7fff6c9a588271afa591b1c533d92246ca85.1781021231.git.fdmanana@suse.com>
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
In-Reply-To: <910f7fff6c9a588271afa591b1c533d92246ca85.1781021231.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:02PaSi09vsc+aN3bTKHaOSYjJxn1I44PN0qD4oijMNUQIT0kU97
 kstzwMQvCyudR2vbZIlHSbdkgWImjPiyqtF3zpkUQkwSehad3FN2b4XpkQj6lxXZFCQDUii
 GfzGyxNMdGIKLkUdWF+GhgdbX1oXyri2NK/oakDbYutad7MUKVD78/7Lcx+Di7yG8E3aZVA
 wrHiWGKrpK+/BWEP1HAyA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:V+s4TO6oyv8=;Pg8CZiKcQXWAZWb3WMaTfHsTvo8
 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



=E5=9C=A8 2026/6/10 01:39, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If during relocation we fail in insert_dirty_subvol() because
> btrfs_update_reloc_root() returned an error, we will leave a root's
> reloc_root field pointing to a reloc root that was freed instead of NULL=
,
> resulting later in a use-after-free, or double free attempt during
> unmount.
>=20
> The sequence of steps is this:
>=20
> 1) During relocation thel call to btrfs_update_reloc_root() in
>     insert_dirty_subvol() fails, so insert_dirty_subvol() returns the
>     error without adding root X to the rc->dirty_subvol_roots list;
>=20
> 2) Then merge_reloc_root() aborts the current transaction because
>     insert_dirty_subvol() return an error;
>=20
> 4) Up the call chain, merge_reloc_roots() gets the error, adds the
>     reloc root for root X to the local reloc_roots list and jumps to the
>     'out' label, where it calls free_reloc_roots() to free all the reloc
>     roots in the local reloc_roots list. This free the reloc root for
>     root X;
>=20
> 5) We go up the call chain to relocate_block_group() which calls
>     clean_dirty_subvols() to go over dirty roots and set their
>     ->reloc_root field to NULL, but root X is not in the dirty_subvol_ro=
ots
>     list, so it's ->reloc_root still points to a reloc root;
>=20
> 6) Relocation finishes, with an error and a transaction abort, but the
>     ->reloc_root field for root X still points to the reloc root that wa=
s
>     freed in step 4;
>=20
> 7) When unmounting the fs we end up calling:
>=20
>       btrfs_free_fs_roots()
>          btrfs_drop_and_free_fs_root()
>             --> calls btrfs_put_root() against root X's ->reloc_root
>                 which is not NULL and points to the already freed
>                 reloc root in step 4 above
>=20
>    Resulting in a use-after-free to a double free attempt.
>=20
> Syzbot reported this with the following dmesg/syslog:
>=20
>     [  106.004389][ T5339] BTRFS error (device loop0 state A): Transacti=
on aborted (error -5)
>     [  106.014266][ T5339] BTRFS: error (device loop0 state A) in merge_=
reloc_root:1655: errno=3D-5 IO failure
>     [  106.021891][ T1061] BTRFS error (device loop0 state A): error whi=
le writing out transaction: -5
>     [  106.026964][ T1061] BTRFS warning (device loop0 state A): Skippin=
g commit of aborted transaction.
>     [  106.033807][ T5340] BTRFS error (device loop0 state A): bdev /dev=
/loop0 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
>     [  106.039265][ T1061] BTRFS: error (device loop0 state A) in cleanu=
p_transaction:2067: errno=3D-5 IO failure
>     [  106.044382][ T5339] BTRFS info (device loop0 state EA): forced re=
adonly
>     [  106.074329][ T5339] BTRFS: error (device loop0 state EA) in merge=
_reloc_roots:1887: errno=3D-5 IO failure
>     [  106.081004][ T5356] BTRFS info (device loop0 state EA): scrub: st=
arted on devid 1
>     [  106.085611][ T5339] BTRFS info (device loop0 state EA): balance: =
ended with status: -30
>     [  106.089517][ T5356] BTRFS info (device loop0 state EA): scrub: no=
t finished on devid 1 with status: -30
>     [  106.662365][ T5338] BTRFS info (device loop0 state EA): last unmo=
unt of filesystem 3a375e4e-b156-4d76-a2ad-16e198ce1409
>     [  106.682946][ T5338] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>     [  106.686574][ T5338] BUG: KASAN: slab-use-after-free in btrfs_put_=
root+0x2f/0x250
>     [  106.690090][ T5338] Write of size 4 at addr ffff88803f978630 by t=
ask syz.0.0/5338
>     [  106.693173][ T5338]
>     [  106.694279][ T5338] CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tai=
nted syzkaller #0 PREEMPT(full)
>     [  106.694293][ T5338] Hardware name: QEMU Standard PC (Q35 + ICH9, =
2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     [  106.694300][ T5338] Call Trace:
>     [  106.694308][ T5338]  <TASK>
>     [  106.694314][ T5338]  dump_stack_lvl+0xe8/0x150
>     [  106.694331][ T5338]  print_address_description+0x55/0x1e0
>     [  106.694343][ T5338]  ? btrfs_put_root+0x2f/0x250
>     [  106.694358][ T5338]  print_report+0x58/0x70
>     [  106.694368][ T5338]  kasan_report+0x117/0x150
>     [  106.694384][ T5338]  ? btrfs_put_root+0x2f/0x250
>     [  106.694399][ T5338]  kasan_check_range+0x264/0x2c0
>     [  106.694416][ T5338]  btrfs_put_root+0x2f/0x250
>     [  106.694430][ T5338]  btrfs_drop_and_free_fs_root+0x160/0x210
>     [  106.694447][ T5338]  btrfs_free_fs_roots+0x2f9/0x3c0
>     [  106.694464][ T5338]  ? __pfx_btrfs_free_fs_roots+0x10/0x10
>     [  106.694479][ T5338]  ? free_root_pointers+0x5bf/0x5f0
>     [  106.694494][ T5338]  close_ctree+0x798/0x12d0
>     [  106.694511][ T5338]  ? __pfx_close_ctree+0x10/0x10
>     [  106.694526][ T5338]  ? _raw_spin_unlock_irqrestore+0x74/0x80
>     [  106.694599][ T5338]  ? rcu_preempt_deferred_qs_irqrestore+0x906/0=
xbc0
>     [  106.694620][ T5338]  ? __rcu_read_unlock+0x83/0xe0
>     [  106.694636][ T5338]  ? btrfs_put_super+0x48/0x1c0
>     [  106.694652][ T5338]  ? __pfx_btrfs_put_super+0x10/0x10
>     [  106.694667][ T5338]  generic_shutdown_super+0x13d/0x2d0
>     [  106.694682][ T5338]  kill_anon_super+0x3b/0x70
>     [  106.694695][ T5338]  btrfs_kill_super+0x41/0x50
>     [  106.694710][ T5338]  deactivate_locked_super+0xbc/0x130
>     [  106.694722][ T5338]  cleanup_mnt+0x437/0x4d0
>     [  106.694736][ T5338]  ? _raw_spin_unlock_irq+0x23/0x50
>     [  106.694752][ T5338]  task_work_run+0x1d9/0x270
>     [  106.694769][ T5338]  ? __pfx_task_work_run+0x10/0x10
>     [  106.694784][ T5338]  ? do_raw_spin_unlock+0x4d/0x210
>     [  106.694802][ T5338]  do_exit+0x70f/0x22c0
>     [  106.694817][ T5338]  ? trace_irq_disable+0x3b/0x140
>     [  106.694835][ T5338]  ? __pfx_do_exit+0x10/0x10
>     [  106.694848][ T5338]  ? preempt_schedule_thunk+0x16/0x30
>     [  106.694863][ T5338]  ? preempt_schedule_common+0x82/0xd0
>     [  106.694878][ T5338]  ? preempt_schedule_thunk+0x16/0x30
>     [  106.694892][ T5338]  do_group_exit+0x21b/0x2d0
>     [  106.694906][ T5338]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [  106.694918][ T5338]  __x64_sys_exit_group+0x3f/0x40
>     [  106.694932][ T5338]  x64_sys_call+0x221a/0x2240
>     [  106.694944][ T5338]  do_syscall_64+0x174/0x580
>     [  106.694954][ T5338]  ? clear_bhb_loop+0x40/0x90
>     [  106.694967][ T5338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [  106.694978][ T5338] RIP: 0033:0x7f958ef9ce59
>     [  106.694988][ T5338] Code: Unable to access opcode bytes at 0x7f95=
8ef9ce2f.
>     [  106.694994][ T5338] RSP: 002b:00007fffd4058318 EFLAGS: 00000246 O=
RIG_RAX: 00000000000000e7
>     [  106.695008][ T5338] RAX: ffffffffffffffda RBX: 0000000000000000 R=
CX: 00007f958ef9ce59
>     [  106.695015][ T5338] RDX: 00007f958c3f8000 RSI: 0000000000000000 R=
DI: 0000000000000000
>     [  106.695022][ T5338] RBP: 0000000000000003 R08: 0000000000000000 R=
09: 00007f958f1e73e0
>     [  106.695028][ T5338] R10: 0000000000000000 R11: 0000000000000246 R=
12: 0000000000000000
>     [  106.695034][ T5338] R13: 00007f958f1e73e0 R14: 0000000000000003 R=
15: 00007fffd40583d0
>     [  106.695046][ T5338]  </TASK>
>     [  106.695050][ T5338]
>     [  106.821635][ T5338] Allocated by task 1061:
>     [  106.823446][ T5338]  kasan_save_track+0x3e/0x80
>     [  106.825498][ T5338]  __kasan_kmalloc+0x93/0xb0
>     [  106.827381][ T5338]  __kmalloc_cache_noprof+0x31c/0x660
>     [  106.829525][ T5338]  btrfs_alloc_root+0x75/0x930
>     [  106.831458][ T5338]  read_tree_root_path+0x127/0xb00
>     [  106.833556][ T5338]  btrfs_read_tree_root+0x34/0x60
>     [  106.835553][ T5338]  create_reloc_root+0x6b3/0xcb0
>     [  106.837556][ T5338]  btrfs_init_reloc_root+0x2ec/0x4b0
>     [  106.839557][ T5338]  record_root_in_trans+0x2ab/0x350
>     [  106.841685][ T5338]  btrfs_record_root_in_trans+0x15c/0x180
>     [  106.844237][ T5338]  start_transaction+0x39c/0x1820
>     [  106.846638][ T5338]  btrfs_finish_one_ordered+0x88e/0x2680
>     [  106.849436][ T5338]  btrfs_work_helper+0x37b/0xc20
>     [  106.851549][ T5338]  process_scheduled_works+0xb5d/0x1860
>     [  106.853807][ T5338]  worker_thread+0xa53/0xfc0
>     [  106.855773][ T5338]  kthread+0x389/0x470
>     [  106.857548][ T5338]  ret_from_fork+0x514/0xb70
>     [  106.859493][ T5338]  ret_from_fork_asm+0x1a/0x30
>     [  106.861504][ T5338]
>     [  106.862527][ T5338] Freed by task 5339:
>     [  106.864224][ T5338]  kasan_save_track+0x3e/0x80
>     [  106.866180][ T5338]  kasan_save_free_info+0x46/0x50
>     [  106.868371][ T5338]  __kasan_slab_free+0x5c/0x80
>     [  106.870462][ T5338]  kfree+0x1c5/0x640
>     [  106.872180][ T5338]  __del_reloc_root+0x341/0x3b0
>     [  106.874290][ T5338]  free_reloc_roots+0x5f/0x90
>     [  106.876282][ T5338]  merge_reloc_roots+0x73f/0x8a0
>     [  106.878489][ T5338]  relocate_block_group+0xbcc/0xe70
>     [  106.880742][ T5338]  do_nonremap_reloc+0xa8/0x5b0
>     [  106.882885][ T5338]  btrfs_relocate_block_group+0x7e6/0xc40
>     [  106.885336][ T5338]  btrfs_relocate_chunk+0x115/0x820
>     [  106.887502][ T5338]  __btrfs_balance+0x1db0/0x2ae0
>     [  106.889543][ T5338]  btrfs_balance+0xaf3/0x11b0
>     [  106.891456][ T5338]  btrfs_ioctl_balance+0x3d3/0x610
>     [  106.893672][ T5338]  __se_sys_ioctl+0xfc/0x170
>     [  106.895530][ T5338]  do_syscall_64+0x174/0x580
>     [  106.897518][ T5338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [  106.900101][ T5338]
>     [  106.901123][ T5338] The buggy address belongs to the object at ff=
ff88803f978000
>     [  106.901123][ T5338]  which belongs to the cache kmalloc-4k of siz=
e 4096
>     [  106.906907][ T5338] The buggy address is located 1584 bytes insid=
e of
>     [  106.906907][ T5338]  freed 4096-byte region [ffff88803f978000, ff=
ff88803f979000)
>     [  106.912980][ T5338]
>     [  106.914022][ T5338] The buggy address belongs to the physical pag=
e:
>     [  106.916716][ T5338] page: refcount:0 mapcount:0 mapping:000000000=
0000000 index:0x0 pfn:0x3f978
>     [  106.920390][ T5338] head: order:3 mapcount:0 entire_mapcount:0 nr=
_pages_mapped:0 pincount:0
>     [  106.923834][ T5338] flags: 0x4fff00000000040(head|node=3D1|zone=
=3D1|lastcpupid=3D0x7ff)
>     [  106.927104][ T5338] page_type: f5(slab)
>     [  106.928898][ T5338] raw: 04fff00000000040 ffff88801ac42140 dead00=
0000000122 0000000000000000
>     [  106.932507][ T5338] raw: 0000000000000000 0000000800040004 000000=
00f5000000 0000000000000000
>     [  106.936193][ T5338] head: 04fff00000000040 ffff88801ac42140 dead0=
00000000122 0000000000000000
>     [  106.939856][ T5338] head: 0000000000000000 0000000800040004 00000=
000f5000000 0000000000000000
>     [  106.943601][ T5338] head: 04fff00000000003 fffffffffffffe01 00000=
000ffffffff 00000000ffffffff
>     [  106.947268][ T5338] head: ffffffffffffffff 0000000000000000 00000=
000ffffffff 0000000000000008
>     [  106.950988][ T5338] page dumped because: kasan: bad access detect=
ed
>     [  106.953710][ T5338] page_owner tracks the page as allocated
>     [  106.956198][ T5338] page last allocated via order 3, migratetype =
Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_CO=
MP|__GFP_NOMEMALLOC), pid 24, tgid 24 (kworker/u4:2), ts 105728970387, fre=
e_ts 29540875453
>     [  106.964984][ T5338]  post_alloc_hook+0x22d/0x280
>     [  106.966956][ T5338]  get_page_from_freelist+0x2593/0x2610
>     [  106.969307][ T5338]  __alloc_frozen_pages_noprof+0x18d/0x380
>     [  106.971839][ T5338]  allocate_slab+0x77/0x660
>     [  106.973709][ T5338]  refill_objects+0x339/0x3d0
>     [  106.975696][ T5338]  __pcs_replace_empty_main+0x321/0x720
>     [  106.978136][ T5338]  __kmalloc_node_track_caller_noprof+0x572/0x7=
b0
>     [  106.981009][ T5338]  __alloc_skb+0x2c1/0x7d0
>     [  106.982983][ T5338]  nsim_dev_trap_report_work+0x29a/0xb90
>     [  106.985356][ T5338]  process_scheduled_works+0xb5d/0x1860
>     [  106.987710][ T5338]  worker_thread+0xa53/0xfc0
>     [  106.989847][ T5338]  kthread+0x389/0x470
>     [  106.991727][ T5338]  ret_from_fork+0x514/0xb70
>     [  106.993722][ T5338]  ret_from_fork_asm+0x1a/0x30
>     [  106.995900][ T5338] page last free pid 77 tgid 77 stack trace:
>     [  106.998479][ T5338]  __free_frozen_pages+0xc1c/0xd30
>     [  107.000819][ T5338]  vfree+0x1d1/0x2f0
>     [  107.002631][ T5338]  delayed_vfree_work+0x55/0x80
>     [  107.004848][ T5338]  process_scheduled_works+0xb5d/0x1860
>     [  107.007366][ T5338]  worker_thread+0xa53/0xfc0
>     [  107.009388][ T5338]  kthread+0x389/0x470
>     [  107.011177][ T5338]  ret_from_fork+0x514/0xb70
>     [  107.013313][ T5338]  ret_from_fork_asm+0x1a/0x30
>     [  107.015454][ T5338]
>     [  107.016460][ T5338] Memory state around the buggy address:
>     [  107.019052][ T5338]  ffff88803f978500: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [  107.022691][ T5338]  ffff88803f978580: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [  107.026264][ T5338] >ffff88803f978600: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [  107.029721][ T5338]                                      ^
>     [  107.032062][ T5338]  ffff88803f978680: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [  107.035547][ T5338]  ffff88803f978700: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
>     [  107.038865][ T5338] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
> Reported-by: syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a1ebde9.c1435f33.112120.0176.=
GAE@google.com/
> Fixes: 7934133fae5e ("btrfs: handle btrfs_update_reloc_root failure in i=
nsert_dirty_subvol")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/relocation.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b345c..4e3b3c34cc87 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1509,15 +1509,22 @@ static int insert_dirty_subvol(struct btrfs_tran=
s_handle *trans,
>   	btrfs_set_root_drop_level(reloc_root_item, 0);
>   	btrfs_set_root_refs(reloc_root_item, 0);
>   	ret =3D btrfs_update_reloc_root(trans, root);
> -	if (ret)
> -		return ret;
> -
> +	/*
> +	 * Even if an error happened, add the root to the dirty_subvol_roots
> +	 * list, so that clean_dirty_subvols() will set the root->reloc_root t=
o
> +	 * NULL and merge_reloc_roots() frees the root (with a call to
> +	 * free_reloc_roots()), otherwise we have a use-after-free when
> +	 * btrfs_update_reloc_root() above returns an error, as the root has a
> +	 * ->reloc_root field pointing to a reloc root we already freed and
> +	 * during unmount we will call btrfs_put_root() against this already
> +	 * freed reloc root.
> +	 */

You may want to check this critical review from sashiko:

https://sashiko.dev/#/patchset/910f7fff6c9a588271afa591b1c533d92246ca85.17=
81021231.git.fdmanana%40suse.com

Which said it's going to cause problems as free_reloc_roots() will free=20
the reloc root, but it doesn't reset root->reloc_root to NULL.

Thus later clean_dirty_subvols() will still access root->reloc_root,=20
causing use-after-free again.

Thanks,
Qu
>   	if (list_empty(&root->reloc_dirty_list)) {
>   		btrfs_grab_root(root);
>   		list_add_tail(&root->reloc_dirty_list, &rc->dirty_subvol_roots);
>   	}
>  =20
> -	return 0;
> +	return ret;
>   }
>  =20
>   static int clean_dirty_subvols(struct reloc_control *rc)

