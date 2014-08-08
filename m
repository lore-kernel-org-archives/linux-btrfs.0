Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35894 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaHHVfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Aug 2014 17:35:30 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so7627490pde.4
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Aug 2014 14:35:29 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Aug 2014 16:35:29 -0500
Message-ID: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
Subject: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

I have been having some issues with btrfs for the past couple of days.

Some info (this has changed as I tried multiple things):

btrfs fi show
Btrfs v3.12

uname -a
Linux server1 3.15.8-031508-generic #201407311933 SMP Thu Jul 31
23:34:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

The complete story:

The filesystem was created on Ubuntu 12.04, running kernel 3.11.
mount options included compress=zlib .

After having some issues with it, specifically that it would mount
itself read-only, and would then be "stuck" while trying to mount it
again, we decided to upgrade 14.04, kernel 3.13, and 3.12 btrfs tools.

It worked just fine for a few days, until it mounted itself read-only
again.  Someone rebooted the server, trying to get it back up: it
never came back.  On console access, there was "hung task" messages,
lots of them.  Well, I rebooted with a rescue disk, and removed btrfs
filesytem entry from fstab, and booted back to the system.

After this, tried to mount btrfs again, it would start reading at
~1MB/s from disk, then all disk activity would cease, and "mount"
would start taking 100% CPU.  Well, we left the server like that
overnight: after ~12 hours, it was just the same, and I had messages
very similar to this one on dmesg output:

http://pastebin.com/dhPTrDSp

Then, after reading here and there, decided to try to use a newer
kernel, tried 3.15.8.  Well, it is still mounting after ~16 hours, and
I got messages like these at first:

[25490.214875] BTRFS info (device sdb1): force clearing of disk cache
[25490.214882] BTRFS info (device sdb1): enabling auto recovery
[25556.240243] BTRFS: detected SSD devices, enabling SSD mode
[25812.123804] INFO: task btrfs-transacti:31532 blocked for more than
120 seconds.
[25812.125408]       Not tainted 3.15.8-031508-generic #201407311933
[25812.126732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25812.128449] btrfs-transacti D 0000000000000003     0 31532      2 0x00000000
[25812.128458]  ffff880608c73dc8 0000000000000002 ffff880608c73d68
ffff880608c73fd8
[25812.128461]  0000000000014500 0000000000014500 ffff8804698b3260
ffff880867440000
[25812.128463]  ffff880608c73dd8 ffff8804658ec000 ffff880868357000
ffff880608c73e00
[25812.128465] Call Trace:
[25812.128476]  [<ffffffff817784f9>] schedule+0x29/0x70
[25812.128503]  [<ffffffffa010273d>]
btrfs_commit_transaction+0x25d/0xa70 [btrfs]
[25812.128514]  [<ffffffff810b5450>] ? __wake_up_sync+0x20/0x20
[25812.128524]  [<ffffffffa0100475>] transaction_kthread+0x1d5/0x250 [btrfs]
[25812.128535]  [<ffffffffa01002a0>] ? open_ctree+0x1ee0/0x1ee0 [btrfs]
[25812.128539]  [<ffffffff81091469>] kthread+0xc9/0xe0
[25812.128542]  [<ffffffff810913a0>] ? flush_kthread_worker+0xb0/0xb0
[25812.128545]  [<ffffffff8178567c>] ret_from_fork+0x7c/0xb0
[25812.128547]  [<ffffffff810913a0>] ? flush_kthread_worker+0xb0/0xb0

mmm... not this is not an SSD device, this is a hardware RAID5 array
of rotational disks.  I am not sure why btrfs thought this is a SSD.

Current mount command:

mount -o clear_cache,compress=zlib,recovery /dev/sdb1 /pot/

And it kept going until later, when I just got this:

[26893.263397] INFO: task btrfs-transacti:31532 blocked for more than
120 seconds.
[26893.342166]       Not tainted 3.15.8-031508-generic #201407311933
[26893.342167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[26893.342170] btrfs-transacti D 0000000000000003     0 31532      2 0x00000000
[26893.342173]  ffff880608c73dc8 0000000000000002 ffff880608c73d68
ffff880608c73fd8
[26893.342174]  0000000000014500 0000000000014500 ffff8804698b3260
ffff880867440000
[26893.342175]  ffff880608c73dd8 ffff8804658ec000 ffff880868357000
ffff880608c73e00
[26893.342176] Call Trace:
[26893.342186]  [<ffffffff817784f9>] schedule+0x29/0x70
[26893.342214]  [<ffffffffa010273d>]
btrfs_commit_transaction+0x25d/0xa70 [btrfs]
[26893.342220]  [<ffffffff810b5450>] ? __wake_up_sync+0x20/0x20
[26893.342231]  [<ffffffffa0100475>] transaction_kthread+0x1d5/0x250 [btrfs]
[26893.342241]  [<ffffffffa01002a0>] ? open_ctree+0x1ee0/0x1ee0 [btrfs]
[26893.342246]  [<ffffffff81091469>] kthread+0xc9/0xe0
[26893.342249]  [<ffffffff810913a0>] ? flush_kthread_worker+0xb0/0xb0
[26893.342252]  [<ffffffff8178567c>] ret_from_fork+0x7c/0xb0
[26893.342253]  [<ffffffff810913a0>] ? flush_kthread_worker+0xb0/0xb0
[43614.686424] perf interrupt took too long (2505 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[72858.744039] ip_tables: (C) 2000-2006 Netfilter Core Team
[85708.015922] ip_tables: (C) 2000-2006 Netfilter Core Team

The last iptables thing was a few minutes ago.  Right now, "mount" is
using 100% CPU, there is no disk activity, memory usage looks low.

perf top output looks like this:

     7.57%  [btrfs]    [k] generic_bin_search.constprop.44
     6.77%  [btrfs]    [k] btrfs_tree_read_unlock
     6.70%  [kernel]   [k] __radix_tree_lookup
     5.45%  [btrfs]    [k] map_private_extent_buffer
     5.13%  [btrfs]    [k] btrfs_comp_cpu_keys
     4.67%  [btrfs]    [k] btrfs_search_slot
     4.66%  [btrfs]    [k] comp_keys
     4.49%  [btrfs]    [k] btrfs_try_tree_read_lock
     3.96%  [btrfs]    [k] find_extent_buffer
     3.12%  [kernel]   [k] _raw_read_lock
     2.97%  [btrfs]    [k] btrfs_clear_path_blocking
     2.96%  [btrfs]    [k] btrfs_get_token_64
     2.84%  [btrfs]    [k] release_extent_buffer
     2.52%  [kernel]   [k] _raw_spin_lock
     2.21%  [btrfs]    [k] btrfs_set_lock_blocking_rw
     2.20%  [btrfs]    [k] btrfs_get_token_16
     2.12%  [kernel]   [k] memcmp
     1.97%  [btrfs]    [k] unlock_up
     1.66%  [btrfs]    [k] btrfs_tree_read_lock
     1.50%  [btrfs]    [k] btrfs_tree_read_unlock_blocking
     1.45%  [btrfs]    [k] read_block_for_search.isra.40
     1.29%  [btrfs]    [k] btrfs_release_path
     1.17%  [btrfs]    [k] btrfs_root_node
     1.16%  [btrfs]    [k] check_buffer_tree_ref
     1.06%  [btrfs]    [k] btrfs_clear_lock_blocking_rw
     0.96%  [btrfs]    [k] btrfs_get_token_8
     0.86%  [btrfs]    [k] btrfs_buffer_uptodate
     0.85%  [btrfs]    [k] verify_parent_transid
     0.81%  [btrfs]    [k] bin_search
     0.78%  [kernel]   [k] memcpy
     0.77%  [btrfs]    [k] free_extent_buffer.part.39
     0.76%  [btrfs]    [k] btrfs_get_token_32
     0.72%  [btrfs]    [k] setup_nodes_for_search
     0.67%  [btrfs]    [k] free_extent_buffer
     0.67%  [btrfs]    [k] mark_extent_buffer_accessed
     0.66%  [kernel]   [k] __kmalloc
     0.57%  [btrfs]    [k] btrfs_set_path_blocking
     0.55%  [btrfs]    [k] check_item_in_log
     0.48%  [btrfs]    [k] read_extent_buffer
     0.42%  [btrfs]    [k] memcmp_extent_buffer
     0.38%  [kernel]   [k] crc32c_intel_le_hw
     0.36%  [btrfs]    [k] btrfs_match_dir_item_name.isra.3
     0.35%  [btrfs]    [k] verify_dir_item
     0.33%  [aacraid]  [k] aac_queuecommand
     0.32%  [kernel]   [k] _raw_spin_unlock
     0.31%  [btrfs]    [k] btrfs_crc32c
     0.31%  [kernel]   [k] kfree
     0.29%  [btrfs]    [k] replay_dir_deletes
     0.29%  [btrfs]    [k] extent_buffer_uptodate
     0.27%  [kernel]   [k] mark_page_accessed
     0.26%  [btrfs]    [k] btrfs_lookup_dir_item
     0.25%  [kernel]   [k] radix_tree_lookup
     0.14%  [btrfs]    [k] btrfs_find_tree_block
     0.13%  [kernel]   [k] crypto_shash_update


I am compiling 3.16 kernel now to give it a try, but I am not sure on
this.  I mean, this 40TB volume is holding just backups, but it took
quite some time to put the backups there, it will take ~2 weeks to put
that data in there again, I'd really prefer *not* to do it.

Any ideas?

Thanks!


-- 
Ildefonso Camargo
Command Prompt, Inc. - http://www.commandprompt.com/
PostgreSQL Support, Training, Professional Services and Development
High Availability, Oracle Conversion, Postgres-XC
@cmdpromptinc - 509-416-6579
