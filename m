Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63859 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551AbbGUSri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 14:47:38 -0400
Received: from [127.0.0.1] ([178.3.134.187]) by mrelayeu.kundenserver.de
 (mreue101) with ESMTPSA (Nemesis) id 0MJCI6-1ZEsU60QAs-002sTh for
 <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 20:47:36 +0200
Message-ID: <55AE93C5.6000505@friedels.name>
Date: Tue, 21 Jul 2015 20:47:33 +0200
From: Hendrik Friedel <root@friedels.name>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at ctree.c:5196
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I recently added a third device to my raid and converted it from raid0 
to raid 5 via balance (dconvert, mconvert).
Unfortunately, the new device was faulty. I wrote about this on this 
List in "size 2.73TiB used 240.97GiB after balance".

Initially the system was very unstable when trying to access this volume 
(even with ro, degraded, recovery), but
now I was able to recover the data from the disk. I think it helped to 
attach the disk directly rather than in its USB-Enclosure.

Now I have two remaining points:
a) I want to contribute to making btrfs more stable
b) I would like to repair the volume

When running btrfs check --repair, I get:
btrfs check --repair /dev/sdb
enabling repair mode
Checking filesystem on /dev/sdb
UUID: b4a6cce6-dc9c-4a13-80a4-ed6bc5b40bb8
checking extents
parent transid verify failed on 8300132024320 wanted 114915 found 114837
parent transid verify failed on 8300132024320 wanted 114915 found 114837
checksum verify failed on 8300132024320 found C3925FB7 wanted 2771E201
parent transid verify failed on 8300132024320 wanted 114915 found 114837
Ignoring transid failure
parent transid verify failed on 8300132024320 wanted 114915 found 114837
Ignoring transid failure
owner ref check failed [8300132024320 16384]
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x442311]
btrfs(btrfs_reserve_extent+0x8a4)[0x4477f5]
btrfs(btrfs_alloc_free_block+0x57)[0x447b43]
btrfs(__btrfs_cow_block+0x163)[0x4389f7]
btrfs(btrfs_cow_block+0xd0)[0x439304]
btrfs(btrfs_search_slot+0x16f)[0x43b996]
btrfs[0x420dcb]
btrfs[0x4284d6]
btrfs(cmd_check+0x14a9)[0x42a464]
btrfs(main+0x153)[0x409f37]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f22b8161ec5]
btrfs[0x409af9]


When now running a balance (dconvert=raid0 mconvert=raid0) this shows up 
in the syslog:

Jul 19 22:43:33 homeserver kernel: [  219.670944] BTRFS: checking UUID 
tree                                                     |
Jul 19 22:43:33 homeserver kernel: [  219.670951] BTRFS info (device 
sde): continuing balance                                   |
Jul 19 22:43:35 homeserver kernel: [  221.108745] BTRFS info (device 
sde): relocating block group 8175533162496 flags 1         |
Jul 19 22:43:35 homeserver kernel: [  221.392879] BTRFS (device sde): 
parent transid verify failed on 8300132024320 wanted 11491|
5 found 114837 |
Jul 19 22:43:35 homeserver kernel: [  221.409515] BTRFS (device sde): 
parent transid verify failed on 8300132024320 wanted 11491|
5 found 114837 |
Jul 19 22:43:35 homeserver kernel: [  221.409564] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/ctree.c:5196!                   |
Jul 19 22:43:35 homeserver kernel: [  221.409594] Modules linked in: 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ip|
v4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcp|
udp ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat 
ebtables x_tables autofs4 bridge stp llc nfsd auth_rpcgss nf|
s_acl nfs lockd binfmt_misc grace sunrpc fscache stv6110x lnbp21 
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coret|
emp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_gener|
ic stv090x cryptd snd_hda_intel snd_hda_controller snd_hda_codec 
snd_hda_core serio_raw snd_hwdep ddbridge snd_pcm i915 cxd2099(|
C) dvb_core snd_seq_midi media snd_seq_midi_event snd_rawmidi snd_seq 
snd_seq_device snd_timer lpc_ich drm_kms_helper snd drm i2|
c_algo_bit soundcore mei_me shpchp mei video mac_hid lp parport btrfs 
raid10 raid456 async_raid6_recov async_memcpy async_pq asy|
nc_xor async_tx xor raid6_pq raid1 hid_generic raid0 e1000e usbhid 
multipath linear psmouse ptp ahci libahci hid pps_core       |
Jul 19 22:43:35 homeserver kernel: [  221.409923] CPU: 0 PID: 4529 Comm: 
btrfs-uuid Tainted: G         C      4.1.0-040100rc5-ge|
neric #201505250235 |
Jul 19 22:43:35 homeserver kernel: [  221.409989] RIP: 
0010:[<ffffffffc01687b2>]  [<ffffffffc01687b2>] btrfs_search_forward+0x31|
2/0x330 [btrfs] |
Jul 19 22:43:35 homeserver kernel: [  221.410261] [<ffffffffc0160a47>] ? 
btrfs_release_path+0x77/0xb0 [btrfs]                  |
Jul 19 22:43:35 homeserver kernel: [  221.410289] [<ffffffffc01b243c>] 
btrfs_uuid_scan_kthread+0xec/0x3b0 [btrfs]              |
Jul 19 22:43:35 homeserver kernel: [  221.410317] [<ffffffffc01b2700>] ? 
btrfs_uuid_scan_kthread+0x3b0/0x3b0 [btrfs]           |
Jul 19 22:43:35 homeserver kernel: [  221.410343] [<ffffffffc01b2732>] 
btrfs_uuid_rescan_kthread+0x32/0x70 [btrfs]             |
Jul 19 22:43:35 homeserver kernel: [  221.410525] RIP 
[<ffffffffc01687b2>] btrfs_search_forward+0x312/0x330 [btrfs]

I can now play a bit with the file-system if valuable for you.
When being able to recover, I would also profit, because I save a bit of 
time getting all data together again (now spread over drives),  but it's 
not major.

Please advise, if it would be useful to further research this.

Greetings,
Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

