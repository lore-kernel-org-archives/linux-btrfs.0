From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [BUG] Btrfs: Corrupted root filesystem
Date: Tue, 5 Jul 2011 11:15:37 +0100
Message-ID: <20110705101537.GA5481@carfax.org.uk>
References: <4E12BC70.5020702@turknetserver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Tarkan Erimer <tarkan@turknetserver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E12BC70.5020702@turknetserver.com>
List-ID: <linux-btrfs.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[added cc to linux-btrfs]

On Tue, Jul 05, 2011 at 10:25:36AM +0300, Tarkan Erimer wrote:
> At the weekend; I updated my Linux Box. After the update, I rebooted
> my box as usually. When I tried to log in, X or KDM was frozen. I
> had no choice but hard reset. After the hard reset; when powered on
> again, I hit the below btrfs bug :
> 
> [   22.588566] udev[1411]: starting version 166
> [   23.343133] device-mapper: uevent: version 1.0.3
> [   23.343327] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29)
> initialised: dm-devel@redhat.com
> [  183.992833] Btrfs loaded
> [  184.000282] device fsid 6e4eba2e662daff1-956db2b6443294be devid 1
> transid 156509 /dev/sda1
> [  184.026900] parent transid verify failed on 712880873472 wanted
> 156509 found 156065
> [  184.027365] parent transid verify failed on 712880873472 wanted
> 156509 found 156065
> [  184.033328] parent transid verify failed on 712880873472 wanted
> 156509 found 156065
> [  184.054422] parent transid verify failed on 485440565248 wanted
> 156055 found 156498
> [  184.054895] parent transid verify failed on 485440565248 wanted
> 156055 found 156498
> [  184.055045] parent transid verify failed on 485440565248 wanted
> 156055 found 156498
> [  184.058274] parent transid verify failed on 485440565248 wanted
> 156055 found 156498
> [  184.058281] parent transid verify failed on 485440565248 wanted
> 156055 found 156498
> [  184.058306] ------------[ cut here ]------------
> [  184.058312] kernel BUG at /usr/src/packages/BUILD/kernel-default-2.6.37.1/linux-2.6.37/fs/btrfs/disk-io.c:1004!
> [  184.058320] invalid opcode: 0000 [#1] SMP
> [  184.058326] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
> [  184.058332] CPU 0
> [  184.058335] Modules linked in: btrfs zlib_deflate dm_mod nls_utf8
> usb_storage ata_generic parport_pc parport arc4 ecb acpi_cpufreq
> mperf fan thermal nfs nfs_acl lockd fscache auth_rpcgss sunrpc
> nls_iso8859_1 nls_cp437 af_packet st usbhid uhci_hcd processor sky2
> sg sr_mod button cdrom ehci_hcd thermal_sys usbcore edd squashfs
> loop
> [  184.058384]
> [  184.058388] Pid: 1975, comm: mount Not tainted
> 2.6.37.1-1.2-default #1 LENOVO INVALID/To be filled by O.E.M.
> [  184.058400] RIP: 0010:[<ffffffffa02ac767>]  [<ffffffffa02ac767>]
> find_and_setup_root+0xf7/0x100 [btrfs]
> [  184.058427] RSP: 0018:ffff88006b851c48  EFLAGS: 00010282
> [  184.058429] RAX: 00000000fffffffe RBX: ffff88006e318800 RCX:
> 0000000000000001
> [  184.058432] RDX: 00000000fffffffb RSI: ffff880072e0bf40 RDI:
> ffff8800669f6140
> [  184.058435] RBP: ffff88006e318000 R08: 0000000000000000 R09:
> 0000000000000000
> [  184.058437] R10: 0000000000000001 R11: 0000000000000000 R12:
> 0000000000000002
> [  184.058440] R13: 00000000ffffffea R14: ffff880066850000 R15:
> ffff88006e318000
> [  184.058443] FS:  00007f15180bd7e0(0000) GS:ffff880075600000(0000)
> knlGS:0000000000000000
> [  184.058446] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  184.058448] CR2: 00007f236f078ca0 CR3: 000000006e4fb000 CR4:
> 00000000000406f0
> [  184.058451] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  184.058453] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  184.058456] Process mount (pid: 1975, threadinfo
> ffff88006b850000, task ffff88006b474700)
> [  184.058459] Stack:
> [  184.058460]  0000000000000002 ffffffffa02abbf5 ffff88006e76e000
> ffff880066851d18
> [  184.058465]  ffff88006e554800 ffffffffa02adbd7 0000000000000003
> ffff88006b851d18
> [  184.058469]  ffff88006b851dd8 ffffffff817a6279 ffff88006e318800
> ffff88006e76e800
> [  184.058473] Call Trace:
> [  184.058509]  [<ffffffffa02adbd7>] open_ctree+0xfc7/0x16e0 [btrfs]
> [  184.058536]  [<ffffffffa028de71>] btrfs_mount+0x411/0x520 [btrfs]
> [  184.058544]  [<ffffffff8114a529>] vfs_kern_mount+0x89/0x250
> [  184.058550]  [<ffffffff8114a763>] do_kern_mount+0x53/0x130
> [  184.058555]  [<ffffffff81164cc2>] do_mount+0x1e2/0x210
> [  184.058560]  [<ffffffff81164dda>] sys_mount+0x9a/0xf0
> [  184.058566]  [<ffffffff81002e4b>] system_call_fastpath+0x16/0x1b
> [  184.058571]  [<00007f15175abe4a>] 0x7f15175abe4a
> [  184.058573] Code: 45 10 31 c0 eb 93 66 0f 1f 44 00 00 8b 95 a8 02
> 00 00 eb b8 48 8b 7d 00 e8 47 71 02 00 b8 fb ff ff ff e9 72 ff ff ff
> 31 ff eb ed <0f> 0b 0f 1f 80 00 00 00 00 48 83 ec 58 48 89 6c 24 30
> 48 8b 2d
> [  184.058597] RIP  [<ffffffffa02ac767>]
> find_and_setup_root+0xf7/0x100 [btrfs]
> [  184.058607]  RSP <ffff88006b851c48>
> [  184.058609] ---[ end trace 4e464313e039d2d9 ]---
> [  208.206581] JFS: nTxBlock = 8192, nTxLock = 65536
> 
> 
> 
> 
> So, this bug ate all of my root file system :-\ When mounting or
> running btrfsck, the same error occurs. I tried with 2.6.37-38 and
> 3.0-rc5 kernels and the result is all the same. It looks like a long
> time bug that sits in btrfs code. I hope the above error message can
> help. Because, I had to re-format my disk :-\
> 
> 
> Tarkan
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOEuRJIKyzvlFcI40RAgAOAJsGG2zw62uaFl/FF4pj3ejT9QwMYgCfSadK
H8KyxS1eahnalbC+Awe1AvY=
=rStK
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
