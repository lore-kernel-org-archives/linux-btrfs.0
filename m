Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31529 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbbBIFFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 00:05:02 -0500
Message-ID: <54D83FFE.3040004@cn.fujitsu.com>
Date: Mon, 9 Feb 2015 13:05:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123
References: <CAPRPZsD_=nWMzs2L7wh172kbSHK5ydb+geTwuMpZYwHEVRcEKQ@mail.gmail.com>
In-Reply-To: <CAPRPZsD_=nWMzs2L7wh172kbSHK5ydb+geTwuMpZYwHEVRcEKQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年02月09日 06:14
> Hi,
>
>
> I have a LUKS encrypted raw external (USB) disk mapped to
> /dev/mapper/sd.backup. This mapped device was default btrfs formatted.
> I can mount the mapped device to /mnt/backup. There used to be a
> subvolume in /mnt/backup, which I deleted.
>
> I now seem unable to either add a directory to /mnt/backup or umount
> /mnt/backup; the command never finishes and the dmesg log reports:
>
> [17937.939438] ------------[ cut here ]------------
> [17937.939523] kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123!
> [17937.939602] invalid opcode: 0000 [#1] SMP
> [17937.939664] Modules linked in: xts gf128mul rfcomm bluetooth joydev
> hid_logitech_dj xt_multiport nfsd auth_rpcgss nfs_acl nfs lockd grace
> sunrpc fscache dm_crypt xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
> xt_physdev br_netfilter xt_tcpudp xt_conntrack iptable_filter
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables ebtable_filter ebtable_broute bridge stp llc
> ebtables x_tables eeepc_wmi asus_wmi sparse_keymap video kvm_amd kvm
> pl2303 usbserial serio_raw k10temp snd_usb_audio snd_usbmidi_lib
> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic
> snd_hda_intel sp5100_tco snd_hda_controller i2c_piix4 snd_hda_codec
> snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
> snd_seq_device snd_timer snd shpchp soundcore 8250_fintek mac_hid
> parport_pc
> [17937.940798]  ppdev lp parport nct6775 nls_iso8859_1 hwmon_vid btrfs
> raid10 raid1 multipath linear raid0 raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx hid_generic usbhid hid xor
> raid6_pq psmouse radeon uas usb_storage r8169 i2c_algo_bit ttm mii
> drm_kms_helper drm wmi ahci libahci
> [17937.941259] CPU: 1 PID: 16331 Comm: btrfs-cleaner Not tainted
> 3.18.3-031803-generic #201501161810
> [17937.941358] Hardware name: System manufacturer System Product
> Name/E45M1-M PRO, BIOS 0801 01/10/2012
> [17937.941464] task: ffff88023383a800 ti: ffff880183868000 task.ti:
> ffff880183868000
> [17937.941547] RIP: 0010:[<ffffffffc04dd109>]  [<ffffffffc04dd109>]
> btrfs_orphan_add+0x1a9/0x1c0 [btrfs]
> [17937.941705] RSP: 0018:ffff88018386bc98  EFLAGS: 00010286
> [17937.941769] RAX: 00000000ffffffe4 RBX: ffff8801ebe6b000 RCX: 0000000000000000
> [17937.941849] RDX: 0000000000005cb8 RSI: 0000000000040000 RDI: ffff8801b7f85138
> [17937.941928] RBP: ffff88018386bcd8 R08: ffff88023ed1db40 R09: ffff88019ab07b40
> [17937.942007] R10: 0000000000000000 R11: 0000000000000010 R12: ffff880233513630
> [17937.942086] R13: ffff880041414d58 R14: ffff8801ebe6b458 R15: 0000000000000001
> [17937.942168] FS:  00007f8d60824740(0000) GS:ffff88023ed00000(0000)
> knlGS:0000000000000000
> [17937.942261] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [17937.942327] CR2: 00007f70b2ec0000 CR3: 0000000124627000 CR4: 00000000000007e0
> [17937.942406] Stack:
> [17937.942435]  ffff88018386bcd8 ffffffffc051bd4f ffff8801b93b9000
> ffff880204bbe200
> [17937.942537]  ffff8801b93b9000 ffff88019ab07b40 ffff880233513630
> 0000000000000001
> [17937.942640]  ffff88018386bd58 ffffffffc04c5310 ffff8801b7f85000
> 00000004c04abffa
> [17937.942742] Call Trace:
> [17937.942819]  [<ffffffffc051bd4f>] ?
> lookup_free_space_inode+0x4f/0x100 [btrfs]
> [17937.942934]  [<ffffffffc04c5310>]
> btrfs_remove_block_group+0x140/0x490 [btrfs]
> [17937.943056]  [<ffffffffc0500065>] btrfs_remove_chunk+0x245/0x380 [btrfs]
> [17937.943163]  [<ffffffffc04c5896>] btrfs_delete_unused_bgs+0x236/0x270 [btrfs]
> [17937.943272]  [<ffffffffc04ced6c>] cleaner_kthread+0x12c/0x190 [btrfs]
> [17937.943374]  [<ffffffffc04cec40>] ?
> btrfs_destroy_all_delalloc_inodes+0x120/0x120 [btrfs]
> [17937.943471]  [<ffffffff85093a49>] kthread+0xc9/0xe0
> [17937.943531]  [<ffffffff85093980>] ? flush_kthread_worker+0x90/0x90
> [17937.943608]  [<ffffffff857b3b7c>] ret_from_fork+0x7c/0xb0
> [17937.943673]  [<ffffffff85093980>] ? flush_kthread_worker+0x90/0x90
> [17937.943746] Code: e8 4d 9f fc ff 8b 45 c8 e9 6d ff ff ff 0f 1f 44
> 00 00 f0 41 80 65 80 fd 4c 89 ef 89 45 c8 e8 bf 1e fe ff 8b 45 c8 e9
> 48 ff ff ff <0f> 0b 4c 89 f7 45 31 f6 e8 ea 64 2d c5 e9 f9 fe ff ff 0f
> 1f 44
> [17937.944273] RIP  [<ffffffffc04dd109>] btrfs_orphan_add+0x1a9/0x1c0 [btrfs]
> [17937.944392]  RSP <ffff88018386bc98>
> [17937.944503] ---[ end trace cee2bcd2393b84fb ]---
The BUG_ON in btrfs_orphan_add() seems have already been fixed by the 
patch from Forrest Liu.
[PATCH] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block 
group

https://patchwork.kernel.org/patch/5759741/

Thanks,
Qu
> $ uname -a:
> Linux zacate 3.18.3-031803-generic #201501161810 SMP Fri Jan 16
> 18:12:22 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> I also ran '$ sudo btrfs check /dev/mapper/sd.backup':
> Checking filesystem on /dev/mapper/sd.backup
> UUID: 15628b78-7380-4d57-bc77-426016205aa0
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 35881083 bytes used err is 0
> total csum bytes: 0
> total tree bytes: 360448
> total fs tree bytes: 32768
> total extent tree bytes: 81920
> btree space waste bytes: 194142
> file data blocks allocated: 67371008
>   referenced 67371008
> Btrfs v3.18.2
>
> $ sudo btrfs fi show
> Label: none  uuid: 6815db4b-bbde-4c98-8cb3-4f984f9bc99f
>          Total devices 1 FS bytes used 4.35GiB
>          devid    1 size 103.81GiB used 30.02GiB path /dev/sdf2
> Label: none  uuid: 81f5565e-e4e4-4f45-938a-9bd0ba435271
>          Total devices 4 FS bytes used 2.59TiB
>          devid    1 size 2.73TiB used 886.18GiB path /dev/sdd
>          devid    2 size 2.73TiB used 886.16GiB path /dev/sdc
>          devid    3 size 2.73TiB used 886.16GiB path /dev/sdb
>          devid    4 size 2.73TiB used 886.16GiB path /dev/sda
> (does not show the affected filesystem; just hangs here)
>
> I'm using git btrfs-progs, BUT with Ubuntu btrfs-tools still installed
> (to take care of btrfs RAID device detection during boot / mount -
> initrd and whatnot), so with the new btrfs-progs in /usr/local/bin and
> the old one in /sbin.
>
> I'm fairly sure I have created the affected filesystem with the
> original btrfs-tools (btrfs in /sbin), which is apparently version
> v3.14.1. What I do not understand is why the (empty) filesystem checks
> out ok with the most recent userland tools and still seems to be
> corrupt.
>
> I could try reformatting but I'll keep the disk in the state it is now
> to allow debugging.
>
> Please let me know if I can (or should) do additional tests.
>
>
> J.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

