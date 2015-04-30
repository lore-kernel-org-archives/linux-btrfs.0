Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36177 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbbD3EPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 00:15:03 -0400
Received: by qgeb100 with SMTP id b100so20254351qge.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 21:15:02 -0700 (PDT)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by mx.google.com with ESMTPSA id b141sm640545qka.11.2015.04.29.21.15.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2015 21:15:02 -0700 (PDT)
Message-ID: <5541AC44.3080008@gmail.com>
Date: Thu, 30 Apr 2015 00:15:00 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: WARNING during btrfs send, kernel 4.1-rc1
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sand & receive from the same machine, from a read-only mount to a 
freshly formatted fs. Aside from the warning everything appears to
be working correctly, but since this is the latest btrfs code it 
needed reporting.

I'll probably have another opportunity to test this again, since I'm 
blowing up my array repeatedly trying to track down a bcache bug.

line number translates to:

    /*
     * This is done when we lookup the root, it should already be complete
     * by the time we get here.
     */
    WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);

[  267.379126] ------------[ cut here ]------------
[  267.379202] WARNING: CPU: 1 PID: 4423 at fs/btrfs/send.c:5699 btrfs_ioctl_send+0x9d/0xe47()
[  267.379297] Modules linked in: binfmt_misc tun nbd rpcsec_gss_krb5 sit ip6table_filter ip6_tables ipt_REJECT nf_reject_ipv4 xt_conntrack xt_multiport iptable_filter xt_length xt_mark iptable_mangle iptable_raw ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_nat xt_tcpudp iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables powernow_k8 pcspkr serio_raw k8temp i2c_piix4 i2c_core rtc_cmos wmi acpi_cpufreq netconsole it87 hwmon_vid ecryptfs ide_pci_generic firewire_ohci firewire_core sata_promise atiixp ide_core e100 pata_acpi ohci_pci sg ohci_hcd ehci_pci ehci_hcd
[  267.381752] CPU: 1 PID: 4423 Comm: btrfs Not tainted 4.1.0-rc1 #1
[  267.381813] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GPM-DS2H/GA-MA78GPM-DS2H, BIOS F1 06/03/2008
[  267.381880]  0000000000000009 ffff8801f613fc18 ffffffff8169d2be 0000000080000000
[  267.382112]  0000000000000000 ffff8801f613fc58 ffffffff81045577 ffff8800bbd9a000
[  267.382342]  ffffffff81306f46 ffff8800c51ee42c 00007ffc4b080bc0 ffff880224699100
[  267.382566] Call Trace:
[  267.382630]  [<ffffffff8169d2be>] dump_stack+0x4f/0x7b
[  267.382686]  [<ffffffff81045577>] warn_slowpath_common+0x9c/0xb6
[  267.382747]  [<ffffffff81306f46>] ? btrfs_ioctl_send+0x9d/0xe47
[  267.382809]  [<ffffffff81045625>] warn_slowpath_null+0x15/0x17
[  267.382869]  [<ffffffff81306f46>] btrfs_ioctl_send+0x9d/0xe47
[  267.382931]  [<ffffffff816a3c10>] ? _raw_spin_unlock_irq+0x17/0x29
[  267.382994]  [<ffffffff816a0d66>] ? __schedule+0x6df/0x90e
[  267.383057]  [<ffffffff812d7691>] btrfs_ioctl+0x18a/0x2436
[  267.383119]  [<ffffffff81068ccd>] ? sched_move_task+0x185/0x194
[  267.383183]  [<ffffffff8137d28c>] ? find_next_bit+0x15/0x1b
[  267.383244]  [<ffffffff8106b1ba>] ? __enqueue_entity+0x67/0x69
[  267.383306]  [<ffffffff8106d4ab>] ? enqueue_task_fair+0xc00/0xcda
[  267.383367]  [<ffffffff810697cc>] ? sched_clock_cpu+0x67/0xbc
[  267.383431]  [<ffffffff81322201>] ? avc_has_perm+0x96/0xf8
[  267.383495]  [<ffffffff81153d51>] do_vfs_ioctl+0x372/0x420
[  267.383558]  [<ffffffff8115bc80>] ? __fget+0x6b/0x76
[  267.383619]  [<ffffffff81153e54>] SyS_ioctl+0x55/0x7a
[  267.383680]  [<ffffffff816a419b>] system_call_fastpath+0x16/0x6e
[  267.383741] ---[ end trace 01d1110aa9307411 ]---

