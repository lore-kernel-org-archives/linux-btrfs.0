Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbCXGdW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 02:33:22 -0400
Message-ID: <551104B9.2010105@oracle.com>
Date: Tue, 24 Mar 2015 14:31:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>	<550FCD9C.1000706@oracle.com>	<CAGfcS_miW0=6A7a5PAQZcseCbS1KDpTPM7woKTosMjnAB3C3Cw@mail.gmail.com> <CAGfcS_nmUyBMZyrr_9pzvKxVFMJVfsmPb3DM83aaxCSUTj-2NA@mail.gmail.com>
In-Reply-To: <CAGfcS_nmUyBMZyrr_9pzvKxVFMJVfsmPb3DM83aaxCSUTj-2NA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Do you have this fix ..

  [PATCH] Btrfs: release path before starting transaction in 
can_nocow_extent

could you try ?.

Thanks, Anand



On 03/24/2015 12:37 AM, Rich Freeman wrote:
> On Mon, Mar 23, 2015 at 9:22 AM, Rich Freeman
> <r-btrfs@thefreemanclan.net> wrote:
>>
>> I'm having a similar problem.  I'm getting some kind of btrfs
>> corruption that causes a panic/reboot, and then the initramfs won't
>> mount root for 3.18.9, but it will mount it for 3.18.8.
>>
>> Running on 3.18.8 eventually caused the panic to repeat, so I'm not
>> sure that 3.18.9 is necessarily breaking things - it might just be
>> fussier about not mounting a dirty fs.
>>
>
> This continues to happen.  The filesystem won't mount with 3.18.9, but
> will mount with 3.18.8.
>
> Here is the dmesg output from dracut on 3.18.9:
>
> [  240.765147] INFO: task mount:395 blocked for more than 120 seconds.
> [  240.765224]       Not tainted 3.18.9-gentoo #1
> [  240.765274] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  240.765809] mount           D ffff880427c51900 11800   395      1 0x00000004
> [  240.765927]  ffff88040d2f76a8 0000000000000082 ffff8804106170f0
> 0000000000011900
> [  240.766181]  ffff88040d2f7fd8 0000000000011900 ffff88041593d6e0
> ffff8804106170f0
> [  240.766373]  ffff88040d2f76b8 ffff8800cb505c70 ffff8800cb505cf0
> ffff8800cb505cd8
> [  240.766556] Call Trace:
> [  240.766618]  [<ffffffff81504084>] schedule+0x24/0x60
> [  240.766719]  [<ffffffffa032fe9d>] btrfs_tree_lock+0x4d/0x1c0 [btrfs]
> [  240.766780]  [<ffffffff810882f0>] ? prepare_to_wait_event+0x100/0x100
> [  240.766859]  [<ffffffffa02d3859>] btrfs_search_slot+0x6e9/0x9f0 [btrfs]
> [  240.766939]  [<ffffffffa02d5503>] btrfs_insert_empty_items+0x73/0xd0 [btrfs]
> [  240.767017]  [<ffffffffa02ce495>] ? btrfs_alloc_path+0x15/0x20 [btrfs]
> [  240.767118]  [<ffffffffa033012a>] btrfs_insert_orphan_item+0x5a/0x80 [btrfs]
> [  240.767211]  [<ffffffffa03316c5>] insert_orphan_item+0x65/0xa0 [btrfs]
> [  240.767301]  [<ffffffffa0336589>] replay_one_buffer+0x349/0x360 [btrfs]
> [  240.767391]  [<ffffffffa0330ff5>] walk_up_log_tree+0xc5/0x220 [btrfs]
> [  240.767481]  [<ffffffffa03311eb>] walk_log_tree+0x9b/0x1a0 [btrfs]
> [  240.767572]  [<ffffffffa0338932>] btrfs_recover_log_trees+0x262/0x4d0 [btrfs]
> [  240.767662]  [<ffffffffa0336240>] ? replay_one_extent+0x780/0x780 [btrfs]
> [  240.767749]  [<ffffffffa02f4b9f>] open_ctree+0x17ef/0x2100 [btrfs]
> [  240.767827]  [<ffffffffa02cb876>] btrfs_mount+0x766/0x900 [btrfs]
> [  240.767886]  [<ffffffff81175bef>] mount_fs+0x3f/0x1b0
> [  240.767940]  [<ffffffff811331b0>] ? __alloc_percpu+0x10/0x20
> [  240.767997]  [<ffffffff8118fc53>] vfs_kern_mount+0x63/0x100
> [  240.768087]  [<ffffffffa02cb28b>] btrfs_mount+0x17b/0x900 [btrfs]
> [  240.768146]  [<ffffffff81132e8a>] ? pcpu_alloc+0x35a/0x660
> [  240.768201]  [<ffffffff81175bef>] mount_fs+0x3f/0x1b0
> [  240.768255]  [<ffffffff811331b0>] ? __alloc_percpu+0x10/0x20
> [  240.768311]  [<ffffffff8118fc53>] vfs_kern_mount+0x63/0x100
> [  240.768365]  [<ffffffff8119289c>] do_mount+0x20c/0xaf0
> [  240.768420]  [<ffffffff81118eb9>] ? __get_free_pages+0x9/0x40
> [  240.768474]  [<ffffffff81192555>] ? copy_mount_options+0x35/0x150
> [  240.768528]  [<ffffffff81193497>] SyS_mount+0x97/0xf0
> [  240.768582]  [<ffffffff81507ad2>] system_call_fastpath+0x12/0x17
> [  240.768638] INFO: task btrfs-transacti:435 blocked for more than 120 seconds.
> [  240.768693]       Not tainted 3.18.9-gentoo #1
> [  240.768742] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  240.768811] btrfs-transacti D ffff880427c11900 12424   435      2 0x00000000
> [  240.768928]  ffff8800cfab7dc8 0000000000000046 ffff880410f01a10
> 0000000000011900
> [  240.769119]  ffff8800cfab7fd8 0000000000011900 ffffffff81a16460
> ffff880410f01a10
> [  240.769302]  ffff8800cfab7dd8 ffff88040c7ab000 ffff8800cb554000
> ffff8800cb5301a0
> [  240.769485] Call Trace:
> [  240.769540]  [<ffffffff81504084>] schedule+0x24/0x60
> [  240.769625]  [<ffffffffa02f73e5>]
> btrfs_commit_transaction+0x275/0xa40 [btrfs]
> [  240.769698]  [<ffffffff810882f0>] ? prepare_to_wait_event+0x100/0x100
> [  240.769784]  [<ffffffffa02f305d>] transaction_kthread+0x1ad/0x240 [btrfs]
> [  240.769870]  [<ffffffffa02f2eb0>] ?
> btrfs_cleanup_transaction+0x530/0x530 [btrfs]
> [  240.769942]  [<ffffffff8106aa04>] kthread+0xc4/0xe0
> [  240.769997]  [<ffffffff8106a940>] ? kthread_create_on_node+0x190/0x190
> [  240.770064]  [<ffffffff81507a2c>] ret_from_fork+0x7c/0xb0
> [  240.770119]  [<ffffffff8106a940>] ? kthread_create_on_node+0x190/0x190
> [  360.832426] INFO: task mount:395 blocked for more than 120 seconds.
> [  360.832488]       Not tainted 3.18.9-gentoo #1
> [  360.832539] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.832609] mount           D ffff880427c51900 11800   395      1 0x00000004
> [  360.832727]  ffff88040d2f76a8 0000000000000082 ffff8804106170f0
> 0000000000011900
> [  360.832911]  ffff88040d2f7fd8 0000000000011900 ffff88041593d6e0
> ffff8804106170f0
> [  360.833093]  ffff88040d2f76b8 ffff8800cb505c70 ffff8800cb505cf0
> ffff8800cb505cd8
> [  360.833276] Call Trace:
> [  360.833385]  [<ffffffff81504084>] schedule+0x24/0x60
> [  360.833495]  [<ffffffffa032fe9d>] btrfs_tree_lock+0x4d/0x1c0 [btrfs]
> [  360.833555]  [<ffffffff810882f0>] ? prepare_to_wait_event+0x100/0x100
> [  360.833634]  [<ffffffffa02d3859>] btrfs_search_slot+0x6e9/0x9f0 [btrfs]
> [  360.833715]  [<ffffffffa02d5503>] btrfs_insert_empty_items+0x73/0xd0 [btrfs]
> [  360.833793]  [<ffffffffa02ce495>] ? btrfs_alloc_path+0x15/0x20 [btrfs]
> [  360.833884]  [<ffffffffa033012a>] btrfs_insert_orphan_item+0x5a/0x80 [btrfs]
> [  360.833975]  [<ffffffffa03316c5>] insert_orphan_item+0x65/0xa0 [btrfs]
> [  360.834065]  [<ffffffffa0336589>] replay_one_buffer+0x349/0x360 [btrfs]
> [  360.834155]  [<ffffffffa0330ff5>] walk_up_log_tree+0xc5/0x220 [btrfs]
> [  360.834245]  [<ffffffffa03311eb>] walk_log_tree+0x9b/0x1a0 [btrfs]
> [  360.834349]  [<ffffffffa0338932>] btrfs_recover_log_trees+0x262/0x4d0 [btrfs]
> [  360.834440]  [<ffffffffa0336240>] ? replay_one_extent+0x780/0x780 [btrfs]
> [  360.834526]  [<ffffffffa02f4b9f>] open_ctree+0x17ef/0x2100 [btrfs]
> [  360.834604]  [<ffffffffa02cb876>] btrfs_mount+0x766/0x900 [btrfs]
> [  360.834662]  [<ffffffff81175bef>] mount_fs+0x3f/0x1b0
> [  360.834717]  [<ffffffff811331b0>] ? __alloc_percpu+0x10/0x20
> [  360.834773]  [<ffffffff8118fc53>] vfs_kern_mount+0x63/0x100
> [  360.834849]  [<ffffffffa02cb28b>] btrfs_mount+0x17b/0x900 [btrfs]
> [  360.834905]  [<ffffffff81132e8a>] ? pcpu_alloc+0x35a/0x660
> [  360.834960]  [<ffffffff81175bef>] mount_fs+0x3f/0x1b0
> [  360.835014]  [<ffffffff811331b0>] ? __alloc_percpu+0x10/0x20
> [  360.835069]  [<ffffffff8118fc53>] vfs_kern_mount+0x63/0x100
> [  360.835123]  [<ffffffff8119289c>] do_mount+0x20c/0xaf0
> [  360.835179]  [<ffffffff81118eb9>] ? __get_free_pages+0x9/0x40
> [  360.835233]  [<ffffffff81192555>] ? copy_mount_options+0x35/0x150
> [  360.835286]  [<ffffffff81193497>] SyS_mount+0x97/0xf0
> [  360.835354]  [<ffffffff81507ad2>] system_call_fastpath+0x12/0x17
> [  360.835412] INFO: task btrfs-transacti:435 blocked for more than 120 seconds.
> [  360.835465]       Not tainted 3.18.9-gentoo #1
> [  360.835515] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.835583] btrfs-transacti D ffff880427c11900 12424   435      2 0x00000000
> [  360.835701]  ffff8800cfab7dc8 0000000000000046 ffff880410f01a10
> 0000000000011900
> [  360.835887]  ffff8800cfab7fd8 0000000000011900 ffffffff81a16460
> ffff880410f01a10
> [  360.836069]  ffff8800cfab7dd8 ffff88040c7ab000 ffff8800cb554000
> ffff8800cb5301a0
> [  360.836252] Call Trace:
> [  360.836315]  [<ffffffff81504084>] schedule+0x24/0x60
> [  360.836403]  [<ffffffffa02f73e5>]
> btrfs_commit_transaction+0x275/0xa40 [btrfs]
> [  360.836479]  [<ffffffff810882f0>] ? prepare_to_wait_event+0x100/0x100
> [  360.836565]  [<ffffffffa02f305d>] transaction_kthread+0x1ad/0x240 [btrfs]
> [  360.836651]  [<ffffffffa02f2eb0>] ?
> btrfs_cleanup_transaction+0x530/0x530 [btrfs]
> [  360.836725]  [<ffffffff8106aa04>] kthread+0xc4/0xe0
> [  360.836780]  [<ffffffff8106a940>] ? kthread_create_on_node+0x190/0x190
> [  360.836834]  [<ffffffff81507a2c>] ret_from_fork+0x7c/0xb0
> [  360.836891]  [<ffffffff8106a940>] ? kthread_create_on_node+0x190/0x190
>
> --
> Rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
