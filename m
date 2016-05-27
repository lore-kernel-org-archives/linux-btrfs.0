Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:33000 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbcE0JnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 05:43:04 -0400
Received: by mail-ig0-f194.google.com with SMTP id l10so4229229igk.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 02:43:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CALJXSJr5UzJLjjOQvSEUJfwqPOMna_=2+PWgQnf1QJvMTMnaxA@mail.gmail.com>
References: <CALJXSJr5UzJLjjOQvSEUJfwqPOMna_=2+PWgQnf1QJvMTMnaxA@mail.gmail.com>
Date: Fri, 27 May 2016 10:43:03 +0100
Message-ID: <CAL3q7H7kKM7Zti2mfhK8KuuyOi+2KuJ8Z0O0eW2KTM0TggTWWg@mail.gmail.com>
Subject: Re: Starting btrfs defrag with xargs -P 2 locks
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 4:58 AM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> I was de-fragmenting a BTRFS recently and it was quite slow, so I
> decided to pipe find output to xargs -P 2 to speed up the file listing
> process and found out it breaks BTRFS quite fast. In 2 minutes, I had
> this in dmesg. As expected, btrfs command is deadlocked.
>
> btrfs-progs v4.2.2
>
>
> [3650924.735400] ------------[ cut here ]------------
> [3650924.735423] WARNING: CPU: 3 PID: 3561 at
> /home/zumbi/linux-4.3.5/fs/btrfs/locking.c:46
> btrfs_set_lock_blocking_rw+0xa2/0xb0 [btrfs]()
> [3650924.735424] Modules linked in: dccp_diag dccp udp_diag unix_diag
> ipt_REJECT nf_reject_ipv4 nf_log_ipv6 ip_vs_rr xt_ipvs ip_vs
> ip6table_filter xt_conntrack xt_multiport xt_limit xt_nat squashfs
> tcp_diag inet_diag nf_log_ipv4 nf_log_common xt_LOG xt_u32 xt_tcpudp
> xt_hashlimit xt_recent iptable_filter dm_snapshot dm_bufio veth
> vhost_net vhost macvtap macvlan tun cbc rbd libceph libcrc32c
> ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 binfmt_misc
> ip6_tables xt_REDIRECT nf_nat_redirect iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables nfsd
> auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc arc4 ecb md4
> hmac nls_utf8 cifs dns_resolver fscache nbd bridge bonding btrfs
> iTCO_wdt iTCO_vendor_support evdev coretemp ttm kvm_intel
> drm_kms_helper kvm
> [3650924.735464]  drm pcspkr dcdbas i7core_edac i2c_algo_bit edac_core
> acpi_power_meter 8250_fintek button acpi_cpufreq lpc_ich tpm_tis tpm
> mfd_core shpchp processor 8021q garp mrp stp llc loop ipmi_watchdog
> ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse parport_pc
> ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 dm_mod raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq raid1 md_mod sg sd_mod uas usb_storage crc32c_intel mvsas
> libsas ehci_pci libata ehci_hcd scsi_transport_sas bnx2 usbcore
> usb_common scsi_mod
> [3650924.735497] CPU: 3 PID: 3561 Comm: btrfs Tainted: G        W
>  4.3.0-0.bpo.1-amd64 #1 Debian 4.3.5-1~bpo8+1
> [3650924.735499] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS
> 1.5.2 10/15/2010
> [3650924.735500]  0000000000000000 00000000b671a633 ffffffff812e1ac9
> 0000000000000000
> [3650924.735502]  ffffffff81074451 ffff880039cc3a28 0000000000000000
> ffff8800b7528b80
> [3650924.735504]  ffff880039cc3a28 ffff8801fbe7eae0 ffffffffa0597c22
> 00000000000001ec
> [3650924.735507] Call Trace:
> [3650924.735512]  [<ffffffff812e1ac9>] ? dump_stack+0x40/0x57
> [3650924.735515]  [<ffffffff81074451>] ? warn_slowpath_common+0x81/0xb0
> [3650924.735530]  [<ffffffffa0597c22>] ?
> btrfs_set_lock_blocking_rw+0xa2/0xb0 [btrfs]
> [3650924.735537]  [<ffffffffa053620c>] ? btrfs_realloc_node+0xcc/0x490 [btrfs]
> [3650924.735551]  [<ffffffffa0574e2d>] ? btrfs_defrag_leaves+0x1ed/0x360 [btrfs]
> [3650924.735562]  [<ffffffffa055f316>] ? btrfs_defrag_root+0x56/0xe0 [btrfs]
> [3650924.735576]  [<ffffffffa0595446>] ? btrfs_ioctl_defrag+0x126/0x170 [btrfs]
> [3650924.735590]  [<ffffffffa05972e3>] ? btrfs_ioctl+0x1873/0x20f0 [btrfs]
> [3650924.735593]  [<ffffffff812fe069>] ? list_del+0x9/0x20
> [3650924.735596]  [<ffffffff810b2ff0>] ? remove_wait_queue+0x20/0x30
> [3650924.735598]  [<ffffffff813b279a>] ? n_tty_write+0x28a/0x4e0
> [3650924.735602]  [<ffffffff811e3465>] ? do_vfs_ioctl+0x2d5/0x4b0
> [3650924.735605]  [<ffffffff811d01b3>] ? vfs_write+0x143/0x190
> [3650924.735607]  [<ffffffff811e36b6>] ? SyS_ioctl+0x76/0x90
> [3650924.735611]  [<ffffffff8158a9f6>] ? system_call_fast_compare_end+0xc/0x6b
> [3650924.735612] ---[ end trace 0c5cdef70670d5c5 ]---
> [3650924.735628] ------------[ cut here ]------------
> [3650924.793031] kernel BUG at /home/zumbi/linux-4.3.5/fs/btrfs/locking.c:295!
> [3650924.876593] invalid opcode: 0000 [#1] SMP
> [3650924.927896] Modules linked in: dccp_diag dccp udp_diag unix_diag
> ipt_REJECT nf_reject_ipv4 nf_log_ipv6 ip_vs_rr xt_ipvs ip_vs
> ip6table_filter xt_conntrack xt_multiport xt_limit xt_nat squashfs
> tcp_diag inet_diag nf_log_ipv4 nf_log_common xt_LOG xt_u32 xt_tcpudp
> xt_hashlimit xt_recent iptable_filter dm_snapshot dm_bufio veth
> vhost_net vhost macvtap macvlan tun cbc rbd libceph libcrc32c
> ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 binfmt_misc
> ip6_tables xt_REDIRECT nf_nat_redirect iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables nfsd
> auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc arc4 ecb md4
> hmac nls_utf8 cifs dns_resolver fscache nbd bridge bonding btrfs
> iTCO_wdt iTCO_vendor_support evdev coretemp ttm kvm_intel
> drm_kms_helper kvm
> [3650925.783705]  drm pcspkr dcdbas i7core_edac i2c_algo_bit edac_core
> acpi_power_meter 8250_fintek button acpi_cpufreq lpc_ich tpm_tis tpm
> mfd_core shpchp processor 8021q garp mrp stp llc loop ipmi_watchdog
> ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse parport_pc
> ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 dm_mod raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq raid1 md_mod sg sd_mod uas usb_storage crc32c_intel mvsas
> libsas ehci_pci libata ehci_hcd scsi_transport_sas bnx2 usbcore
> usb_common scsi_mod
> [3650926.350014] CPU: 3 PID: 3561 Comm: btrfs Tainted: G        W
>  4.3.0-0.bpo.1-amd64 #1 Debian 4.3.5-1~bpo8+1
> [3650926.473013] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS
> 1.5.2 10/15/2010
> [3650926.564902] task: ffff8800a03acf80 ti: ffff8800242a8000 task.ti:
> ffff8800242a8000
> [3650926.656787] RIP: 0010:[<ffffffffa0597b75>]  [<ffffffffa0597b75>]
> btrfs_assert_tree_locked.part.1+0x5/0x10 [btrfs]
> [3650926.782049] RSP: 0018:ffff8800242abc28  EFLAGS: 00010246
> [3650926.847848] RAX: 0000000000000000 RBX: ffff880039cc3a28 RCX:
> 0000000000000006
> [3650926.935675] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000009
> [3650927.023399] RBP: 0000000000000000 R08: 000000000000000a R09:
> 000000000000fffe
> [3650927.111125] R10: 0000000000000386 R11: 0000000000000002 R12:
> ffff8800b7528b80
> [3650927.198954] R13: ffff880039cc3a28 R14: ffff8801fbe7eae0 R15:
> 0000000000000000
> [3650927.286679] FS:  00007fdefc02a8c0(0000) GS:ffff88042f260000(0000)
> knlGS:0000000000000000
> [3650927.385850] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [3650927.457027] CR2: 00007fdefc045000 CR3: 00000002d32e3000 CR4:
> 00000000000006e0
> [3650927.544753] Stack:
> [3650927.571080]  ffffffffa0597c13 00000000000001ec ffffffffa053620c
> 00000000b671a633
> [3650927.662135]  0000000000000002 0000000000000003 00004000000001ec
> ffff8800b7528b80
> [3650927.753291]  ffff880039cc3c58 ffff8800b7528800 0000000000000000
> ffff8801fbe7eae0
> [3650927.844451] Call Trace:
> [3650927.875790]  [<ffffffffa0597c13>] ?
> btrfs_set_lock_blocking_rw+0x93/0xb0 [btrfs]
> [3650927.966524]  [<ffffffffa053620c>] ? btrfs_realloc_node+0xcc/0x490 [btrfs]
> [3650928.050090]  [<ffffffffa0574e2d>] ? btrfs_defrag_leaves+0x1ed/0x360 [btrfs]
> [3650928.135629]  [<ffffffffa055f316>] ? btrfs_defrag_root+0x56/0xe0 [btrfs]
> [3650928.217007]  [<ffffffffa0595446>] ? btrfs_ioctl_defrag+0x126/0x170 [btrfs]
> [3650928.301610]  [<ffffffffa05972e3>] ? btrfs_ioctl+0x1873/0x20f0 [btrfs]
> [3650928.381102]  [<ffffffff812fe069>] ? list_del+0x9/0x20
> [3650928.443851]  [<ffffffff810b2ff0>] ? remove_wait_queue+0x20/0x30
> [3650928.517007]  [<ffffffff813b279a>] ? n_tty_write+0x28a/0x4e0
> [3650928.586001]  [<ffffffff811e3465>] ? do_vfs_ioctl+0x2d5/0x4b0
> [3650928.656138]  [<ffffffff811d01b3>] ? vfs_write+0x143/0x190
> [3650928.723050]  [<ffffffff811e36b6>] ? SyS_ioctl+0x76/0x90
> [3650928.787883]  [<ffffffff8158a9f6>] ? system_call_fast_compare_end+0xc/0x6b
> [3650928.871547] Code: ff ff ff e8 6e 65 c5 e0 e9 94 e0 ff ff 66 0f 1f
> 84 00 00 00 00 00 66 66 66 66 90 0f 0b 66 0f 1f 84 00 00 00 00 00 66
> 66 66 66 90 <0f> 0b 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 66 83
> 7f 5c
> [3650929.107439] RIP  [<ffffffffa0597b75>]
> btrfs_assert_tree_locked.part.1+0x5/0x10 [btrfs]
> [3650929.204547]  RSP <ffff8800242abc28>
> [3650929.248779] ---[ end trace 0c5cdef70670d5c6 ]---

Hi,

We got this fixed in the 4.5 kernel with commit:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0376374a98abd533fb49c6db12967bddc2f4b4b3


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
