Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48009 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab3GQWoo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 18:44:44 -0400
Received: by mail-ob0-f176.google.com with SMTP id v19so2994323obq.35
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 15:44:43 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Wed, 17 Jul 2013 17:44:23 -0500
Message-ID: <CAKuK5J0ZiMnAHWAEvNBESX99cawYJQ4_sFQ=5_Ka8gwJqLT2cA@mail.gmail.com>
Subject: report: my btrfs filesystem failed hard today
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a btrfs filesystem under 3.9.8 that failed /hard/ today. So hard
that the filesystem could not be mounted because there wasn't enough
free space, unless it was mounted read only.

This happened after I ran out of metadata space (is there a way to
increase the amount of metadata storage) while still having many gigs
free of data space, as reported by btrfs fi df. I tried balancing the
metadata, defrag'ing files (with -czlib) and even tried mounting with
-o remount,metadata_ratio={several values}, none of which worked, and
then it crashed hard.

First, it killed systemd's logger (journald), which refused to
start.Following the crash, I was not able to mount the filesystem
without -o ro.  -o recovery did not work.

The first messages are (when I ran out of disk space):

2013-07-17T12:37:36.159351-05:00 linux-3y3i kernel: [58301.322033]
btrfs allocation failed flags 1, wanted 1310720
2013-07-17T12:37:36.159367-05:00 linux-3y3i kernel: [58301.322037]
space_info 1 has 19119284224 free, is full
2013-07-17T12:37:36.159369-05:00 linux-3y3i kernel: [58301.322039]
space_info total=146070831104, used=126941663232, pinned=643072,
reserved=9175040, may_use=43724800, readonly=65536
2013-07-17T12:37:36.159370-05:00 linux-3y3i kernel: [58301.322041]
block group 1107296256 has 5368709120 bytes, 4263174144 used 0 pinned
0 reserved
2013-07-17T12:37:36.159371-05:00 linux-3y3i kernel: [58301.322042]
entry offset 1107296256, bytes 20082688, bitmap yes
2013-07-17T12:37:36.159372-05:00 linux-3y3i kernel: [58301.322044]
entry offset 1241513984, bytes 35172352, bitmap yes
2013-07-17T12:37:36.159373-05:00 linux-3y3i kernel: [58301.322045]
entry offset 1246859264, bytes 12288, bitmap no
...
2013-07-17T12:37:36.160185-05:00 linux-3y3i kernel: [58301.322387]
block group has cluster?: no
2013-07-17T12:37:36.160186-05:00 linux-3y3i kernel: [58301.322388] 40
blocks of free space at or bigger than bytes is
2013-07-17T12:37:36.160188-05:00 linux-3y3i kernel: [58301.322390]
block group 8623489024 has 5368709120 bytes, 4745510912 used 0 pinned
0 reserved
...
and a few hundred thousand more lines


I also tried 3.7 and 3.10.1 (although I could not try 3.10.1 to try to
mount the filesystem after it finally went boom).


Lots and lots (10's of thousands) of:

2013-07-17T13:25:24.690135-05:00 linux-3y3i kernel: [  493.772797]
------------[ cut here ]------------
2013-07-17T13:25:24.690137-05:00 linux-3y3i kernel: [  493.772825]
WARNING: at fs/btrfs/extent-tree.c:6556
btrfs_alloc_free_block+0x3bd/0x3d0 [btrfs]()
2013-07-17T13:25:24.690138-05:00 linux-3y3i kernel: [  493.772826]
Hardware name: 4239CTO
2013-07-17T13:25:24.690140-05:00 linux-3y3i kernel: [  493.772828]
btrfs: block rsv returned -28
2013-07-17T13:25:24.690141-05:00 linux-3y3i kernel: [  493.772829]
Modules linked in: fuse ufs qnx4 hfsplus hfs minix vfat msdos fat jfs
xfs reiserfs xt_tcpudp xt_pkttype xt_LOG af_packet xt_limit
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
iptable_raw xt_CT iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables arc4 iwldvm snd_hda_codec_hdmi mac80211 iTCO_wdt
snd_hda_codec_conexant iTCO_vendor_support mperf snd_usb_audio
snd_usbmidi_lib coretemp snd_rawmidi snd_seq_device snd_hda_intel
kvm_intel kvm microcode pcspkr snd_hda_codec snd_hwdep snd_pcm iwlwifi
sr_mod sdhci_pci sdhci mmc_core cfg80211 joydev cdrom snd_timer e1000e
snd_page_alloc thinkpad_acpi lpc_ich mfd_core rfkill i2c_i801 ptp
pps_core wmi snd soundcore battery tpm_tis ac tpm tpm_bios
tcp_westwood sg autofs4 btrfs raid6_pq zlib_deflate xor libcrc32c
sha256_generic dm_crypt dm_mod ghash_clmulni_intel crc32_pclmul
crc32c_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts
gf128mul i915 drm_kms_helper drm thermal i2c_algo_bit video button
processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc
scsi_dh_alua scsi_dh ata_generic ata_piix
2013-07-17T13:25:24.690144-05:00 linux-3y3i kernel: [  493.772882]
Pid: 334, comm: btrfs-balance Tainted: G        W
3.9.8-1.gfccf19c-desktop #3
2013-07-17T13:25:24.690145-05:00 linux-3y3i kernel: [  493.772883] Call Trace:
2013-07-17T13:25:24.690146-05:00 linux-3y3i kernel: [  493.772895]
[<ffffffff81004728>] dump_trace+0x88/0x300
2013-07-17T13:25:24.690148-05:00 linux-3y3i kernel: [  493.772902]
[<ffffffff815c8e9b>] dump_stack+0x69/0x6f
2013-07-17T13:25:24.690149-05:00 linux-3y3i kernel: [  493.772907]
[<ffffffff81046069>] warn_slowpath_common+0x79/0xc0
2013-07-17T13:25:24.690150-05:00 linux-3y3i kernel: [  493.772912]
[<ffffffff81046165>] warn_slowpath_fmt+0x45/0x50
2013-07-17T13:25:24.690151-05:00 linux-3y3i kernel: [  493.772923]
[<ffffffffa0224fad>] btrfs_alloc_free_block+0x3bd/0x3d0 [btrfs]
2013-07-17T13:25:24.690152-05:00 linux-3y3i kernel: [  493.772955]
[<ffffffffa0210685>] __btrfs_cow_block+0x135/0x560 [btrfs]
2013-07-17T13:25:24.690153-05:00 linux-3y3i kernel: [  493.772974]
[<ffffffffa0210c5c>] btrfs_cow_block+0x12c/0x210 [btrfs]
2013-07-17T13:25:24.690155-05:00 linux-3y3i kernel: [  493.772992]
[<ffffffffa021529a>] btrfs_search_slot+0x33a/0x7e0 [btrfs]
2013-07-17T13:25:24.690156-05:00 linux-3y3i kernel: [  493.773017]
[<ffffffffa027e566>] do_relocation+0x3b6/0x510 [btrfs]
2013-07-17T13:25:24.690157-05:00 linux-3y3i kernel: [  493.773097]
[<ffffffffa0282635>] relocate_tree_blocks+0x615/0x640 [btrfs]
2013-07-17T13:25:24.690158-05:00 linux-3y3i kernel: [  493.773176]
[<ffffffffa028314a>] relocate_block_group+0x28a/0x6f0 [btrfs]
2013-07-17T13:25:24.690159-05:00 linux-3y3i kernel: [  493.773254]
[<ffffffffa0283771>] btrfs_relocate_block_group+0x1c1/0x310 [btrfs]
2013-07-17T13:25:24.690161-05:00 linux-3y3i kernel: [  493.773334]
[<ffffffffa025a1aa>] btrfs_relocate_chunk.isra.60+0x4a/0x480 [btrfs]
2013-07-17T13:25:24.690162-05:00 linux-3y3i kernel: [  493.773394]
[<ffffffffa025ede6>] __btrfs_balance+0x416/0x810 [btrfs]
2013-07-17T13:25:24.690163-05:00 linux-3y3i kernel: [  493.773455]
[<ffffffffa025f59d>] btrfs_balance+0x3bd/0x620 [btrfs]
2013-07-17T13:25:24.690164-05:00 linux-3y3i kernel: [  493.773515]
[<ffffffffa025f880>] balance_kthread+0x80/0x90 [btrfs]
2013-07-17T13:25:24.690170-05:00 linux-3y3i kernel: [  493.773616]
[<ffffffff810696c3>] kthread+0xb3/0xc0
2013-07-17T13:25:24.691080-05:00 linux-3y3i kernel: [  493.773632]
[<ffffffff815dca7c>] ret_from_fork+0x7c/0xb0
2013-07-17T13:25:24.691083-05:00 linux-3y3i kernel: [  493.773636]
DWARF2 unwinder stuck at ret_from_fork+0x7c/0xb0
2013-07-17T13:25:24.691084-05:00 linux-3y3i kernel: [  493.773637]
2013-07-17T13:25:24.691085-05:00 linux-3y3i kernel: [  493.773638]
Leftover inexact backtrace:
2013-07-17T13:25:24.691086-05:00 linux-3y3i kernel: [  493.773638]
2013-07-17T13:25:24.691086-05:00 linux-3y3i kernel: [  493.773641]
[<ffffffff81069610>] ? kthread_create_on_node+0x120/0x120
2013-07-17T13:25:24.691087-05:00 linux-3y3i kernel: [  493.773646]
---[ end trace b481c7d2cb64b3c1 ]---


and then



013-07-17T13:36:42.665398-05:00 linux-3y3i kernel: [  375.603242]
------------[ cut here ]------------
2013-07-17T13:36:42.665416-05:00 linux-3y3i kernel: [  375.603274]
WARNING: at fs/btrfs/inode.c:2157 record_one_backref+0x3c1/0x430
[btrfs]()
2013-07-17T13:36:42.665418-05:00 linux-3y3i kernel: [  375.603276]
Hardware name: 4239CTO
2013-07-17T13:36:42.666367-05:00 linux-3y3i kernel: [  375.603277]
Modules linked in: nfsv4 auth_rpcgss nfs fscache lockd sunrpc fuse
xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables arc4
iwldvm mac80211 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi
snd_hda_codec_conexant mperf snd_hda_intel snd_hda_codec coretemp
snd_usb_audio kvm_intel kvm snd_pcm microcode snd_hwdep
snd_usbmidi_lib snd_rawmidi snd_seq_device joydev pcspkr i2c_i801
sr_mod cdrom sdhci_pci sdhci iwlwifi mmc_core lpc_ich mfd_core
snd_timer cfg80211 snd_page_alloc thinkpad_acpi rfkill e1000e snd ptp
pps_core battery soundcore ac tpm_tis tpm tpm_bios wmi tcp_westwood sg
autofs4 btrfs raid6_pq zlib_deflate xor libcrc32c sha256_generic
dm_crypt dm_mod ghash_clmulni_intel crc32_pclmul crc32c_intel
aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul thermal
i915 drm_kms_helper drm i2c_algo_bit video button processor
thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh ata_generic ata_piix
2013-07-17T13:36:42.666375-05:00 linux-3y3i kernel: [  375.603814]
Pid: 816, comm: btrfs-endio-wri Not tainted 3.9.8-1.gfccf19c-desktop
#3
2013-07-17T13:36:42.666377-05:00 linux-3y3i kernel: [  375.603816] Call Trace:
2013-07-17T13:36:42.666378-05:00 linux-3y3i kernel: [  375.603825]
[<ffffffff81004728>] dump_trace+0x88/0x300
2013-07-17T13:36:42.666379-05:00 linux-3y3i kernel: [  375.603830]
[<ffffffff815c8e9b>] dump_stack+0x69/0x6f
2013-07-17T13:36:42.666380-05:00 linux-3y3i kernel: [  375.603834]
[<ffffffff81046069>] warn_slowpath_common+0x79/0xc0
2013-07-17T13:36:42.666381-05:00 linux-3y3i kernel: [  375.603847]
[<ffffffffa0245dc1>] record_one_backref+0x3c1/0x430 [btrfs]
2013-07-17T13:36:42.666382-05:00 linux-3y3i kernel: [  375.603883]
[<ffffffffa029b0e5>] iterate_extent_inodes+0x1e5/0x370 [btrfs]
2013-07-17T13:36:42.666383-05:00 linux-3y3i kernel: [  375.603946]
[<ffffffffa029b308>] iterate_inodes_from_logical+0x98/0xc0 [btrfs]
2013-07-17T13:36:42.666383-05:00 linux-3y3i kernel: [  375.604005]
[<ffffffffa0243218>] record_extent_backrefs+0x68/0xe0 [btrfs]
2013-07-17T13:36:42.666384-05:00 linux-3y3i kernel: [  375.604034]
[<ffffffffa024ddd0>] btrfs_finish_ordered_io+0x150/0x990 [btrfs]
2013-07-17T13:36:42.666385-05:00 linux-3y3i kernel: [  375.604066]
[<ffffffffa026df43>] worker_loop+0x153/0x560 [btrfs]
2013-07-17T13:36:42.666386-05:00 linux-3y3i kernel: [  375.604104]
[<ffffffff810696c3>] kthread+0xb3/0xc0
2013-07-17T13:36:42.666386-05:00 linux-3y3i kernel: [  375.604107]
[<ffffffff815dca7c>] ret_from_fork+0x7c/0xb0
2013-07-17T13:36:42.666387-05:00 linux-3y3i kernel: [  375.604110]
DWARF2 unwinder stuck at ret_from_fork+0x7c/0xb0
2013-07-17T13:36:42.666388-05:00 linux-3y3i kernel: [  375.604111]
2013-07-17T13:36:42.666389-05:00 linux-3y3i kernel: [  375.604111]
Leftover inexact backtrace:
2013-07-17T13:36:42.666390-05:00 linux-3y3i kernel: [  375.604111]
2013-07-17T13:36:42.666390-05:00 linux-3y3i kernel: [  375.604114]
[<ffffffff81069610>] ? kthread_create_on_node+0x120/0x120
2013-07-17T13:36:42.666391-05:00 linux-3y3i kernel: [  375.604116]
---[ end trace 975aef43d9552003 ]---


and then

2013-07-17T13:38:00.080382-05:00 linux-3y3i kernel: [  452.918252]
btrfs: defrag_file cancelled
2013-07-17T13:41:50.901561-05:00 linux-3y3i kernel: [  683.440785]
------------[ cut here ]------------
2013-07-17T13:41:50.901576-05:00 linux-3y3i kernel: [  683.440892]
WARNING: at fs/btrfs/inode.c:2157 record_one_backref+0x3c1/0x430
[btrfs]()
2013-07-17T13:41:50.901578-05:00 linux-3y3i kernel: [  683.440894]
Hardware name: 4239CTO
2013-07-17T13:41:50.901579-05:00 linux-3y3i kernel: [  683.440895]
Modules linked in: nfsv4 auth_rpcgss nfs fscache lockd sunrpc fuse
xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables arc4
iwldvm mac80211 iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi
snd_hda_codec_conexant mperf snd_hda_intel snd_hda_codec coretemp
snd_usb_audio kvm_intel kvm snd_pcm microcode snd_hwdep
snd_usbmidi_lib snd_rawmidi snd_seq_device joydev pcspkr i2c_i801
sr_mod cdrom sdhci_pci sdhci iwlwifi mmc_core lpc_ich mfd_core
snd_timer cfg80211 snd_page_alloc thinkpad_acpi rfkill e1000e snd ptp
pps_core battery soundcore ac tpm_tis tpm tpm_bios wmi tcp_westwood sg
autofs4 btrfs raid6_pq zlib_deflate xor libcrc32c sha256_generic
dm_crypt dm_mod ghash_clmulni_intel crc32_pclmul crc32c_intel
aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul thermal
i915 drm_kms_helper drm i2c_algo_bit video button processor
thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh ata_generic ata_piix
2013-07-17T13:41:50.901580-05:00 linux-3y3i kernel: [  683.440947]
Pid: 814, comm: btrfs-endio-wri Tainted: G        W
3.9.8-1.gfccf19c-desktop #3
2013-07-17T13:41:50.901581-05:00 linux-3y3i kernel: [  683.440948] Call Trace:
2013-07-17T13:41:50.901582-05:00 linux-3y3i kernel: [  683.440959]
[<ffffffff81004728>] dump_trace+0x88/0x300
2013-07-17T13:41:50.901583-05:00 linux-3y3i kernel: [  683.440966]
[<ffffffff815c8e9b>] dump_stack+0x69/0x6f
2013-07-17T13:41:50.901584-05:00 linux-3y3i kernel: [  683.440973]
[<ffffffff81046069>] warn_slowpath_common+0x79/0xc0
2013-07-17T13:41:50.901585-05:00 linux-3y3i kernel: [  683.440987]
[<ffffffffa0245dc1>] record_one_backref+0x3c1/0x430 [btrfs]
2013-07-17T13:41:50.901586-05:00 linux-3y3i kernel: [  683.441045]
[<ffffffffa029b0e5>] iterate_extent_inodes+0x1e5/0x370 [btrfs]
2013-07-17T13:41:50.901587-05:00 linux-3y3i kernel: [  683.441153]
[<ffffffffa029b308>] iterate_inodes_from_logical+0x98/0xc0 [btrfs]
2013-07-17T13:41:50.901587-05:00 linux-3y3i kernel: [  683.441257]
[<ffffffffa0243218>] record_extent_backrefs+0x68/0xe0 [btrfs]
2013-07-17T13:41:50.901588-05:00 linux-3y3i kernel: [  683.441318]
[<ffffffffa024ddd0>] btrfs_finish_ordered_io+0x150/0x990 [btrfs]
2013-07-17T13:41:50.901589-05:00 linux-3y3i kernel: [  683.441375]
[<ffffffffa026df43>] worker_loop+0x153/0x560 [btrfs]
2013-07-17T13:41:50.901590-05:00 linux-3y3i kernel: [  683.441444]
[<ffffffff810696c3>] kthread+0xb3/0xc0
2013-07-17T13:41:50.901590-05:00 linux-3y3i kernel: [  683.441449]
[<ffffffff815dca7c>] ret_from_fork+0x7c/0xb0
2013-07-17T13:41:50.901591-05:00 linux-3y3i kernel: [  683.441453]
DWARF2 unwinder stuck at ret_from_fork+0x7c/0xb0
2013-07-17T13:41:50.901592-05:00 linux-3y3i kernel: [  683.441454]
2013-07-17T13:41:50.901594-05:00 linux-3y3i kernel: [  683.441455]
Leftover inexact backtrace:
2013-07-17T13:41:50.901595-05:00 linux-3y3i kernel: [  683.441455]
2013-07-17T13:41:50.901596-05:00 linux-3y3i kernel: [  683.441459]
[<ffffffff81069610>] ? kthread_create_on_node+0x120/0x120
2013-07-17T13:41:50.902332-05:00 linux-3y3i kernel: [  683.441789]
---[ end trace 975aef43d9552004 ]---

mount said:

mount.bin: mount BLAH on /mnt failed: No space left on device

[ 3514.028586] device fsid BLAHUUID devid 1 transid 191163 /dev/mapper/crypted
[ 3514.029914] btrfs: disk space caching is enabled
[ 3514.073155] Btrfs detected SSD devices, enabling SSD mode
[ 3514.075501] BTRFS: inode 10973366 still on the orphan list
[ 3514.075511] btrfs: could not do orphan cleanup -28
[ 3514.977244] btrfs: open_ctree failed

btrfs fi df reported:

Data: total=136.04GB, used=99.83GB
System: total=32.00MB, used=12.00KB
Metadata, DUP: total=4.00GB, used=3.50GB


--
Jon
Software Blacksmith
