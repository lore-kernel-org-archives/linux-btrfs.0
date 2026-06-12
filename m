Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C132D2394
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781223953; cv=none; b=LUNucyD+hsDe23P8dc5kW8EC4mPhOkYtfZbfdVEQM8T82im2b7skbNy+77jQaxXVyF31Nes8tGIOdEC7/8lxC1R7UorOQkZGqi+RS2z77IF/2bODVwtZXTLMIB02uhWKJ9XqTgjlVZ7Fhd4fMi4ZwJwGMqGFmx8MtRPSIO+C3qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781223953; c=relaxed/simple;
	bh=Q1LPUe8o5PJoCWvfB/wq/td3Mmt4KABm6XdR0p9mwQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WU7qP0+M75NZUKuxAtM8te2nsag90HVfjFcfRQN/0zNqJZm64WTbRf7vCDXeytnpQO5wfkQl427+vOhZF7o71EAR+5luDydHT3la3dWOD2DOcljUJfjBsMDZ8XEJlY5/hvanUT0WncJSJNJsdZ3IS37ZjJQfggI5zWoIp8zO+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=V9Yc+62i; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="V9Yc+62i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781223949; x=1781828749; i=quwenruo.btrfs@gmx.com;
	bh=rd+AkVvXTa89Yxx+qwLp5TalJ6CiT3ILMXCi7eLhspE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=V9Yc+62i4DL3oyXcko6rVsaUHGH4VMKTFTsNIcTnVvqoAl4mcADcf99nrCZoeTTY
	 6gYWZtsvMgQo3NIgQPsCKboQPv1C151KnJsyz+aSwVntH6Y0mXbh5e9YhysP3v7ar
	 SWGRCJOC2Knt7KwrzYnkPGfde6ft2rLFCTFDegNhrHu3AU4eckIfBZNGGo3INVI7j
	 muBQEQulkQsTiCVOUOV6XCePaRY3itCQFcb3sF/u0tj2YgVZhXPRJ8j+Q4+WwmTbQ
	 /vIH+ywWGWq/veH28LKvR2NW9QvOjTxNxUF7vKxwal/TdVsqF1K9JjTFZqcpUG1lu
	 O7HynKxhrTpT5JH7bQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVeI8-1whhdf3hzA-00JQ4H; Fri, 12
 Jun 2026 02:25:49 +0200
Message-ID: <52541564-4cdb-4c4a-84ac-8e47258fdf63@gmx.com>
Date: Fri, 12 Jun 2026 09:55:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] btrfs: fix use-after-free on reloc root after error in
 insert_dirty_subvol()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <910f7fff6c9a588271afa591b1c533d92246ca85.1781021231.git.fdmanana@suse.com>
 <cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana@suse.com>
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
In-Reply-To: <cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FNBdyj3q11lPemC3gZGpuUhHoyPuDT7jvajxe3liMQGMHL6lVLf
 mQHQhZFZvimiTDkTuxbtvZQUG7Og+nTavSUdSu8wmiDkW/jSEHsSgpLA2GSQvQuskZSCwKp
 RQMDfq29TQUgnvuYu+jed1tUPbDB0HWX8JOZgWZ5NPh9D+x1NOvjCKlVvp6imy168Kl/WIp
 DHYEqvlb/h8ZGLoUbfQnA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xZ/AxNpSiCs=;NulLT1lKnVHvJcMMuk3vERA1l7e
 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
 DLhVvzmpbctHH4xR70=



=E5=9C=A8 2026/6/12 01:50, fdmanana@kernel.org =E5=86=99=E9=81=93:
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
> 1) During relocation the call to btrfs_update_reloc_root() in
>     insert_dirty_subvol() fails, so insert_dirty_subvol() returns the
>     error to merge_reloc_root() without adding the root to the list
>     rc->dirty_subvol_roots;
>=20
> 2) Then merge_reloc_root() aborts the current transaction because
>     insert_dirty_subvol() returned an error;
>=20
> 3) Up the call chain, merge_reloc_roots() gets the error, adds the
>     reloc root for root X to the local reloc_roots list and jumps to the
>     'out' label, where it calls free_reloc_roots() to free all the reloc
>     roots in the local reloc_roots list. This frees the reloc root for
>     root X;
>=20
> 4) We go up the call chain to relocate_block_group() which calls
>     clean_dirty_subvols() to go over dirty roots and set their
>     ->reloc_root field to NULL, but root X is not in the dirty_subvol_ro=
ots
>     list, so its ->reloc_root still points to a reloc root;
>=20
> 5) Relocation finishes, with an error and a transaction abort, but the
>     ->reloc_root field for root X still points to the reloc root that wa=
s
>     freed in step 3;
>=20
> 6) When unmounting the fs we end up calling:
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
> Fix this by resetting a root's ->reloc_root if we get an error while
> trying to merge a reloc root.
>=20
> Reported-by: syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a1ebde9.c1435f33.112120.0176.=
GAE@google.com/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V5: Update the ref tracking for the reloc root after error from
>      merge_reloc_root(), sashiko was still pointing out issues with
>      this (and was correct about it).
>=20
> V4: Update comment to avoid confusing sashiko.
>=20
> V3: Clear reloc root before putting the root, detected by sashiko.
>=20
> V2: Change the approach since it could possibly still lead to a
>      use-after-free just in an different way (detected by sashiko).
>=20
>   fs/btrfs/relocation.c | 42 +++++++++++++++++++++++++++++++++---------
>   1 file changed, 33 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 9447d009a9a0..74687c75f763 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1520,6 +1520,17 @@ static int insert_dirty_subvol(struct btrfs_trans=
_handle *trans,
>   	return 0;
>   }
>  =20
> +static void clear_reloc_root(struct btrfs_root *root)
> +{
> +	root->reloc_root =3D NULL;
> +	/*
> +	 * Need barrier to ensure clear_bit() only happens after
> +	 * root->reloc_root =3D NULL. Pairs with have_reloc_root().
> +	 */
> +	smp_wmb();
> +	clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
> +}
> +
>   static int clean_dirty_subvols(struct reloc_control *rc)
>   {
>   	struct btrfs_root *root;
> @@ -1534,13 +1545,7 @@ static int clean_dirty_subvols(struct reloc_contr=
ol *rc)
>   			struct btrfs_root *reloc_root =3D root->reloc_root;
>  =20
>   			list_del_init(&root->reloc_dirty_list);
> -			root->reloc_root =3D NULL;
> -			/*
> -			 * Need barrier to ensure clear_bit() only happens after
> -			 * root->reloc_root =3D NULL. Pairs with have_reloc_root.
> -			 */
> -			smp_wmb();
> -			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
> +			clear_reloc_root(root);
>   			if (reloc_root) {
>   				/*
>   				 * btrfs_drop_snapshot drops our ref we hold for
> @@ -1916,13 +1921,32 @@ void merge_reloc_roots(struct reloc_control *rc)
>   				goto out;
>   			}
>   			ret =3D merge_reloc_root(rc, root);
> -			btrfs_put_root(root);
>   			if (ret) {
> -				if (list_empty(&reloc_root->root_list))
> +				/*
> +				 * Clear the reloc root since below we will call
> +				 * free_reloc_roots(), otherwise we leave
> +				 * root->reloc_root pointing to a freed reloc
> +				 * root and trigger a use-after-free during
> +				 * unmount or elsewhere.
> +				 */
> +				clear_reloc_root(root);
> +				btrfs_put_root(root);
> +				/*
> +				 * We are adding the reloc_root to the local
> +				 * reloc_roots list, so we add a ref for this
> +				 * list which will be dropped below by the call
> +				 * to free_reloc_roots().
> +				 */
> +				if (list_empty(&reloc_root->root_list)) {
>   					list_add_tail(&reloc_root->root_list,
>   						      &reloc_roots);
> +					btrfs_grab_root(reloc_root);
> +				}
> +				/* Now drop the ref for root->reloc_root. */
> +				btrfs_put_root(reloc_root);
>   				goto out;
>   			}
> +			btrfs_put_root(root);
>   		} else {
>   			if (!IS_ERR(root)) {
>   				if (root->reloc_root =3D=3D reloc_root) {

