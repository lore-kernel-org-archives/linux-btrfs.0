Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:43293 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab2GBXG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 19:06:26 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q62N6Or3016937
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 02:06:24 +0300
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 27517-1147 for <linux-btrfs@vger.kernel.org>;
 Tue,  3 Jul 2012 02:06:24 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q62N6MVe016935
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 02:06:22 +0300
Date: Tue, 3 Jul 2012 02:01:21 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: btrfs GPF in read_extent_buffer() while scrubbing with kernel 3.4.2
Message-ID: <20120702230121.GD12755@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I just got this oops on a computer running 3.4.2.

A few minutes before I had started "btrfs device scrub /" and had a
watcher process running "btrfs scrub status /" every 5 seconds. After
a few gigabytes of scrubbing, I got this crash.

The oops is transcribed from photos, so it may contain some errors. I
tried to be careful, and double checked the backtrace.

	Sami

------------------------------------------------------------
general protection fault: 0000 [#1] SMP
CPU 4
Modules linked in: tcp_diag inet_diag nfnetlink_log nfnetlink ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs ext3 jbd ext2 ip6_tables ebtable_nat ebtables cn rfcomm bnep
parport_pc ppdev lp parport tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative binfmt_misc fuse nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc iptable_filter ipt_MASQUERADE
ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables xfs ext4 jbd2 mbcache radeon drm_kms_helper ttm drm i2c_algo_bit loop kvm_intel kvm snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_usbmidi_lib snd_hwdep snd_pcm_oss snd_mixer_oss joydev snd_pcm acpi_cpufreq snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmi
di ath3k snd_seq snd_seq_device snd_timer iTCO_wdt bluetooth eeepci_wmi asus_wmi sparse_keymap crc16 rfkill pcspkr psmouse coretemp serio_raw evdev mperf pci_hotplug i2c_i801 i2c_core processor button
intel_agp snd mxm_wmi video wmi intel_gtt microcode soundcore sha256_generic dm_crypt dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq md_mod nbd btrfs libcrc32c
zlib_deflate sd_mod crc_t10dif crc32c_intel ghash_cmulni_intel firewire_ohci r8196 firewire_core ahci aesni_intel libahci mii crc_itu_t aes_x86_64 libata aes_generic cryptd scsi_mod e1000e thermal fa
n thermal_sys [last unloaded: scsi_wait_scan]

Pid: 30863, comm: btrfs-endio-met Tainted: G        W    3.4.2 #1 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff811e83bd>]  [<ffffffff811e83bd>] memcpy+0xd/0x110
RSP: 0000:ffff88003174dba8  EFLAGS: 00010202
RAX: ffff88003174dc8f RBX: 0000000000000011 RCX: 0000000000000002
RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff88003174dc8f
RBP: ffff88003174dbf0 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003174dca0
R13: ffff8800659f42b0 R14: 0000000000000048 R15: 0000000000000011
FS:  0000000000000000(0000) GS:ffff88021ed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000973c000 CR3: 0000000167ef3000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-met (pid: 30863, threadinfo ffff88003174c000, task ffff88006f818000)
Stack:
 ffffffffa026bd6b ffff8801960f5000 0000000000008003 0000000000001000
 ffff88003174dc58 00000000000003dd ffff88000ac13c60 ffff88003174dc58
 696f70203a61685f ffff88003174dc00 ffffffffa026904d ffff88003174dcd0
Call Trace:
 [<ffffffffa026bd6b>] ? read_extent_buffer+0xbb/0x110 [btrfs]
 [<ffffffffa026304d>] btrfs_node_key+0x1d/0x20 [btrfs]
 [<ffffffffa02994e0>] __readahead_hook.isra.5+0x3c0/0x420 [btrfs]
 [<ffffffffa029986f>] btree_readahead_hook+0x1f/0x40 [btrfs]
 [<ffffffffa023f841>] btree_readpage_end_io_hook+0x111/0x260 [btrfs]
 [<ffffffffa0267452>] ? find_first_extent_bit_state+0x22/0x80 [btrfs]
 [<ffffffffa026809b>] end_bio_extent_readpage+0xcb/0xa30 [btrfs]
 [<ffffffffa023ee61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
 [<ffffffff81158958>] bio_endio+0x18/0x30
 [<ffffffffa023ee6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
 [<ffffffffa0275857>] worker_loop+0x157/0x560 [btrfs]
 [<ffffffffa0275700>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
 [<ffffffff81058e5e>] kthread+0x8e/0xa0
 [<ffffffff81418fe4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
 [<ffffffff81418fe0>] ? gs_change+0x13/0x13
Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff ff eb e1 90 90 90 90 90 90 90...
8 4c 8b 56 10 4c
RIP  [<ffffffff811e83bd>] memcpy+0xd/0x110
 RSP <ffff88003174dba8>

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP8ihBAAoJEKLT589SE0a0VNQP/RpgntaRBe420A3hc4HOjhvn
J4XDwWgCFjFDqPRe5usJDMjQ1whaZqonFAmQ5TbDZkOSFzWiCoHWF/mAnuPpWH92
dyzDO474S4qQ/LGLgVVndua1FeKD+MQkyvlCfd73BA6sqqctq8iNCWQegWbkw44L
o6R+tZyxJUahicn6fi2AuXIjiu1wsOynIwEQEhcS1bnWmRJ0zpQuivPw7ENovIc5
pXfdbXgzoR9+axRCQwxwxdJMN7urGUlqEEeatYRlobfb+aX9+GmV6bpZJkZdPpwI
+T6Z1y0epPgkVs8uienJRt9S3j3Pgty6jz0CX78CD6Iw6k/ea/11XxvaV4QQp6sP
VoHxO8w1Sgu2WEUJSA6ioH7L2IopvsHKGQFmTTHPZZtReWZcv4G3XSwZqY6d5Vf8
ZUQgQIdq8Ga0cFVn38CbIy/Bjlppr6pwMpY/TGWpdCNEChVaXZo3pYV7aQbIZdGR
x6rN5V/CrZwgT/NrUoMDxfNUEbBN4h2GfI61Tkp3b6qxdNaRDAf+8wMMf526rPhd
UkpxZupyaMNeCQaeTu/gV1LjE+iEXeCcJbNj6VOHcOxt27GbojV/HpXipd6qT4gF
MMC7pvjHU5S8fMMNDdTmZ55cohMhdrgkVbj69aLjTE1MpZwdSOgj40BI/uh0pUX9
AHkFj9TzcDC532ob4b5R
=Eoc3
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
