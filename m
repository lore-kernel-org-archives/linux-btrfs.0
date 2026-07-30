Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64E449B24
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425109; cv=none; b=u+rKDbCIweUt0pojK0eJK+1nOWeNxbDulV87kxGsk9UBcl/lYrZTaX2nxDR44Kwd6ygoJyN5Iw3ja/Ywy4r3y7+vMhxNqJtpejTA0fqdz/W8ZSovtmv54SniRZc+6T8/+7fyhuDuqy7o7XTXV8EOo71YniUByiJTacMDWxo4+Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425109; c=relaxed/simple;
	bh=Wspd1I6TFu7EYBAJNtuxhq4HoSeEaukYJ6wwTOr4/xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDvyu3APK9A2TbBxHwPEGiH3PD+AUz12MWXdHYtAse49/+vHadEsqK/fRoxIS25X73Swgov6Z96qawtaBbOQjnxZFGrpcW5q0dke+HYs9/Qp1IQHrL5GwW+WdBxycsuZB1f3gG5PajwzKTSAfs7txU3uvasOafE3H2XSqsba3x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXkE3hpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXkE3hpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF631F00A3E
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785425107;
	bh=O5jq4G4f9lrCdrhTLdNxutNqs40X5/eWG7gHe8yPsQk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JXkE3hpx2deYOoJI6bapEIxUWTqfq3GOYB30ddXmJcH/SdvTQANyEFgqeILgb0QVA
	 aXqgafZ/s/gWl+MlbZgNwNJgtppInVHU14z/sjLyT60Z58SoJck8dEvbjsB1xKXiTF
	 24JuuSpAc1sfMfHgTI8XmNOZ+606kg23zgZE4IxP/ksJWCbhc6IcF0Ay5BiJa7X7IN
	 Yj78/fP6XxKSExU8M27yZdPKnYZ3taJxI1FQQiFsq4q7CumjhQKaIqHNvqQ0IRhKvD
	 YEVHaiB3jqS+wYPS/nVOGP80EQTQDwXZXIk0xDXD33fMqVw5zKwU0W6IHZG4M45vfs
	 20R7GoSpWdo+g==
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9696369925aso739442241.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 08:25:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqMhl/S5txGXKVPy0jMRSCXc/SD7nY4r0Nw85GTdzyafeTB9qCoLvHxJhWHRMh0jn5zsadpTbUBXcep0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCVzvQ0QVMs+aU+mvIMeuxNdoaIplP6M1JD9k4x6VOsj3AFAU1
	TVvNhw5IAGn4Tt2dAE0QmFqvgrqb92HiFOpje7Nb2uj5JZbMmaaAVHwjbZRAuIXudPZKeHZwH1U
	89T6YnMbvz67sqZGv55GsR24SQeEaBH4=
X-Received: by 2002:a05:6102:f0e:b0:71e:1c56:e78e with SMTP id
 ada2fe7eead31-758429afe41mr189956137.17.1785425106858; Thu, 30 Jul 2026
 08:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com>
 <202607301616.c4685aab-lkp@intel.com>
In-Reply-To: <202607301616.c4685aab-lkp@intel.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 30 Jul 2026 16:24:30 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6=kW73FYPV866Pk5EPJ5paVcH_pmkYU5DcuqBPqa3DqA@mail.gmail.com>
X-Gm-Features: AUfX_mxq3OfzCJbM_32O4AdB1Z9i5ROAsrEg8pf2uanHvrVaGGeXCWaNRo2kYMQ
Message-ID: <CAL3q7H6=kW73FYPV866Pk5EPJ5paVcH_pmkYU5DcuqBPqa3DqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()
To: kernel test robot <oliver.sang@intel.com>
Cc: "fdmanana@kernel.orgFilipe Manana" <fdmanana@suse.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-btrfs@vger.kernel.org, ltp@lists.linux.it
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 3:10=E2=80=AFPM kernel test robot <oliver.sang@inte=
l.com> wrote:
>
>
>
> Hello,
>
> kernel test robot noticed "UBSAN:array-index-out-of-bounds_in_btrfs/tree-=
log.c" on:

Yes, this was actually fixed before committing to the for-next branch
on github, but missed the mailing list.
The incremental diff is:

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e59569770b7b..47046dd14997 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3168,7 +3168,7 @@ static int update_log_root(struct
btrfs_trans_handle *trans,
 static bool wait_log_commit(struct btrfs_root *root, int transid)
 {
        DEFINE_WAIT(wait);
-       int index =3D transid % 2;
+       const int index =3D (transid >=3D 0 ? transid % 2 : -transid % 2);

        if (!root->log_commit[index])
                return false;

Thanks.

>
> commit: a99687b4edeead900d714fa0839a302a5a56d7aa ("[PATCH v2 3/5] btrfs: =
move condition for log commit wait into wait_log_commit()")
> url: https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-org/b=
trfs-stop-sleeping-for-one-jiffy-in-non-ssd-mounts-during-log-commit/202607=
22-235417
> patch link: https://lore.kernel.org/all/842ef70c9ca3ddf17f8660ad24f63f627=
2621afa.1784733396.git.fdmanana@suse.com/
> patch subject: [PATCH v2 3/5] btrfs: move condition for log commit wait i=
nto wait_log_commit()
>
> in testcase: ltp
> version:
> with following parameters:
>
>         disk: 1SSD
>         fs: btrfs
>         test: syscalls-01
>
>
>
> config: x86_64-rhel-9.4-ltp
> compiler: gcc-14
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake)=
 with 16G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202607301616.c4685aab-lkp@intel.=
com
>
>
>
> kern  :warn  : [  104.466941] [   T5568] ------------[ cut here ]--------=
----
> kern  :err   : [  104.467469] [   T5568] UBSAN: array-index-out-of-bounds=
 in btrfs/tree-log.c:3173:35
> kern  :err   : [  104.467989] [   T5568] index -1 is out of range for typ=
e 'atomic_t [2]'
> kern  :warn  : [  104.468507] [   T5568] CPU: 4 UID: 0 PID: 5568 Comm: fd=
atasync03 Not tainted 7.2.0-rc4+ #1 PREEMPT(lazy)
> kern  :warn  : [  104.468512] [   T5568] Hardware name: System manufactur=
er System Product Name/Z170I PRO GAMING, BIOS 3805 05/16/2018
> kern  :warn  : [  104.468514] [   T5568] Call Trace:
> kern  :warn  : [  104.468516] [   T5568]  <TASK>
> kern  :warn  : [  104.468519] [   T5568]  dump_stack_lvl (dump_stack.c:94=
 dump_stack.c:120)
> kern  :warn  : [  104.468528] [   T5568]  ubsan_epilogue (ubsan.c:233)
> kern  :warn  : [  104.468533] [   T5568]  __ubsan_handle_out_of_bounds.co=
ld (ubsan.c:455 ubsan.c:442)
> kern  :warn  : [  104.468539] [   T5568]  ? __pfx_stack_trace_consume_ent=
ry (usercopy_64.c:?)
> kern  :warn  : [  104.468544] [   T5568] wait_log_commit (btrfs/tree-log.=
c:3173) btrfs
> kern  :warn  : [  104.468751] [   T5568]  ? kernel_text_address (extable.=
c:125 extable.c:94)
> kern  :warn  : [  104.468757] [   T5568]  ? __pfx_wait_log_commit (btrfs/=
tree-log.c:4984) btrfs
> kern  :warn  : [  104.468950] [   T5568]  ? arch_stack_walk (x86/kernel/s=
tacktrace.c:26)
> kern  :warn  : [  104.468955] [   T5568]  ? __pfx_autoremove_wake_functio=
n (linux/list.h:441 (discriminator 4))
> kern  :warn  : [  104.468961] [   T5568]  ? mutex_lock (linux/instrumente=
d.h:55 linux/atomic/atomic-instrumented.h:4457 locking/mutex.c:161 locking/=
mutex.c:318)
> kern  :warn  : [  104.468966] [   T5568]  ? __pfx_mutex_lock (locking/mut=
ex.c:1164 (discriminator 1))
> kern  :warn  : [  104.468973] [   T5568] btrfs_sync_log (btrfs/tree-log.c=
:3331) btrfs
> kern  :warn  : [  104.469161] [   T5568]  ? __printk_deferred_exit (print=
k/printk_safe.c:55 (discriminator 1))
> kern  :warn  : [  104.469164] [   T5568]  ? stack_depot_save_flags (stack=
depot.c:728)
> kern  :warn  : [  104.469168] [   T5568]  ? kasan_save_stack (kasan/commo=
n.c:58)
> kern  :warn  : [  104.469171] [   T5568]  ? kasan_save_stack (kasan/commo=
n.c:57)
> kern  :warn  : [  104.469174] [   T5568]  ? __pfx_btrfs_sync_log (btrfs/t=
ree-log.c:3254) btrfs
> kern  :warn  : [  104.469285] [   T5568]  ? do_fsync (sync.c:186 sync.c:2=
00 sync.c:211)
> kern  :warn  : [  104.469288] [   T5568]  ? __x64_sys_fdatasync (sync.c:2=
21 sync.c:219 sync.c:219)
> kern  :warn  : [  104.469291] [   T5568]  ? do_syscall_64 (x86/entry/sysc=
all_64.c:63 x86/entry/syscall_64.c:94)
> kern  :warn  : [  104.469294] [   T5568]  ? entry_SYSCALL_64_after_hwfram=
e (x86/entry/entry_64.S:121)
> kern  :warn  : [  104.469298] [   T5568]  ? __pfx_free_extent_buffer_clea=
r_reading (btrfs/extent_io.c:3746) btrfs
> kern  :warn  : [  104.469405] [   T5568]  ? __pfx_copy_inode_items_to_log=
 (linux/list.h:161) btrfs
> kern  :warn  : [  104.469512] [   T5568]  ? kasan_save_track (kasan/commo=
n.c:78)
> kern  :warn  : [  104.469516] [   T5568]  ? kmem_cache_free (linux/kasan.=
h:235 slub.c:2705 slub.c:6405 slub.c:6532)
> kern  :warn  : [  104.469519] [   T5568]  ? btrfs_release_path (btrfs/ctr=
ee.c:173 (discriminator 1)) btrfs
> kern  :warn  : [  104.469618] [   T5568]  ? free_frozen_page_commit (linu=
x/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 page_a=
lloc.c:2809 page_alloc.c:2881)
> kern  :warn  : [  104.469622] [   T5568]  ? __free_frozen_pages (linux/sp=
inlock.h:390 page_alloc.c:2980)
> kern  :warn  : [  104.469626] [   T5568]  ? __page_cache_release (linux/i=
nstrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 linux/pag=
e-flags.h:552 swap.c:76)
> kern  :warn  : [  104.469629] [   T5568]  ? __virt_addr_valid (linux/mmzo=
ne.h:2187 (discriminator 1) linux/mmzone.h:2269 (discriminator 1) x86/mm/ph=
ysaddr.c:54 (discriminator 1))
> kern  :warn  : [  104.469632] [   T5568]  ? rcu_segcblist_enqueue (linux/=
instrumented.h:112 linux/atomic/atomic-instrumented.h:3260 rcu/rcu_segcblis=
t.c:214 rcu/rcu_segcblist.c:231 rcu/rcu_segcblist.c:332)
> kern  :warn  : [  104.469635] [   T5568]  ? __call_rcu_common+0x341/0x970
> kern  :warn  : [  104.469639] [   T5568]  ? __pfx___call_rcu_common+0x10/=
0x10
> kern  :warn  : [  104.469642] [   T5568]  ? _raw_spin_lock_irq (linux/ins=
trumented.h:55 linux/atomic/atomic-instrumented.h:1301 asm-generic/qspinloc=
k.h:111 linux/spinlock.h:187 linux/spinlock_api_smp.h:143 locking/spinlock.=
c:174)
> kern  :warn  : [  104.469645] [   T5568]  ? detach_extent_buffer_folio (l=
inux/mm.h:2124 linux/pagemap.h:636 btrfs/extent_io.c:2976) btrfs
> kern  :warn  : [  104.469753] [   T5568]  ? release_extent_buffer (btrfs/=
extent_io.c:3758 btrfs/extent_io.c:3721) btrfs
> kern  :warn  : [  104.469860] [   T5568]  ? free_extent_buffer_clear_read=
ing (btrfs/extent_io.c:3821) btrfs
> kern  :warn  : [  104.469966] [   T5568]  ? __pfx_free_extent_buffer_clea=
r_reading (btrfs/extent_io.c:3746) btrfs
> kern  :warn  : [  104.470073] [   T5568] btrfs_sync_file (btrfs/file.c:17=
26) btrfs
> kern  :warn  : [  104.470181] [   T5568]  ? __pfx_btrfs_sync_file (btrfs/=
file.c:1489) btrfs
> kern  :warn  : [  104.470296] [   T5568]  ? fdget (linux/instrumented.h:8=
2 linux/atomic/atomic-instrumented.h:49 file.c:1194 file.c:1208)
> kern  :warn  : [  104.470300] [   T5568]  do_fsync (sync.c:186 sync.c:200=
 sync.c:211)
> kern  :warn  : [  104.470303] [   T5568]  __x64_sys_fdatasync (sync.c:221=
 sync.c:219 sync.c:219)
> kern  :warn  : [  104.470306] [   T5568]  do_syscall_64 (x86/entry/syscal=
l_64.c:63 x86/entry/syscall_64.c:94)
> kern  :warn  : [  104.470310] [   T5568]  ? do_syscall_64 (linux/irq-entr=
y-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/en=
try/syscall_64.c:100)
> kern  :warn  : [  104.470313] [   T5568]  ? __pfx_vfs_write (linux/fs.h:2=
733 (discriminator 1))
> kern  :warn  : [  104.470317] [   T5568]  ? __x64_sys_munmap (mmap.c:1079=
 mmap.c:1076 mmap.c:1076)
> kern  :warn  : [  104.470320] [   T5568]  ? do_syscall_64 (linux/irq-entr=
y-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/en=
try/syscall_64.c:100)
> kern  :warn  : [  104.470324] [   T5568]  ? fdget_pos (linux/instrumented=
.h:82 linux/atomic/atomic-instrumented.h:3188 linux/file_ref.h:215 file.c:1=
231 file.c:1257)
> kern  :warn  : [  104.470327] [   T5568]  ? ksys_write (read_write.c:739)
> kern  :warn  : [  104.470330] [   T5568]  ? __pfx_ksys_write (read_write.=
c:723)
> kern  :warn  : [  104.470333] [   T5568]  ? __pfx_ksys_write (read_write.=
c:723)
> kern  :warn  : [  104.470337] [   T5568]  ? do_syscall_64 (linux/irq-entr=
y-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/en=
try/syscall_64.c:100)
> kern  :warn  : [  104.470340] [   T5568]  ? do_syscall_64 (linux/irq-entr=
y-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/en=
try/syscall_64.c:100)
> kern  :warn  : [  104.470344] [   T5568]  ? do_syscall_64 (linux/randomiz=
e_kstack.h:57 x86/entry/syscall_64.c:92)
> kern  :warn  : [  104.470347] [   T5568]  entry_SYSCALL_64_after_hwframe =
(x86/entry/entry_64.S:121)
> kern  :warn  : [  104.470350] [   T5568] RIP: 0033:0x7f28a60b5687
> kern  :warn  : [  104.470353] [   T5568] Code: 48 89 fa 4c 89 df e8 58 b3=
 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00=
 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 =
de e8 23 ff ff ff
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:   48 89 fa                mov    %rdi,%rdx
>    3:   4c 89 df                mov    %r11,%rdi
>    6:   e8 58 b3 00 00          call   0xb363
>    b:   8b 93 08 03 00 00       mov    0x308(%rbx),%edx
>   11:   59                      pop    %rcx
>   12:   5e                      pop    %rsi
>   13:   48 83 f8 fc             cmp    $0xfffffffffffffffc,%rax
>   17:   74 1a                   je     0x33
>   19:   5b                      pop    %rbx
>   1a:   c3                      ret
>   1b:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
>   22:   00
>   23:   48 8b 44 24 10          mov    0x10(%rsp),%rax
>   28:   0f 05                   syscall
>   2a:*  5b                      pop    %rbx             <-- trapping inst=
ruction
>   2b:   c3                      ret
>   2c:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
>   33:   83 e2 39                and    $0x39,%edx
>   36:   83 fa 08                cmp    $0x8,%edx
>   39:   75 de                   jne    0x19
>   3b:   e8 23 ff ff ff          call   0xffffffffffffff63
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:   5b                      pop    %rbx
>    1:   c3                      ret
>    2:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
>    9:   83 e2 39                and    $0x39,%edx
>    c:   83 fa 08                cmp    $0x8,%edx
>    f:   75 de                   jne    0xffffffffffffffef
>   11:   e8 23 ff ff ff          call   0xffffffffffffff39
> kern  :warn  : [  104.470356] [   T5568] RSP: 002b:00007ffcb7666460 EFLAG=
S: 00000202 ORIG_RAX: 000000000000004b
> kern  :warn  : [  104.470360] [   T5568] RAX: ffffffffffffffda RBX: 00007=
f28a6023780 RCX: 00007f28a60b5687
> kern  :warn  : [  104.470362] [   T5568] RDX: 0000000000000000 RSI: 00000=
00000000000 RDI: 0000000000000003
> kern  :warn  : [  104.470363] [   T5568] RBP: 00007f28a6023720 R08: 00000=
00000000000 R09: 0000000000000000
> kern  :warn  : [  104.470365] [   T5568] R10: 0000000000000000 R11: 00000=
00000000202 R12: 000056382db4c047
> kern  :warn  : [  104.470367] [   T5568] R13: 0000000000000004 R14: 00000=
00000000000 R15: 000056382db4d260
> kern  :warn  : [  104.470370] [   T5568]  </TASK>
> kern  :warn  : [  104.504778] [   T5568] ---[ end trace ]---
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260730/202607301616.c4685aab-lk=
p@intel.com
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>
