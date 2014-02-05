Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56897 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158AbaBEUrB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 15:47:01 -0500
Message-ID: <52F2A33E.3060302@fb.com>
Date: Wed, 5 Feb 2014 15:46:54 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: switch to btrfs_previous_extent_item()
References: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com> <CAL3q7H7n+L2CqT9whDDT1ZjUzgU378HUhOuQHhjKUp7eiKD=aw@mail.gmail.com> <337FC422-D102-4310-A714-FA35538DD402@gmail.com> <23FBD0CF-ABE2-4135-8522-7B24E90911B9@gmail.com>
In-Reply-To: <23FBD0CF-ABE2-4135-8522-7B24E90911B9@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 11:14 AM, Wang Shilong wrote:
> Hi Filipe,
>
>> So i knew what was wrong here, we need found_key while btrfs_previous_extent_item() did set
>> it properly..^_^
>>
>> I will send a v2 to fix this, thanks!
>>
>>
>>> On Fri, Jan 31, 2014 at 4:42 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>
>>>> Since we have introduced btrfs_previous_extent_item() to search previous
>>>> extent item, just switch into it.
>>>>
>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> Hi Shilong,
>>>
>>> This patch is making btrfs/004 fail for me, consistently:
> I was trying to reproduce this xfstest failure(though we have known what's wrong with my previous patch).
> I did not really hit 004 failure, but i can reproduce btrfs/030 fail consistently, i think you might be interested in this:
>
> FSTYP         -- btrfs
> PLATFORM      -- Linux/i686 wangsl 3.13.0-4-default+
> MKFS_OPTIONS  -- /dev/sdb2
> MOUNT_OPTIONS -- /dev/sdb2 /mnt/scratch
>                                                                                                                                                                                                             
> btrfs/030        [failed, exit status 1] - output mismatch (see /home/wangsl/tools/xfstests/results//btrfs/030.out.bad)
>      --- tests/btrfs/030.out     2014-02-01 01:01:11.261999486 +0800
>      +++ /home/wangsl/tools/xfstests/results//btrfs/030.out.bad  2014-02-05 23:56:31.740988010 +0800
>      @@ -1 +1,3 @@
>       QA output created by 030
>      +failed: '/home/wangsl/tools/xfstests/src/fssum -r /tmp/tmp.30GWDU8xaU/2.fssum /mnt/scratch/mysnap2'
>      +(see /home/wangsl/tools/xfstests/results//btrfs/030.full for details)
>      ...
>      (Run 'diff -u tests/btrfs/030.out /home/wangsl/tools/xfstests/results//btrfs/030.out.bad'  to see the entire diff)
> Ran: btrfs/030
> Failures: btrfs/030
> Failed 1 of 1 tests
>
> dmesg show more information:
>
> [  818.988731] WARNING: CPU: 0 PID: 29978 at fs/btrfs/send.c:5427 btrfs_ioctl_send+0x34b/0xeb0 [btrfs]()
> [  818.988733] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse bnep snd_ens1371 coretemp crc32_pclmul gameport crc32c_intel snd_rawmidi aesni_intel snd_ac97_codec sr_mod cdrom ata_generic ac97_bus snd_pcm snd_seq ppdev ata_piix snd_timer snd_seq_device ablk_helper ahci btusb snd libahci cryptd bluetooth libata vmw_balloon lrw aes_i586 xts serio_raw gf128mul vmw_vmci parport_pc pcspkr soundcore mptctl snd_page_alloc parport pcnet32 i2c_piix4 shpchp joydev floppy mii ac button rfkill sg autofs4 btrfs raid6_pq xor linear hid_generic
> [  818.988766]  usbhid hid uhci_hcd vmwgfx ehci_pci ehci_hcd processor thermal_sys usbcore hwmon ttm usb_common mptspi mptscsih mptbase scsi_transport_spi drm i2c_core scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh dm_snapshot dm_mirror dm_region_hash dm_log dm_mod
> [  818.988786] CPU: 0 PID: 29978 Comm: btrfs Tainted: G        W    3.13.0-4-default+ #44
> [  818.988787] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2012
> [  818.988789]  00000000 00000000 c9561cf8 c06a8276 00000000 c9561d28 c02432f9 c080cf24
> [  818.988793]  00000000 0000751a fa1b7b6e 00001533 fa1a647b fa1a647b dade1140 dade1138
> [  818.988797]  dade1000 c9561d38 c024338d 00000009 00000000 c9561df4 fa1a647b dade1000
> [  818.988800] Call Trace:
> [  818.988858]  [<c06a8276>] dump_stack+0x41/0x52
> [  818.988941]  [<c02432f9>] warn_slowpath_common+0x79/0x90
> [  818.988962]  [<fa1a647b>] ? btrfs_ioctl_send+0x34b/0xeb0 [btrfs]
> [  818.988975]  [<fa1a647b>] ? btrfs_ioctl_send+0x34b/0xeb0 [btrfs]
> [  818.988977]  [<c024338d>] warn_slowpath_null+0x1d/0x20
> [  818.988990]  [<fa1a647b>] btrfs_ioctl_send+0x34b/0xeb0 [btrfs]
> [  818.989004]  [<fa171250>] ? update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
> [  818.989017]  [<fa1714f8>] btrfs_ioctl+0x2a8/0x33f0 [btrfs]
> [  818.989021]  [<c026f956>] ? update_cfs_rq_blocked_load+0x116/0x170
> [  818.989023]  [<c026fa55>] ? __enqueue_entity+0x65/0x70
> [  818.989025]  [<c0274aec>] ? enqueue_entity+0x31c/0xe60
> [  818.989028]  [<c0275c01>] ? enqueue_task_fair+0x5d1/0x7d0
> [  818.989031]  [<c02082b8>] ? sched_clock+0x8/0x10
> [  818.989043]  [<fa171250>] ? update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
> [  818.989048]  [<c03569a2>] do_vfs_ioctl+0x2d2/0x4b0
> [  818.989051]  [<c0269ceb>] ? resched_task+0x3b/0x50
> [  818.989053]  [<c026a6bd>] ? check_preempt_curr+0x5d/0x80
> [  818.989056]  [<c026c305>] ? wake_up_new_task+0xe5/0x140
> [  818.989058]  [<c0242780>] ? do_fork+0x100/0x2b0
> [  818.989061]  [<c0356bd8>] SyS_ioctl+0x58/0x80
> [  818.989063]  [<c06b4b59>] sysenter_do_call+0x12/0x28
> [  818.989065] ---[ end trace 7f6e499355102e48 ]---
> [  819.101601] BTRFS: device fsid 061bb332-4adc-4489-9a79-0931007b9d51 devid 1 transid 4 /dev/sdb2
> [  819.117930] BTRFS: device fsid 061bb332-4adc-4489-9a79-0931007b9d51 devid 1 transid 4 /dev/sdb2
> [  819.118653] BTRFS info (device sdb2): disk space caching is enabled
> [  819.118655] BTRFS: flagging fs with big metadata feature
> [  819.119958] BTRFS: creating UUID tree
> [  819.271220] BTRFS: device fsid 67b57caa-2cde-40b5-b3b4-c4732bfeacd9 devid 1 transid 247 /dev/sdb1
> [  819.272128] BTRFS info (device sdb1): disk space caching is enabled
>
> I test with latest btrfs-next and xfstest, with/without this patch applied, i can not pass btrfs/030.
> I don't know if there are some patches missing in btrfs-next.
>
> Feel free to tell me if i miss something here.^_^
>
Ok I've reproduced this on my VM, I'll try and get this fixed up. Thanks,

Josef
