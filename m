Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:32802 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbKQM4o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 07:56:44 -0500
Received: by igvi2 with SMTP id i2so96038841igv.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2015 04:56:43 -0800 (PST)
Subject: Re: btrfs-replace OOM on 2GB machine
To: Georg Lukas <georg@op-co.de>, linux-btrfs@vger.kernel.org
References: <20151113161501.GA29604@ovgu.de>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564B23D8.2000202@gmail.com>
Date: Tue, 17 Nov 2015 07:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <20151113161501.GA29604@ovgu.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010602070803050005070007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010602070803050005070007
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 11:15, Georg Lukas wrote:
> Hi,
>
> while evaluating btrfs for production use I ended up with a degraded
> two-disk RAID1 with one disk missing, and wanted to perform a "btrfs
> replace" to rebuild the RAID1. However, the replace operation causes
> most of my userland to be OOM-killed and aborts eventually, at about
> 30% progress, on a box with 2GB of physical RAM.
>
> My setup is:
>
> Linux-4.3 with the following patches applied:
>   - http://www.spinics.net/lists/linux-btrfs/msg46123.html
>     (needed for degraded mount of RAID1)
>   - http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/patch/?id=
=3D7c4fbd50bfece00abf529bc96ac989dd2bb83ca4
>     (needed for the Seagate SMRs)
>
> btrfs-progs v4.2.3
>
> A btrfs RAID1 initially built on two dm-crypt containers on top of two
> Seagate 8TB SMR disks. For testing purposes, I unmounted the fs,
> reformatted one of the two crypto containers, mounted the fs in degrade=
d
> mode (which required Anand's patch), and tried different approaches to
> get it back to full operation (rebalance to m=3Dd=3Dsingle, remove the
> missing drive, finally a replace), all without success.
While it probably isn't related to the OOM issue, I would be=20
particularly wary of using BTRFS on SMR disks, we've had multiple=20
reports of serious issues with them (and IIRC, they were all the same=20
model of 8TB Seagate SMR disks).
>
> The current status is as follows:
>
> # btrfs dev usage /media/archive/
> /dev/mapper/archive1, ID: 1
>     Device size:             7.28TiB
>     Data,single:           837.00GiB
>     Data,RAID0:              1.17TiB
>     Data,RAID1:            959.00GiB
>     Data,DUP:                2.17TiB
>     Metadata,single:         2.00GiB
>     Metadata,RAID1:          4.00GiB
>     Metadata,DUP:            5.00GiB
>     System,RAID1:           32.00MiB
>     System,DUP:            192.00MiB
>     Unallocated:             2.17TiB
>
> missing, ID: 2
>     Device size:               0.00B
>     Data,RAID0:              1.17TiB
>     Data,RAID1:            959.00GiB
>     Metadata,RAID1:          4.00GiB
>     System,RAID1:           32.00MiB
>     Unallocated:             5.17TiB
Hmm, it looks like things weren't all RAID1, you've got a little over=20
1TiB of data that was RAID0, and that may be why you can't rebuild the=20
FS.  This shouldn't be causing an OOM condition, but it definitely means =

things are not fully recoverable.
>
> I then start the replace:
>
> # btrfs replace start 2 /dev/mapper/archive2 /media/archive/
>
> That takes a while, OOM-kills half of my userspace in the process (it
> seems like the kernel is allocating and freeing large chunks of memory
> during the replace:
>
>               total       used       free     shared    buffers     cac=
hed
> Mem:          1.9G       1.6G       342M       784K       1.8M        1=
4M
> -/+ buffers/cache:       1.6G       358M
> Swap:         4.0G        48M       4.0G
>
> (5 second pause)
>               total       used       free     shared    buffers     cac=
hed
> Mem:          1.9G       157M       1.8G       808K       6.6M        3=
2M
> -/+ buffers/cache:       118M       1.8G
> Swap:         4.0G        46M       4.0G
>
> (another 5 seconds)
>               total       used       free     shared    buffers     cac=
hed
> Mem:          1.9G       1.1G       835M       808K       6.7M        3=
7M
> -/+ buffers/cache:       1.1G       879M
> Swap:         4.0G        46M       4.0G
>
> That seems to be kernel memory, as the swap is hardly used, despite
> default swappiness settings. Furthermore, /proc/meminfo and slabtop hav=
e
> no indication of how the memory is used; it just vanishes from the
> "available" pool.
This sounds to me like a memory leak in the kernel, but I'm not certain. =

  I'm going to try and reproduce this without the SMR patch (and=20
obviously without the SMR drives themselves) in a VM.
>
> Eventually, the replace aborts:
>
> [64326.700731] BTRFS: btrfs_scrub_dev(<missing disk>, 2, /dev/mapper/ar=
chive2) failed -12
> [64326.700986] ------------[ cut here ]------------
> [64326.701024] WARNING: CPU: 1 PID: 36251 at fs/btrfs/dev-replace.c:428=
 btrfs_dev_replace_start+0x36b/0x390 [btrfs]()
> [64326.701062] Modules linked in: btrfs dm_crypt loop sha256_ssse3 sha2=
56_generic hmac drbg ansi_cprng xts gf128mul algif_skcipher af_alg cpuid =
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xor =
raid6_pq intel_rapl iosf_mbi x86_pkg_temp_thermal iTCO_wdt intel_powercla=
mp iTCO_vendor_support kvm_intel kvm evdev crct10dif_pclmul crc32_pclmul =
cryptd snd_pcm snd_timer snd soundcore pcspkr psmouse serio_raw hpwdt hpi=
lo lpc_ich mfd_core 8250_fintek shpchp acpi_power_meter button pcc_cpufre=
q acpi_cpufreq processor coretemp ipmi_watchdog dm_mod ipmi_si ipmi_power=
off ipmi_devintf ipmi_msghandler fuse autofs4 ext4 crc16 mbcache jbd2 sg =
sd_mod usb_storage hid_generic usbhid hid crc32c_intel uhci_hcd thermal a=
hci libahci libata scsi_mod tg3 ptp pps_core libphy ehci_pci ehci_hcd xhc=
i_pci xhci_hcd
> [64326.701579]  usbcore usb_common [last unloaded: btrfs]
> [64326.701611] CPU: 1 PID: 36251 Comm: btrfs Tainted: G        W       =
4.3.0-gl+ #42
> [64326.701647] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 06=
/06/2014
> [64326.701671]  ffffffffa06e8b71 ffffffff8129eac3 0000000000000000 ffff=
ffff8106891c
> [64326.701720]  00000000fffffff4 ffff880079079800 ffff880006f1a000 ffff=
880074e2e000
> [64326.701769]  ffff880006f1aec8 ffffffffa06da7db 00007ffc00000001 ffff=
880071c42400
> [64326.701818] Call Trace:
> [64326.701840]  [<ffffffff8129eac3>] ? dump_stack+0x40/0x5d
> [64326.701864]  [<ffffffff8106891c>] ? warn_slowpath_common+0x7c/0xb0
> [64326.701896]  [<ffffffffa06da7db>] ? btrfs_dev_replace_start+0x36b/0x=
390 [btrfs]
> [64326.701939]  [<ffffffffa06a6bbe>] ? btrfs_ioctl+0x1b6e/0x27b0 [btrfs=
]
> [64326.701964]  [<ffffffff8116b83a>] ? page_add_file_rmap+0x2a/0x50
> [64326.706074]  [<ffffffff81160379>] ? do_set_pte+0x99/0xc0
> [64326.706100]  [<ffffffff81135f49>] ? filemap_map_pages+0x219/0x220
> [64326.706123]  [<ffffffff81162127>] ? handle_mm_fault+0xdd7/0x16c0
> [64326.706149]  [<ffffffff811b0b0e>] ? do_vfs_ioctl+0x2be/0x490
> [64326.706174]  [<ffffffff811b0d51>] ? SyS_ioctl+0x71/0x80
> [64326.706198]  [<ffffffff815000ee>] ? entry_SYSCALL_64_fastpath+0x12/0=
x71
> [64326.706222] ---[ end trace 37fc29aa3c600bcf ]---
This actually looks like it's a different issue potentially, for some=20
reason BTRFS is trying to scrub the missing disk (which won't work of=20
course).
>
> I'm not sure how to proceed from here, or how to debug this issue. Whil=
e
> the disks are not holding critical data, I'm sure it would benefit the
> community (and btrfs' reputation) if this issue could be sorted out.


--------------ms010602070803050005070007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE3MTI1NTUyWjBPBgkq
hkiG9w0BCQQxQgRAcKqOFch3yg7HfUdEgB/z72ZtYrBpaX10u6tpPibB0jv14Gaxli2vCjI5
iNZ+0+6JdOE9P5hI5CKlcrHmCdzlyDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCN6eklANF9U31q/oRXl/SVGgrqngSY0FkweysangLmdBkI6LUu
e3nghTrYYP9DXqeXUr3nJw7CC7ipTyBaVX3+vZIGviqCrVAJWF46ltPyqeMewj+FJKhNr7BD
YcRlDD5v2Y/21H8/OQbId99Y7ScuGF563u0YT0jbshawdc0g6bU93X9OuuxICZIdj7eEVh95
t9m9FsYrWRuuMDFAa8ktgPyw22FoS8OjEZlNl3XLfHg3TQpKVzKgnuOslSgO13f4akbateZI
SWTULDPTpweEojqYmtpHG0+xuJXGRaFWLWPCK5/98OqqbV712oDo3MhAan2PZlx8LDZgBaic
h8TUXKD411LoUUwDchf7+0m1vV+Qs2lA0MGHDCNtPJ9gNto21ydF2HYoySN0DxnkuGSLsz+f
02NpDAS3VB3a39jr1iD0tCYUpev/XpQqgGkeuiWFoezpolP1c8dlpsf521fkRBbkTyCKrx1x
UVt/l+mw8t/lHyNQQ/YAKaJhv4xULIB32hPjhh/fY9dqcJk7s/ul1wiMkVXFmZR56v0IF0Sm
tn1X5Cdk1h0EI2jb2ubarzTv1V7e90zMU0dYMnmELZCNN3aQbigp07LeGQGIntrZghvl4m/U
+DvqdZdzF8iygIGKXV87ivhbmvVXCdpkL+rVOJw4xREQzBzlbuHum+wLswAAAAAAAA==
--------------ms010602070803050005070007--
