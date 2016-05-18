Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbcERWrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 18:47:11 -0400
Date: Thu, 19 May 2016 00:46:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: introduce ticketed enospc infrastructure
Message-ID: <20160518224642.GC511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458926760-17563-8-git-send-email-jbacik@fb.com>
 <1463506255-15918-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463506255-15918-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 01:30:55PM -0400, Josef Bacik wrote:
> V1->V2:
> -fixed a check in space_info_add_old_bytes where we didn't take into account
>  bytes_may_used for the space used.
> -don't count ticket->bytes when checking overcommit.

I still see the warning in generic/333, same as with v1.

2016-05-19T00:44:33.232414+02:00 ben kernel: ------------[ cut here ]------------
2016-05-19T00:44:33.232446+02:00 ben kernel: WARNING: CPU: 2 PID: 3559 at fs/btrfs/extent-tree.c:2956 btrfs_run_delayed_refs+0x27d/0x2a0 [btrfs]
2016-05-19T00:44:33.232448+02:00 ben kernel: BTRFS: Transaction aborted (error -28)
2016-05-19T00:44:33.242936+02:00 ben kernel: Modules linked in: nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc fscache af_packet bridge stp llc iscsi_ibft iscsi_boot_sysfs msr btrfs radeon i2c_algo_bit drm_kms_helper coretemp kvm_intel syscopyarea sysfillrect sysimgblt fb_sys_fops ttm xor kvm raid6_pq drm e1000e dm_mod pcspkr ptp iTCO_wdt gpio_ich i5000_edac pps_core edac_core i2c_i801 iTCO_vendor_support lpc_ich mfd_core ppdev parport_pc intel_rng i5k_amb parport irqbypass serio_raw button ata_generic uhci_hcd ehci_pci ehci_hcd ata_piix usbcore aic79xx usb_common scsi_transport_spi sg [last unloaded: floppy]
2016-05-19T00:44:33.242960+02:00 ben kernel: CPU: 2 PID: 3559 Comm: btrfs-transacti Not tainted 4.6.0-rc5-vanilla+ #14
2016-05-19T00:44:33.242963+02:00 ben kernel: Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 07/26/2006
2016-05-19T00:44:33.242964+02:00 ben kernel: 0000000000000000 ffff88017de1bd20 ffffffff8139d86a ffff88017de1bd70
2016-05-19T00:44:33.242966+02:00 ben kernel: 0000000000000000 ffff88017de1bd60 ffffffff81080941 00000b8c3279c6c0
2016-05-19T00:44:33.242967+02:00 ben kernel: ffff8802274fb0a0 ffff8800b5f8d000 ffff88023279c6c0 ffff8800b5f8d000
2016-05-19T00:44:33.242969+02:00 ben kernel: Call Trace:
2016-05-19T00:44:33.242970+02:00 ben kernel: [<ffffffff8139d86a>] dump_stack+0x63/0x89
2016-05-19T00:44:33.242972+02:00 ben kernel: [<ffffffff81080941>] __warn+0xd1/0xf0
2016-05-19T00:44:33.242973+02:00 ben kernel: [<ffffffff810809af>] warn_slowpath_fmt+0x4f/0x60
2016-05-19T00:44:33.242975+02:00 ben kernel: [<ffffffffa0b1a09d>] btrfs_run_delayed_refs+0x27d/0x2a0 [btrfs]
2016-05-19T00:44:33.242977+02:00 ben kernel: [<ffffffff810ecef8>] ? del_timer_sync+0x48/0x50
2016-05-19T00:44:33.242978+02:00 ben kernel: [<ffffffffa0b300d3>] btrfs_commit_transaction+0x43/0xae0 [btrfs]
2016-05-19T00:44:33.242979+02:00 ben kernel: [<ffffffffa0b2b1cc>] transaction_kthread+0x1cc/0x1f0 [btrfs]
2016-05-19T00:44:33.242981+02:00 ben kernel: [<ffffffffa0b2b000>] ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
2016-05-19T00:44:33.242983+02:00 ben kernel: [<ffffffff8109fab9>] kthread+0xc9/0xe0
2016-05-19T00:44:33.242984+02:00 ben kernel: [<ffffffff816b2462>] ret_from_fork+0x22/0x40
2016-05-19T00:44:33.242986+02:00 ben kernel: [<ffffffff8109f9f0>] ? kthread_create_on_node+0x180/0x180
2016-05-19T00:44:33.242988+02:00 ben kernel: ---[ end trace a9fa5269514f9444 ]---
2016-05-19T00:44:33.242990+02:00 ben kernel: BTRFS: error (device sdc) in btrfs_run_delayed_refs:2956: errno=-28 No space left
2016-05-19T00:44:33.242992+02:00 ben kernel: BTRFS info (device sdc): forced readonly
