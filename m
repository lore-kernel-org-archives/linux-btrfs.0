Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41954 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbKAMe6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 07:34:58 -0500
Date: Sun, 1 Nov 2015 12:34:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ken Long <kelargo1000@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: trying to balance, filesystem keeps going read-only.
Message-ID: <20151101123455.GI21103@carfax.org.uk>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZVh52eu0Ophig4D"
In-Reply-To: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZVh52eu0Ophig4D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 01, 2015 at 06:24:53AM -0500, Ken Long wrote:
> I have a file system of four 5TB drives. Well, one drive is 8TB with a
> 5TB partition.. the rest are 5TB drives.  I created the initial btrfs
> file system on on drive. rsync'd data to it. added another drive.
> rsync'd data. added a third drive, rsync'd data. Added a four drive,
> trying to balance. The file system gets an error and I have to reboot
> to get the file system out of read only.
> 
> I dont think it is hardware issue..but It could be...  or it could be
> some kind bug in btrfs?

   Looks very much like a hardware error to me. This stuff:

> [64947.160961] ata10.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
> action 0x6 frozen
> [64947.160966] ata10.00: failed command: WRITE FPDMA QUEUED
> [64947.160970] ata10.00: cmd 61/c0:00:38:8a:1d/0f:00:0c:00:00/40 tag 0
> ncq 2064384 out
>                         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
> 0x4 (timeout)

is coming from the ATA layer, a couple of layers below btrfs, and
would definitely indicate some kind of issue with the hardware.

> [66025.199406] ata10: softreset failed (1st FIS failed)
> [66025.199417] ata10: hard resetting link
> [66030.407703] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [66030.407713] ata10.00: link online but device misclassified
> [66030.407746] ata10: EH complete
> [66030.408360] sd 9:0:0:0: [sdg] tag#16 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.408363] sd 9:0:0:0: [sdg] tag#16 CDB: Write(16) 8a 00 00 00 00
> 00 09 a4 bf 80 00 00 49 80 00 00
> [66030.408365] blk_update_request: I/O error, dev sdg, sector 161791872
> [66030.408369] BTRFS: bdev /dev/sdg errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> [66030.408439] BTRFS: bdev /dev/sdg errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> [66030.408537] BTRFS: bdev /dev/sdg errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
> [66030.408643] BTRFS: bdev /dev/sdg errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
> [66030.408768] BTRFS: bdev /dev/sdg errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
> [66030.408880] BTRFS: bdev /dev/sdg errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
> [66030.408985] BTRFS: bdev /dev/sdg errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
> [66030.409082] BTRFS: bdev /dev/sdg errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
> [66030.409180] BTRFS: bdev /dev/sdg errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
> [66030.409284] BTRFS: bdev /dev/sdg errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> [66030.409847] sd 9:0:0:0: [sdg] tag#17 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.409850] sd 9:0:0:0: [sdg] tag#17 CDB: Write(16) 8a 00 00 00 00
> 00 09 a5 09 00 00 00 44 40 00 00
> [66030.409851] blk_update_request: I/O error, dev sdg, sector 161810688
> [66030.411235] sd 9:0:0:0: [sdg] tag#18 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.411238] sd 9:0:0:0: [sdg] tag#18 CDB: Write(16) 8a 00 00 00 00
> 00 09 a5 4d 40 00 00 49 80 00 00
> [66030.411239] blk_update_request: I/O error, dev sdg, sector 161828160
> [66030.412695] sd 9:0:0:0: [sdg] tag#19 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.412697] sd 9:0:0:0: [sdg] tag#19 CDB: Write(16) 8a 00 00 00 00
> 00 09 a5 96 c0 00 00 49 80 00 00
> [66030.412699] blk_update_request: I/O error, dev sdg, sector 161846976
> [66030.414113] sd 9:0:0:0: [sdg] tag#20 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.414115] sd 9:0:0:0: [sdg] tag#20 CDB: Write(16) 8a 00 00 00 00
> 00 09 a5 e0 40 00 00 1f 80 00 00
> [66030.414117] blk_update_request: I/O error, dev sdg, sector 161865792
> [66030.414755] sd 9:0:0:0: [sdg] tag#21 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.414758] sd 9:0:0:0: [sdg] tag#21 CDB: Write(16) 8a 00 00 00 00
> 00 09 a5 ff c0 00 00 15 00 00 00
> [66030.414759] blk_update_request: I/O error, dev sdg, sector 161873856
> [66030.415205] sd 9:0:0:0: [sdg] tag#22 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.415207] sd 9:0:0:0: [sdg] tag#22 CDB: Write(16) 8a 00 00 00 00
> 00 09 a6 14 c0 00 00 44 40 00 00
> [66030.415208] blk_update_request: I/O error, dev sdg, sector 161879232
> [66030.416562] sd 9:0:0:0: [sdg] tag#23 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.416564] sd 9:0:0:0: [sdg] tag#23 CDB: Write(16) 8a 00 00 00 00
> 00 09 a6 59 00 00 00 44 40 00 00
> [66030.416572] blk_update_request: I/O error, dev sdg, sector 161896704
> [66030.417922] sd 9:0:0:0: [sdg] tag#24 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.417924] sd 9:0:0:0: [sdg] tag#24 CDB: Write(16) 8a 00 00 00 00
> 00 09 a6 9d 40 00 00 49 80 00 00
> [66030.417926] blk_update_request: I/O error, dev sdg, sector 161914176
> [66030.419365] sd 9:0:0:0: [sdg] tag#25 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [66030.419368] sd 9:0:0:0: [sdg] tag#25 CDB: Write(16) 8a 00 00 00 00
> 00 09 a6 e6 c0 00 00 49 80 00 00

   Here, we've got a bunch of write errors returned from the
hardware. At this point, btrfs is giving up, in the name of safety:

> [66030.419369] blk_update_request: I/O error, dev sdg, sector 161932992
> [66031.291479] BTRFS: error (device sdb) in write_all_supers:3548:
> errno=-5 IO failure (errors while submitting device barriers.)
> [66031.291484] BTRFS info (device sdb): forced readonly
> [66031.291487] BTRFS warning (device sdb): Skipping commit of aborted
> transaction.
> [66031.291489] ------------[ cut here ]------------
> [66031.291505] WARNING: CPU: 5 PID: 11970 at
> /build/linux-d3RvQM/linux-4.2.0/fs/btrfs/transaction.c:1710
> cleanup_transaction+0x92/0x2f0 [btrfs]()
> [66031.291507] BTRFS: Transaction aborted (error -5)
> [66031.291508] Modules linked in: ipheth snd_seq_dummy rfcomm
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge
> stp llc ebtable_filter ebtables ip6table_filter ip6_tables
> iptable_filter ip_tables x_tables vmw_vsock_vmci_transport vsock
> vmw_vmci snd_hrtimer binfmt_misc bnep ch341 usbserial eeepc_wmi
> asus_wmi sparse_keymap video mxm_wmi crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
> ablk_helper cryptd serio_raw fam15h_power edac_core k10temp
> edac_mce_amd joydev input_leds btusb btrtl btbcm btintel bluetooth
> snd_hdsp i2c_piix4 snd_ice1724 snd_ak4113 snd_pt2258 snd_ak4114
> snd_i2c snd_ice17xx_ak4xxx snd_ak4xxx_adda
> [66031.291541]  snd_ac97_codec ac97_bus snd_hda_codec_realtek
> snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
> snd_hda_core snd_hwdep 8250_fintek tpm_infineon shpchp mac_hid wmi
> kvm_amd kvm cuse snd_aloop snd_pcm snd_seq_midi snd_seq_midi_event
> snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore parport_pc
> ppdev lp parport autofs4 btrfs raid10 raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0
> multipath linear hid_generic usbhid hid psmouse r8169 mii amdkfd
> amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper drm ahci libahci
> [66031.291569] CPU: 5 PID: 11970 Comm: btrfs-transacti Not tainted
> 4.2.0-17-lowlatency #21-Ubuntu
> [66031.291570] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./SABERTOOTH 990FX R2.0, BIOS 1903 07/08/2013
> [66031.291572]  0000000000000000 0000000094954717 ffff8803b162bc98
> ffffffff817f5409
> [66031.291574]  0000000000000000 ffff8803b162bcf0 ffff8803b162bcd8
> ffffffff8107bed6
> [66031.291576]  0000000000000246 ffff8803b1cd4d38 ffff8803d11de800
> ffff8804178fc450
> [66031.291578] Call Trace:
> [66031.291583]  [<ffffffff817f5409>] dump_stack+0x4c/0x6e
> [66031.291586]  [<ffffffff8107bed6>] warn_slowpath_common+0x86/0xc0
> [66031.291588]  [<ffffffff8107bf65>] warn_slowpath_fmt+0x55/0x70
> [66031.291598]  [<ffffffffc037aca2>] cleanup_transaction+0x92/0x2f0 [btrfs]
> [66031.291601]  [<ffffffff810beb10>] ? wake_atomic_t_function+0x60/0x60
> [66031.291611]  [<ffffffffc037c117>]
> btrfs_commit_transaction+0xa07/0xb20 [btrfs]
> [66031.291620]  [<ffffffffc0376da3>] transaction_kthread+0x1c3/0x230 [btrfs]
> [66031.291629]  [<ffffffffc0376be0>] ?
> btrfs_cleanup_transaction+0x560/0x560 [btrfs]
> [66031.291631]  [<ffffffff8109b908>] kthread+0xd8/0xf0
> [66031.291633]  [<ffffffff8109b830>] ? kthread_worker_fn+0x170/0x170
> [66031.291635]  [<ffffffff817fc9df>] ret_from_fork+0x3f/0x70
> [66031.291637]  [<ffffffff8109b830>] ? kthread_worker_fn+0x170/0x170
> [66031.291638] ---[ end trace c69e578c3752000c ]---
> [66031.291640] BTRFS: error (device sdb) in cleanup_transaction:1710:
> errno=-5 IO failure
> [66031.291642] BTRFS info (device sdb): delayed_refs has NO entry
> [66031.292522] BTRFS warning (device sdb): Skipping commit of aborted
> transaction.
> [66031.292527] BTRFS: error (device sdb) in cleanup_transaction:1710:
> errno=-5 IO failure
> [66031.292530] BTRFS info (device sdb): delayed_refs has NO entry
> [66031.292659] BTRFS: error (device sdb) in __cancel_balance:3452:
> errno=-5 IO failure

   Hugo.

-- 
Hugo Mills             | I can resist everything except temptation.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--YZVh52eu0Ophig4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWNgbvAAoJEFheFHXiqx3kvp8P/2TpCTDsLcHYXHBOmcAXcjKt
vs3fiQFWwQwkkfT/SHW1M7vMs1YAapGhV0aVCESrobeKW8FkVvJP/q/K6dFW/pII
86zrxnY3pFcYQ8vjJ8WUmA4jevcpOI21W0diOk5qv/ECZLnQ/t5zfn3vYWmSf/Uw
2hQAvYK7usxCCUbmjD6bkbf3tuKybjkIHkvgCcLbR8RcmJF6/loPPpon7LoPGiC5
GQ8f6UWv9DSUBX7a+tiu1RXJDg9dUSPIC4TAXy5I/LvZTvd/7kPHKslaILqlRTXQ
e6VsIpS6xvifYXmcVW9Xh0PpdL2g9Q7lIHis9bFQOOwufGmcL3hDHA1Wsn+bkcHy
YXMYqX9OxAAlQjljQUSFt5Rp010ekPo032mSdtelaCiavS5MYYBsEcVYoMdXrnFT
f9Rz7ydum+yh4SN3I1ZYDEBepW17EOdokklNIVvtmYf5wI+UIPFrRCwcPqVZ/YDv
iq4+zOkGMd4cLfkU/t+PxXQqEMP/6XJq41v9FEYdcOZ/VRouxe11U5xE1Fkbflq8
OON60wSgGHHMrVGs0MiqlzmSPMiiKlTf4y5D4HpoYsfO1ZmcuLdLYwTFKLFxP1+8
DRxuficXMD6WZfVKzkWKkETq1plRiCGqdqrPcQEM0uCGhorUwI3zWKmNfv33GTvr
VvyjtdKjBA9yABQlbeqa
=MSyp
-----END PGP SIGNATURE-----

--YZVh52eu0Ophig4D--
