Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:41584 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVWa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 18:30:57 -0400
Received: by mail-qe0-f48.google.com with SMTP id nd7so1621162qeb.7
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 15:30:56 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 00:30:56 +0200
Message-ID: <CAD+_0Yr2P=OK3w3RvUw1VE0dijph99NNgEwgB61ht4ncvF4aOA@mail.gmail.com>
Subject: Deleting a subvolume causes RO remount
From: Rain Maker <rainmaker52@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I'm still busy trying to figure out how to get VMs running without
corruption (see
http://www.spinics.net/lists/linux-btrfs/msg27300.html) and in the
process of this, I tried to remove the "@vmware" subvolume I've made.

This seems to trigger some bug, as dmesg is showing an OOPS (2 I
believe). The filesystem is then remounted read-only.

I am running kernel 3.12-rc1, but I can also confirm this o 3.11.0.
The storage setup is:
- 2 physical disks (sda = HDD, sdb = SSD)
- SSD is configured as bcache "caching device" for HDD (the "backing device")
- /dev/bcache0 is a LVM PV, with one VG, and one LV (unfortunately,
this was necessary for the Debian / Ubuntu setup to recognize the
device as a non-partitionable device) formatted as BTRFS.
- The BTRFS filesystem has several subvolumes (some done by the Ubuntu
installer)
- None of the subvolumes have any snapshots configured whatsoever

Command I use to remove (maybe this is wrong?):
# mount /dev/vgSystem/lvBTRFS /mnt
# cd /mnt
# ls
@  @home  @kvm  @virtualbox  @vmware
# btrfs sub delete @vmware

Here is the error from dmesg:

[   56.910180] ------------[ cut here ]------------
[   56.910197] WARNING: CPU: 3 PID: 1979 at fs/btrfs/uuid-tree.c:171
btrfs_uuid_tree_rem+0x1ec/0x210()
[   56.910201] Modules linked in: rfcomm(F) bnep(F)
serpent_avx_x86_64(F) serpent_sse2_x86_64(F) serpent_generic(F) lrw(F)
glue_helper(F) ablk_helper(F) cryptd(F) xts(F) gf128mul(F)
binfmt_misc(F) dm_crypt(F) arc4(F) ip6t_REJECT(F) xt_hl(F) ip6t_rt(F)
nf_conntrack_ipv6(F) nf_defrag_ipv6(F) ipt_REJECT(F) xt_LOG(F)
xt_limit(F) xt_tcpudp(F) xt_addrtype(F) iwldvm(F) nf_conntrack_ipv4(F)
btusb(F) nf_defrag_ipv4(F) mac80211(F) joydev(F) xt_state(F)
snd_hda_codec_hdmi(F) bluetooth(F) snd_hda_codec_idt(F)
snd_hda_intel(F) snd_hda_codec(F) psmouse(F) iwlwifi(F) snd_hwdep(F)
ip6table_filter(F) ip6_tables(F) snd_pcm(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) nf_nat_ftp(F) nf_nat(F) nf_conntrack_ftp(F)
nf_conntrack(F) snd_page_alloc(F) iptable_filter(F) ip_tables(F)
snd_seq_midi(F) snd_seq_midi_event(F) dell_wmi(F) sparse_keymap(F)
x_tables(F) snd_rawmidi(F) dell_laptop(F) dcdbas(F) snd_seq(F)
cfg80211(F) serio_raw(F) lpc_ich(F) mfd_core(F) snd_seq_device(F)
snd_timer(F) snd(F) soundcore(F) hid_logitech_dj(F) usbhid(F) hid(F)
firewire_ohci(F) nouveau(F) ahci(F) libahci(F) mxm_wmi(F) e1000e(F)
wmi(F) ttm(F) firewire_core(F) sdhci_pci(F) crc_itu_t(F) sdhci(F)
ptp(F) pps_core(F) i915(F) video(F) i2c_algo_bit(F) drm_kms_helper(F)
drm(F) i2c_core(F)
[   56.910315] CPU: 3 PID: 1979 Comm: btrfs Tainted: GF
3.12.0-rc1-bcache-00060-g31b8586 #1
[   56.910318] Hardware name: Dell Inc. Latitude E6520/0J4TFW, BIOS
A17 03/07/2013
[   56.910322]  0000000000000009 ffff88022f7f5c28 ffffffff816b1dc3
0000000000000000
[   56.910328]  ffff88022f7f5c60 ffffffff810480bc ffff88023031ff00
ffff88022ec30f00
[   56.910334]  0000000000000000 ffff880231c54000 0000000000000000
ffff88022f7f5c70
[   56.910340] Call Trace:
[   56.910351]  [<ffffffff816b1dc3>] dump_stack+0x4e/0x82
[   56.910359]  [<ffffffff810480bc>] warn_slowpath_common+0x8c/0xc0
[   56.910366]  [<ffffffff8104810a>] warn_slowpath_null+0x1a/0x20
[   56.910371]  [<ffffffff8131e3bc>] btrfs_uuid_tree_rem+0x1ec/0x210
[   56.910377]  [<ffffffff8128cde6>] ? btrfs_free_path+0x26/0x30
[   56.910384]  [<ffffffff812e9a6a>] ? btrfs_insert_orphan_item+0x6a/0x90
[   56.910389]  [<ffffffff812e5393>] btrfs_ioctl_snap_destroy+0x573/0x670
[   56.910395]  [<ffffffff812e7b08>] btrfs_ioctl+0x1018/0x25c0
[   56.910403]  [<ffffffff8115185c>] ? handle_mm_fault+0x42c/0x1030
[   56.910411]  [<ffffffff81435239>] ? n_tty_write+0x1b9/0x4d0
[   56.910418]  [<ffffffff816b8bd8>] ? _raw_spin_unlock_irqrestore+0x18/0x40
[   56.910424]  [<ffffffff816bc4a4>] ? __do_page_fault+0x204/0x500
[   56.910430]  [<ffffffff81431f6c>] ? tty_write+0x1cc/0x2b0
[   56.910435]  [<ffffffff81435080>] ? process_echoes+0x90/0x90
[   56.910443]  [<ffffffff811a2bcc>] do_vfs_ioctl+0x8c/0x4f0
[   56.910450]  [<ffffffff81190a6c>] ? vfs_write+0x16c/0x1e0
[   56.910456]  [<ffffffff811a30c1>] SyS_ioctl+0x91/0xb0
[   56.910462]  [<ffffffff816bc7ae>] ? do_page_fault+0xe/0x10
[   56.910468]  [<ffffffff816c0846>] system_call_fastpath+0x1a/0x1f
[   56.910472] ---[ end trace 16cd56b9210c7fea ]---
[   56.910475] ------------[ cut here ]------------
[   56.910482] WARNING: CPU: 3 PID: 1979 at fs/btrfs/super.c:255
__btrfs_abort_transaction+0x12d/0x140()
[   56.910485] btrfs: Transaction aborted (error -22)
[   56.910487] Modules linked in: rfcomm(F) bnep(F)
serpent_avx_x86_64(F) serpent_sse2_x86_64(F) serpent_generic(F) lrw(F)
glue_helper(F) ablk_helper(F) cryptd(F) xts(F) gf128mul(F)
binfmt_misc(F) dm_crypt(F) arc4(F) ip6t_REJECT(F) xt_hl(F) ip6t_rt(F)
nf_conntrack_ipv6(F) nf_defrag_ipv6(F) ipt_REJECT(F) xt_LOG(F)
xt_limit(F) xt_tcpudp(F) xt_addrtype(F) iwldvm(F) nf_conntrack_ipv4(F)
btusb(F) nf_defrag_ipv4(F) mac80211(F) joydev(F) xt_state(F)
snd_hda_codec_hdmi(F) bluetooth(F) snd_hda_codec_idt(F)
snd_hda_intel(F) snd_hda_codec(F) psmouse(F) iwlwifi(F) snd_hwdep(F)
ip6table_filter(F) ip6_tables(F) snd_pcm(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) nf_nat_ftp(F) nf_nat(F) nf_conntrack_ftp(F)
nf_conntrack(F) snd_page_alloc(F) iptable_filter(F) ip_tables(F)
snd_seq_midi(F) snd_seq_midi_event(F) dell_wmi(F) sparse_keymap(F)
x_tables(F) snd_rawmidi(F) dell_laptop(F) dcdbas(F) snd_seq(F)
cfg80211(F) serio_raw(F) lpc_ich(F) mfd_core(F) snd_seq_device(F)
snd_timer(F) snd(F) soundcore(F) hid_logitech_dj(F) usbhid(F) hid(F)
firewire_ohci(F) nouveau(F) ahci(F) libahci(F) mxm_wmi(F) e1000e(F)
wmi(F) ttm(F) firewire_core(F) sdhci_pci(F) crc_itu_t(F) sdhci(F)
ptp(F) pps_core(F) i915(F) video(F) i2c_algo_bit(F) drm_kms_helper(F)
drm(F) i2c_core(F)
[   56.910579] CPU: 3 PID: 1979 Comm: btrfs Tainted: GF       W
3.12.0-rc1-bcache-00060-g31b8586 #1
[   56.910582] Hardware name: Dell Inc. Latitude E6520/0J4TFW, BIOS
A17 03/07/2013
[   56.910584]  0000000000000009 ffff88022f7f5c18 ffffffff816b1dc3
ffff88022f7f5c60
[   56.910590]  ffff88022f7f5c50 ffffffff810480bc 00000000ffffffea
ffff88022d339800
[   56.910595]  ffff880231957000 ffffffff818465b0 00000000000008cc
ffff88022f7f5cb0
[   56.910601] Call Trace:
[   56.910607]  [<ffffffff816b1dc3>] dump_stack+0x4e/0x82
[   56.910613]  [<ffffffff810480bc>] warn_slowpath_common+0x8c/0xc0
[   56.910619]  [<ffffffff810481ac>] warn_slowpath_fmt+0x4c/0x50
[   56.910626]  [<ffffffff8128981d>] __btrfs_abort_transaction+0x12d/0x140
[   56.910631]  [<ffffffff812e546c>] btrfs_ioctl_snap_destroy+0x64c/0x670
[   56.910637]  [<ffffffff812e7b08>] btrfs_ioctl+0x1018/0x25c0
[   56.910642]  [<ffffffff8115185c>] ? handle_mm_fault+0x42c/0x1030
[   56.910648]  [<ffffffff81435239>] ? n_tty_write+0x1b9/0x4d0
[   56.910653]  [<ffffffff816b8bd8>] ? _raw_spin_unlock_irqrestore+0x18/0x40
[   56.910660]  [<ffffffff816bc4a4>] ? __do_page_fault+0x204/0x500
[   56.910664]  [<ffffffff81431f6c>] ? tty_write+0x1cc/0x2b0
[   56.910670]  [<ffffffff81435080>] ? process_echoes+0x90/0x90
[   56.910676]  [<ffffffff811a2bcc>] do_vfs_ioctl+0x8c/0x4f0
[   56.910681]  [<ffffffff81190a6c>] ? vfs_write+0x16c/0x1e0
[   56.910687]  [<ffffffff811a30c1>] SyS_ioctl+0x91/0xb0
[   56.910692]  [<ffffffff816bc7ae>] ? do_page_fault+0xe/0x10
[   56.910697]  [<ffffffff816c0846>] system_call_fastpath+0x1a/0x1f
[   56.910701] ---[ end trace 16cd56b9210c7feb ]---
[   56.910706] BTRFS error (device dm-0) in
btrfs_ioctl_snap_destroy:2252: errno=-22 unknown
[   56.910710] BTRFS info (device dm-0): forced readonly
[   66.772123] btrfs: use spread ssd allocation scheme
[   66.772133] btrfs: disk space caching is enabled

Thanks for any response,
Sincerely,
Roel Brook
