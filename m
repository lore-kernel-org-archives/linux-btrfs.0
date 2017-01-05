Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:45336 "EHLO mail.crc.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762572AbdAELgd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 06:36:33 -0500
Received: from dhcp-10-1-1-170.lan.crc.id.au (2407-e400-b000-201-3630-49f5-93b4-16d6-cpe.spintel.net.au [IPv6:2407:e400:b000:201:3630:49f5:93b4:16d6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by mail.crc.id.au (Postfix) with ESMTPSA id 790363A003A
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jan 2017 22:27:52 +1100 (AEDT)
From: Steven Haigh <netwiz@crc.id.au>
Subject: System freeze mounting USB BTRFS filesystem
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <9bb7f7e8-e7d4-71ca-da16-213526ff8b7c@crc.id.au>
Date: Thu, 5 Jan 2017 22:27:48 +1100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HjuEHPBdOPNwDkUoBe3oR5DXTlC9oriWv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HjuEHPBdOPNwDkUoBe3oR5DXTlC9oriWv
Content-Type: multipart/mixed; boundary="9SDl7kxf5GH7gkULBWE64rnjcCAW3fGVt";
 protected-headers="v1"
From: Steven Haigh <netwiz@crc.id.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <9bb7f7e8-e7d4-71ca-da16-213526ff8b7c@crc.id.au>
Subject: System freeze mounting USB BTRFS filesystem

--9SDl7kxf5GH7gkULBWE64rnjcCAW3fGVt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm running Fedora 25 with kernel 4.8.15 (also tested 4.8.14), and when
I go to mount my USB BTRFS filesystem, the PC freezes completely.

I have managed to get a kernel crash once out of the number of freezes -
and I have attached that log. I have also posted a copy here:
	https://paste.fedoraproject.org/520173/36148521/raw/

I don't believe there is anything physically wrong with the USB drive,
as I can read at least the first 120Gb with dd via:
	dd if=3D/dev/sdc1 of=3D/dev/null bs=3D1M

I can successfully run btrfsck - and no read errors or messages are logge=
d:
$ btrfsck /dev/sdc1
Checking filesystem on /dev/sdc1
UUID: dba49c2d-5362-47ae-b25a-3c3e3aa1b66f
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 161932349440 bytes used err is 0
total csum bytes: 156784812
total tree bytes: 1338654720
total fs tree bytes: 1091043328
total extent tree bytes: 76120064
btree space waste bytes: 219938988
file data blocks allocated: 160593731584
 referenced 160593694720

Even though the tool mentions the 'repair is considered dangerous', I
ran it anyway, and got the following:
$ btrfsck --repair -p /dev/sdc1
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: dba49c2d-5362-47ae-b25a-3c3e3aa1b66f
checking extents [O]
Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
checking fs roots [.]
checking csums
checking root refs
found 161932349440 bytes used err is 0
total csum bytes: 156784812
total tree bytes: 1338654720
total fs tree bytes: 1091043328
total extent tree bytes: 76120064
btree space waste bytes: 219938988
file data blocks allocated: 160593731584
 referenced 160593694720

I tried to mount the filesystem again - and while the system doesn't
hard freeze, I get the following crash:

 kernel: BTRFS info (device sdc1): disk space caching is enabled


 kernel: BTRFS info (device sdc1): has skinny extents


 kernel: BUG: unable to handle kernel NULL pointer dereference at
000000000000035c

 kernel: IP: [<ffffffffc14eec0d>] flush_space+0x2ed/0x620 [btrfs]
 kernel: PGD 0
 kernel: Oops: 0000 [#1] SMP
 kernel: Modules linked in: btrfs xor raid6_pq uas usb_storage rfcomm
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute bridge stp llc ip6table_raw ip6table_security
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle iptable_raw iptable_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables bnep
hwmon_vid snd_hda_codec_hdmi intel_powerclamp coretemp kvm_intel kvm
irqbypass nvidia_drm(POE) ir_lirc_codec intel_cstate nvidia_modeset(POE)
lirc_dev intel_uncore iTCO_wdt nvidia(POE) iTCO_vendor_support
snd_hda_codec_realtek r820t snd_hda_codec_generic rtl2832 i2c_mux
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq btusb btrtl
 kernel:  snd_seq_device btbcm btintel snd_pcm bluetooth
dvb_usb_rtl28xxu r8169 dvb_usb_v2 joydev drm_kms_helper dvb_core
i2c_i801 rc_core rfkill drm i2c_smbus snd_timer mii lpc_ich snd
soundcore i7core_edac i5500_temp edac_core acpi_cpufreq tpm_tis
tpm_tis_core asus_atk0110 shpchp tpm nfsd auth_rpcgss nfs_acl lockd
grace sunrpc xfs libcrc32c mxm_wmi crc32c_intel serio_raw hid_microsoft
fjes wmi
 kernel: CPU: 6 PID: 2910 Comm: mount Tainted: P          IOE
4.8.15-300.fc25.x86_64 #1
 kernel: Hardware name: System manufacturer System Product
Name/P6X58D-E, BIOS 0803    08/06/2012
 kernel: task: ffffa2456d639d40 task.stack: ffffa245afd28000
 kernel: RIP: 0010:[<ffffffffc14eec0d>]  [<ffffffffc14eec0d>]
flush_space+0x2ed/0x620 [btrfs]
 kernel: RSP: 0018:ffffa245afd2b760  EFLAGS: 00010246
 kernel: RAX: 0000000000000001 RBX: 00000000ffffffff RCX: 000000000002000=
0
 kernel: RDX: 0000000000020000 RSI: ffffa24584e9f800 RDI: 000000000000000=
0
 kernel: RBP: ffffa245afd2b818 R08: 0000000000000001 R09: 000000000000000=
0
 kernel: R10: 00000000ffffffe4 R11: 0000000000000100 R12: 000000000000000=
0
 kernel: R13: 0000000000020000 R14: 0000000000000001 R15: 000000000000000=
2
 kernel: FS:  00007f1f55eaf340(0000) GS:ffffa245f9380000(0000)
knlGS:0000000000000000
 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 kernel: CR2: 000000000000035c CR3: 0000000124578000 CR4: 00000000000006e=
0
 kernel: Stack:
 kernel:  ffffa24561c09cc0 0000000000000000 0000000000000000
ffffa24561c09b40
 kernel:  ffffa24584e9f800 00000000e2c595b9 ffffa245afd2b7f8
ffffa24561c09cb8
 kernel:  0007ffffffffffff ffffa245afd2b7d0 0000000000020000
0000000000020000
 kernel: Call Trace:
 kernel:  [<ffffffffc14e1e3a>] ? can_overcommit.part.70+0x6a/0x100 [btrfs=
]
 kernel:  [<ffffffffc14ef5c4>] reserve_metadata_bytes+0x1c4/0xb60 [btrfs]=

 kernel:  [<ffffffffc14f0825>] btrfs_block_rsv_refill+0x75/0xa0 [btrfs]
 kernel:  [<ffffffffc15113b8>] btrfs_evict_inode+0x3e8/0x5c0 [btrfs]
 kernel:  [<ffffffffb30e4e10>] ? wake_atomic_t_function+0x60/0x60
 kernel:  [<ffffffffb326d4f3>] evict+0xb3/0x180
 kernel:  [<ffffffffb326d7d0>] iput+0x1b0/0x230
 kernel:  [<ffffffffc1512032>] btrfs_orphan_cleanup+0x1f2/0x430 [btrfs]
 kernel:  [<ffffffffc155f761>] btrfs_recover_relocation+0x351/0x460 [btrf=
s]
 kernel:  [<ffffffffc14fcd9c>] ? btrfs_cleanup_fs_roots+0x14c/0x180 [btrf=
s]
 kernel:  [<ffffffffc1501065>] open_ctree+0x2045/0x2520 [btrfs]
 kernel:  [<ffffffffc14d44b2>] btrfs_mount+0xda2/0xef0 [btrfs]
 kernel:  [<ffffffffb33fbb9d>] ? find_next_zero_bit+0x1d/0x20
 kernel:  [<ffffffffb33fbb78>] ? find_next_bit+0x18/0x20
 kernel:  [<ffffffffb3254bb8>] mount_fs+0x38/0x150
 kernel:  [<ffffffffb31e39a5>] ? __alloc_percpu+0x15/0x20
 kernel:  [<ffffffffb3271d97>] vfs_kern_mount+0x67/0x100
 kernel:  [<ffffffffc14d38b3>] btrfs_mount+0x1a3/0xef0 [btrfs]
 kernel:  [<ffffffffb33fbb9d>] ? find_next_zero_bit+0x1d/0x20
 kernel:  [<ffffffffb3254bb8>] mount_fs+0x38/0x150
 kernel:  [<ffffffffb31e39a5>] ? __alloc_percpu+0x15/0x20
 kernel:  [<ffffffffb3271d97>] vfs_kern_mount+0x67/0x100
 kernel:  [<ffffffffb327424d>] do_mount+0x1dd/0xc50
 kernel:  [<ffffffffb324c0b5>] ? __check_object_size+0x105/0x1dc
 kernel:  [<ffffffffb31ddccf>] ? memdup_user+0x4f/0x70
 kernel:  [<ffffffffb3274fc3>] SyS_mount+0x83/0xd0
 kernel:  [<ffffffffb3803b72>] entry_SYSCALL_64_fastpath+0x1a/0xa4
 kernel: Code: 48 8b 4d 98 4c 89 e2 4c 89 ee ff d0 49 8b 06 48 85 c0 75
da e9 78 ff ff ff 48 98 48 c1 e0 12 48 89 85 78 ff ff ff e9 d6 fe ff ff
<8b> 8f 5c 03 00 00 48 8b 45 98 31 d2 c1 e1 04 48 f7 f1 8d 1c 00
 kernel: RIP  [<ffffffffc14eec0d>] flush_space+0x2ed/0x620 [btrfs]
 kernel:  RSP <ffffa245afd2b760>
 kernel: CR2: 000000000000035c
 kernel: ---[ end trace c49186b736aa143c ]---

Has anyone seen this recently or have any ideas on how to fix this proble=
m?

Please CC me as well as the list as I don't believe I'm currently
subscribed to this specific list.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897



--9SDl7kxf5GH7gkULBWE64rnjcCAW3fGVt--

--HjuEHPBdOPNwDkUoBe3oR5DXTlC9oriWv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYbi21AAoJEEGvNdV6fTHcQNUP/3LpKIbHZCFGseq3JEFPcSgu
E+9mjW5lMe9Ash4cW0uaHMEwyoTqDeTNqSMkULKieBGifiUPbR8KMxBQh0LHjzIN
pmOP3fiLXtottmv9ltd1TVdtLdr9k+n9vhesnomHzGmS6ssLK6T7XeEnLwWUhd16
oHHiVHohrREc3ulOhsMWybG2n2eHp5m088d3IPrwLC3l2ldG7R5Rx5XneyHiljk/
/tNeXWGBVP2iA/WaVr+PHtROZhuxo44uvZhAo/lIykebOVuw5EMqYxsYVSCt98A1
eCka2UGTlOdC3QRzNuGld42b0KmZyRSZd36kmp9zeM3xuKCaC7dvM6ZGV2puGMlO
jZ7T+S5qadLY26M3M8j7fHuFFn3Nwdvxze+HieMsFT2iPIA2lbhSma9VJm0v1+a5
vQgOQI0zREFSI/IWLzY687VNNcsKNfI4N8royLOqAsASeR+PKxIspnMdTvZYPwmI
R2X1E0wvo+/9dVFro3C4fvEEanuiYHMPDIeWAA5W6whlM9PNUhnrqwZy/KsL06cW
WAb7KEZT1gle/NSODaA4OGkjY2x3Nu0RJJkgTVWrFsMDEjk1+uR6wV+RiEIr4BGh
gtAbw44/JxeHRJoA9PV8l7/ewDvsxtU3AxtGaZ16snIteGGFQgSctdF5mBtH+45j
CzzjWFd1pYysUmpyJlWd
=6pkM
-----END PGP SIGNATURE-----

--HjuEHPBdOPNwDkUoBe3oR5DXTlC9oriWv--
