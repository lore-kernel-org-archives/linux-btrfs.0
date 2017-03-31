Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56991 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdCaOv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 10:51:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2938BAB07
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 14:51:12 +0000 (UTC)
Date: Fri, 31 Mar 2017 07:51:04 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: linux-btrfs@vger.kernel.org
Subject: WARN splat fs/btrfs/qgroup.c
Message-ID: <20170331145104.GA2270@linux-80c1.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While doing a regular kernel build I triggered the following splat
on a vanilla v4.11-rc4 kernel.

[73253.814880] WARNING: CPU: 20 PID: 631 at fs/btrfs/qgroup.c:2472 btrfs_qgroup_free_refroot+0x154/0x180 [btrfs]
[73253.814880] Modules linked in: st(E) sr_mod(E) cdrom(E) nfsv3(E) nfs_acl(E) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) fscache(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) msr(E) ext4(E) crc16(E) jbd2(E) mbcache(E) intel_rapl(E) sb_edac(E) edac_core(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) igb(E) ghash_clmulni_intel(E) iTCO_wdt(E) joydev(E) pcbc(E) aesni_intel(E) ipmi_ssif(E) aes_x86_64(E) ptp(E) iTCO_vendor_support(E) crypto_simd(E) glue_helper(E) pps_core(E) lpc_ich(E) ioatdma(E) pcspkr(E) dca(E) mfd_core(E) cryptd(E) i2c_i801(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E)
[73253.814893]  wmi(E) shpchp(E) button(E) sunrpc(E) btrfs(E) hid_generic(E) xor(E) usbhid(E) raid6_pq(E) sd_mod(E) mgag200(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) ttm(E) isci(E) ehci_pci(E) ahci(E) ehci_hcd(E) libsas(E) crc32c_intel(E) scsi_transport_sas(E) libahci(E) drm(E) usbcore(E) libata(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) autofs4(E)
[73253.814901] CPU: 20 PID: 631 Comm: btrfs-transacti Tainted: G        W   E   4.11.0-rc4-92.11-default+ #2
[73253.814901] Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS RMLCRB.86I.R1.25.D670.1303141058 03/14/2013
[73253.814902] Call Trace:
[73253.814903]  dump_stack+0x63/0x87
[73253.814905]  __warn+0xd1/0xf0
[73253.814906]  warn_slowpath_null+0x1d/0x20
[73253.814915]  btrfs_qgroup_free_refroot+0x154/0x180 [btrfs]
[73253.814923]  __btrfs_run_delayed_refs.constprop.73+0x309/0x1300 [btrfs]
[73253.814932]  btrfs_run_delayed_refs+0x7e/0x2e0 [btrfs]
[73253.814941]  btrfs_commit_transaction+0x39/0x950 [btrfs]
[73253.814948]  ? start_transaction+0xaa/0x490 [btrfs]
[73253.814956]  transaction_kthread+0x18a/0x1c0 [btrfs]
[73253.814958]  kthread+0x101/0x140
[73253.814965]  ? btrfs_cleanup_transaction+0x4f0/0x4f0 [btrfs]
[73253.814966]  ? kthread_park+0x90/0x90
[73253.814967]  ret_from_fork+0x2c/0x40

Any ideas?

Thanks,
Davidlohr
