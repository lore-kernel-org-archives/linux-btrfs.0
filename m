From: Michael Raskin <7c6f434c@mail.ru>
Subject: Kernel [BUG] trace on suspend.
Date: Fri, 30 Oct 2009 20:26:12 +0300
Message-ID: <4AEB21B4.3040603@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030207070504050006010208"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030207070504050006010208
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

	Attached find a dmesg snapshot. Configuration: Zen-kernel 2.6.31-zen5
with TuxOnIce and BtrFS, suspend from console.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJK6yGyAAoJEE6tnN0aWvw3I+MIAKD0PSuvF4GvuX3ZZj805ahD
InantIlWub4vYtUu/LnkqE574waAnjulXrSK8I3WLj1Pv1or9jhSLY+8HxzaG7Ag
N9k8i0UWiFMg2XABQPCesbts542wyKBN9bXmt6m49o4F0LmrcuiCk7LhfJV/An6R
cX9/KpgdDCvJd8akljfHkvnaLJs07F+FEPZcDMipbqy7X2o1pr7FfnhvVki3GC95
r0Z+ErrZrHpyRbi8BGygiTZxAoZDJ35KC1nAlDR01JXMBzYrqApptQ4uPeJbj259
nOYPNKAwD2zdUfbC0N2GiTpGbpV6pn6XgWEfeVkP/WxmvL4OgdqVqpq5vKxzisU=
=ueAW
-----END PGP SIGNATURE-----

--------------030207070504050006010208
Content-Type: text/plain;
 name="btrfs-bug.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="btrfs-bug.log"

[ 3233.289136] Initiating a hibernation cycle.
[ 3233.289360] TuxOnIce: Userui disabled.
[ 3233.289366] Freezing processes & syncing filesystems.
[ 3233.289396] Stopping fuse filesystems.
[ 3233.289403] Freezing user space processes ... (elapsed 0.00 seconds) d=
one.
[ 3233.290387] Stopping normal filesystems.
[ 3233.304122] Freezing remaining freezable tasks ... (elapsed 0.00 secon=
ds) done.
[ 3233.347382] Preparing Image. Try 1.
[ 3233.348853] Restarting normal filesystems.
[ 3233.386864] Stopping fuse filesystems.
[ 3233.386886] Freezing user space processes ... (elapsed 0.00 seconds) d=
one.
[ 3233.387014] Stopping normal filesystems.
[ 3233.388751] Freezing remaining freezable tasks ... (elapsed 0.00 secon=
ds) done.
[ 3233.441488] Starting to save the image..
[ 3233.442305] Writing caches...
[ 3235.444557] ...20%...40%...60%...80%...100%
[ 3243.580723] Waited for i/o due to synchronous I/O 5 times.
[ 3243.580726] Waited for i/o due to throughput_throttle 2829 times.
[ 3243.580731] Doing atomic copy/restore.
[ 3243.581526] Suspending console(s) (use no_console_suspend to debug)
[ 3243.581787] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3243.652009] radeonfb (0000:01:05.0): suspending for event: 1...
[ 3243.684027] HDA Intel 0000:00:14.2: PCI INT A disabled
[ 3243.700104] pata_atiixp 0000:00:14.1: PCI INT A disabled
[ 3244.528007] ata1: softreset failed (device not ready)
[ 3244.528010] ata1: applying SB600 PMP SRST workaround and retrying
[ 3244.692018] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3244.692949] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[ 3244.694003] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[ 3244.694006] ata1.00: configured for UDMA/100
[ 3244.694144] ahci 0000:00:12.0: PCI INT A disabled
[ 3244.695137] ACPI: Preparing to enter system sleep state S4
[ 3244.695862] PM: Saving platform NVS memory
[ 3244.704665] Disabling non-boot CPUs ...
[ 3244.704724] Extended CMOS year: 2000
[ 3244.704724] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[ 3244.704724] Intel machine check architecture supported.
[ 3244.704724] Intel machine check reporting enabled on CPU#0.
[ 3244.704724] mce: CPU supports 6 MCE banks
[ 3244.704724] PM: Restoring platform NVS memory
[ 3244.704724] Extended CMOS year: 2000
[ 3244.704724] ACPI: Waking up from system sleep state S4
[ 3244.788092] unable to find logical 137439014912 len 4096
[ 3244.788135] ------------[ cut here ]------------
[ 3244.788137] Kernel BUG at f82f7c75 [verbose debug info unavailable]
[ 3244.788140] invalid opcode: 0000 [#1] SMP=20
[ 3244.788143] last sysfs file: /sys/power/state
[ 3244.788145] Modules linked in: md4 raid456 raid6_pq async_xor async_me=
mcpy async_tx xor raid1 raid0 af_packet md_mod snd_pcm_oss snd_mixer_oss =
pktcdvd pata_atiixp video output ipv6 ipip tunnel4 radeon drm snd_hda_cod=
ec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd=
_pcm snd_timer snd soundcore snd_page_alloc ftdi_sio usbserial loop ati_a=
gp agpgart p4_clockmod freq_table speedstep_lib 8139too mii kqemu fuse th=
ermal thermal_sys hwmon ac battery tun usb_storage usb_libusual radeonfb =
fb_ddc i2c_algo_bit dm_mod ide_generic ide_gd_mod ide_cd_mod ide_core sr_=
mod cdrom pata_marvell ata_piix sata_uli sata_sis pata_sis sata_via sata_=
nv ahci tuxonice_userui tuxonice_swap tuxonice_block_io tuxonice_core bfq=
_iosched xtkbd atkbd ohci_hcd ssb pcmcia pcmcia_core firmware_class ehci_=
hcd uhci_hcd usbhid hid usbcore nls_base unix btrfs zlib_deflate libcrc32=
c crc32c libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache synaptics_i2c=
 i2c_core sermouse psmouse libps2 evdev mousedev pcips2 i8042 serio
[ 3244.788207]=20
[ 3244.788211] Pid: 2053, comm: btrfs-transacti Not tainted (2.6.31-zen5 =
#1) X51RL              =20
[ 3244.788213] EIP: 0060:[<f82f7c75>] EFLAGS: 00010286 CPU: 0
[ 3244.788247] EIP is at __btrfs_map_block+0xde/0x4c8 [btrfs]
[ 3244.788250] EAX: 00000042 EBX: 00001000 ECX: c126e3dc EDX: ffffffff
[ 3244.788252] ESI: 0000f000 EDI: 00000020 EBP: f5147a10 ESP: f514797c
[ 3244.788255]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 3244.788258] Process btrfs-transacti (pid: 2053, ti=3Df5147000 task=3Df=
4822cc0 task.ti=3Df5147000)
[ 3244.788259] Stack:
[ 3244.788261]  f830e5b2 0000f000 00000020 00001000 00000000 f51479a8 c11=
596f7 00000000
[ 3244.788265] <0> 00000000 00000000 0000006d 00001000 f61ba098 f61ba09c =
f58c8180 f3febcc8
[ 3244.788270] <0> 00000000 f35eb9b0 f51479e0 f5dc0550 f5dc0550 f3fed1c8 =
00000008 00000001
[ 3244.788275] Call Trace:
[ 3244.788295]  [<c11596f7>] ? div64_u64+0x52/0x59
[ 3244.788323]  [<f82f3058>] ? set_extent_bit+0xa1/0x46a [btrfs]
[ 3244.788357]  [<f82f80b0>] ? btrfs_map_block+0x1e/0x20 [btrfs]
[ 3244.788392]  [<f82e4b51>] ? btrfs_merge_bio_hook+0x65/0x8c [btrfs]
[ 3244.788426]  [<f82e4aec>] ? btrfs_merge_bio_hook+0x0/0x8c [btrfs]
[ 3244.788461]  [<f82f1da1>] ? submit_extent_page+0xaf/0x1a0 [btrfs]
[ 3244.788495]  [<f82f4cc8>] ? __extent_read_full_page+0x600/0x68e [btrfs=
]
[ 3244.788530]  [<f82f5137>] ? end_bio_extent_readpage+0x0/0x217 [btrfs]
[ 3244.788563]  [<f82d6e8a>] ? btree_get_extent+0x0/0x18e [btrfs]
[ 3244.788597]  [<f82f4f29>] ? read_extent_buffer_pages+0x1d3/0x271 [btrf=
s]
[ 3244.788631]  [<f82d6dab>] ? btree_read_extent_buffer_pages+0x41/0x95 [=
btrfs]
[ 3244.788663]  [<f82d6e8a>] ? btree_get_extent+0x0/0x18e [btrfs]
[ 3244.788697]  [<f82d7694>] ? read_tree_block+0x45/0x5d [btrfs]
[ 3244.788727]  [<f82c5494>] ? read_block_for_search+0x247/0x27a [btrfs]
[ 3244.788733]  [<c1020d5a>] ? kmap_atomic_prot+0xee/0x110
[ 3244.788737]  [<c1020d5a>] ? kmap_atomic_prot+0xee/0x110
[ 3244.788769]  [<f82c96bf>] ? btrfs_search_slot+0x343/0x444 [btrfs]
[ 3244.788801]  [<f82cf114>] ? lookup_inline_extent_backref+0xea/0x3e6 [b=
trfs]
[ 3244.788806]  [<c114c8ea>] ? blk_do_ordered+0x184/0x247
[ 3244.788837]  [<f82d008f>] ? __btrfs_free_extent+0xa4/0x5fe [btrfs]
[ 3244.788872]  [<f82f8055>] ? __btrfs_map_block+0x4be/0x4c8 [btrfs]
[ 3244.788903]  [<f82d0a63>] ? run_one_delayed_ref+0x47a/0x48f [btrfs]
[ 3244.788908]  [<c10080c6>] ? sched_clock+0x8/0xb
[ 3244.788940]  [<f82d2a8e>] ? run_clustered_refs+0x1f7/0x230 [btrfs]
[ 3244.788972]  [<f82d2b78>] ? btrfs_run_delayed_refs+0xb1/0x147 [btrfs]
[ 3244.788977]  [<c126e1d6>] ? _spin_lock+0xd/0x10
[ 3244.789012]  [<f82db974>] ? btrfs_commit_transaction+0x6a/0x580 [btrfs=
]
[ 3244.789045]  [<f82db64f>] ? start_transaction+0x24/0x11b [btrfs]
[ 3244.789050]  [<c103e483>] ? autoremove_wake_function+0x0/0x38
[ 3244.789083]  [<f82d7b80>] ? transaction_kthread+0x0/0x1fc [btrfs]
[ 3244.789116]  [<f82d7cff>] ? transaction_kthread+0x17f/0x1fc [btrfs]
[ 3244.789149]  [<f82d7b80>] ? transaction_kthread+0x0/0x1fc [btrfs]
[ 3244.789152]  [<c103e1f2>] ? kthread+0x73/0x78
[ 3244.789155]  [<c103e17f>] ? kthread+0x0/0x78
[ 3244.789159]  [<c10041c7>] ? kernel_thread_helper+0x7/0x10
[ 3244.789161] Code: 7d 1c 00 0f 95 45 9b 84 c0 74 27 31 c0 80 7d 9b 00 0=
f 85 f6 03 00 00 8b 45 10 ff 70 04 ff 30 57 56 68 b2 e5 30 f8 e8 67 4a f7=
 c8 <0f> 0b 83 c4 14 eb fe 8b 4d ac 8b 41 0c 8b 51 10 39 fa 77 23 72=20
[ 3244.789185] EIP: [<f82f7c75>] __btrfs_map_block+0xde/0x4c8 [btrfs] SS:=
ESP 0068:f514797c
[ 3244.789221] ---[ end trace 26ec96f422909e55 ]---
[ 3245.052599] ahci 0000:00:12.0: restoring config space at offset 0x1 (w=
as 0x2300103, writing 0x2300107)
[ 3245.052846] ehci_hcd 0000:00:13.5: PME# disabled
[ 3245.052908] pata_atiixp 0000:00:14.1: restoring config space at offset=
 0x3 (was 0x0, writing 0x4000)
[ 3245.052932] HDA Intel 0000:00:14.2: restoring config space at offset 0=
xf (was 0x10b, writing 0xb)
[ 3245.052962] HDA Intel 0000:00:14.2: restoring config space at offset 0=
x1 (was 0x4100006, writing 0x4100002)
[ 3245.339301] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ=
 22
[ 3245.395985] usb usb2: root hub lost power or was reset
[ 3245.455983] usb usb3: root hub lost power or was reset
[ 3245.515983] usb usb4: root hub lost power or was reset
[ 3245.575984] usb usb5: root hub lost power or was reset
[ 3245.635983] usb usb6: root hub lost power or was reset
[ 3245.636004] ehci_hcd 0000:00:13.5: PME# disabled
[ 3245.636012] usb usb1: root hub lost power or was reset
[ 3245.636032] ehci_hcd 0000:00:13.5: debug port 1
[ 3245.636048] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low)=
 -> IRQ 16
[ 3245.637604] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[ 3245.660025] ata2: SATA link down (SStatus 0 SControl 300)
[ 3245.660058] ata3: SATA link down (SStatus 0 SControl 300)
[ 3245.660087] ata4: SATA link down (SStatus 0 SControl 300)
[ 3245.732326] radeonfb (0000:01:05.0): resuming from state: 1...
[ 3245.794853] pci 0000:02:00.0: PME# disabled
[ 3245.794862] pci 0000:08:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ =
21
[ 3245.794874] pci 0000:08:01.1: PME# disabled
[ 3245.794881] pci 0000:08:01.2: PME# disabled
[ 3245.794913] eth0: link down
[ 3245.800647] ata5.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[ 3245.800651] ata5.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
[ 3245.800654] ata5.01: ACPI cmd f5/00:00:00:00:00:b0 filtered out
[ 3245.816618] ata5.01: configured for UDMA/33
[ 3245.928041] sd 0:0:0:0: [sda] Starting disk
[ 3246.068007] ata1: softreset failed (device not ready)
[ 3246.068011] ata1: applying SB600 PMP SRST workaround and retrying
[ 3246.232018] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3246.232925] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[ 3246.233982] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[ 3246.233985] ata1.00: configured for UDMA/100
[ 3246.750177] Post atomic.
[ 3246.750919] Reading caches...
[ 3256.764890] ...20%...40%...60%...80%...100%
[ 3257.495457] Waited for i/o due to throughput_throttle 3088 times.
[ 3257.497541] Cleaning up...
[ 3257.499175] Restarting all filesystems ...
[ 3257.502604] Restarting tasks ... Restarting tasks ... done.
[ 3257.607763] TuxOnIce debugging info:
[ 3257.607766] - TuxOnIce core  : 3.0.1
[ 3257.607767] - Kernel Version : 2.6.31-zen5
[ 3257.607768] - Compiler vers. : 4.3
[ 3257.607769] - Attempt number : 1
[ 3257.607770] - Parameters     : 0 667648 0 0 0 0
[ 3257.607771] - Overall expected compression percentage: 0.
[ 3257.607772] - Checksum method is 'md4'.
[ 3257.607773]   0 pages resaved in atomic copy.
[ 3257.607774] - Max outstanding reads 1044. Max writes 4664.
[ 3257.607775]   Memory_needed: 1024 x (4096 + 200 + 76) =3D 4476928 byte=
s.
[ 3257.607777]   Free mem throttle point reached 0.
[ 3257.607778] - SwapAllocator active.
[ 3257.607779]   Swap available for image: 623283 pages.
[ 3257.607780] - I/O speed: Write 34 MB/s, Read 35 MB/s.
[ 3257.607781] - Extra pages    : 59 used/2000.
[ 3257.607782] - Result         : Succeeded.

--------------030207070504050006010208
Content-Type: application/octet-stream;
 name="btrfs-bug.log.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs-bug.log.sig"

iQEcBAABAgAGBQJK6yGyAAoJEE6tnN0aWvw3XUkH/jCWtlsg7+IYWbtC3eIjfNYi1K6U0lb6
sOf668vNmjCASCptf3eZwImC4buhovOta/FfPyJx97t1t8eZDPT3qyFUNu50kV1+WTi+Hpbe
caJK1Mx/ei4SFW4i93rF4PvcEWM3U1kpVUooYdghcWavtHLO2tZWdOYN0fm3DXBbKN2MjpM8
pAXAnJQEnFhjlPDDW705omJNUNM7CEHAhe3UGYTatgTzVt7q2pEWXGJ8AnCk3aatAVw0upRS
e7CP61Ki73LtouRUZe94LufaUIHUcATCxvlEqq2ahxAJJjgd8vLAlkcZmFXV9kBmvCt2o17m
8DgwqqRgvjlWVEtL5jrx2hU=
--------------030207070504050006010208--
