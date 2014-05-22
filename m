Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:49510 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaEVIvP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 04:51:15 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 6395E35C6D4
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 10:51:12 +0200 (CEST)
Received: from s9 (7.Red-88-15-60.dynamicIP.rima-tde.net [88.15.60.7])
	by mail.virtall.com (Postfix) with ESMTPSA id C03A535BE7B
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 10:51:09 +0200 (CEST)
Date: Thu, 22 May 2014 09:51:01 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: mount hangs after disk crash (RAID-1)
Message-ID: <20140522095101.107b62e8@s9>
In-Reply-To: <20140522032258.234aaab7@s9>
References: <20140522032258.234aaab7@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 May 2014 03:22:58 +0100
Tomasz Chmielewski <tch@virtall.com> wrote:

> One disk in RAID-1 crashed, so powered off, changed disk, powered
> on, trying to mount degraded. 
> 
> Unfortunately it hangs (running 3.14.4).
> 
> # mount -o degraded,compress=lzo,noatime /dev/sdb4 /home
> (...never returns...)
> 
> iostat shows no disk activity.
> 
> Any ideas how to recover?

Tried with 3.15-rc6 (had to hard reboot, otherwise it won't reboot), but it hangs in the same way.

# ps aux|grep mount
root      4420  0.0  0.0  20092  2476 pts/1    D+   04:46   0:00 mount -o degraded,compress=lzo,noatime /dev/sdb4 /home


[  119.649346] Btrfs loaded
[  119.650297] BTRFS: device label home devid 2 transid 53234 /dev/sdb4
[  119.650941] BTRFS info (device sdb4): allowing degraded mounts
[  119.651002] BTRFS info (device sdb4): disk space caching is enabled
[  119.729178] BTRFS: bdev (null) errs: wr 0, rd 58, flush 0, corrupt 0, gen 0
[  147.976429] BTRFS error (device sdb4): free space inode generation (0) did not match free space cache generation (53233)
[  360.024364] INFO: task mount:4420 blocked for more than 120 seconds.
[  360.024419]       Not tainted 3.15.0-rc6 #1
[  360.024465] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.024520] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[  360.024650]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[  360.024851]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[  360.025154]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[  360.025459] Call Trace:
[  360.025576]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[  360.025696]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[  360.025804]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  360.025909]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[  360.026022]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  360.026131]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[  360.026234]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[  360.026344]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[  360.026450]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  360.026556]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[  360.026661]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[  360.026767]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[  360.026887]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[  360.027006]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  360.027119]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[  360.027233]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  360.027349]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  360.027465]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  360.027638]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[  360.027757]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[  360.027930]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  360.028103]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[  360.028216]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[  360.028319]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[  360.028423]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  360.028531]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[  360.028636]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[  360.028740]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[  360.028847]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[  360.028955]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[  360.029058]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[  360.029172] INFO: task btrfs-transacti:4632 blocked for more than 120 seconds.
[  360.029328]       Not tainted 3.15.0-rc6 #1
[  360.029430] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.029587] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[  360.029767]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[  360.030071]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[  360.030376]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[  360.030680] Call Trace:
[  360.030779]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[  360.030882]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[  360.030987]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  360.031108]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  360.031276]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[  360.031389]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[  360.031503]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  360.031623]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  360.031737]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[  360.031843]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[  360.031945]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  360.032050]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[  360.032155]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  479.960978] INFO: task mount:4420 blocked for more than 120 seconds.
[  479.961088]       Not tainted 3.15.0-rc6 #1
[  479.961188] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  479.961348] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[  479.961527]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[  479.961840]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[  479.962149]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[  479.962455] Call Trace:
[  479.962576]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[  479.962693]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[  479.962801]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  479.962907]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[  479.963010]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  479.963109]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[  479.963213]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[  479.963325]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[  479.963426]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  479.963530]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[  479.963636]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[  479.963743]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[  479.963861]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[  479.963991]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  479.964109]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[  479.964227]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  479.964345]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  479.964463]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  479.964634]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[  479.964753]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[  479.964928]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  479.966618]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[  479.966732]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[  479.966837]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[  479.966940]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  479.967055]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[  479.967161]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[  479.967265]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[  479.967367]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[  479.967470]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[  479.967576]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[  479.967684] INFO: task btrfs-transacti:4632 blocked for more than 120 seconds.
[  479.967839]       Not tainted 3.15.0-rc6 #1
[  479.967938] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  479.968099] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[  479.968278]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[  479.968585]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[  479.968896]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[  479.969207] Call Trace:
[  479.969306]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[  479.969415]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[  479.969524]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  479.969637]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  479.969799]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[  479.969910]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[  479.970024]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  479.970140]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  479.970251]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[  479.970359]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[  479.970462]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  479.970564]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[  479.970666]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  599.897604] INFO: task mount:4420 blocked for more than 120 seconds.
[  599.897727]       Not tainted 3.15.0-rc6 #1
[  599.897813] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  599.897946] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[  599.898110]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[  599.898390]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[  599.898668]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[  599.898955] Call Trace:
[  599.899043]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[  599.899133]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[  599.899220]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  599.899303]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[  599.899385]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  599.899466]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[  599.899546]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[  599.899640]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[  599.899744]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  599.899834]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[  599.899923]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[  599.900013]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[  599.900109]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[  599.900205]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  599.900299]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[  599.900392]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  599.900488]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  599.900582]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  599.900722]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[  599.900816]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[  599.900955]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  599.901093]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[  599.901185]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[  599.901275]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[  599.901363]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  599.901454]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[  599.901542]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[  599.901630]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[  599.901718]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[  599.901821]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[  599.901902]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[  599.901987] INFO: task btrfs-transacti:4632 blocked for more than 120 seconds.
[  599.902112]       Not tainted 3.15.0-rc6 #1
[  599.902190] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  599.902317] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[  599.902459]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[  599.902702]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[  599.902993]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[  599.903277] Call Trace:
[  599.903361]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[  599.903450]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[  599.903538]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  599.903637]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  599.903771]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[  599.903864]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[  599.903958]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  599.904051]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  599.904145]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[  599.904238]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[  599.904342]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  599.904425]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[  599.904507]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  719.834220] INFO: task mount:4420 blocked for more than 120 seconds.
[  719.834329]       Not tainted 3.15.0-rc6 #1
[  719.834414] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  719.834548] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[  719.834712]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[  719.834991]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[  719.835268]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[  719.835548] Call Trace:
[  719.835642]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[  719.835739]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[  719.835857]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  719.835950]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[  719.836033]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  719.836113]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[  719.836194]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[  719.836275]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[  719.836356]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  719.836439]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[  719.836521]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[  719.836604]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[  719.836692]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[  719.836783]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  719.836897]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[  719.836999]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  719.837094]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  719.837187]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  719.837327]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[  719.837422]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[  719.837560]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  719.837697]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[  719.837789]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[  719.837879]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[  719.837968]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  719.838059]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[  719.838147]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[  719.838236]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[  719.838350]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[  719.838442]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[  719.838522]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[  719.838606] INFO: task btrfs-transacti:4632 blocked for more than 120 seconds.
[  719.838732]       Not tainted 3.15.0-rc6 #1
[  719.838811] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  719.838938] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[  719.839079]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[  719.839323]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[  719.839619]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[  719.839899] Call Trace:
[  719.839983]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[  719.840072]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[  719.840160]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  719.840251]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  719.840384]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[  719.840476]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[  719.840569]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  719.840662]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  719.840755]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[  719.840879]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[  719.842225]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  719.842315]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[  719.842403]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  839.770843] INFO: task mount:4420 blocked for more than 120 seconds.
[  839.770948]       Not tainted 3.15.0-rc6 #1
[  839.771043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  839.771198] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[  839.771414]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[  839.771736]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[  839.772058]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[  839.772393] Call Trace:
[  839.772513]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[  839.772629]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[  839.772733]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  839.772833]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[  839.772933]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  839.773031]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[  839.773130]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[  839.773229]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[  839.773368]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[  839.773477]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[  839.773585]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[  839.773694]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[  839.773815]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[  839.773936]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  839.774051]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[  839.774171]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  839.774291]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  839.774407]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  839.774581]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[  839.774698]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[  839.774887]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  839.775057]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[  839.775163]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[  839.775262]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[  839.775365]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  839.775468]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[  839.775565]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[  839.775665]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[  839.775764]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[  839.775862]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[  839.776003]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[  839.776114] INFO: task btrfs-transacti:4632 blocked for more than 120 seconds.
[  839.776274]       Not tainted 3.15.0-rc6 #1
[  839.776376] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  839.776537] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[  839.776724]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[  839.777045]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[  839.777363]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[  839.777684] Call Trace:
[  839.777798]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[  839.777901]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[  839.778002]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[  839.778109]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  839.778265]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[  839.778375]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[  839.778485]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  839.778594]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  839.778704]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[  839.778806]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[  839.778947]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[  839.779055]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[  839.779162]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43


[21899.485094] SysRq : Show Blocked State
[21899.485163]   task                        PC stack   pid father
[21899.485242] mount           D ffff88083fad16c0     0  4420   4373 0x00000000
[21899.485315]  ffff880812c836a8 0000000000000082 ffff88003723c800 ffff880812f43060
[21899.485441]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f43060
[21899.485566]  ffff88003723c800 0000000000000002 ffff880812c835f8 ffffffffa039b721
[21899.485691] Call Trace:
[21899.485771]  [<ffffffffa039b721>] ? btrfs_bio_counter_dec+0x20/0x4d [btrfs]
[21899.485855]  [<ffffffffa03662e2>] ? btrfs_map_bio+0x3c8/0x432 [btrfs]
[21899.485927]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[21899.485996]  [<ffffffff810b1f12>] ? __lock_page+0x63/0x63
[21899.486064]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[21899.486130]  [<ffffffff8139e088>] io_schedule+0x8a/0xc8
[21899.486196]  [<ffffffff810b1f1b>] sleep_on_page+0x9/0xd
[21899.486262]  [<ffffffff8139e61f>] __wait_on_bit+0x45/0x7e
[21899.486329]  [<ffffffff810b1bfd>] ? find_get_pages_tag+0xe9/0x123
[21899.486397]  [<ffffffff810b22fc>] wait_on_page_bit+0x71/0x73
[21899.486465]  [<ffffffff810685fe>] ? wake_atomic_t_function+0x28/0x28
[21899.486535]  [<ffffffff810b23b6>] filemap_fdatawait_range+0x79/0x118
[21899.486616]  [<ffffffffa035914e>] btrfs_wait_ordered_range+0x6b/0x11d [btrfs]
[21899.486699]  [<ffffffffa0379255>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[21899.486775]  [<ffffffffa032598d>] ? comp_keys+0x26/0x28 [btrfs]
[21899.486853]  [<ffffffffa037974f>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[21899.486934]  [<ffffffffa035e60a>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[21899.487012]  [<ffffffffa0336883>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[21899.487147]  [<ffffffffa034216d>] commit_cowonly_roots+0x165/0x234 [btrfs]
[21899.487226]  [<ffffffffa0343c6f>] btrfs_commit_transaction+0x413/0x866 [btrfs]
[21899.487360]  [<ffffffffa0384c67>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[21899.487492]  [<ffffffffa0341b02>] open_ctree+0x1739/0x1a7c [btrfs]
[21899.487565]  [<ffffffffa03213c6>] btrfs_mount+0x4a7/0x7b5 [btrfs]
[21899.487633]  [<ffffffff810b92f5>] ? __free_pages+0x1c/0x48
[21899.487701]  [<ffffffff81173bf4>] ? selinux_sb_copy_data+0x1a0/0x1d1
[21899.487770]  [<ffffffff810fca31>] mount_fs+0x64/0x14f
[21899.487836]  [<ffffffff810c896c>] ? __alloc_percpu+0xb/0xd
[21899.487903]  [<ffffffff81111c75>] vfs_kern_mount+0x61/0xf7
[21899.487969]  [<ffffffff81113cd7>] do_mount+0x70b/0x8af
[21899.488035]  [<ffffffff811140b5>] SyS_mount+0x80/0xb9
[21899.488101]  [<ffffffff813a10e2>] system_call_fastpath+0x16/0x1b
[21899.488169] btrfs-transacti D ffff88083fad16c0     0  4632      2 0x00000000
[21899.488240]  ffff880811f93d78 0000000000000046 0000000000000000 ffff880812f160c0
[21899.488365]  00000000000116c0 0000000000004000 ffff880813e0b060 ffff880812f160c0
[21899.488489]  ffff880811f93db8 ffffffff8139de33 0000000200000000 ffff880812f160c0
[21899.488614] Call Trace:
[21899.488675]  [<ffffffff8139de33>] ? __schedule+0x743/0x8a2
[21899.488742]  [<ffffffff81061f28>] ? enqueue_entity+0x611/0x73f
[21899.488810]  [<ffffffff8139dffc>] schedule+0x6a/0x6c
[21899.488884]  [<ffffffffa034330e>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[21899.489006]  [<ffffffff810685a4>] ? __wake_up_sync+0xd/0xd
[21899.489082]  [<ffffffffa03445ea>] start_transaction+0x205/0x463 [btrfs]
[21899.489160]  [<ffffffffa0344895>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[21899.489238]  [<ffffffffa0341f12>] transaction_kthread+0xcd/0x1c3 [btrfs]
[21899.489314]  [<ffffffffa0341e45>] ? open_ctree+0x1a7c/0x1a7c [btrfs]
[21899.489385]  [<ffffffff81050f4e>] kthread+0xcd/0xd5
[21899.489451]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[21899.489519]  [<ffffffff813a103c>] ret_from_fork+0x7c/0xb0
[21899.489586]  [<ffffffff81050e81>] ? kthread_freezable_should_stop+0x43/0x43
[21899.489656] Sched Debug Version: v0.11, 3.15.0-rc6 #1
[21899.489721] ktime                                   : 21911055.649977
[21899.489788] sched_clk                               : 21899489.655251
[21899.489855] cpu_clk                                 : 21899489.655289
[21899.489922] jiffies                                 : 4297128402
[21899.489988] sched_clock_stable()                    : 1
[21899.490052] 
[21899.490108] sysctl_sched
[21899.490167]   .sysctl_sched_latency                    : 24.000000
[21899.490234]   .sysctl_sched_min_granularity            : 3.000000
[21899.490300]   .sysctl_sched_wakeup_granularity         : 4.000000
[21899.490366]   .sysctl_sched_child_runs_first           : 0
[21899.490430]   .sysctl_sched_features                   : 11899
[21899.490496]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[21899.490562] 
[21899.490620] cpu#0, 3411.454 MHz
[21899.490680]   .nr_running                    : 0
[21899.490744]   .load                          : 0
[21899.490807]   .nr_switches                   : 11468946
[21899.490871]   .nr_load_updates               : 866697
[21899.490935]   .nr_uninterruptible            : -11546
[21899.490999]   .next_balance                  : 4297.128396
[21899.491064]   .curr->pid                     : 0
[21899.491128]   .clock                         : 21899484.972881
[21899.491193]   .cpu_load[0]                   : 0
[21899.491256]   .cpu_load[1]                   : 0
[21899.491319]   .cpu_load[2]                   : 0
[21899.491382]   .cpu_load[3]                   : 0
[21899.491445]   .cpu_load[4]                   : 0
[21899.491509]   .yld_count                     : 19
[21899.491572]   .sched_count                   : 11473794
[21899.491637]   .sched_goidle                  : 4188455
[21899.491701]   .avg_idle                      : 1000000
[21899.491766]   .max_idle_balance_cost         : 500000
[21899.491830]   .ttwu_count                    : 9483428
[21899.491894]   .ttwu_local                    : 7207661
[21899.491959] 
[21899.491959] cfs_rq[0]:/autogroup-25
[21899.493588]   .exec_clock                    : 434.190881
[21899.493652]   .MIN_vruntime                  : 0.000001
[21899.493717]   .min_vruntime                  : 432.817689
[21899.493782]   .max_vruntime                  : 0.000001
[21899.493846]   .spread                        : 0.000000
[21899.493910]   .spread0                       : -175901.363109
[21899.493975]   .nr_spread_over                : 0
[21899.494038]   .nr_running                    : 0
[21899.494102]   .load                          : 0
[21899.494165]   .runnable_load_avg             : 0
[21899.494228]   .blocked_load_avg              : 0
[21899.494291]   .tg_load_contrib               : 0
[21899.494354]   .tg_runnable_contrib           : 0
[21899.494417]   .tg_load_avg                   : 0
[21899.494479]   .tg->runnable_avg              : 0
[21899.494543]   .tg->cfs_bandwidth.timer_active: 0
[21899.494606]   .throttled                     : 0
[21899.494669]   .throttle_count                : 0
[21899.494732]   .se->exec_start                : 21899484.967126
[21899.494798]   .se->vruntime                  : 176334.180798
[21899.494863]   .se->sum_exec_runtime          : 434.190881
[21899.494927]   .se->statistics.wait_start     : 0.000000
[21899.494992]   .se->statistics.sleep_start    : 0.000000
[21899.495056]   .se->statistics.block_start    : 0.000000
[21899.495120]   .se->statistics.sleep_max      : 0.000000
[21899.495185]   .se->statistics.block_max      : 0.000000
[21899.495249]   .se->statistics.exec_max       : 6.710813
[21899.495314]   .se->statistics.slice_max      : 0.240705
[21899.495378]   .se->statistics.wait_max       : 0.102857
[21899.495443]   .se->statistics.wait_sum       : 1.889409
[21899.495507]   .se->statistics.wait_count     : 4889
[21899.495570]   .se->load.weight               : 2
[21899.495633]   .se->avg.runnable_avg_sum      : 58
[21899.495697]   .se->avg.runnable_avg_period   : 48382
[21899.495761]   .se->avg.load_avg_contrib      : 0
[21899.495824]   .se->avg.decay_count           : 20884977
[21899.495889] 
[21899.495889] cfs_rq[0]:/
[21899.496003]   .exec_clock                    : 262940.736760
[21899.496068]   .MIN_vruntime                  : 0.000001
[21899.496132]   .min_vruntime                  : 176334.180798
[21899.496197]   .max_vruntime                  : 0.000001
[21899.496261]   .spread                        : 0.000000
[21899.496326]   .spread0                       : 0.000000
[21899.496390]   .nr_spread_over                : 35
[21899.496454]   .nr_running                    : 0
[21899.496516]   .load                          : 0
[21899.496579]   .runnable_load_avg             : 0
[21899.496642]   .blocked_load_avg              : 0
[21899.496704]   .tg_load_contrib               : 0
[21899.496767]   .tg_runnable_contrib           : 1
[21899.496830]   .tg_load_avg                   : 0
[21899.496894]   .tg->runnable_avg              : 44
[21899.496958]   .tg->cfs_bandwidth.timer_active: 0
[21899.497021]   .throttled                     : 0
[21899.497085]   .throttle_count                : 0
[21899.497148]   .avg->runnable_avg_sum         : 83
[21899.497213]   .avg->runnable_avg_period      : 47328
[21899.497279] 
[21899.497279] rt_rq[0]:/
[21899.497393]   .rt_nr_running                 : 0
[21899.497456]   .rt_throttled                  : 0
[21899.497519]   .rt_time                       : 0.000000
[21899.497583]   .rt_runtime                    : 950.000000
[21899.497649] 
[21899.497649] runnable tasks:
[21899.497649]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.497649] ----------------------------------------------------------------------------------------------------------
[21899.498014]      ksoftirqd/0     3    176322.164522     26211   120    176322.164522       694.113016  21897507.123650 /
[21899.498148]     kworker/0:0H     5       809.251050         5   100       809.251050         0.049381      1049.540088 /
[21899.498281]           rcu_bh     8       117.315906         2   120       117.315906         0.001357         0.000732 /
[21899.498414]      migration/0     9         0.000000        55     0         0.000000       595.934405         0.000945 /
[21899.498548]       watchdog/0    10       -11.786542      5487     0       -11.786542        78.881463        93.388016 /
[21899.498684]               md   347       428.324204         2   100       428.324204         0.007888         0.003880 /
[21899.498816]      kworker/0:1   590    176322.397665    255994   120    176322.397665      3646.626853  21894359.775811 /
[21899.498950]          deferwq   718       445.387190         2   100       445.387190         0.030247         0.029450 /
[21899.499083]      kworker/0:2   719      1575.582100         5   120      1575.582100         0.014370     33869.085959 /
[21899.499216]        scsi_eh_0   847       808.228002        18   120       808.228002         0.812184       350.576852 /
[21899.499350]        scsi_eh_2   851       807.502459         3   120       807.502459         0.063064         1.557453 /
[21899.499483]        scsi_eh_3   853       807.507931         3   120       807.507931         0.041415         1.480934 /
[21899.499616]        scsi_eh_4   855       807.500429         3   120       807.500429         0.062727         1.383249 /
[21899.499749]     kworker/0:1H   870    176322.131352   3227418   100    176322.131352     73909.919684  21822939.455055 /
[21899.499883]        md2_raid1   912    176319.708127   1904634   120    176319.708127    112347.908224  21779586.811747 /
[21899.500018]         rsyslogd  2998      9667.377636        17   120      9667.377636         2.168560   5993625.189747 /autogroup-6
[21899.500154]         rsyslogd  3023      9351.650497        25   120      9351.650497         2.853960   5649803.120979 /autogroup-6
[21899.500290]              atd  3166         0.894976         8   120         0.894976         0.251211  21588604.307372 /autogroup-9
[21899.500425]             cron  3167        19.716363       432   120        19.716363        28.779929  21821074.252869 /autogroup-10
[21899.500562]            acpid  3200         0.761126         4   120         0.761126         0.331029        70.181766 /autogroup-11
[21899.500697]             ntpd  3249       198.174713     22173   120       198.174713       733.960500  21860725.923946 /autogroup-12
[21899.500833]            nginx  3381       228.838539     12011   120       228.838539       221.763641  21080722.835065 /autogroup-14
[21899.500968]           mysqld  4016     17502.260268      1026   120     17502.260268       486.235187  16082465.636474 /autogroup-6
[21899.501104]           mysqld  4058     19823.487946      4372   120     19823.487946        71.761763  21853520.339707 /autogroup-6
[21899.501239]           mysqld  4059       932.238656        22   120       932.238656         1.114792     14053.522372 /autogroup-6
[21899.501374]           mysqld  4088     19838.049940    155687   120     19838.049940     15582.597784  21839967.663937 /autogroup-6
[21899.501508]           mysqld  4091     17501.988465     39947   120     17501.988465      5364.968383  16071902.529412 /autogroup-6
[21899.501643]           mysqld  5066     17502.412717       106   120     17502.412717         8.815131     82120.381421 /autogroup-6
[21899.501778]            getty  4312         0.426116        90   120         0.426116         2.248871       114.518681 /autogroup-23
[21899.501913]             sshd  4322       432.817689      9748   120       432.817689       517.839144  21798014.813211 /autogroup-25
[21899.502054]    btrfs-cleaner  4631      7919.209869         3   120      7919.209869         0.140736         0.153269 /
[21899.502191]    kworker/u16:2  5052    176321.134148      2828   120    176321.134148       189.112029   6369384.863274 /
[21899.502324]           pickup  5090        46.915293        67   120        46.915293        11.710485   3899371.672474 /autogroup-18
[21899.502459]    kworker/u16:1  5097    176214.804945         4   120    176214.804945         0.155542   2854191.219499 /
[21899.502591] 
[21899.502648] cpu#1, 3411.454 MHz
[21899.502708]   .nr_running                    : 2
[21899.502772]   .load                          : 2048
[21899.502835]   .nr_switches                   : 2872731
[21899.502899]   .nr_load_updates               : 464658
[21899.502963]   .nr_uninterruptible            : 6742
[21899.503027]   .next_balance                  : 4297.128397
[21899.503091]   .curr->pid                     : 4324
[21899.503155]   .clock                         : 21899485.003402
[21899.503220]   .cpu_load[0]                   : 0
[21899.503283]   .cpu_load[1]                   : 0
[21899.503345]   .cpu_load[2]                   : 0
[21899.503409]   .cpu_load[3]                   : 0
[21899.503472]   .cpu_load[4]                   : 0
[21899.503536]   .yld_count                     : 116
[21899.503599]   .sched_count                   : 2877989
[21899.503663]   .sched_goidle                  : 1329267
[21899.503727]   .avg_idle                      : 1000000
[21899.503791]   .max_idle_balance_cost         : 500000
[21899.503855]   .ttwu_count                    : 480332
[21899.503919]   .ttwu_local                    : 431163
[21899.503983] 
[21899.503983] cfs_rq[1]:/autogroup-26
[21899.504099]   .exec_clock                    : 12.255692
[21899.504164]   .MIN_vruntime                  : 0.000001
[21899.504229]   .min_vruntime                  : 10.745539
[21899.504294]   .max_vruntime                  : 0.000001
[21899.504358]   .spread                        : 0.000000
[21899.504422]   .spread0                       : -176323.435259
[21899.504488]   .nr_spread_over                : 0
[21899.504550]   .nr_running                    : 1
[21899.504614]   .load                          : 1024
[21899.504677]   .runnable_load_avg             : 0
[21899.504741]   .blocked_load_avg              : 0
[21899.504804]   .tg_load_contrib               : 0
[21899.504868]   .tg_runnable_contrib           : 0
[21899.504932]   .tg_load_avg                   : 0
[21899.504995]   .tg->runnable_avg              : 0
[21899.505059]   .tg->cfs_bandwidth.timer_active: 0
[21899.505122]   .throttled                     : 0
[21899.506697]   .throttle_count                : 0
[21899.506760]   .se->exec_start                : 21899485.003402
[21899.506825]   .se->vruntime                  : 75576.305484
[21899.506890]   .se->sum_exec_runtime          : 12.299428
[21899.506955]   .se->statistics.wait_start     : 0.000000
[21899.507020]   .se->statistics.sleep_start    : 0.000000
[21899.507084]   .se->statistics.block_start    : 0.000000
[21899.507148]   .se->statistics.sleep_max      : 0.000000
[21899.507213]   .se->statistics.block_max      : 0.000000
[21899.507277]   .se->statistics.exec_max       : 2.415129
[21899.507341]   .se->statistics.slice_max      : 0.000000
[21899.507405]   .se->statistics.wait_max       : 0.011789
[21899.507469]   .se->statistics.wait_sum       : 0.059870
[21899.507532]   .se->statistics.wait_count     : 30
[21899.507596]   .se->load.weight               : 1024
[21899.507659]   .se->avg.runnable_avg_sum      : 0
[21899.507723]   .se->avg.runnable_avg_period   : 48352
[21899.507786]   .se->avg.load_avg_contrib      : 0
[21899.507849]   .se->avg.decay_count           : 0
[21899.507913] 
[21899.507913] cfs_rq[1]:/autogroup-27
[21899.508029]   .exec_clock                    : 1075.434446
[21899.508093]   .MIN_vruntime                  : 0.000001
[21899.508157]   .min_vruntime                  : 1074.385870
[21899.508222]   .max_vruntime                  : 0.000001
[21899.508286]   .spread                        : 0.000000
[21899.508351]   .spread0                       : -175259.794928
[21899.508416]   .nr_spread_over                : 0
[21899.508480]   .nr_running                    : 0
[21899.508542]   .load                          : 0
[21899.508606]   .runnable_load_avg             : 0
[21899.508668]   .blocked_load_avg              : 0
[21899.508730]   .tg_load_contrib               : 0
[21899.508793]   .tg_runnable_contrib           : 0
[21899.508856]   .tg_load_avg                   : 0
[21899.508919]   .tg->runnable_avg              : 0
[21899.508983]   .tg->cfs_bandwidth.timer_active: 0
[21899.509047]   .throttled                     : 0
[21899.509110]   .throttle_count                : 0
[21899.509174]   .se->exec_start                : 21899387.327955
[21899.509239]   .se->vruntime                  : 75582.028559
[21899.509304]   .se->sum_exec_runtime          : 1075.463253
[21899.509369]   .se->statistics.wait_start     : 0.000000
[21899.509433]   .se->statistics.sleep_start    : 0.000000
[21899.509503]   .se->statistics.block_start    : 0.000000
[21899.509563]   .se->statistics.sleep_max      : 0.000000
[21899.509633]   .se->statistics.block_max      : 0.000000
[21899.509698]   .se->statistics.exec_max       : 0.434543
[21899.509762]   .se->statistics.slice_max      : 0.104413
[21899.509826]   .se->statistics.wait_max       : 0.031711
[21899.509891]   .se->statistics.wait_sum       : 1.487240
[21899.509955]   .se->statistics.wait_count     : 13162
[21899.510019]   .se->load.weight               : 2
[21899.510082]   .se->avg.runnable_avg_sum      : 42
[21899.510145]   .se->avg.runnable_avg_period   : 46355
[21899.510208]   .se->avg.load_avg_contrib      : 0
[21899.510272]   .se->avg.decay_count           : 20884884
[21899.510336] 
[21899.510336] cfs_rq[1]:/
[21899.510451]   .exec_clock                    : 85092.143374
[21899.510515]   .MIN_vruntime                  : 75577.012695
[21899.510580]   .min_vruntime                  : 75582.028559
[21899.510645]   .max_vruntime                  : 75577.012695
[21899.510709]   .spread                        : 0.000000
[21899.510773]   .spread0                       : -100752.152239
[21899.510839]   .nr_spread_over                : 6
[21899.510902]   .nr_running                    : 2
[21899.510965]   .load                          : 2048
[21899.511028]   .runnable_load_avg             : 0
[21899.511090]   .blocked_load_avg              : 0
[21899.511153]   .tg_load_contrib               : 0
[21899.511216]   .tg_runnable_contrib           : 1
[21899.511280]   .tg_load_avg                   : 0
[21899.511343]   .tg->runnable_avg              : 48
[21899.511407]   .tg->cfs_bandwidth.timer_active: 0
[21899.511470]   .throttled                     : 0
[21899.511534]   .throttle_count                : 0
[21899.511598]   .avg->runnable_avg_sum         : 68
[21899.511661]   .avg->runnable_avg_period      : 47099
[21899.511726] 
[21899.511726] rt_rq[1]:/
[21899.511839]   .rt_nr_running                 : 0
[21899.511902]   .rt_throttled                  : 0
[21899.511965]   .rt_time                       : 0.000000
[21899.512029]   .rt_runtime                    : 950.000000
[21899.512094] 
[21899.512094] runnable tasks:
[21899.512094]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.512094] ----------------------------------------------------------------------------------------------------------
[21899.512460]        rcu_sched     7     75581.549156    156612   120     75581.549156      9417.078958  21889713.120356 /
[21899.512593]       watchdog/1    11        -2.971829      5481     0        -2.971829        73.004291        85.681641 /
[21899.512727]      migration/1    12         0.000000        80     0         0.000000        11.452365         0.001061 /
[21899.512859]      ksoftirqd/1    13     75529.508663       881   120     75529.508663        19.964746  21773631.112731 /
[21899.512992]      kworker/1:0    14         0.796806        12   120         0.796806         0.024592       576.481603 /
[21899.513125]     kworker/1:0H    15       433.498873         6   100       433.498873         0.050749     33667.062153 /
[21899.513260]      kworker/1:1   592     75577.012695     82166   120     75577.012695      1323.635024  21897375.643395 /
[21899.513393]        scsi_eh_1   849       304.651175        18   120       304.651175         1.423886       350.363177 /
[21899.513527]       jbd2/md2-8   927     75569.532756     16914   120     75569.532756       804.662400  21892284.700017 /
[21899.513661]     kworker/1:1H  1159     75543.537912    207451   100     75543.537912      3501.628429  21794041.515434 /
[21899.513794]    rs:main Q:Reg  3021      2610.794736       248   120      2610.794736        47.436735  21581452.742463 /autogroup-6
[21899.513929]             sshd  3328        -1.011224         4   120        -1.011224         0.606253     64176.198279 /autogroup-13
[21899.514064]            nginx  3380       374.590033     31727   120       374.590033       553.045003  21860502.309871 /autogroup-14
[21899.514198]            nginx  3382       374.753157     43707   120       374.753157       763.565837  21860162.615409 /autogroup-14
[21899.514333]      mysqld_safe  3402       122.818333       438   120       122.818333        30.032898       474.108745 /autogroup-6
[21899.514469]           mysqld  4033      2620.376893     43761   120      2620.376893       596.642937  21858734.950881 /autogroup-6
[21899.514605]           mysqld  4060       659.291830       240   120       659.291830        19.399793    129483.960055 /autogroup-6
[21899.514740]            getty  4308         2.510700        99   120         2.510700         4.489629       113.428154 /autogroup-19
[21899.514876] R           bash  4324         8.339001       206   120         8.339001        57.946482  21796961.826617 /autogroup-26
[21899.515012]             tmux  4372      1074.385870     66560   120      1074.385870      5591.476659  21787607.137065 /autogroup-27
[21899.515147]    kworker/u17:0  4568      2308.940644         3   100      2308.940644         0.024287         0.015868 /
[21899.515282] 
[21899.515339] cpu#2, 3411.454 MHz
[21899.515399]   .nr_running                    : 0
[21899.515462]   .load                          : 0
[21899.515525]   .nr_switches                   : 2424905
[21899.515589]   .nr_load_updates               : 451974
[21899.515653]   .nr_uninterruptible            : 1796
[21899.515716]   .next_balance                  : 4297.128381
[21899.515780]   .curr->pid                     : 0
[21899.515843]   .clock                         : 21899289.240972
[21899.515908]   .cpu_load[0]                   : 0
[21899.515971]   .cpu_load[1]                   : 0
[21899.516034]   .cpu_load[2]                   : 0
[21899.516097]   .cpu_load[3]                   : 0
[21899.516159]   .cpu_load[4]                   : 0
[21899.516222]   .yld_count                     : 0
[21899.516285]   .sched_count                   : 2430075
[21899.516348]   .sched_goidle                  : 1169020
[21899.516412]   .avg_idle                      : 1000000
[21899.516476]   .max_idle_balance_cost         : 500000
[21899.516540]   .ttwu_count                    : 343117
[21899.516603]   .ttwu_local                    : 300240
[21899.516667] 
[21899.516667] cfs_rq[2]:/autogroup-14
[21899.516783]   .exec_clock                    : 403.708732
[21899.516847]   .MIN_vruntime                  : 0.000001
[21899.516912]   .min_vruntime                  : 287.377673
[21899.516976]   .max_vruntime                  : 0.000001
[21899.517040]   .spread                        : 0.000000
[21899.517103]   .spread0                       : -176046.803125
[21899.517169]   .nr_spread_over                : 0
[21899.517231]   .nr_running                    : 0
[21899.517294]   .load                          : 0
[21899.517357]   .runnable_load_avg             : 0
[21899.517420]   .blocked_load_avg              : 0
[21899.517483]   .tg_load_contrib               : 0
[21899.517546]   .tg_runnable_contrib           : 0
[21899.517609]   .tg_load_avg                   : 0
[21899.517672]   .tg->runnable_avg              : 0
[21899.517735]   .tg->cfs_bandwidth.timer_active: 0
[21899.517797]   .throttled                     : 0
[21899.517860]   .throttle_count                : 0
[21899.517923]   .se->exec_start                : 21899289.234443
[21899.517988]   .se->vruntime                  : 64875.180643
[21899.518053]   .se->sum_exec_runtime          : 403.873293
[21899.518117]   .se->statistics.wait_start     : 0.000000
[21899.518181]   .se->statistics.sleep_start    : 0.000000
[21899.519757]   .se->statistics.block_start    : 0.000000
[21899.519821]   .se->statistics.sleep_max      : 0.000000
[21899.519886]   .se->statistics.block_max      : 0.000000
[21899.519949]   .se->statistics.exec_max       : 0.123187
[21899.520013]   .se->statistics.slice_max      : 0.026523
[21899.520077]   .se->statistics.wait_max       : 0.095209
[21899.520141]   .se->statistics.wait_sum       : 4.402436
[21899.520205]   .se->statistics.wait_count     : 23460
[21899.520268]   .se->load.weight               : 2
[21899.520331]   .se->avg.runnable_avg_sum      : 13
[21899.520394]   .se->avg.runnable_avg_period   : 47792
[21899.520458]   .se->avg.load_avg_contrib      : 0
[21899.520521]   .se->avg.decay_count           : 20884790
[21899.520585] 
[21899.520585] cfs_rq[2]:/autogroup-6
[21899.520701]   .exec_clock                    : 4797.463344
[21899.520766]   .MIN_vruntime                  : 0.000001
[21899.520830]   .min_vruntime                  : 2990.173771
[21899.520895]   .max_vruntime                  : 0.000001
[21899.520960]   .spread                        : 0.000000
[21899.521024]   .spread0                       : -173344.007027
[21899.521089]   .nr_spread_over                : 90
[21899.521152]   .nr_running                    : 0
[21899.521215]   .load                          : 0
[21899.521278]   .runnable_load_avg             : 0
[21899.521341]   .blocked_load_avg              : 0
[21899.521405]   .tg_load_contrib               : 0
[21899.521468]   .tg_runnable_contrib           : 0
[21899.521531]   .tg_load_avg                   : 0
[21899.521594]   .tg->runnable_avg              : 3
[21899.521657]   .tg->cfs_bandwidth.timer_active: 0
[21899.521720]   .throttled                     : 0
[21899.521782]   .throttle_count                : 0
[21899.521845]   .se->exec_start                : 21899203.385231
[21899.521911]   .se->vruntime                  : 64887.070968
[21899.521975]   .se->sum_exec_runtime          : 4798.115180
[21899.522040]   .se->statistics.wait_start     : 0.000000
[21899.522104]   .se->statistics.sleep_start    : 0.000000
[21899.522169]   .se->statistics.block_start    : 0.000000
[21899.522233]   .se->statistics.sleep_max      : 0.000000
[21899.522298]   .se->statistics.block_max      : 0.000000
[21899.522362]   .se->statistics.exec_max       : 9.984601
[21899.522427]   .se->statistics.slice_max      : 0.358968
[21899.522491]   .se->statistics.wait_max       : 0.220493
[21899.522555]   .se->statistics.wait_sum       : 19.612568
[21899.522620]   .se->statistics.wait_count     : 101892
[21899.522683]   .se->load.weight               : 2
[21899.522746]   .se->avg.runnable_avg_sum      : 1
[21899.522810]   .se->avg.runnable_avg_period   : 47201
[21899.522873]   .se->avg.load_avg_contrib      : 0
[21899.522936]   .se->avg.decay_count           : 20884708
[21899.523000] 
[21899.523000] cfs_rq[2]:/
[21899.523114]   .exec_clock                    : 70951.067886
[21899.523179]   .MIN_vruntime                  : 0.000001
[21899.523243]   .min_vruntime                  : 64887.070968
[21899.523308]   .max_vruntime                  : 0.000001
[21899.523371]   .spread                        : 0.000000
[21899.523436]   .spread0                       : -111447.109830
[21899.523500]   .nr_spread_over                : 5
[21899.523562]   .nr_running                    : 0
[21899.523625]   .load                          : 0
[21899.523688]   .runnable_load_avg             : 0
[21899.523752]   .blocked_load_avg              : 0
[21899.523815]   .tg_load_contrib               : 0
[21899.523879]   .tg_runnable_contrib           : 41
[21899.523943]   .tg_load_avg                   : 0
[21899.524006]   .tg->runnable_avg              : 47
[21899.524071]   .tg->cfs_bandwidth.timer_active: 0
[21899.524134]   .throttled                     : 0
[21899.524198]   .throttle_count                : 0
[21899.524267]   .avg->runnable_avg_sum         : 1928
[21899.524330]   .avg->runnable_avg_period      : 47230
[21899.524395] 
[21899.524395] rt_rq[2]:/
[21899.524509]   .rt_nr_running                 : 0
[21899.524572]   .rt_throttled                  : 0
[21899.524635]   .rt_time                       : 0.000000
[21899.524700]   .rt_runtime                    : 950.000000
[21899.524765] 
[21899.524765] runnable tasks:
[21899.524765]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.524765] ----------------------------------------------------------------------------------------------------------
[21899.525132]             init     1        23.595661      4610   120        23.595661       616.234479  21897940.187047 /autogroup-2
[21899.525266]         kthreadd     2     64811.539667       139   120     64811.539667         2.923312  21749449.471237 /
[21899.525400]       watchdog/2    16        -5.975085      5481     0        -5.975085        71.688752        72.366594 /
[21899.525534]      migration/2    17         0.000000        63     0         0.000000         5.806137         0.000964 /
[21899.525666]      ksoftirqd/2    18     64873.119229       778   120     64873.119229        17.952324  21883213.134744 /
[21899.525799]      kworker/2:0    19        -5.020887        13   120        -5.020887         0.028730       568.777360 /
[21899.525932]     kworker/2:0H    20       358.098517         6   100       358.098517         0.070725      2626.180931 /
[21899.526066]      kworker/2:1   594     64875.443491     79034   120     64875.443491      1240.181080  21897254.704480 /
[21899.526200]     kworker/2:1H   955     61875.368559     76761   100     61875.368559      1274.600575  11196616.413840 /
[21899.526334]         rsyslogd  3022      2893.672895       232   120      2893.672895        14.042786  21581486.275518 /autogroup-6
[21899.526470]          vnstatd  3001       228.013859      4432   120       228.013859       565.645704  21860411.835162 /autogroup-7
[21899.526605]            mdadm  3137         0.044246        23   120         0.044246         5.028579  21642417.577079 /autogroup-8
[21899.526741]            nginx  3383       287.377673     43723   120       287.377673       759.382769  21860350.601922 /autogroup-14
[21899.526877]           mysqld  4038      2978.492075     43752   120      2978.492075       581.848348  21858719.178052 /autogroup-6
[21899.527013]          dovecot  4167        20.656730        50   120        20.656730         4.753497  10113792.206034 /autogroup-16
[21899.527148]            getty  4313         1.305357        96   120         1.305357         2.549224       114.426945 /autogroup-24
[21899.527285] 
[21899.527342] cpu#3, 3411.454 MHz
[21899.527402]   .nr_running                    : 0
[21899.527465]   .load                          : 0
[21899.527528]   .nr_switches                   : 1115803
[21899.527592]   .nr_load_updates               : 346081
[21899.527656]   .nr_uninterruptible            : -130
[21899.527720]   .next_balance                  : 4297.128395
[21899.527785]   .curr->pid                     : 0
[21899.527848]   .clock                         : 21899524.908508
[21899.527913]   .cpu_load[0]                   : 0
[21899.527977]   .cpu_load[1]                   : 0
[21899.528039]   .cpu_load[2]                   : 0
[21899.528103]   .cpu_load[3]                   : 0
[21899.528165]   .cpu_load[4]                   : 0
[21899.528228]   .yld_count                     : 0
[21899.528291]   .sched_count                   : 1120937
[21899.528355]   .sched_goidle                  : 542155
[21899.528419]   .avg_idle                      : 1000000
[21899.528483]   .max_idle_balance_cost         : 500000
[21899.528546]   .ttwu_count                    : 357245
[21899.528610]   .ttwu_local                    : 311737
[21899.528674] 
[21899.528674] cfs_rq[3]:/autogroup-6
[21899.528790]   .exec_clock                    : 4287.632283
[21899.528856]   .MIN_vruntime                  : 0.000001
[21899.528920]   .min_vruntime                  : 2528.524559
[21899.528984]   .max_vruntime                  : 0.000001
[21899.529048]   .spread                        : 0.000000
[21899.529112]   .spread0                       : -173805.656239
[21899.529177]   .nr_spread_over                : 166
[21899.529240]   .nr_running                    : 0
[21899.529302]   .load                          : 0
[21899.529366]   .runnable_load_avg             : 0
[21899.529429]   .blocked_load_avg              : 0
[21899.529493]   .tg_load_contrib               : 0
[21899.529556]   .tg_runnable_contrib           : 2
[21899.529620]   .tg_load_avg                   : 0
[21899.529683]   .tg->runnable_avg              : 3
[21899.529746]   .tg->cfs_bandwidth.timer_active: 0
[21899.529809]   .throttled                     : 0
[21899.529872]   .throttle_count                : 0
[21899.529935]   .se->exec_start                : 21899524.902076
[21899.530000]   .se->vruntime                  : 19863.836093
[21899.530065]   .se->sum_exec_runtime          : 4289.053828
[21899.530129]   .se->statistics.wait_start     : 0.000000
[21899.530193]   .se->statistics.sleep_start    : 0.000000
[21899.530257]   .se->statistics.block_start    : 0.000000
[21899.530321]   .se->statistics.sleep_max      : 0.000000
[21899.530386]   .se->statistics.block_max      : 0.000000
[21899.530450]   .se->statistics.exec_max       : 9.996177
[21899.530514]   .se->statistics.slice_max      : 0.211223
[21899.530578]   .se->statistics.wait_max       : 0.185806
[21899.530643]   .se->statistics.wait_sum       : 13.428816
[21899.530707]   .se->statistics.wait_count     : 114676
[21899.530770]   .se->load.weight               : 2
[21899.530833]   .se->avg.runnable_avg_sum      : 116
[21899.530896]   .se->avg.runnable_avg_period   : 46970
[21899.530960]   .se->avg.load_avg_contrib      : 0
[21899.531022]   .se->avg.decay_count           : 20885015
[21899.531086] 
[21899.531086] cfs_rq[3]:/
[21899.531200]   .exec_clock                    : 25043.808837
[21899.532776]   .MIN_vruntime                  : 0.000001
[21899.532841]   .min_vruntime                  : 19863.836093
[21899.532907]   .max_vruntime                  : 0.000001
[21899.532970]   .spread                        : 0.000000
[21899.533035]   .spread0                       : -156470.344705
[21899.533100]   .nr_spread_over                : 5
[21899.533162]   .nr_running                    : 0
[21899.533225]   .load                          : 0
[21899.533288]   .runnable_load_avg             : 0
[21899.533352]   .blocked_load_avg              : 0
[21899.533415]   .tg_load_contrib               : 0
[21899.533479]   .tg_runnable_contrib           : 2
[21899.533543]   .tg_load_avg                   : 0
[21899.533606]   .tg->runnable_avg              : 46
[21899.533670]   .tg->cfs_bandwidth.timer_active: 0
[21899.533733]   .throttled                     : 0
[21899.533797]   .throttle_count                : 0
[21899.533860]   .avg->runnable_avg_sum         : 119
[21899.533924]   .avg->runnable_avg_period      : 47453
[21899.533989] 
[21899.533989] rt_rq[3]:/
[21899.534102]   .rt_nr_running                 : 0
[21899.534165]   .rt_throttled                  : 0
[21899.534229]   .rt_time                       : 0.000000
[21899.534293]   .rt_runtime                    : 950.000000
[21899.534358] 
[21899.534358] runnable tasks:
[21899.534358]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.534358] ----------------------------------------------------------------------------------------------------------
[21899.534725]       watchdog/3    21        -7.045804         3   120        -7.045804         0.003826         0.001433 /
[21899.534858]      migration/3    22         0.000000        39     0         0.000000         5.577471         0.000861 /
[21899.534991]      ksoftirqd/3    23     19828.580802       370   120     19828.580802         7.783530  21784352.586413 /
[21899.535123]      kworker/3:0    24       -10.014423        13   120       -10.014423         0.035173       555.691063 /
[21899.535256]     kworker/3:0H    25       415.709424         6   100       415.709424         0.045434      1623.334982 /
[21899.535391]       khungtaskd   143     19834.190218       184   120     19834.190218        39.123599  21828417.861350 /
[21899.535524]            khubd   341      1006.219177        62   120      1006.219177         3.533607     34705.301678 /
[21899.535657]      kworker/3:1   596     19851.700559     94183   120     19851.700559      1526.794281  21897090.224599 /
[21899.535791]        scsi_eh_5   857       394.018847         3   120       394.018847         0.041174         1.250220 /
[21899.535925]        md1_raid1   904     19822.012091        63   120     19822.012091         2.146865  21678439.110013 /
[21899.536059]     kworker/3:1H   913     17613.807216     29829   100     17613.807216       459.164739   8659751.435858 /
[21899.536193]           mysqld  4032      2516.537997     43747   120      2516.537997       583.531066  21858584.163485 /autogroup-6
[21899.536327]           mysqld  4035      2526.087749     43758   120      2526.087749       648.741466  21858675.375847 /autogroup-6
[21899.536462]           mysqld  4037      2516.557278     43750   120      2516.557278       633.393731  21858689.775832 /autogroup-6
[21899.536598]           mysqld  4040      2524.016723     43754   120      2524.016723       580.545502  21859041.975487 /autogroup-6
[21899.536733]           mysqld  4055      2524.511288     22109   120      2524.511288      3284.930419  21854644.285624 /autogroup-6
[21899.536868]           mysqld  4056      2528.524559     22408   120      2528.524559      6379.210179  21850610.374232 /autogroup-6
[21899.537003]           mysqld  4057      2515.634414      4376   120      2515.634414        79.041349  21853393.637059 /autogroup-6
[21899.537139]           master  4282        22.986731      1159   120        22.986731        69.926946  21844197.703090 /autogroup-18
[21899.537276]             qmgr  4307        13.308744       161   120        13.308744        23.300543  21590194.795219 /autogroup-18
[21899.537411]            getty  4310         1.190649       100   120         1.190649         2.444583       115.312522 /autogroup-21
[21899.537547]             bash  4373        28.083046       109   120        28.083046        41.494043     12565.890293 /autogroup-28
[21899.537682]            mount  4420       142.405537      6520   120       142.405537       505.231069     33673.941201 /autogroup-28
[21899.537819]             bash  4585        19.900318       122   120        19.900318        51.388786  16042563.639159 /autogroup-29
[21899.537954]  btrfs-transacti  4632      2871.297967         3   120      2871.297967         0.071315     29976.238403 /
[21899.538087] 
[21899.538145] cpu#4, 3411.454 MHz
[21899.538204]   .nr_running                    : 0
[21899.538267]   .load                          : 0
[21899.538330]   .nr_switches                   : 150437
[21899.538393]   .nr_load_updates               : 62170
[21899.538457]   .nr_uninterruptible            : 781
[21899.538521]   .next_balance                  : 4297.128118
[21899.538585]   .curr->pid                     : 0
[21899.538648]   .clock                         : 21899240.642168
[21899.538713]   .cpu_load[0]                   : 0
[21899.538776]   .cpu_load[1]                   : 0
[21899.538839]   .cpu_load[2]                   : 0
[21899.538903]   .cpu_load[3]                   : 0
[21899.538966]   .cpu_load[4]                   : 0
[21899.539029]   .yld_count                     : 0
[21899.539093]   .sched_count                   : 155900
[21899.539158]   .sched_goidle                  : 78244
[21899.539222]   .avg_idle                      : 1000000
[21899.539286]   .max_idle_balance_cost         : 500000
[21899.539350]   .ttwu_count                    : 57417
[21899.539413]   .ttwu_local                    : 54751
[21899.539478] 
[21899.539478] cfs_rq[4]:/autogroup-6
[21899.539594]   .exec_clock                    : 806.671076
[21899.539658]   .MIN_vruntime                  : 0.000001
[21899.539723]   .min_vruntime                  : 4372.239841
[21899.539788]   .max_vruntime                  : 0.000001
[21899.539851]   .spread                        : 0.000000
[21899.539915]   .spread0                       : -171961.940957
[21899.539980]   .nr_spread_over                : 121
[21899.540043]   .nr_running                    : 0
[21899.540106]   .load                          : 0
[21899.540169]   .runnable_load_avg             : 0
[21899.540232]   .blocked_load_avg              : 0
[21899.540295]   .tg_load_contrib               : 0
[21899.540358]   .tg_runnable_contrib           : 0
[21899.540421]   .tg_load_avg                   : 0
[21899.540484]   .tg->runnable_avg              : 3
[21899.540547]   .tg->cfs_bandwidth.timer_active: 0
[21899.540609]   .throttled                     : 0
[21899.540672]   .throttle_count                : 0
[21899.540736]   .se->exec_start                : 21899240.635686
[21899.540801]   .se->vruntime                  : 6179.601864
[21899.540865]   .se->sum_exec_runtime          : 806.970943
[21899.540930]   .se->statistics.wait_start     : 0.000000
[21899.540993]   .se->statistics.sleep_start    : 0.000000
[21899.541058]   .se->statistics.block_start    : 0.000000
[21899.541121]   .se->statistics.sleep_max      : 0.000000
[21899.541186]   .se->statistics.block_max      : 0.000000
[21899.541250]   .se->statistics.exec_max       : 9.988278
[21899.541314]   .se->statistics.slice_max      : 0.018898
[21899.541378]   .se->statistics.wait_max       : 0.032481
[21899.541441]   .se->statistics.wait_sum       : 0.699690
[21899.541505]   .se->statistics.wait_count     : 34293
[21899.541569]   .se->load.weight               : 2
[21899.541631]   .se->avg.runnable_avg_sum      : 13
[21899.541694]   .se->avg.runnable_avg_period   : 47814
[21899.541758]   .se->avg.load_avg_contrib      : 0
[21899.541821]   .se->avg.decay_count           : 20884744
[21899.541885] 
[21899.541885] cfs_rq[4]:/
[21899.541999]   .exec_clock                    : 2419.310191
[21899.542064]   .MIN_vruntime                  : 0.000001
[21899.542127]   .min_vruntime                  : 6179.601864
[21899.542192]   .max_vruntime                  : 0.000001
[21899.542256]   .spread                        : 0.000000
[21899.542319]   .spread0                       : -170154.578934
[21899.542385]   .nr_spread_over                : 240
[21899.542449]   .nr_running                    : 0
[21899.542512]   .load                          : 0
[21899.542574]   .runnable_load_avg             : 0
[21899.542637]   .blocked_load_avg              : 0
[21899.542700]   .tg_load_contrib               : 0
[21899.542763]   .tg_runnable_contrib           : 0
[21899.542826]   .tg_load_avg                   : 0
[21899.542890]   .tg->runnable_avg              : 46
[21899.542953]   .tg->cfs_bandwidth.timer_active: 0
[21899.543017]   .throttled                     : 0
[21899.543080]   .throttle_count                : 0
[21899.543144]   .avg->runnable_avg_sum         : 13
[21899.543208]   .avg->runnable_avg_period      : 48174
[21899.543273] 
[21899.543273] rt_rq[4]:/
[21899.543386]   .rt_nr_running                 : 0
[21899.543448]   .rt_throttled                  : 0
[21899.543512]   .rt_time                       : 0.000000
[21899.543576]   .rt_runtime                    : 950.000000
[21899.543641] 
[21899.543641] runnable tasks:
[21899.543641]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.543641] ----------------------------------------------------------------------------------------------------------
[21899.544007]       watchdog/4    26        -8.970995      5481     0        -8.970995        71.917391        45.701610 /
[21899.544139]      migration/4    27         0.000000       651     0         0.000000         8.685849         0.000871 /
[21899.544273]      ksoftirqd/4    28      6166.457109       292   120      6166.457109         4.968426  21858574.037354 /
[21899.545913]      kworker/4:0    29      2901.103537        13   120      2901.103537         0.040330       542.596863 /
[21899.546046]     kworker/4:0H    30      3874.244415         6   100      3874.244415         0.031718     33941.440802 /
[21899.546180]        writeback   144        18.960406         2   100        18.960406         0.004398         0.002997 /
[21899.546312]           bioset   150        30.964087         2   100        30.964087         0.004239         0.003120 /
[21899.546445]          kblockd   154        42.968506         2   100        42.968506         0.004960         0.000928 /
[21899.546578]      kworker/4:1   598      6167.540594     10559   120      6167.540594       208.835109  21895693.692777 /
[21899.546711]          ata_sff   827      3073.515378         2   100      3073.515378         0.010434         0.002782 /
[21899.546845]        md0_raid1   896      6161.452569        62   120      6161.452569         1.495908  21678660.483939 /
[21899.546979]            udevd  1116       200.356223       268   120       200.356223        42.017921     88950.271269 /autogroup-4
[21899.547114]     kworker/4:1H  1291      5785.001120      2825   100      5785.001120        47.406818   5596191.423059 /
[21899.547248]           mysqld  4041      4372.239841     43754   120      4372.239841       628.162144  21858708.112380 /autogroup-6
[21899.547384]            anvil  4219        -8.530207        20   120        -8.530207         1.994961  10113412.385971 /autogroup-16
[21899.547520]            getty  4311         0.269441        99   120         0.269441         1.810545       115.554102 /autogroup-22
[21899.547657] 
[21899.547715] cpu#5, 3411.454 MHz
[21899.547775]   .nr_running                    : 0
[21899.547838]   .load                          : 0
[21899.547900]   .nr_switches                   : 237157
[21899.547964]   .nr_load_updates               : 112164
[21899.548027]   .nr_uninterruptible            : 838
[21899.548090]   .next_balance                  : 4297.128340
[21899.548155]   .curr->pid                     : 0
[21899.548218]   .clock                         : 21899240.646096
[21899.548283]   .cpu_load[0]                   : 0
[21899.548345]   .cpu_load[1]                   : 0
[21899.548408]   .cpu_load[2]                   : 0
[21899.548472]   .cpu_load[3]                   : 0
[21899.548535]   .cpu_load[4]                   : 0
[21899.548599]   .yld_count                     : 0
[21899.548663]   .sched_count                   : 242504
[21899.548727]   .sched_goidle                  : 122273
[21899.548791]   .avg_idle                      : 1000000
[21899.548855]   .max_idle_balance_cost         : 500000
[21899.548919]   .ttwu_count                    : 119587
[21899.548983]   .ttwu_local                    : 105312
[21899.549047] 
[21899.549047] cfs_rq[5]:/autogroup-6
[21899.549163]   .exec_clock                    : 483.170584
[21899.549228]   .MIN_vruntime                  : 0.000001
[21899.549292]   .min_vruntime                  : 5266.924640
[21899.549357]   .max_vruntime                  : 0.000001
[21899.549421]   .spread                        : 0.000000
[21899.549485]   .spread0                       : -171067.256158
[21899.549550]   .nr_spread_over                : 200
[21899.549613]   .nr_running                    : 0
[21899.549676]   .load                          : 0
[21899.549738]   .runnable_load_avg             : 0
[21899.549802]   .blocked_load_avg              : 0
[21899.549864]   .tg_load_contrib               : 0
[21899.549928]   .tg_runnable_contrib           : 0
[21899.549990]   .tg_load_avg                   : 0
[21899.550053]   .tg->runnable_avg              : 3
[21899.550116]   .tg->cfs_bandwidth.timer_active: 0
[21899.550178]   .throttled                     : 0
[21899.550242]   .throttle_count                : 0
[21899.550305]   .se->exec_start                : 21899240.637529
[21899.550370]   .se->vruntime                  : 7803.382091
[21899.550435]   .se->sum_exec_runtime          : 483.339156
[21899.550499]   .se->statistics.wait_start     : 0.000000
[21899.550563]   .se->statistics.sleep_start    : 0.000000
[21899.550627]   .se->statistics.block_start    : 0.000000
[21899.550691]   .se->statistics.sleep_max      : 0.000000
[21899.550755]   .se->statistics.block_max      : 0.000000
[21899.550819]   .se->statistics.exec_max       : 2.051977
[21899.550883]   .se->statistics.slice_max      : 0.000000
[21899.550947]   .se->statistics.wait_max       : 0.050909
[21899.551011]   .se->statistics.wait_sum       : 0.408472
[21899.551075]   .se->statistics.wait_count     : 28927
[21899.551138]   .se->load.weight               : 2
[21899.551201]   .se->avg.runnable_avg_sum      : 15
[21899.551264]   .se->avg.runnable_avg_period   : 48679
[21899.551327]   .se->avg.load_avg_contrib      : 0
[21899.551391]   .se->avg.decay_count           : 20884744
[21899.551455] 
[21899.551455] cfs_rq[5]:/
[21899.551569]   .exec_clock                    : 4156.415344
[21899.551634]   .MIN_vruntime                  : 0.000001
[21899.551698]   .min_vruntime                  : 7803.382091
[21899.551763]   .max_vruntime                  : 0.000001
[21899.551827]   .spread                        : 0.000000
[21899.551892]   .spread0                       : -168530.798707
[21899.551957]   .nr_spread_over                : 299
[21899.552020]   .nr_running                    : 0
[21899.552083]   .load                          : 0
[21899.552147]   .runnable_load_avg             : 0
[21899.552210]   .blocked_load_avg              : 0
[21899.552273]   .tg_load_contrib               : 0
[21899.552336]   .tg_runnable_contrib           : 0
[21899.552398]   .tg_load_avg                   : 0
[21899.552461]   .tg->runnable_avg              : 46
[21899.552524]   .tg->cfs_bandwidth.timer_active: 0
[21899.552587]   .throttled                     : 0
[21899.552651]   .throttle_count                : 0
[21899.552715]   .avg->runnable_avg_sum         : 15
[21899.552778]   .avg->runnable_avg_period      : 47863
[21899.552842] 
[21899.552842] rt_rq[5]:/
[21899.552956]   .rt_nr_running                 : 0
[21899.553018]   .rt_throttled                  : 0
[21899.553081]   .rt_time                       : 0.000000
[21899.553145]   .rt_runtime                    : 950.000000
[21899.553210] 
[21899.553210] runnable tasks:
[21899.553210]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.553210] ----------------------------------------------------------------------------------------------------------
[21899.553578]       watchdog/5    31        -8.976407      5481     0        -8.976407        72.323285        32.380679 /
[21899.553710]      migration/5    32         0.000000       817     0         0.000000         9.402880         0.000883 /
[21899.553843]      ksoftirqd/5    33      7791.396232       123   120      7791.396232       122.942133  21898428.213472 /
[21899.553976]      kworker/5:0    34      2244.723326        12   120      2244.723326         0.041102       121.897143 /
[21899.554109]     kworker/5:0H    35      4568.760446         6   100      4568.760446         0.099904      2646.190175 /
[21899.554244]      kworker/5:1   449      7791.425432     52203   120      7791.425432       869.248715  21897558.028766 /
[21899.554382]     kworker/5:1H  1006      6052.591935      1361   100      6052.591935        25.067913   4906525.698277 /
[21899.554519]           mysqld  4036      5266.924640     43758   120      5266.924640       615.632628  21858722.860926 /autogroup-6
[21899.554656]            udevd  4564       350.224193         2   120       350.224193         0.340662         0.146965 /autogroup-4
[21899.554791] 
[21899.554849] cpu#6, 3411.454 MHz
[21899.554908]   .nr_running                    : 0
[21899.554971]   .load                          : 0
[21899.555034]   .nr_switches                   : 155890
[21899.555098]   .nr_load_updates               : 73983
[21899.555162]   .nr_uninterruptible            : 734
[21899.555225]   .next_balance                  : 4297.128218
[21899.555290]   .curr->pid                     : 0
[21899.555353]   .clock                         : 21899240.642586
[21899.555418]   .cpu_load[0]                   : 0
[21899.555481]   .cpu_load[1]                   : 0
[21899.555544]   .cpu_load[2]                   : 0
[21899.555607]   .cpu_load[3]                   : 0
[21899.555670]   .cpu_load[4]                   : 0
[21899.555733]   .yld_count                     : 1
[21899.555796]   .sched_count                   : 161344
[21899.555859]   .sched_goidle                  : 81959
[21899.555923]   .avg_idle                      : 1000000
[21899.555987]   .max_idle_balance_cost         : 500000
[21899.556050]   .ttwu_count                    : 69928
[21899.556114]   .ttwu_local                    : 67797
[21899.556177] 
[21899.556177] cfs_rq[6]:/autogroup-6
[21899.556293]   .exec_clock                    : 875.872232
[21899.556358]   .MIN_vruntime                  : 0.000001
[21899.556422]   .min_vruntime                  : 5901.481253
[21899.556487]   .max_vruntime                  : 0.000001
[21899.556551]   .spread                        : 0.000000
[21899.556615]   .spread0                       : -170432.699545
[21899.556680]   .nr_spread_over                : 126
[21899.556742]   .nr_running                    : 0
[21899.556805]   .load                          : 0
[21899.556868]   .runnable_load_avg             : 0
[21899.556931]   .blocked_load_avg              : 0
[21899.556995]   .tg_load_contrib               : 0
[21899.557058]   .tg_runnable_contrib           : 0
[21899.557120]   .tg_load_avg                   : 2
[21899.557183]   .tg->runnable_avg              : 2
[21899.557246]   .tg->cfs_bandwidth.timer_active: 0
[21899.557308]   .throttled                     : 0
[21899.558884]   .throttle_count                : 0
[21899.558947]   .se->exec_start                : 21899240.635841
[21899.559013]   .se->vruntime                  : 4173.876078
[21899.559077]   .se->sum_exec_runtime          : 876.451216
[21899.559142]   .se->statistics.wait_start     : 0.000000
[21899.559206]   .se->statistics.sleep_start    : 0.000000
[21899.559269]   .se->statistics.block_start    : 0.000000
[21899.559334]   .se->statistics.sleep_max      : 0.000000
[21899.559398]   .se->statistics.block_max      : 0.000000
[21899.559462]   .se->statistics.exec_max       : 8.535287
[21899.559526]   .se->statistics.slice_max      : 0.000000
[21899.559590]   .se->statistics.wait_max       : 0.039212
[21899.559655]   .se->statistics.wait_sum       : 0.689800
[21899.559718]   .se->statistics.wait_count     : 53793
[21899.559782]   .se->load.weight               : 2
[21899.559844]   .se->avg.runnable_avg_sum      : 13
[21899.559907]   .se->avg.runnable_avg_period   : 48391
[21899.559970]   .se->avg.load_avg_contrib      : 0
[21899.560033]   .se->avg.decay_count           : 20884744
[21899.560098] 
[21899.560098] cfs_rq[6]:/
[21899.560212]   .exec_clock                    : 1830.575196
[21899.560276]   .MIN_vruntime                  : 0.000001
[21899.560340]   .min_vruntime                  : 4173.876078
[21899.560405]   .max_vruntime                  : 0.000001
[21899.560469]   .spread                        : 0.000000
[21899.560533]   .spread0                       : -172160.304720
[21899.560598]   .nr_spread_over                : 102
[21899.560662]   .nr_running                    : 0
[21899.560724]   .load                          : 0
[21899.560787]   .runnable_load_avg             : 0
[21899.560849]   .blocked_load_avg              : 0
[21899.560912]   .tg_load_contrib               : 0
[21899.560976]   .tg_runnable_contrib           : 0
[21899.561039]   .tg_load_avg                   : 0
[21899.561103]   .tg->runnable_avg              : 47
[21899.561167]   .tg->cfs_bandwidth.timer_active: 0
[21899.561230]   .throttled                     : 0
[21899.561293]   .throttle_count                : 0
[21899.561357]   .avg->runnable_avg_sum         : 13
[21899.561421]   .avg->runnable_avg_period      : 48564
[21899.561485] 
[21899.561485] rt_rq[6]:/
[21899.561599]   .rt_nr_running                 : 0
[21899.561661]   .rt_throttled                  : 0
[21899.561724]   .rt_time                       : 0.000000
[21899.561789]   .rt_runtime                    : 950.000000
[21899.561854] 
[21899.561854] runnable tasks:
[21899.561854]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.561854] ----------------------------------------------------------------------------------------------------------
[21899.562222]       watchdog/6    36        -8.977275      5481     0        -8.977275        69.634621        19.060411 /
[21899.562354]      migration/6    37         0.000000       663     0         0.000000         8.840079         0.000910 /
[21899.562487]      ksoftirqd/6    38      4160.799441        79   120      4160.799441         1.483681  21858550.861505 /
[21899.562620]      kworker/6:0    39      1147.724307        13   120      1147.724307         0.058340       516.327171 /
[21899.562753]     kworker/6:0H    40      1883.005876         6   100      1883.005876         0.071140     33735.933716 /
[21899.562888]      kworker/6:1   601      4161.845745      6878   120      4161.845745       149.237673  21896776.774763 /
[21899.563021]  acpi_thermal_pm   606      1167.732140         2   100      1167.732140         0.010717         0.002847 /
[21899.563154]    irq/44-mei_me   660         0.000000        14    49         0.000000         0.579329         0.000000 /
[21899.563287]        kpsmoused   674      1191.763707         2   100      1191.763707         0.027833         0.007182 /
[21899.563421]       scsi_tmf_0   848      1418.027634         2   100      1418.027634         0.033926         0.004042 /
[21899.563554]       scsi_tmf_1   850      1442.097401         2   100      1442.097401         0.037671         0.003357 /
[21899.563687]       scsi_tmf_2   852      1466.170799         2   100      1466.170799         0.039337         0.003358 /
[21899.563820]       scsi_tmf_3   854      1490.185113         2   100      1490.185113         0.007055         0.003510 /
[21899.563953]       scsi_tmf_4   856      1514.230079         2   100      1514.230079         0.009111         0.003775 /
[21899.564085]       scsi_tmf_5   858      1538.272533         2   100      1538.272533         0.008466         0.003968 /
[21899.564218]           bioset   895      1642.662840         2   100      1642.662840         0.025913         0.005468 /
[21899.564351]           bioset   903      1674.969625         2   100      1674.969625         0.034134         0.026656 /
[21899.564484]           bioset   911      1707.296862         2   100      1707.296862         0.007876         0.020316 /
[21899.564618]     kworker/6:1H  1207      3658.246975      1492   100      3658.246975        23.691113   5564301.725731 /
[21899.564751]        kjournald  2218      2276.164886         2   120      2276.164886         1.593018         0.027832 /
[21899.564884]    ipv6_addrconf  3277      2409.399382         2   100      2409.399382         0.019128         0.017320 /
[21899.565017]           mysqld  4034      5901.481253     43757   120      5901.481253       655.002338  21858683.280223 /autogroup-6
[21899.565154]           mysqld  4085      3553.246418         2   120      3553.246418         0.145701       769.621025 /autogroup-6
[21899.565290]           bioset  4565      2620.208328         2   100      2620.208328         0.023300         0.008634 /
[21899.565423]            udevd  4566       331.552504         2   120       331.552504         0.210461         0.037267 /autogroup-4
[21899.565559]   btrfs-delalloc  4570      2632.221380         2   100      2632.221380         0.014551         0.007010 /
[21899.565692]  btrfs-flush_del  4571      2644.229124         2   100      2644.229124         0.008615         0.004697 /
[21899.565824]      btrfs-cache  4572      2656.236301         2   100      2656.236301         0.008068         0.004642 /
[21899.565957]     btrfs-submit  4573      2668.243488         2   100      2668.243488         0.007991         0.002886 /
[21899.566090]      btrfs-fixup  4574      2680.250506         2   100      2680.250506         0.007965         0.002899 /
[21899.566223]      btrfs-endio  4575      2692.258057         2   100      2692.258057         0.008370         0.002817 /
[21899.566356]  btrfs-endio-met  4576      2704.269234         2   100      2704.269234         0.012289         0.022302 /
[21899.566490]  btrfs-freespace  4581      2716.277121         2   100      2716.277121         0.008360         0.083971 /
[21899.566622]  btrfs-delayed-m  4582      2728.280529         2   100      2728.280529         0.003811         0.001952 /
[21899.566755]  btrfs-readahead  4583      2740.286195         2   100      2740.286195         0.006497         0.050178 /
[21899.566887]  btrfs-qgroup-re  4584      2752.291591         2   100      2752.291591         0.006395         0.017750 /
[21899.567020] 
[21899.567077] cpu#7, 3411.454 MHz
[21899.567137]   .nr_running                    : 0
[21899.567201]   .load                          : 0
[21899.567263]   .nr_switches                   : 136354
[21899.567327]   .nr_load_updates               : 65971
[21899.567390]   .nr_uninterruptible            : 787
[21899.567453]   .next_balance                  : 4297.128268
[21899.567518]   .curr->pid                     : 0
[21899.567580]   .clock                         : 21899240.648277
[21899.567645]   .cpu_load[0]                   : 0
[21899.567708]   .cpu_load[1]                   : 0
[21899.567771]   .cpu_load[2]                   : 0
[21899.567834]   .cpu_load[3]                   : 0
[21899.567897]   .cpu_load[4]                   : 0
[21899.567961]   .yld_count                     : 1
[21899.568024]   .sched_count                   : 141827
[21899.568089]   .sched_goidle                  : 72227
[21899.568153]   .avg_idle                      : 1000000
[21899.568217]   .max_idle_balance_cost         : 500000
[21899.568281]   .ttwu_count                    : 61617
[21899.568344]   .ttwu_local                    : 59740
[21899.568408] 
[21899.568408] cfs_rq[7]:/autogroup-6
[21899.568524]   .exec_clock                    : 1040.550761
[21899.568589]   .MIN_vruntime                  : 0.000001
[21899.568653]   .min_vruntime                  : 4769.735382
[21899.568718]   .max_vruntime                  : 0.000001
[21899.568782]   .spread                        : 0.000000
[21899.568846]   .spread0                       : -171564.445416
[21899.568911]   .nr_spread_over                : 136
[21899.568974]   .nr_running                    : 0
[21899.569038]   .load                          : 0
[21899.569101]   .runnable_load_avg             : 0
[21899.569164]   .blocked_load_avg              : 0
[21899.569227]   .tg_load_contrib               : 0
[21899.569290]   .tg_runnable_contrib           : 0
[21899.569353]   .tg_load_avg                   : 2
[21899.569416]   .tg->runnable_avg              : 2
[21899.569479]   .tg->cfs_bandwidth.timer_active: 0
[21899.569541]   .throttled                     : 0
[21899.569604]   .throttle_count                : 0
[21899.569668]   .se->exec_start                : 21899240.640183
[21899.569733]   .se->vruntime                  : 3394.675397
[21899.569798]   .se->sum_exec_runtime          : 1040.608571
[21899.569862]   .se->statistics.wait_start     : 0.000000
[21899.569927]   .se->statistics.sleep_start    : 0.000000
[21899.569991]   .se->statistics.block_start    : 0.000000
[21899.570056]   .se->statistics.sleep_max      : 0.000000
[21899.570121]   .se->statistics.block_max      : 0.000000
[21899.570186]   .se->statistics.exec_max       : 1.179599
[21899.570250]   .se->statistics.slice_max      : 0.042319
[21899.570314]   .se->statistics.wait_max       : 0.029437
[21899.570378]   .se->statistics.wait_sum       : 2.588588
[21899.570442]   .se->statistics.wait_count     : 27648
[21899.572015]   .se->load.weight               : 2
[21899.572077]   .se->avg.runnable_avg_sum      : 16
[21899.572140]   .se->avg.runnable_avg_period   : 48416
[21899.572204]   .se->avg.load_avg_contrib      : 0
[21899.572268]   .se->avg.decay_count           : 20884744
[21899.572332] 
[21899.572332] cfs_rq[7]:/
[21899.572447]   .exec_clock                    : 2153.634461
[21899.572519]   .MIN_vruntime                  : 0.000001
[21899.572579]   .min_vruntime                  : 3401.849899
[21899.572640]   .max_vruntime                  : 0.000001
[21899.572703]   .spread                        : 0.000000
[21899.572779]   .spread0                       : -172932.330899
[21899.572844]   .nr_spread_over                : 18
[21899.572907]   .nr_running                    : 0
[21899.572969]   .load                          : 0
[21899.573032]   .runnable_load_avg             : 0
[21899.573094]   .blocked_load_avg              : 0
[21899.573157]   .tg_load_contrib               : 0
[21899.573220]   .tg_runnable_contrib           : 0
[21899.573283]   .tg_load_avg                   : 0
[21899.573345]   .tg->runnable_avg              : 52
[21899.573408]   .tg->cfs_bandwidth.timer_active: 0
[21899.573471]   .throttled                     : 0
[21899.573534]   .throttle_count                : 0
[21899.573597]   .avg->runnable_avg_sum         : 16
[21899.573660]   .avg->runnable_avg_period      : 48390
[21899.573724]
[21899.573724] rt_rq[7]:/
[21899.573838]   .rt_nr_running                 : 0
[21899.573901]   .rt_throttled                  : 0
[21899.573963]   .rt_time                       : 0.000000
[21899.574027]   .rt_runtime                    : 950.000000
[21899.574092]
[21899.574092] runnable tasks:
[21899.574092]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[21899.574092] ----------------------------------------------------------------------------------------------------------
[21899.574460]       watchdog/7    41        -8.977606      5481     0        -8.977606        60.288612         5.744928 /
[21899.574594]      migration/7    42         0.000000       761     0         0.000000         9.528422         0.000899 /
[21899.574728]      ksoftirqd/7    43      3318.329118        74   120      3318.329118         1.307871  19890767.930118 /
[21899.574861]      kworker/7:0    44       215.370686        13   120       215.370686         0.028703       503.264907 /
[21899.574994]     kworker/7:0H    45      1918.187361         6   100      1918.187361         0.077636    176634.318153 /
[21899.575128]          khelper    46        10.956305         2   100        10.956305         0.005556         0.003187 /
[21899.575261]            netns    47        22.959595         2   100        22.959595         0.003603         0.002525 /
[21899.575394]           crypto   152       107.170217         2   100       107.170217         0.003659         0.001423 /
[21899.575527]          kswapd0   495       768.598077         3   120       768.598077         0.032157        93.474814 /
[21899.575661]    fsnotify_mark   563      1222.126134        13   120      1222.126134         0.242822     33472.286981 /
[21899.575794]      kworker/7:1   603      3391.090645      7447   120      3391.090645       160.117776  21897266.283828 /
[21899.575929]  ext4-rsv-conver   928       968.658291         2   100       968.658291         0.060681         0.034484 /
[21899.576064]            nginx  3379       140.997826         2   120       140.997826         0.532104   5991983.688812 /autogroup-14
[21899.576200]           mysqld  4039      4769.735382     43754   120      4769.735382       613.989370  21858706.669425 /autogroup-6
[21899.576335]              log  4220        -1.827792        23   120        -1.827792         2.455380  10113412.065845 /autogroup-16
[21899.576470]            getty  4309         0.016081       103   120         0.016081         1.715809       116.202681 /autogroup-20
[21899.576607]     btrfs-worker  4567      1673.179661         2   100      1673.179661         0.032876         0.005095 /
[21899.576739]  btrfs-worker-hi  4569      1697.204382         2   100      1697.204382         0.004792         0.002620 /
[21899.576874]  btrfs-endio-met  4577      1709.307326         2   100      1709.307326         0.108350         0.025991 /
[21899.577007]  btrfs-endio-rai  4578      1721.393543         2   100      1721.393543         0.087643         0.037782 /
[21899.577139]        btrfs-rmw  4579      1733.495644         2   100      1733.495644         0.105179         0.033797 /
[21899.577273]  btrfs-endio-wri  4580      1745.616606         2   100      1745.616606         0.122362         0.033939 /
[21899.577406]     kworker/7:1H  4635      2882.934932      1204   100      2882.934932        22.740523   5499142.092498 /
[21899.577539]    kworker/u16:0  5139      3401.849899         2   120      3401.849899         0.090069         0.052751 /
[21899.577672]
