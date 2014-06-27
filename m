Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:43073 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaF0F66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 01:58:58 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 2156B3EE0C2
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 14:58:57 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 33C9AAC0C5C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 14:58:56 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id CE144E08003
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 14:58:55 +0900 (JST)
Message-ID: <53AD0816.6020304@jp.fujitsu.com>
Date: Fri, 27 Jun 2014 14:58:46 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <franziska.naepelt@hiperscan.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: cancel btrfs delete job
References: <1403845244.4216.6.camel@hsew-frn.HIPERSCAN>
In-Reply-To: <1403845244.4216.6.camel@hsew-frn.HIPERSCAN>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Franziska,

(2014/06/27 14:00), Franziska Näpelt wrote:
> Hi!
>
> After about 12 hours of booting, the system runs now

Congratulations!

> The fifth harddrive is still in the btrfs-pool.
>
> Here is the log from the crash, while the btrfs delete job runs:
>
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957248] ------------[ cut
> here ]------------
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957268] WARNING: CPU: 3 PID:
> 31131 at fs/btrfs/super.c:259 __btrfs_abort_transaction+0x46/0xf8 [
> btrfs]()
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957270] Modules linked in:
> xts gf128mul tun parport_pc ppdev lp parport bnep rfcomm bluetooth rf
> kill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) cpufreq_powersave
> cpufreq_userspace cpufreq_stats cpufreq_conservative vboxdrv(O) binfm
> t_misc fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache
> sunrpc ext2 dm_crypt hwmon_vid loop firewire_sbp2 snd_hda_codec_hdmi snd
> _hda_intel joydev radeon ttm drm_kms_helper iTCO_wdt iTCO_vendor_support
> snd_hda_controller drm i2c_algo_bit snd_hda_codec snd_hwdep snd_pcm
>   i7core_edac snd_timer edac_core snd soundcore psmouse acpi_cpufreq
> coretemp processor kvm_intel kvm microcode lpc_ich mfd_core pcspkr asus_
> atk0110 ehci_pci mxm_wmi i2c_i801 i2c_core wmi serio_raw thermal_sys
> evdev button ext4 crc16 jbd2 mbcache btrfs xor raid6_pq dm_mod raid1 md
> _mod sg sd_mod crct10dif_generic crc_t10dif crct10dif_common hid_generic
> usbhid hid crc32c_intel firewire_ohci r8169 firewire_core mii crc_i
> tu_t sata_sil ahci libahci sata_mv uhci_hcd ehci_hcd
> Jun 25 20:34:59 hsad-srv-03 kernel: libata xhci_hcd scsi_mod usbcore
> usb_common
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957309] CPU: 3 PID: 31131
> Comm: find Tainted: G           O  3.15.0 #1
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957310] Hardware name:
> System manufacturer System Product Name/SABERTOOTH X58, BIOS 1304
> 08/02/2011
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957311]  0000000000000000
> 0000000000000009 ffffffff8138b54a ffff880001593b58
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957313]  ffffffff81039583
> 0000000000000000 ffffffffa01c8123 00000000000000b0
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957315]  00000000ffffffe4
> ffff880625fb9000 ffff8801077e8e80 ffffffffa0247ac0
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957317] Call Trace:
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957321]
> [<ffffffff8138b54a>] ? dump_stack+0x41/0x51
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957324]
> [<ffffffff81039583>] ? warn_slowpath_common+0x78/0x90
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957331]
> [<ffffffffa01c8123>] ? __btrfs_abort_transaction+0x46/0xf8 [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957333]
> [<ffffffff81039633>] ? warn_slowpath_fmt+0x45/0x4a
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957340]
> [<ffffffffa01c8123>] ? __btrfs_abort_transaction+0x46/0xf8 [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957348]
> [<ffffffffa01d648a>] ? __btrfs_free_extent+0x80a/0x84d [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957351]
> [<ffffffff8138db1c>] ? mutex_trylock+0x10/0x29
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957359]
> [<ffffffffa01dabfe>] ? __btrfs_run_delayed_refs+0xae4/0xc2b [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957368]
> [<ffffffffa01dc86c>] ? btrfs_run_delayed_refs+0x7b/0x17e [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957378]
> [<ffffffffa01ea1d7>] ? __btrfs_end_transaction+0xe5/0x2c0 [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957389]
> [<ffffffffa01ee9bb>] ? btrfs_dirty_inode+0x8c/0xa7 [btrfs]
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957391]
> [<ffffffff8111f12d>] ? touch_atime+0xe3/0x11c
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957393]
> [<ffffffff81119843>] ? iterate_dir+0x7c/0xa2
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957395]
> [<ffffffff81119949>] ? SyS_getdents+0x74/0xca
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957397]
> [<ffffffff811196ee>] ? filldir64+0xdd/0xdd
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957399]
> [<ffffffff81394522>] ? system_call_fastpath+0x16/0x1b
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957400] ---[ end trace
> 8392ac15dafb7de4 ]---
> Jun 25 20:34:59 hsad-srv-03 kernel: [614028.957422] BTRFS info (device
> sdh): forced readonly

Your delete job seemed to fail at __btrfs_abort_transaction(),
resulted in readonly remount at that time.

>
> After that event, there are furher entries in the messages log, but
> nothing interesting, only some dhcp infos. Three minutes later, the log
> stopped without any message.
>
> Does someone need further logs?

I have no idea.

Thanks,
Satoru

>
> best regards,
> Franziska
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

