Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:53483 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968083Ab3E3LZX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 07:25:23 -0400
Received: from [10.0.0.210] (atom.chemaxon.com [91.120.7.54])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tamas.papp@rtfm.co.hu)
	by gitanes.rtfm.co.hu (Postfix) with ESMTPSA id 58FC28A953
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 13:17:09 +0200 (CEST)
Message-ID: <51A73532.6060900@martos.bme.hu>
Date: Thu, 30 May 2013 13:17:06 +0200
From: Papp Tamas <tompos@martos.bme.hu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: oops at mount
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi All,

I'm new on the list.

System:
Distributor ID:	Ubuntu
Description:	Ubuntu 13.04
Release:	13.04
Codename:	raring

Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

The symptom is the same with Saucy 3.9 kernel.

ii  btrfs-tools                               0.20~git20130524~650e656-0daily13~raring1 amd64 
  Checksumming Copy on Write Filesystem utilities


I also tried btrfs-tools v0.19 before with no luck.


$ btrfsck --repair /dev/sda1
enabling repair mode
parent transid verify failed on 430612480 wanted 81016 found 81011
parent transid verify failed on 430612480 wanted 81016 found 81011
parent transid verify failed on 430612480 wanted 81016 found 81011
parent transid verify failed on 430612480 wanted 81016 found 81011
Ignoring transid failure
Checking filesystem on /dev/sda1
UUID: deed1ffb-27bb-4555-b5ce-8a3c8ee5612c
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 67570520064 bytes used err is 0
total csum bytes: 65168792
total tree bytes: 789745664
total fs tree bytes: 651145216
total extent tree bytes: 50372608
btree space waste bytes: 192929190
file data blocks allocated: 80764424192
  referenced 69347667968
Btrfs v0.20-rc1


If I mount, I get an oops message. The machine is not completely freezed, but I have to reboot it to 
be able to use it again.


    69.257107] btrfsck[2703]: segfault at 7ff069802710 ip 00007ff063ceecbd sp 00007fff9bb5db70 error 
4 in libc-2.17.so[7ff063c6f000+1be000]
[  480.799981] device fsid deed1ffb-27bb-4555-b5ce-8a3c8ee5612c devid 1 transid 81010 /dev/sda1
[  480.802507] btrfs: disk space caching is enabled
[  480.851534] Btrfs detected SSD devices, enabling SSD mode
[  480.863245] btrfs bad tree block start 0 413601792
[  480.863320] btrfs bad tree block start 0 413601792
[  480.863389] ------------[ cut here ]------------
[  480.863426] Kernel BUG at ffffffffa03d3b6a [verbose debug info unavailable]
[  480.863459] invalid opcode: 0000 [#1] SMP
[  480.863490] Modules linked in: ip6table_filter(F) ip6_tables(F) xt_state(F) ipt_REJECT(F) 
xt_CHECKSUM(F) iptable_mangle(F) xt_tcpudp(F) iptable_filter(F) ipt_MASQUERADE(F) iptable_nat(F) 
nf_conntrack_ipv4(F) nf_defrag_ipv4(F) nf_nat_ipv4(F) nf_nat(F) nf_conntrack(F) ip_tables(F) 
x_tables(F) bridge(F) stp(F) llc(F) pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) 
rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_idt binfmt_misc(F) qcserial usb_wwan usbserial 
pata_pcmcia arc4(F) hid_generic coretemp kvm_intel iwldvm kvm mac80211 ghash_clmulni_intel(F) 
aesni_intel(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F) cryptd(F) usbhid hid joydev(F) 
tpm_infineon hp_wmi sparse_keymap uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev pcmcia microcode(F) btusb bluetooth psmouse(F) serio_raw(F) intel_ips btrfs(F) tpm_tis 
libcrc32c(F) zlib_deflate(F) sdhci_pci snd_hda_intel sdhci snd_hda_codec snd_hwdep(F) snd_pcm(F) 
firewire_ohci snd_page_alloc(F) firewire_core snd_seq_midi(F) snd_seq_midi_event(F) crc_itu_t(F) 
yenta_socket pcmcia_rsrc i915 pcmcia_core snd_rawmidi(F) drm_kms_helper snd_seq(F) hp_accel drm 
lis3lv02d snd_seq_device(F) input_polldev snd_timer(F) wmi iwlwifi snd(F) video(F) mac_hid cfg80211 
lpc_ich i2c_algo_bit mei e1000e(F) soundcore(F) lp(F) parport(F) ahci(F) libahci(F)
[  480.864322] CPU 3
[  480.864338] Pid: 5550, comm: mount Tainted: GF          O 3.8.0-19-generic #30-Ubuntu 
Hewlett-Packard HP EliteBook 2540p/7008
[  480.864386] RIP: 0010:[<ffffffffa03d3b6a>]  [<ffffffffa03d3b6a>] 
btrfs_recover_log_trees+0x23a/0x390 [btrfs]
[  480.864474] RSP: 0018:ffff88012ad41b40  EFLAGS: 00010282
[  480.864499] RAX: 00000000fffffffb RBX: ffff88018b91c000 RCX: 00000001801c001b
[  480.864531] RDX: 00000001801c001c RSI: 00000000801c001b RDI: ffff8801b20b3900
[  480.864563] RBP: ffff88012ad41bf0 R08: 0000000000000000 R09: 0000000000000001
[  480.864594] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88014fc0a5a0
[  480.864625] R13: ffff88011d2f0e40 R14: ffff88018b91a800 R15: ffff8801ab3ea000
[  480.864656] FS:  00007fb531818840(0000) GS:ffff8801bbcc0000(0000) knlGS:0000000000000000
[  480.864693] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  480.864718] CR2: 00000000006a5000 CR3: 000000016800b000 CR4: 00000000000007e0
[  480.864750] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  480.864781] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  480.864813] Process mount (pid: 5550, threadinfo ffff88012ad40000, task ffff880128522e80)
[  480.864847] Stack:
[  480.864860]  ffff8801b0e5ce40 ffff88012ad41b98 fffffffa00000000 ffffff84ffffffff
[  480.864905]  fffffaffffffffff 010684ffffffffff 0106000000000000 ff84000000000000
[  480.864947]  faffffffffffffff 84ffffffffffffff 0000000000000106 0000000000000000
[  480.864990] Call Trace:
[  480.865019]  [<ffffffffa03d1a10>] ? fixup_inode_link_counts+0x150/0x150 [btrfs]
[  480.865061]  [<ffffffffa0398a2c>] open_ctree+0x171c/0x1da0 [btrfs]
[  480.865095]  [<ffffffff81331461>] ? disk_name+0x61/0xc0
[  480.865126]  [<ffffffffa0371a83>] btrfs_mount+0x613/0x750 [btrfs]
[  480.865160]  [<ffffffff81197c43>] mount_fs+0x43/0x1b0
[  480.865187]  [<ffffffff811b2457>] ? alloc_vfsmnt+0xd7/0x1b0
[  480.865214]  [<ffffffff811b25e4>] vfs_kern_mount+0x74/0x110
[  480.865240]  [<ffffffff811b495f>] do_mount+0x21f/0xac0
[  480.865270]  [<ffffffff8114a46b>] ? strndup_user+0x5b/0x80
[  480.865296]  [<ffffffff811b528e>] sys_mount+0x8e/0xe0
[  480.865323]  [<ffffffff816d37dd>] system_call_fastpath+0x1a/0x1f
[  480.865352] Code: ef e8 bb 9e ff ff 85 c0 75 21 83 7d b8 02 0f 85 ad fe ff ff 48 8b 75 c0 4c 89 
e2 4c 89 ef e8 5e dd ff ff 85 c0 0f 84 96 fe ff ff <0f> 0b 0f 1f 40 00 4c 89 e7 e8 b8 13 fa ff 44 8b 
5d b4 45 85 db
[  480.865680] RIP  [<ffffffffa03d3b6a>] btrfs_recover_log_trees+0x23a/0x390 [btrfs]
[  480.865743]  RSP <ffff88012ad41b40>
[  481.887687] ---[ end trace 6d9b536c1234c5bc ]---



The storage is an Intel X18-M/X25-M/X25-V G2 SSD and a similar error was there a couple of weeks ago.
It's a root partition with 3 subvolumes. Now I use a secondary system on the drive.

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
   4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
   5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       4
   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       9718
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       3532
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       486
225 Host_Writes_32MiB       0x0030   200   200   000    Old_age   Offline      -       172848
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       1823
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       4
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       1156268736
232 Available_Reservd_Space 0x0033   099   099   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   098   098   000    Old_age   Always       -       0
184 End-to-End_Error        0x0033   100   100   099    Pre-fail  Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Reserved (0x80)     Completed without error       00%      8925         -
# 2  Reserved (0x18)     Completed without error       00%      8921         -
# 3  Vendor (0xb8)       Completed without error       00%      8920         -
# 4  Reserved (0x30)     Completed without error       00%      8065         -
# 5  Vendor (0xd0)       Completed without error       00%      3530         -
# 6  Offline             Completed without error       00%        38         -

Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever 
been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing


Is it the SSD or rather a bug?


Thanks,
tamas
