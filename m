Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36845 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbcLERKR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 12:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 5 Dec 2016 18:09:29 +0100
Message-ID: <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 December 2016 at 12:10, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 5 December 2016 at 00:04, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> FWIW I hit this as well:
>>
>> BUG: unable to handle kernel paging request at ffffffff81ff08b7
>> IP: [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30
>> CPU: 0 PID: 21744 Comm: trinity-c56 Tainted: G    B           4.9.0-rc7+ #217
> [...]
>
>> I think you can rule out btrfs in any case, probably block layer as
>> well, since it looks like this comes from shmem.
>
> I should rather say that the VM runs on a 9p root filesystem and it
> doesn't use/mount any block devices or disk-based filesystems.
>
> I have all the trinity logs for the crash if that's useful. I tried a
> couple of runs with just the (at the time) in-progress syscalls but it
> didn't turn up anything interesting. Otherwise it seems like a lot of
> data to go through by hand.

I've hit this another 7 times in the past ~3 hours.

Three times the address being dereferenced has pointed to
iov_iter_init+0xaf (even across a kernel rebuild), three times it has
pointed to put_prev_entity+0x55, once to 0x800000008, and twice to
0x292. The fact that it would hit even one of those more than once
across runs is pretty suspicious to me, although the ones that point
to iov_iter_init and put_prev_entity point to "random" instructions in
the sense that they are neither entry points nor return addresses.

shmem_fault() was always on the stack, but it came from different
syscalls: add_key(), newuname(), pipe2(), newstat(), fstat(),
clock_settime(), mount(), etc.

I also got this warning which is related:

------------[ cut here ]------------
WARNING: CPU: 9 PID: 25045 at lib/list_debug.c:59 __list_del_entry+0x14f/0x1d0
list_del corruption. prev->next should be ffff88014bdc79e8, but was
ffff88014bfbfc60
Kernel panic - not syncing: panic_on_warn set ...

CPU: 9 PID: 25045 Comm: trinity-c22 Not tainted 4.9.0-rc7+ #219
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
ffff88014bdc7700 ffffffff81fb0861 ffffffff83e74b60 ffff88014bdc77d8
ffffffff84006c00 ffffffff847103e0 ffff88014bdc77c8 ffffffff81515244
0000000041b58ab3 ffffffff844e21c2 ffffffff81515061 ffffffff00000054
Call Trace:
[<ffffffff81fb0861>] dump_stack+0x83/0xb2
[<ffffffff81515244>] panic+0x1e3/0x3ad
[<ffffffff81515061>] ? percpu_up_read_preempt_enable.constprop.45+0xcb/0xcb
[<ffffffff82016f7f>] ? __list_del_entry+0x14f/0x1d0
[<ffffffff812708bf>] __warn+0x1bf/0x1e0
[<ffffffff8135f2d2>] ? __lock_acquire.isra.32+0xc2/0x1a30
[<ffffffff8127098c>] warn_slowpath_fmt+0xac/0xd0
[<ffffffff812708e0>] ? __warn+0x1e0/0x1e0
[<ffffffff813530c0>] ? finish_wait+0xb0/0x180
[<ffffffff82016f7f>] __list_del_entry+0x14f/0x1d0
[<ffffffff813530c0>] ? finish_wait+0xb0/0x180
[<ffffffff813530cb>] finish_wait+0xbb/0x180
[<ffffffff81576227>] shmem_fault+0x4c7/0x6b0
[<ffffffff81574743>] ? shmem_getpage_gfp+0x673/0x1c90
[<ffffffff81575d60>] ? shmem_getpage_gfp+0x1c90/0x1c90
[<ffffffff81352150>] ? wake_atomic_t_function+0x210/0x210
[<ffffffff815ad316>] __do_fault+0x206/0x410
[<ffffffff815ad110>] ? do_page_mkwrite+0x320/0x320
[<ffffffff815b80ac>] ? handle_mm_fault+0x1cc/0x2a60
[<ffffffff815b8fd7>] handle_mm_fault+0x10f7/0x2a60
[<ffffffff815b8012>] ? handle_mm_fault+0x132/0x2a60
[<ffffffff81310a7f>] ? thread_group_cputime+0x49f/0x6e0
[<ffffffff815b7ee0>] ? __pmd_alloc+0x370/0x370
[<ffffffff81310a9c>] ? thread_group_cputime+0x4bc/0x6e0
[<ffffffff81310d2d>] ? thread_group_cputime_adjusted+0x6d/0xe0
[<ffffffff81237170>] ? __do_page_fault+0x220/0x9f0
[<ffffffff815cba10>] ? find_vma+0x30/0x150
[<ffffffff812373a2>] __do_page_fault+0x452/0x9f0
[<ffffffff81237bf5>] trace_do_page_fault+0x1e5/0x3a0
[<ffffffff8122a007>] do_async_page_fault+0x27/0xa0
[<ffffffff83c97618>] async_page_fault+0x28/0x30
[<ffffffff81fdec7c>] ? copy_user_generic_string+0x2c/0x40
[<ffffffff812b0303>] ? SyS_times+0x93/0x110
[<ffffffff812b0270>] ? do_sys_times+0x2b0/0x2b0
[<ffffffff812b0270>] ? do_sys_times+0x2b0/0x2b0
[<ffffffff8100524f>] do_syscall_64+0x1af/0x4d0
[<ffffffff83c96534>] entry_SYSCALL64_slow_path+0x25/0x25
------------[ cut here ]------------

The warning shows that it made it past the list_empty_careful() check
in finish_wait() but then bugs out on the &wait->task_list
dereference.

Anything stick out?


Vegard
