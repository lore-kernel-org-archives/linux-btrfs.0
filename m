Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36065 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbcAWPXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 10:23:36 -0500
Received: by mail-lb0-f176.google.com with SMTP id oh2so55030998lbb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 07:23:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHRikPHt7SmFhzQsZ-XKLYSbwCAgCeccEFXbw+YXBobJx8w1Ew@mail.gmail.com>
References: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
	<CAJCQCtSyc1YAsVgNcPCeA5fW8cofwqSVuF69acZo+GYm2rUx4A@mail.gmail.com>
	<CAHRikPHt7SmFhzQsZ-XKLYSbwCAgCeccEFXbw+YXBobJx8w1Ew@mail.gmail.com>
Date: Sat, 23 Jan 2016 09:23:33 -0600
Message-ID: <CAHRikPFGrXJte0zXrOxoq7MD9DcYHJ+YCWnoKyhEPACFnqwR+g@mail.gmail.com>
Subject: Re: Out of space on small-ish partition, clobber and other methods
 haven't worked
From: Jerry Steinhauer <jerry.steinhauer@singlewire.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, I have a call stack.  Does this help?  If I can provide anything
else to help narrow this down, please let me know.

% echo 8 > /proc/sys/kernel/printk

% btrfs fi df /data
System, single: total=32.00MiB, used=4.00KiB
Data+Metadata, single: total=200.00MiB, used=44.64MiB
GlobalReserve, single: total=4.00MiB, used=0.00B

% mount -o remount,enospc_debug,relatime,rw,space_cache /data
% mount | grep /data
/dev/sda8 on /data type btrfs (rw,relatime,space_cache,enospc_debug)
% cat /dev/zero > a.file
cat: write error: No space left on device
% rm a.file
rm: cannot remove 'a.file': No space left on device
% btrfs fi df /data
System, single: total=32.00MiB, used=4.00KiB
Data+Metadata, single: total=506.00MiB, used=499.62MiB
GlobalReserve, single: total=12.00MiB, used=5.69MiB

[67333.553850] ------------[ cut here ]------------
[67333.553931] WARNING: CPU: 0 PID: 14400 at
/home/builder/workspace/BuildAppImage/poky/build/tmp/work-shared/qemux86/kernel-source/fs/btrfs/extent-tree.c:7539
btrfs_alloc_tree_block+0xd2/0x41b()
[67333.553997] BTRFS: block rsv returned -28
[67333.554010] Modules linked in: nf_log_ipv4 nf_log_common xt_limit
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_hashlimit xt_conntrack
nf_conntrack iptable_mangle iptable_filter ip_tables xt_LOG x_tables
vmw_balloon pcspkr floppy parport_pc parport vmw_vmci i2c_piix4
[67333.554206] CPU: 0 PID: 14400 Comm: kworker/u2:5 Not tainted
4.1.15-yocto-standard #1
[67333.554234] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[67333.554289] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[67333.554312]  00000000 de5d7c04 de5d7bdc c16a0203 de5d7bf4 c10394ed
c11fa00d deef90c0
[67333.554344]  00000000 ffffffe4 de5d7c0c c103952f 00000009 de5d7c04
c18ca448 de5d7c20
[67333.554375]  de5d7c74 c11fa00d c18c9f0d 00001d73 c18ca448 ffffffe4
00000145 de5d7c8c
[67333.554407] Call Trace:
[67333.554445]  [<c16a0203>] dump_stack+0x16/0x18
[67333.554477]  [<c10394ed>] warn_slowpath_common+0x7c/0x93
[67333.554496]  [<c11fa00d>] ? btrfs_alloc_tree_block+0xd2/0x41b
[67333.554516]  [<c103952f>] warn_slowpath_fmt+0x2b/0x2f
[67333.554533]  [<c11fa00d>] btrfs_alloc_tree_block+0xd2/0x41b
[67333.554560]  [<c124bf99>] ? btrfs_add_delayed_tree_ref+0xf8/0x132
[67333.554652]  [<c11e858b>] __btrfs_cow_block+0x11f/0x457
[67333.554701]  [<c11e8a50>] btrfs_cow_block+0x12e/0x194
[67333.554756]  [<c11ea50e>] push_leaf_right+0x97/0x12d
[67333.554798]  [<c11eac50>] split_leaf+0xb9/0x529
[67333.554839]  [<c11eb5ba>] btrfs_search_slot+0x4fa/0x6bb
[67333.554883]  [<c120073d>] btrfs_csum_file_blocks+0x1db/0x5a9
[67333.554929]  [<c120cab9>] add_pending_csums.isra.5+0x40/0x56
[67333.554974]  [<c12120ae>] btrfs_finish_ordered_io+0x384/0x4fa
[67333.555020]  [<c121243c>] finish_ordered_fn+0x12/0x14
[67333.555062]  [<c12340dc>] btrfs_scrubnc_helper+0xf6/0x2ec
[67333.555106]  [<c1234348>] btrfs_endio_write_helper+0xd/0xf
[67333.555151]  [<c10491f5>] process_one_work+0x17a/0x2e9
[67333.555193]  [<c1049b63>] worker_thread+0x267/0x346
[67333.555235]  [<c10498fc>] ? rescuer_thread+0x281/0x281
[67333.555278]  [<c104ceb3>] kthread+0xa3/0xa8
[67333.555318]  [<c16a5380>] ret_from_kernel_thread+0x20/0x30
[67333.555362]  [<c104ce10>] ? kthread_worker_fn+0x132/0x132
[67333.555406] ---[ end trace df2e60be34a6df48 ]---

 - Jerry




On Fri, Jan 22, 2016 at 5:54 AM, Jerry Steinhauer
<jerry.steinhauer@singlewire.com> wrote:
> Thanks, Chris.
>
> 1) Re: enospec_debug, I've rebuilt with CONFIG_BTRFS_DEBUG:
>
> root@singlewire:~# zcat /proc/config.gz | grep BTRFS
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> CONFIG_BTRFS_DEBUG=y
> # CONFIG_BTRFS_ASSERT is not set
>
> I've also remounted the partition with enospc_debug:
>
> root@singlewire:~# mount | grep /data
> /dev/sda8 on /data type btrfs (rw,relatime,space_cache,enospc_debug)
>
> But, neither dmesg nor /var/log/messages have output from btrfs when I run
> the system out of space.  My C is rusty, but it looks like a macro called
> DEBUG needs to be defined.  What do I need to do to in kernel config to turn
> that on?  (google searches are not helpful with this particular term :) )
>
> 2) We went to 4.1.15 yesterday.  No change in symptom.
>
>
>  - Jerry
>
>
>
> On Wed, Jan 20, 2016 at 8:28 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>>
>> On Wed, Jan 20, 2016 at 2:22 PM, Jerry Steinhauer
>> <jerry.steinhauer@singlewire.com> wrote:
>>
>> > % rm a.file
>> > rm: cannot remove 'a.file': No space left on device
>> > % cat /dev/null > a.file
>> > -sh: a.file: No space left on device
>> > % btrfs fi df /data
>> > System, single: total=32.00MiB, used=4.00KiB
>> > Data+Metadata, single: total=506.00MiB, used=500.39MiB
>> > GlobalReserve, single: total=12.00MiB, used=6.45MiB
>>
>>
>> I see somewhere between 6MiB and 12MiB that should be available for
>> file removal. Since delete is cow, the fs still needs free space. But
>> I'd think rm would need very little cow metadata space to work and
>> then free things up.
>>
>> I can't say for sure but sounds like a bug, or at least an unintended
>> behavior.
>>
>>
>> > We encountered this on 3.1, so we upgraded as far as our distro would
>> > take us (yocto) to 4.1.  Same issue persists.
>>
>> I suggest two things, neither of which fixes the problem:
>>
>> 1. Remount with -o enospc_debug, and reproduce the problem.
>> 2. See if you can go to 4.1.15. There are quite a few Btrfs backports
>> from the 4.1.8 you're using up until 4.1.15.
>>
>>
>>
>> --
>> Chris Murphy
>
>
