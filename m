Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49165 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759250AbdEWDmB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 23:42:01 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:48326 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1dD0ho-0000Lt-SP
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 20:42:00 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1dD0ho-0001sm-Dm
        for linux-btrfs@vger.kernel.org; Mon, 22 May 2017 20:41:56 -0700
Date: Mon, 22 May 2017 20:41:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170523034156.t4oavzypwebxcqp2@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: WARNING: CPU: 5 PID: 19734 at fs/btrfs/send.c:6290
 btrfs_ioctl_send+0xad/0xde2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is probably not a bug I should report and simply an issue with the
filesystem I'm trying to get data out of, but reporting it just in case
it's useful somehow.

/*
 * This is done when we lookup the root, it should already be complete
 * by the time we get here.
 */
WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);



WARNING: CPU: 5 PID: 19734 at fs/btrfs/send.c:6290 btrfs_ioctl_send+0xad/0xde2
Modules linked in: udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebta bles ppdev lp hfs ntfs vfat msdos fat jfs xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_m isc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt _mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm _snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_cmipci snd_mpu401_uart snd_hda_codec asix snd_opl3_lib tpm_infineon eeepc_wmi
 snd_hda_core tpm_tis snd_hwdep snd_rawmidi rc_ati_x10 usbnet asus_wmi snd_seq_device sparse_keymap libphy ati_remote snd_pcm lpc_ich tpm_tis_core input_leds rfkill rc_core usbserial i2c_i801 evdev mei_me parport_pc hwmon pcspkr snd_timer i915 snd wmi tpm battery parport soundcore e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd ehci_pci xhci_pci ehci_hcd xhci_hcd sata_sil24 mvsas r8169 libsas usbcore mii fan scsi_transport_sas thermal [last unloaded: ftdi_sio]
CPU: 5 PID: 19734 Comm: btrfs Tainted: G     U  W       4.11.1-amd64-preempt-sysrq-20170406 #4
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Call Trace:
 dump_stack+0x61/0x7d
 __warn+0xc2/0xdd
 warn_slowpath_null+0x1d/0x1f
 btrfs_ioctl_send+0xad/0xde2
 ? get_mem_cgroup_from_mm+0x4c/0x54
 ? memcg_kmem_get_cache+0xfb/0x10c
 ? set_task_rq+0x34/0x83
 btrfs_ioctl+0x168c/0x1e22
 ? __default_send_IPI_dest_field+0x58/0x5f
 ? flat_send_IPI_mask+0x11/0x13
 ? default_send_IPI_single+0x39/0x3b
 ? native_smp_send_reschedule+0x3a/0x3c
 ? smp_send_reschedule+0xa/0xc
 ? resched_curr+0x4e/0x58
 ? check_preempt_wakeup+0x147/0x1be
 vfs_ioctl+0x21/0x38
 ? vfs_ioctl+0x21/0x38
 do_vfs_ioctl+0x4ef/0x537
 ? current_kernel_time64+0x10/0x36
 ? __fget+0x6d/0x79
 SyS_ioctl+0x57/0x7b
 do_syscall_64+0x6b/0x7d
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f670352ccc7
RSP: 002b:00007ffd84f76158 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f670352ccc7
RDX: 00007ffd84f761e0 RSI: 0000000040489426 RDI: 0000000000000004
RBP: 0000000000000004 R08: 00007f670344b700 R09: 00007f670344b700
R10: 00007f670344b9d0 R11: 0000000000000202 R12: 0000000000000001
R13: 000055c4e6cdf010 R14: 0000000000000001 R15: 0000000000000001
---[ end trace 203f8b2c86a5f883 ]---

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
