Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53795 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932826AbcJZUBH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 16:01:07 -0400
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
 <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
Date: Wed, 26 Oct 2016 16:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/26/2016 03:06 PM, Linus Torvalds wrote:
> On Wed, Oct 26, 2016 at 11:42 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>>
>> The stacks show nearly all of them are stuck in sync_inodes_sb
> 
> That's just wb_wait_for_completion(), and it means that some IO isn't
> completing.
> 
> There's also a lot of processes waiting for inode_lock(), and a few
> waiting for mnt_want_write()
> 
> Ignoring those, we have
> 
>> [<ffffffffa009554f>] btrfs_wait_ordered_roots+0x3f/0x200 [btrfs]
>> [<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
>> [<ffffffff811fbd4e>] sync_filesystem+0x6e/0xa0
>> [<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
>> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
>> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Don't know this one. There's a couple of them. Could there be some
> ABBA deadlock on the ordered roots waiting?

It's always possible, but we haven't changed anything here.

I've tried a long list of things to reproduce this on my test boxes,
including days of trinity runs and a kernel module to exercise vmalloc,
and thread creation.

Today I turned off every CONFIG_DEBUG_* except for list debugging, and
ran dbench 2048:

[ 2759.118711] WARNING: CPU: 2 PID: 31039 at lib/list_debug.c:33 __list_add+0xbe/0xd0
[ 2759.119652] list_add corruption. prev->next should be next (ffffe8ffffc80308), but was ffffc90000ccfb88. (prev=ffff880128522380).
[ 2759.121039] Modules linked in: crc32c_intel i2c_piix4 aesni_intel aes_x86_64 virtio_net glue_helper i2c_core lrw floppy gf128mul serio_raw pcspkr button ablk_helper cryptd sch_fq_codel autofs4 virtio_blk
[ 2759.124369] CPU: 2 PID: 31039 Comm: dbench Not tainted 4.9.0-rc1-15246-g4ce9206-dirty #317
[ 2759.125077] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 04/01/2014
[ 2759.125077]  ffffc9000f6fb868 ffffffff814fe4ff ffffffff8151cb5e ffffc9000f6fb8c8
[ 2759.125077]  ffffc9000f6fb8c8 0000000000000000 ffffc9000f6fb8b8 ffffffff81064bbf
[ 2759.127444]  ffff880128523680 0000002139968000 ffff880138b7a4a0 ffff880128523540
[ 2759.127444] Call Trace:
[ 2759.127444]  [<ffffffff814fe4ff>] dump_stack+0x53/0x74
[ 2759.127444]  [<ffffffff8151cb5e>] ? __list_add+0xbe/0xd0
[ 2759.127444]  [<ffffffff81064bbf>] __warn+0xff/0x120
[ 2759.127444]  [<ffffffff81064c99>] warn_slowpath_fmt+0x49/0x50
[ 2759.127444]  [<ffffffff8151cb5e>] __list_add+0xbe/0xd0
[ 2759.127444]  [<ffffffff814df338>] blk_sq_make_request+0x388/0x580
[ 2759.127444]  [<ffffffff814d5b44>] generic_make_request+0x104/0x200
[ 2759.127444]  [<ffffffff814d5ca5>] submit_bio+0x65/0x130
[ 2759.127444]  [<ffffffff8152a946>] ? __percpu_counter_add+0x96/0xd0
[ 2759.127444]  [<ffffffff814260bc>] btrfs_map_bio+0x23c/0x310
[ 2759.127444]  [<ffffffff813f42b3>] btrfs_submit_bio_hook+0xd3/0x190
[ 2759.127444]  [<ffffffff814117ad>] submit_one_bio+0x6d/0xa0
[ 2759.127444]  [<ffffffff8141182e>] flush_epd_write_bio+0x4e/0x70
[ 2759.127444]  [<ffffffff81418d8d>] extent_writepages+0x5d/0x70
[ 2759.127444]  [<ffffffff813f84e0>] ? btrfs_releasepage+0x50/0x50
[ 2759.127444]  [<ffffffff81220ffe>] ? wbc_attach_and_unlock_inode+0x6e/0x170
[ 2759.127444]  [<ffffffff813f5047>] btrfs_writepages+0x27/0x30
[ 2759.127444]  [<ffffffff81178690>] do_writepages+0x20/0x30
[ 2759.127444]  [<ffffffff81167d85>] __filemap_fdatawrite_range+0xb5/0x100
[ 2759.127444]  [<ffffffff81168263>] filemap_fdatawrite_range+0x13/0x20
[ 2759.127444]  [<ffffffff81405a7b>] btrfs_fdatawrite_range+0x2b/0x70
[ 2759.127444]  [<ffffffff81405ba8>] btrfs_sync_file+0x88/0x490
[ 2759.127444]  [<ffffffff810751e2>] ? group_send_sig_info+0x42/0x80
[ 2759.127444]  [<ffffffff8107527d>] ? kill_pid_info+0x5d/0x90
[ 2759.127444]  [<ffffffff8107564a>] ? SYSC_kill+0xba/0x1d0
[ 2759.127444]  [<ffffffff811f2638>] ? __sb_end_write+0x58/0x80
[ 2759.127444]  [<ffffffff81225b9c>] vfs_fsync_range+0x4c/0xb0
[ 2759.127444]  [<ffffffff81002501>] ? syscall_trace_enter+0x201/0x2e0
[ 2759.127444]  [<ffffffff81225c1c>] vfs_fsync+0x1c/0x20
[ 2759.127444]  [<ffffffff81225c5d>] do_fsync+0x3d/0x70
[ 2759.127444]  [<ffffffff810029cb>] ? syscall_slow_exit_work+0xfb/0x100
[ 2759.127444]  [<ffffffff81225cc0>] SyS_fsync+0x10/0x20
[ 2759.127444]  [<ffffffff81002b65>] do_syscall_64+0x55/0xd0
[ 2759.127444]  [<ffffffff810026d7>] ? prepare_exit_to_usermode+0x37/0x40
[ 2759.127444]  [<ffffffff819ad986>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2759.150635] ---[ end trace 3b5b7e2ef61c3d02 ]---

I put a variant of your suggested patch in place, but my printk never
triggered.  Now that I've made it happen once, I'll make sure I can do it
over and over again.  This doesn't have the patches that Andy asked Davej to
try out yet, but I'll try them once I have a reliable reproducer.

diff --git a/kernel/fork.c b/kernel/fork.c
index 623259f..de95e19 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -165,7 +165,7 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
  * flush.  Try to minimize the number of calls by caching stacks.
  */
-#define NR_CACHED_STACKS 2
+#define NR_CACHED_STACKS 256
 static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
 #endif
 
@@ -173,7 +173,9 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 #ifdef CONFIG_VMAP_STACK
        void *stack;
+       char *p;
        int i;
+       int j;
 
        local_irq_disable();
        for (i = 0; i < NR_CACHED_STACKS; i++) {
@@ -183,7 +185,15 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
                        continue;
                this_cpu_write(cached_stacks[i], NULL);
 
+               p = s->addr;
+               for (j = 0; j < THREAD_SIZE; j++) {
+                       if (p[j] != 'c') {
+                               printk_ratelimited(KERN_CRIT "bad poison %c byte %d\n", p[j], j);
+                               break;
+                       }
+               }
                tsk->stack_vm_area = s;
+
                local_irq_enable();
                return s->addr;
        }
@@ -219,6 +229,7 @@ static inline void free_thread_stack(struct task_struct *tsk)
                int i;
 
                local_irq_save(flags);
+               memset(tsk->stack_vm_area->addr, 'c', THREAD_SIZE);
                for (i = 0; i < NR_CACHED_STACKS; i++) {
                        if (this_cpu_read(cached_stacks[i]))
                                continue;
