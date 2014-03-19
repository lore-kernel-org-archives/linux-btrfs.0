Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:44563 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaCSF5z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 01:57:55 -0400
Received: by mail-ig0-f170.google.com with SMTP id uq10so13098839igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 22:57:54 -0700 (PDT)
Received: from [10.80.50.89] (CPEbc14012ad2f3-CMbc14012ad2f0.cpe.net.cable.rogers.com. [99.238.119.135])
        by mx.google.com with ESMTPSA id t1sm27927301igw.16.2014.03.18.22.57.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 18 Mar 2014 22:57:53 -0700 (PDT)
Message-ID: <532931D9.60809@gmail.com>
Date: Wed, 19 Mar 2014 01:57:45 -0400
From: Adam Khan <adam.s.khan@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Please advise on repair action
Content-Type: multipart/mixed;
 boundary="------------060806020604050302030806"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060806020604050302030806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I have a simple btrfs located on a dm-crypt volume. I'm getting a general protection fault when I 
attempt to access a specific directory in Thunar file manager and in a Python program.

The trace is attached for Thunar.

btrfsck returns this:

Checking filesystem on /dev/mapper/xyz_crypt
UUID: ...
found 88316880601 bytes used err is 1
total csum bytes: 180423792
total tree bytes: 291459072
total fs tree bytes: 50192384
total extent tree bytes: 12898304
btree space waste bytes: 55087032
file data blocks allocated: 352826490880
 referenced 184697802752
Btrfs v3.12

How should I proceed to repair this fs?

Best regards,

Adam

--------------060806020604050302030806
Content-Type: text/plain; charset=UTF-8;
 name="gpf_smp"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="gpf_smp"

[  313.491347] general protection fault: 0000 [#1] SMP=20
[  313.491387] Modules linked in: ccm xt_conntrack xt_LOG xt_limit xt_tcp=
udp iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ip=
v4 nf_nat nf_conntrack iptable_filter ip_tables x_tables rfcomm bnep defl=
ate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common=
 camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_generic=
 lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_commo=
n cast5_generic cast_common ablk_helper cryptd des_generic cmac xcbc rmd1=
60 sha512_ssse3 sha512_generic hmac crypto_null af_key xfrm_algo nfsd aut=
h_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext4 mbcache jbd2 =
fuse parport_pc ppdev lp parport hid_generic joydev hid_lenovo_tpkbd usbh=
id hid sg btusb bluetooth crc16 usb_storage iTCO_wdt iTCO_vendor_support =
snd_hda_codec_conexant coretemp kvm_intel kvm psmouse serio_raw pcspkr ev=
dev i2c_i801 lpc_ich mfd_core arc4 iwldvm mac80211 iwlwifi cfg80211 wmi b=
attery thinkpad_acpi nvram rfkill ac snd_hda_intel snd_hda_codec tpm_tis =
snd_hwdep snd_pcm tpm snd_page_alloc snd_seq snd_seq_device snd_timer i91=
5 snd video uhci_hcd ehci_pci drm_kms_helper button acpi_cpufreq ehci_hcd=
 drm i2c_algo_bit e1000e i2c_core mei_me processor mei ptp pps_core sound=
core usbcore usb_common btrfs crc32c libcrc32c xor raid6_pq sha256_ssse3 =
sha256_generic cbc dm_crypt dm_mod sd_mod crc_t10dif crct10dif_common ahc=
i libahci libata scsi_mod thermal thermal_sys
[  313.492281] CPU: 1 PID: 3946 Comm: Thunar Not tainted 3.13-1-amd64 #1 =
Debian 3.13.5-1
[  313.492313] Hardware name: LENOVO 7454CTO/7454CTO, BIOS 6DET71WW (3.21=
 ) 12/13/2011
[  313.492345] task: ffff88022fe1c010 ti: ffff88022f6d8000 task.ti: ffff8=
8022f6d8000
[  313.492376] RIP: 0010:[<ffffffff8127c66d>]  [<ffffffff8127c66d>] memcp=
y+0xd/0x110
[  313.492414] RSP: 0018:ffff88022f6d9970  EFLAGS: 00010206
[  313.492438] RAX: ffff8800aa2528b5 RBX: 000000000000034b RCX: 000000000=
0000069
[  313.492467] RDX: 0000000000000003 RSI: db73880000000000 RDI: ffff8800a=
a2528b5
[  313.492496] RBP: ffff880225b9e9c0 R08: 0000000000000000 R09: 000000000=
0001000
[  313.492525] R10: 0000000000000000 R11: 0000000000000000 R12: 6db6db6db=
6db6db7
[  313.492554] R13: 0000160000000000 R14: ffff8800aa252c00 R15: 000000000=
000034b
[  313.492584] FS:  00007fe3282f7a00(0000) GS:ffff88023bc80000(0000) knlG=
S:0000000000000000
[  313.492620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  313.492643] CR2: 00007fe2e0029228 CR3: 00000000b7625000 CR4: 000000000=
00407e0
[  313.492673] Stack:
[  313.492683]  ffffffffa013f168 0000000000000000 ffff8800b8289000 ffff88=
0225ac8c40
[  313.492724]  0000000000000000 0000000000000c00 ffff880225615330 ffff88=
0227448658
[  313.492764]  ffffffffa0125064 ffff880225b9e8f0 0000000000001000 ffff88=
00aa252000
[  313.492804] Call Trace:
[  313.492836]  [<ffffffffa013f168>] ? read_extent_buffer+0xc8/0x120 [btr=
fs]
[  313.492877]  [<ffffffffa0125064>] ? btrfs_get_extent+0x8f4/0x950 [btrf=
s]
[  313.492917]  [<ffffffffa0138154>] ? set_state_bits+0x34/0x70 [btrfs]
[  313.492957]  [<ffffffffa013b7b8>] ? __do_readpage+0x378/0x730 [btrfs]
[  313.492995]  [<ffffffffa013a4dd>] ? lock_extent_bits+0x6d/0x1c0 [btrfs=
]
[  313.493034]  [<ffffffffa0124770>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
[  313.493075]  [<ffffffffa013bf12>] ? __extent_readpages.constprop.42+0x=
2d2/0x2f0 [btrfs]
[  313.493119]  [<ffffffffa0124770>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
[  313.493160]  [<ffffffffa013daa2>] ? extent_readpages+0x182/0x190 [btrf=
s]
[  313.493201]  [<ffffffffa0124770>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
[  313.493234]  [<ffffffff811598a7>] ? alloc_pages_current+0x97/0x150
[  313.493264]  [<ffffffff81121f03>] ? __do_page_cache_readahead+0x193/0x=
240
[  313.493293]  [<ffffffff811223ba>] ? ondemand_readahead+0x14a/0x280
[  313.493322]  [<ffffffff811186ee>] ? generic_file_aio_read+0x4be/0x6e0
[  313.493350]  [<ffffffff81178d47>] ? do_sync_read+0x57/0x90
[  313.493376]  [<ffffffff8117935b>] ? vfs_read+0x8b/0x160
[  313.493399]  [<ffffffff81179e43>] ? SyS_read+0x43/0xa0
[  313.493424]  [<ffffffff814adb39>] ? system_call_fastpath+0x16/0x1b
[  313.493451] Code: fc ff ff 48 8b 43 58 48 2b 43 50 88 43 4e eb e9 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2=
 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c=20
[  313.493686] RIP  [<ffffffff8127c66d>] memcpy+0xd/0x110
[  313.493713]  RSP <ffff88022f6d9970>
[  313.500471] ---[ end trace a08695abfe727a2b ]---

--------------060806020604050302030806--
