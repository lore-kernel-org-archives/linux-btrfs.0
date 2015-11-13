Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:53221 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbKMTAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 14:00:08 -0500
Subject: Re: 4.2-rc6: kernel BUG at fs/btrfs/inode.c:3230
To: fdmanana@gmail.com
References: <55CC5799.3040504@profihost.ag>
 <CAL3q7H5YxJ+PNO0BJZDGoNKqUnQ7=sx8ivydVxG9hpoPT8qGiw@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <5646333E.6090502@profihost.ag>
Date: Fri, 13 Nov 2015 20:00:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5YxJ+PNO0BJZDGoNKqUnQ7=sx8ivydVxG9hpoPT8qGiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 13.11.2015 um 16:33 schrieb Filipe Manana:
> On Thu, Aug 13, 2015 at 9:38 AM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>>
>> Seen today:
>>
>> [150110.712196] ------------[ cut here ]------------
>> [150110.776995] kernel BUG at fs/btrfs/inode.c:3230!
>> [150110.841067] invalid opcode: 0000 [#1] SMP
>> [150110.904472] Modules linked in: dm_mod netconsole ipt_REJECT
>> nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
>> cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
>> bonding usbhid ext2 coretemp loop ehci_pci ehci_hcd sb_edac i2c_i801
>> usbcore edac_core i2c_core usb_common ipmi_si shpchp ipmi_msghandler
>> button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
>> async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod ixgbe(O)
>> i40e(O) vxlan ip6_udp_tunnel udp_tunnel ahci ptp aacraid libahci pps_core
>> [150111.236617] CPU: 27 PID: 5015 Comm: btrfs-cleaner Tainted: G
>>     O   4.2-rc6 #1
>> [150111.305690] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
>> 02/18/2015
>> [150111.376185] task: ffff88104ec19d50 ti: ffff8810328bc000 task.ti:
>> ffff8810328bc000
>> [150111.446596] RIP: 0010:[<ffffffffa01caaa3>]  [<ffffffffa01caaa3>]
>> btrfs_orphan_add+0x153/0x230 [btrfs]
>> [150111.518909] RSP: 0018:ffff8810328bfbf8  EFLAGS: 00010286
>> [150111.591117] RAX: 00000000ffffffe4 RBX: ffff88104bc0d000 RCX:
>> ffff881052942000
>> [150111.664479] RDX: 000000000000dc9e RSI: 0000000000040000 RDI:
>> ffff881052942138
>> [150111.737600] RBP: ffff8810328bfc38 R08: 000060ef80001fd0 R09:
>> ffff880ec4c0f3f0
>> [150111.810923] R10: ffffffffa01e1527 R11: ffffea0030914100 R12:
>> ffff880a127477d0
>> [150111.884381] R13: 0000000000000001 R14: ffff880d4c35fcc0 R15:
>> 0000000000000001
>> [150111.957062] FS:  0000000000000000(0000) GS:ffff88107fd60000(0000)
>> knlGS:0000000000000000
>> [150112.031233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [150112.104347] CR2: 0000000001262000 CR3: 0000000001c14000 CR4:
>> 00000000001407e0
>> [150112.178463] Stack:
>> [150112.251776]  ffff8810328bfc38 ffffffffa020ce17 ffff8810538aa000
>> ffff880d4c35fcc0
>> [150112.327874]  ffff8810538aa000 ffff880ec4c0f3f0 ffff880a127477d0
>> ffff881037d26600
>> [150112.404005]  ffff8810328bfcd8 ffffffffa01b3e06 ffff88104cf54c00
>> ffff880d4c35fcc0
>> [150112.480156] Call Trace:
>> [150112.555499]  [<ffffffffa020ce17>] ?
>> lookup_free_space_inode+0x47/0xf0 [btrfs]
>> [150112.632958]  [<ffffffffa01b3e06>]
>> btrfs_remove_block_group+0x246/0x930 [btrfs]
>> [150112.709655]  [<ffffffffa01ed447>] btrfs_remove_chunk+0x6a7/0x950 [btrfs]
>> [150112.785134]  [<ffffffffa01b4819>]
>> btrfs_delete_unused_bgs+0x329/0x350 [btrfs]
>> [150112.860907]  [<ffffffffa01bc396>] cleaner_kthread+0x196/0x200 [btrfs]
>> [150112.936807]  [<ffffffffa01bc200>] ?
>> btree_read_extent_buffer_pages.constprop.128+0x110/0x110 [btrfs]
>> [150113.014224]  [<ffffffff81090d59>] kthread+0xc9/0xe0
>> [150113.090363]  [<ffffffff81090c90>] ? kthread_worker_fn+0x150/0x150
>> [150113.165866]  [<ffffffff815fb708>] ret_from_fork+0x58/0x90
>> [150113.241276]  [<ffffffff81090c90>] ? kthread_worker_fn+0x150/0x150
>> [150113.316909] Code: 0f 1f 84 00 00 00 00 00 49 8b 54 24 38 eb 8d 66 0f
>> 1f 84 00 00 00 00 00 4c 89 e6 4c 89 f7 e8 c5 05 fe ff 85 c0 0f 84 53 ff
>> ff ff <0f> 0b 0f 1f 00 be 07 00 00 00 48 89 df e8 fb 02 fe ff 48 85 c0
>> [150113.476216] RIP  [<ffffffffa01caaa3>] btrfs_orphan_add+0x153/0x230
>> [btrfs]
>> [150113.553676]  RSP <ffff8810328bfbf8>
>> [150113.630868] ---[ end trace d01d42d1600e0787 ]---
>
>
> Thanks for reporting.
> Not a new issue, it's been around for many kernel releases before 4.2
> and got less likely to hit from 4.0 onwards.
>
> This is now fixed by the second patch in the following patchset:
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/50150

Thx!

Stefan

>
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
