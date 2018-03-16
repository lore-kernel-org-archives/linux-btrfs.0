Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:40774 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeCPVjx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 17:39:53 -0400
Received: by mail-it0-f46.google.com with SMTP id y20-v6so3737647itc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 14:39:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Fri, 16 Mar 2018 14:39:52 -0700
Message-ID: <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 2:07 PM, Mike Stevens <michael.stevens@bayer.com> wrote:
>> That's a hell of a filesystem. RAID5 and RAID5 is unstable and should
>> not be used for anything but throw away data. You will be happy that you
>> value you data enough to have backups.... because all sensible sysadmins
>> do have backups correct?! (Do read just about any of Duncan's replies -
>> he describes this better than me).
>
> It's a backup of a backup of a very large filesystem.  Nothing I want to sync again,
> but not a critical data loss if I have to.
>
>> Also if you are running kernel ***3.10*** that is nearly antique in
>> btrfs terms. As a word of advise, try a more recent kernel (there have
>> been lots of patches to raid5/6 since kernel 4.9) and if you ever get
>> the filesystem running again then *at least* rebalance the metadata to
>> raid1 as quickly as possible as the raid1 profile is (unlike raid5 or
>> raid6) working really well.
>
> Not being in the kernel space much, I did not realize how far behind I was.
> I've updated to 4.15.10 with a different crash at least.
>

Could you please paste the whole dmesg, it looks like it hit
btrfs_abort_transaction(),
which should give us more information about where goes wrong.

thanks,
liubo

> Mar 15 14:03:06 auswscs9903 kernel: WARNING: CPU: 6 PID: 2720 at fs/btrfs/extent-tree.c:10192 btrfs_create_pending_block_groups+0x1f3/0x260 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: Modules linked in: nfsv3 nfs fscache mpt3sas raid_class mptctl mptbase binfmt_misc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_comment xt_multiport xt_conntrack nf_conntrack libcrc32c iptable_filter dm_mirror dm_region_hash dm_log dm_mod dax iTCO_wdt iTCO_vendor_support btrfs ses enclosure scsi_transport_sas xor zstd_decompress zstd_compress xxhash raid6_pq sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper cryptd intel_cstate lpc_ich sg intel_rapl_perf pcspkr joydev input_leds i2c_i801 mfd_core mei_me mei ipmi_si ipmi_devintf shpchp wmi ioatdma ipmi_msghandler acpi_power_meter acpi_pad nfsd nfs_acl lockd grace auth_rpcgss sunrpc ip_tables ext4 mbcache
> Mar 15 14:03:06 auswscs9903 kernel: jbd2 sd_mod crc32c_intel ast drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ahci ttm libahci igb ptp drm pps_core i2c_algo_bit libata myri10ge megaraid_sas dca
> Mar 15 14:03:06 auswscs9903 kernel: CPU: 6 PID: 2720 Comm: btrfs Not tainted 4.15.10-1.el7.elrepo.x86_64 #1
> Mar 15 14:03:06 auswscs9903 kernel: Hardware name: Supermicro Super Server/X10DRL-i, BIOS 1.1b 09/11/2015
> Mar 15 14:03:06 auswscs9903 kernel: RIP: 0010:btrfs_create_pending_block_groups+0x1f3/0x260 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: RSP: 0018:ffffc90009c2fae8 EFLAGS: 00010282
> Mar 15 14:03:06 auswscs9903 kernel: RAX: 0000000000000000 RBX: 00000000ffffffe5 RCX: 0000000000000006
> Mar 15 14:03:06 auswscs9903 kernel: RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff88103f3969d0
> Mar 15 14:03:06 auswscs9903 kernel: RBP: ffffc90009c2fb68 R08: 0000000000000000 R09: 0000000000000525
> Mar 15 14:03:06 auswscs9903 kernel: R10: 0000000000000004 R11: 0000000000000524 R12: ffff88100d7c7000
> Mar 15 14:03:06 auswscs9903 kernel: R13: ffff880fc6985800 R14: ffff88100d7c6f48 R15: ffff880fc6985920
> Mar 15 14:03:06 auswscs9903 kernel: FS:  00007fc1564b6700(0000) GS:ffff88103f380000(0000) knlGS:0000000000000000
> Mar 15 14:03:06 auswscs9903 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Mar 15 14:03:06 auswscs9903 kernel: CR2: 00000000016a5330 CR3: 0000000fc6310005 CR4: 00000000001606e0
> Mar 15 14:03:06 auswscs9903 kernel: Call Trace:
> Mar 15 14:03:06 auswscs9903 kernel: do_chunk_alloc+0x269/0x2e0 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? start_transaction+0xa7/0x450 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_inc_block_group_ro+0x142/0x160 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: scrub_enumerate_chunks+0x1ad/0x680 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? try_to_wake_up+0x59/0x480
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_scrub_dev+0x21d/0x540 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? __check_object_size+0x159/0x190
> Mar 15 14:03:06 auswscs9903 kernel: ? _copy_from_user+0x33/0x70
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_ioctl+0xf20/0x2110 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? audit_filter_rules.isra.9+0x241/0xe80
> Mar 15 14:03:06 auswscs9903 kernel: do_vfs_ioctl+0xaa/0x610
> Mar 15 14:03:06 auswscs9903 kernel: ? __audit_syscall_entry+0xac/0xf0
> Mar 15 14:03:06 auswscs9903 kernel: ? syscall_trace_enter+0x1cd/0x2b0
> Mar 15 14:03:06 auswscs9903 kernel: SyS_ioctl+0x79/0x90
> Mar 15 14:03:06 auswscs9903 kernel: do_syscall_64+0x79/0x1b0
> Mar 15 14:03:06 auswscs9903 kernel: entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Mar 15 14:03:06 auswscs9903 kernel: RIP: 0033:0x7fc1565a6107
> Mar 15 14:03:06 auswscs9903 kernel: RSP: 002b:00007fc1564b5d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> Mar 15 14:03:06 auswscs9903 kernel: RAX: ffffffffffffffda RBX: 000000000168a3a0 RCX: 00007fc1565a6107
> Mar 15 14:03:06 auswscs9903 kernel: RDX: 000000000168a3a0 RSI: 00000000c400941b RDI: 0000000000000003
> Mar 15 14:03:06 auswscs9903 kernel: RBP: 0000000000000000 R08: 00007fc1564b6700 R09: 0000000000000000
> Mar 15 14:03:06 auswscs9903 kernel: R10: 00007fc1564b6700 R11: 0000000000000246 R12: 00007fc1564b64e0
> Mar 15 14:03:06 auswscs9903 kernel: R13: 00007fc1564b69c0 R14: 00007fc1564b6700 R15: 0000000000000001
> Mar 15 14:03:06 auswscs9903 kernel: Code: 00 e9 5d ff ff ff 49 8b 44 24 60 f0 0f ba a8 d8 cd 00 00 02 72 17 83 fb fb 74 2d 89 de 48 c7 c7 d8 68 77 a0 31 c0 e8 cd 8f 9b e0 <0f> 0b 89 d9 ba d0 27 00 00 48 c7 c6 60 f7 76 a0 4c 89 e7 e8 18
>
> ________________________________________________________________________
> The information contained in this e-mail is for the exclusive use of the
> intended recipient(s) and may be confidential, proprietary, and/or
> legally privileged.  Inadvertent disclosure of this message does not
> constitute a waiver of any privilege.  If you receive this message in
> error, please do not directly or indirectly use, print, copy, forward,
> or disclose any part of this message.  Please also delete this e-mail
> and all copies and notify the sender.  Thank you.
> ________________________________________________________________________
