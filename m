Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:42224 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbbDRPgd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 11:36:33 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
	by mailgw01.dd24.net (Postfix) with ESMTP id AD6DD5FAE1
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 15:36:31 +0000 (UTC)
Received: from mailgw01.dd24.net ([192.168.1.35])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
	with ESMTP id GKOJcmk64f6h for <linux-btrfs@vger.kernel.org>;
	Sat, 18 Apr 2015 15:36:29 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-188-174-18-198.dynamic.mnet-online.de [188.174.18.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw01.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 15:36:29 +0000 (UTC)
Message-ID: <1429371388.4805.9.camel@scientia.net>
Subject: system frozen during send/receive
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Sat, 18 Apr 2015 17:36:28 +0200
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-kHFz8x+dmmFnUgSYhnoA"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-kHFz8x+dmmFnUgSYhnoA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

As mentioned before on the list, I'm just playing with send/receive.

The first huge disappointment (after copying already hundreds of
gigabytes for hours) was, that when I Ctrl-Z the sending/receiving pipe
(to give the disks a little bit of rest to cool down) can resuming it
(fg) it immediately exited with an crc32 error in the command itself
(i.e. not a data block error, at least I guess, since this would be in
the syslog, wouldn't it?).
As if stopping that wasn't allowed to be stopped... nothing of which
would be anywhere documented :-(

I don't recall the exact wording since shortly afterwards the following
happened:

I deleted the (obviously broken) subvolume at the target fs, did some
proper cursing and started over from scratch with the copying.


A minute or so later, the system froze.
SysRq-RESIUB still worked though.


The following found itself in the syslog:=20
Apr 18 17:03:04 heisenberg kernel: [425939.974472] ------------[ cut here ]=
------------
Apr 18 17:03:04 heisenberg kernel: [425939.974495] kernel BUG at /build/lin=
ux-gzeV2n/linux-3.19.3/fs/btrfs/inode.c:3142!
Apr 18 17:03:04 heisenberg kernel: [425939.974517] invalid opcode: 0000 [#1=
] SMP
Apr 18 17:03:04 heisenberg kernel: [425939.974531] Modules linked in: nls_u=
tf8 isofs sr_mod cdrom udp_diag tcp_diag inet_diag vhost_net vhost macvtap =
macvlan xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 ip=
table_nat nf_nat_ipv4 nf_nat xt_tcpudp bridge stp llc tun ccm binfmt_misc s=
eqiv algif_skcipher md4 algif_hash af_alg cpufreq_conservative cpufreq_user=
space cpufreq_powersave cpufreq_stats xfrm_user xfrm4_tunnel tunnel4 ipcomp=
 xfrm_ipcomp esp4 ah4 deflate ctr twofish_generic twofish_avx_x86_64 twofis=
h_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_aesni=
_avx_x86_64 camellia_x86_64 serpent_avx_x86_64 serpent_sse2_x86_64 xts serp=
ent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5_avx_x86_=
64 cast5_generic cast_common des_generic cbc cmac xcbc rmd160 sha512_ssse3 =
sha512_generic ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 =
ip6table_filter ip6_tables sha256_ssse3 sha256_generic hmac crypto_null xt_=
policy ipt_REJECT nf_reject_ipv4 af_key xt_comment xfrm_algo nf_conntrack_i=
pv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_filter ip=
_tables x_tables joydev rtsx_pci_ms rtsx_pci_sdmmc mmc_core memstick iTCO_w=
dt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp kvm_i=
ntel kvm crct10dif_pclmul crc32_pclmul evdev ghash_clmulni_intel psmouse se=
rio_raw pcspkr ecb sg uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2=
_core v4l2_common videodev media btusb bluetooth arc4 iwldvm mac80211 iwlwi=
fi rtsx_pci cfg80211 rfkill tpm_tis tpm 8250_fintek snd_hda_codec_hdmi snd_=
hda_codec_realtek snd_hda_codec_generic battery processor fujitsu_laptop sn=
d_hda_intel snd_hda_controller snd_hda_codec ac i2c_i801 snd_hwdep snd_pcm =
lpc_ich mfd_core snd_timer snd soundcore shpchp i915 button video drm_kms_h=
elper drm e1000e thermal_sys i2c_algo_bit i2c_core ptp mei_me pps_core mei =
loop fuse parport_pc ppdev lp parport autofs4 dm_crypt dm_mod md_mod btrfs =
xor raid6_pq ext4 crc16 mbcache jbd2 uhci_hcd usb_storage sd_mod crc32c_int=
el aesni_intel ahci libahci aes_x86_64 glue_helper lrw gf128mul ablk_helper=
 cryptd xhci_pci libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_com=
mon
Apr 18 17:03:04 heisenberg kernel: [425939.975271] CPU: 0 PID: 8008 Comm: b=
trfs-cleaner Tainted: G        W      3.19.0-trunk-amd64 #1 Debian 3.19.3-1=
~exp1
Apr 18 17:03:04 heisenberg kernel: [425939.975299] Hardware name: FUJITSU L=
IFEBOOK E782/FJNB23E, BIOS Version 1.11 05/24/2012
Apr 18 17:03:04 heisenberg kernel: [425939.975323] task: ffff880409bc8ca0 t=
i: ffff88024b540000 task.ti: ffff88024b540000
Apr 18 17:03:04 heisenberg kernel: [425939.975344] RIP: 0010:[<ffffffffa031=
38b3>]  [<ffffffffa03138b3>] btrfs_orphan_add+0x103/0x1d0 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975385] RSP: 0018:ffff88024b543c=
88  EFLAGS: 00010286
Apr 18 17:03:04 heisenberg kernel: [425939.975400] RAX: 00000000ffffffe4 RB=
X: ffff88040ab96000 RCX: 000000000000618b
Apr 18 17:03:04 heisenberg kernel: [425939.975419] RDX: 000000000000618b RS=
I: 0000000000040000 RDI: ffff880028fbb138
Apr 18 17:03:04 heisenberg kernel: [425939.975439] RBP: ffff880101d331e8 R0=
8: ffff8800889a73a0 R09: ffff880130738ec0
Apr 18 17:03:04 heisenberg kernel: [425939.975458] R10: 0000000000000000 R1=
1: 0000000000000000 R12: ffff88040ab96458
Apr 18 17:03:04 heisenberg kernel: [425939.975478] R13: ffff88011cd9fe88 R1=
4: 0000000000000001 R15: 0000000000000001
Apr 18 17:03:04 heisenberg kernel: [425939.975498] FS:  0000000000000000(00=
00) GS:ffff88041e200000(0000) knlGS:0000000000000000
Apr 18 17:03:04 heisenberg kernel: [425939.975520] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
Apr 18 17:03:04 heisenberg kernel: [425939.975536] CR2: 00007ffbb4092000 CR=
3: 0000000001813000 CR4: 00000000001407f0
Apr 18 17:03:04 heisenberg kernel: [425939.975556] Stack:
Apr 18 17:03:04 heisenberg kernel: [425939.975563]  0000000000000000 ffffff=
ff811d9205 ffff880130738ec0 ffff880100f50800
Apr 18 17:03:04 heisenberg kernel: [425939.975588]  ffff880130738ec0 000000=
0000000001 ffff88040b78a400 ffff8803e8aa3020
Apr 18 17:03:04 heisenberg kernel: [425939.975613]  ffff880101d331e8 ffffff=
ffa02fd832 ffff88011cd9fe88 ffff88040ab96000
Apr 18 17:03:04 heisenberg kernel: [425939.975638] Call Trace:
Apr 18 17:03:04 heisenberg kernel: [425939.975650]  [<ffffffff811d9205>] ? =
igrab+0x15/0x50
Apr 18 17:03:04 heisenberg kernel: [425939.975675]  [<ffffffffa02fd832>] ? =
btrfs_remove_block_group+0x132/0x740 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975707]  [<ffffffffa0335f59>] ? =
btrfs_remove_chunk+0x619/0x720 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975736]  [<ffffffffa02fe08b>] ? =
btrfs_delete_unused_bgs+0x24b/0x270 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975765]  [<ffffffffa0305964>] ? =
cleaner_kthread+0x154/0x1b0 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975792]  [<ffffffffa0305810>] ? =
check_leaf+0x360/0x360 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.975813]  [<ffffffff8108a1a3>] ? =
kthread+0xd3/0xf0
Apr 18 17:03:04 heisenberg kernel: [425939.975833]  [<ffffffff8108a0d0>] ? =
kthread_create_on_node+0x180/0x180
Apr 18 17:03:04 heisenberg kernel: [425939.975853]  [<ffffffff815509d8>] ? =
ret_from_fork+0x58/0x90
Apr 18 17:03:04 heisenberg kernel: [425939.975870]  [<ffffffff8108a0d0>] ? =
kthread_create_on_node+0x180/0x180
Apr 18 17:03:04 heisenberg kernel: [425939.975889] Code: 45 31 f6 eb 91 0f =
1f 00 48 8b 55 40 eb ae 66 2e 0f 1f 84 00 00 00 00 00 48 89 ee 4c 89 ef e8 =
a5 28 fe ff 85 c0 0f 84 76 ff ff ff <0f> 0b 0f 1f 00 f0 80 65 80 df b9 56 0=
c 00 00 41 89 c0 48 89 de=20
Apr 18 17:03:04 heisenberg kernel: [425939.976035] RIP  [<ffffffffa03138b3>=
] btrfs_orphan_add+0x103/0x1d0 [btrfs]
Apr 18 17:03:04 heisenberg kernel: [425939.976066]  RSP <ffff88024b543c88>=
=20
Apr 18 17:03:04 heisenberg kernel: [425939.982979] ---[ end trace de47fb63a=
11a4748 ]---


Interestingly, the system itself seemed to have lived on... i.e. I saw
all further things in the syslog like disconnecting the external disks
that I was sending/recieving between:=20
Apr 18 17:06:24 heisenberg kernel: [426139.963788] usb 1-1.2: USB disconnec=
t, device number 62
Apr 18 17:06:24 heisenberg kernel: [426139.965404] sd 21:0:0:0: [sdc] Synch=
ronizing SCSI cache
Apr 18 17:06:24 heisenberg kernel: [426139.965466] sd 21:0:0:0: [sdc] Synch=
ronize Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRI=
VER_OK
Apr 18 17:06:31 heisenberg kernel: [426146.824094] usb 1-1.2: new high-spee=
d USB device number 64 using ehci-pci
Apr 18 17:06:31 heisenberg kernel: [426146.919068] usb 1-1.2: New USB devic=
e found, idVendor=3D058f, idProduct=3D6387
Apr 18 17:06:31 heisenberg kernel: [426146.919077] usb 1-1.2: New USB devic=
e strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Apr 18 17:06:31 heisenberg kernel: [426146.919080] usb 1-1.2: Product: Mass=
 Storage Device
Apr 18 17:06:31 heisenberg kernel: [426146.919083] usb 1-1.2: Manufacturer:=
 JetFlash
Apr 18 17:06:31 heisenberg kernel: [426146.919086] usb 1-1.2: SerialNumber:=
 PR5OPGX5
Apr 18 17:06:31 heisenberg kernel: [426146.919566] usb-storage 1-1.2:1.0: U=
SB Mass Storage device detected
Apr 18 17:06:31 heisenberg kernel: [426146.920018] scsi host30: usb-storage=
 1-1.2:1.0
Apr 18 17:06:31 heisenberg mtp-probe: checking bus 1, device 64: "/sys/devi=
ces/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2"
Apr 18 17:06:31 heisenberg mtp-probe: bus: 1, device: 64 was not an MTP dev=
ice
Apr 18 17:06:32 heisenberg kernel: [426147.921692] scsi 30:0:0:0: Direct-Ac=
cess     JetFlash Transcend 8GB    8.07 PQ: 0 ANSI: 2
Apr 18 17:06:32 heisenberg kernel: [426147.922474] sd 30:0:0:0: Attached sc=
si generic sg3 type 0
Apr 18 17:06:32 heisenberg kernel: [426147.923781] sd 30:0:0:0: [sdd] 15687=
678 512-byte logical blocks: (8.03 GB/7.47 GiB)
Apr 18 17:06:32 heisenberg kernel: [426147.924414] sd 30:0:0:0: [sdd] Write=
 Protect is off
Apr 18 17:06:32 heisenberg kernel: [426147.924423] sd 30:0:0:0: [sdd] Mode =
Sense: 03 00 00 00
Apr 18 17:06:32 heisenberg kernel: [426147.925019] sd 30:0:0:0: [sdd] No Ca=
ching mode page found
Apr 18 17:06:32 heisenberg kernel: [426147.925025] sd 30:0:0:0: [sdd] Assum=
ing drive cache: write through
Apr 18 17:06:33 heisenberg kernel: [426148.493797]  sdd: sdd1 sdd2 sdd3
Apr 18 17:06:33 heisenberg kernel: [426148.497018] sd 30:0:0:0: [sdd] Attac=
hed SCSI removable disk
Apr 18 17:06:38 heisenberg kernel: [426153.842516] SysRq : Keyboard mode se=
t to system default
Apr 18 17:06:38 heisenberg kernel: [426154.139075] SysRq : This sysrq opera=
tion is disabled.
Apr 18 17:06:39 heisenberg kernel: [426154.491005] SysRq : Emergency Sync
Apr 18 17:06:39 heisenberg kernel: [426154.988836] SysRq : This sysrq opera=
tion is disabled.
Apr 18 17:06:39 heisenberg kernel: [426155.310565] SysRq : Emergency Remoun=
t R/O


The kernel is:=20
Linux heisenberg 3.19.0-trunk-amd64 #1 SMP Debian 3.19.3-1~exp1 (2015-03-29=
) x86_64 GNU/Linux

Evertyhing except the kernel (which is from experimental) is from Debian
sid.


After rebooting a check on the source fs (I was sending from) gave:
# btrfs check /dev/mapper/data-a
Checking filesystem on /dev/mapper/data-a
UUID: 3ebe98fd-91d7-47e8-b631-33bbc9514a65
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 2150915376081 bytes used err is 0
total csum bytes: 4096624552
total tree bytes: 6352224256
total fs tree bytes: 1544847360
total extent tree bytes: 237551616
btree space waste bytes: 650901113
file data blocks allocated: 5041330393088
referenced 5050128224256
Btrfs v3.17

This was mounted,ro during the send... can anyone tell me whether
there's a slight chance in any corruption at the source side? I.e. does
btrfs itself or something from btrfs send modify anything on the disk
when it's mounted read-only?
Do I have to look for corruptions or run a scrub?


Thanks,
Chris.

--=-kHFz8x+dmmFnUgSYhnoA
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEZIw
ggW/MIIDp6ADAgECAgMCOakwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xNDA2MTIxNjM2MThaFw0xNjA2MTExNjM2MThaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4phP/j9vT9dZT+k3ffHxvRWMOuzBnu5O3Fl4y2+WL7pL
rfLiEhWzGXhHvjSqpt4vCNSdqy43453nnu8+hMb+uEtqSIL1AHU5eLhuDNVN9S4bt9E7nA2WKYBU
LCUi/xCD/GL7ToyJNwhrhzcCZ7pXSc3xVqFoC4f6weU9ExhoEZQNRpTM0BFCOi4fRxvKFNnUYgjK
hqy0Ta5H0Xx86mAp0Q4dxoD7mhI5iTF6TRkUheELxF24JCuAf04M89Cwft6DRH1FpJ3yvgW2B5U5
aFSL4ZnF4N/wyCB7Dkm1rQ7RCAvw5btkf0VdPnU7ccDCx8HEc2nxK/lbCjrznvh3sa1CCwIDAQAB
o4IBcDCCAWwwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYD
VR0PAQH/BAQDAgOoMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYK
KwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDov
L29jc3AuY2FjZXJ0Lm9yZzA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNhY2VydC5vcmcv
Y2xhc3MzLXJldm9rZS5jcmwwRAYDVR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWls
QGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMA0GCSqGSIb3DQEBDQUAA4ICAQBefctiLgGl
e5baspuozyA4k7Up7SVhGHbif6pQfoFc/9Thx9GXnYpX+U64PMyWBfWwHZIy52Vg0RVkvPi1t6mi
GyBfoSpC6ooR0bKWtUIogw/ymqKWlTLVR8kbLqRmRk4juMtCXG2K3yMygX/rjkuUSuFj2Bjpkmzg
CtMojbUMYbszePmhQ7DJ62YEdtKpcjN94QAsI5GWlIAbs3KJazAcaNCRJeXCLcUMchyKHJA+NXH5
az/ekBxBMBzJP2An20PP88UI4JW18z31KiG9UVGa2uO4l4aWgVe2GnhNEdCD/o48msJEWKAt5vl2
yMqr7ihmNPocU2+/FW0xPe/vftdOTD9pgXdSGf4prdD+23q2YvpalOCzr2p8yCJZNVBPMxAP4mL0
3OEktXza4wohqAmceXKfGUNwRGBaPvtIGnPrpLhCQ+2YJDg8g1UEsk23bKyZlJWeKJyVqOBsDJmj
aBsN/qKhQFnav+zQdqGhMeaSisF/53mD3gyVYg2JRl18apgGbg32kyLmomqa0JbhnY3Dc3FVtZfe
+P+s2Cyep3pVKvFer2llRoGm8TwraG5Yhyx8Oq/1qETpstjbURJOVBLDCV4AjOEUj0ZnE/tEo/DK
yexgGaViNvjp+IZdFdJhYmsVjw4Q3vG7O0pfsLiYEyQjeDgjNEWDfa5/MufPywIfxzCCBb8wggOn
oAMCAQICAwI5qTANBgkqhkiG9w0BAQ0FADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UE
CxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4X
DTE0MDYxMjE2MzYxOFoXDTE2MDYxMTE2MzYxOFowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFudG9u
IE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkqhkiG
9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDimE/+P29P11lP6Td98fG9FYw67MGe7k7cWXjLb5Yvukut8uISFbMZ
eEe+NKqm3i8I1J2rLjfjneee7z6Exv64S2pIgvUAdTl4uG4M1U31Lhu30TucDZYpgFQsJSL/EIP8
YvtOjIk3CGuHNwJnuldJzfFWoWgLh/rB5T0TGGgRlA1GlMzQEUI6Lh9HG8oU2dRiCMqGrLRNrkfR
fHzqYCnRDh3GgPuaEjmJMXpNGRSF4QvEXbgkK4B/Tgzz0LB+3oNEfUWknfK+BbYHlTloVIvhmcXg
3/DIIHsOSbWtDtEIC/Dlu2R/RV0+dTtxwMLHwcRzafEr+VsKOvOe+HexrUILAgMBAAGjggFwMIIB
bDAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNh
dGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3
CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5j
YWNlcnQub3JnMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMt
cmV2b2tlLmNybDBEBgNVHREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0
b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwDQYJKoZIhvcNAQENBQADggIBAF59y2IuAaV7ltqym6jP
IDiTtSntJWEYduJ/qlB+gVz/1OHH0Zedilf5Trg8zJYF9bAdkjLnZWDRFWS8+LW3qaIbIF+hKkLq
ihHRspa1QiiDD/KaopaVMtVHyRsupGZGTiO4y0JcbYrfIzKBf+uOS5RK4WPYGOmSbOAK0yiNtQxh
uzN4+aFDsMnrZgR20qlyM33hACwjkZaUgBuzcolrMBxo0JEl5cItxQxyHIockD41cflrP96QHEEw
HMk/YCfbQ8/zxQjglbXzPfUqIb1RUZra47iXhpaBV7YaeE0R0IP+jjyawkRYoC3m+XbIyqvuKGY0
+hxTb78VbTE97+9+105MP2mBd1IZ/imt0P7berZi+lqU4LOvanzIIlk1UE8zEA/iYvTc4SS1fNrj
CiGoCZx5cp8ZQ3BEYFo++0gac+ukuEJD7ZgkODyDVQSyTbdsrJmUlZ4onJWo4GwMmaNoGw3+oqFA
Wdq/7NB2oaEx5pKKwX/neYPeDJViDYlGXXxqmAZuDfaTIuaiaprQluGdjcNzcVW1l974/6zYLJ6n
elUq8V6vaWVGgabxPCtobliHLHw6r/WoROmy2NtREk5UEsMJXgCM4RSPRmcT+0Sj8MrJ7GAZpWI2
+On4hl0V0mFiaxWPDhDe8bs7Sl+wuJgTJCN4OCM0RYN9rn8y58/LAh/HMIIGCDCCA/CgAwIBAgIB
ATANBgkqhkiG9w0BAQQFADB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3
LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG
9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0wNTEwMTQwNzM2NTVaFw0zMzAzMjgwNzM2NTVa
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcx
HDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
AoICAQCrSTURSHzSJn5TlM9Dqd0o10Iqi/OHeBlYfA+e2ol94fvrcpANdKGWZKufoCSZc9riVXbH
F3v1BKxGuMO+f2SNEGwk82GcwPKQ+lHm9WkBY8MPVuJKQs/iRIwlKKjFeQl9RrmK8+nzNCkIReQc
n8uUBByBqBSzmGXEQ+xOgo0J0b2qW42S0OzekMV/CsLj6+YxWl50PpczWejDAz1gM7/30W9HxM3u
YoNSbi4ImqTZFRiRpoWSR7CuSOtttyHshRpocjWr//AQXcD0lKdq1TuSfkyQBX6TwSyLpI5idBVx
bgtxA+qvFTia1NIFcm+M+SvrWnIl+TlG43IbPgTDZCciECqKT1inA62+tC4T7V2qSNfVfdQqe1z6
RgRQ5MwOQluM7dvyz/yWk+DbETZUYjQ4jwxgmzuXVjit89Jbi6Bb6k6WuHzX1aCGcEDTkSm3ojyt
9Yy7zxqSiuQ0e8DYbF/pCsLDpyCaWt8sXVJcukfVm+8kKHA4IC/VfynAskEDaJLM4JzMl0tF7zoQ
CqtwOpiVcK01seqFK6QcgCExqa5geoAmSAC4AcCTY1UikTxW56/bOiXzjzFU6iaLgVn5odFTEcV7
nQP2dBHgbbEsPyyGkZlxmqZ3izRg0RS0LKydr4wQ05/EavhvE/xzWfdmQnQeiuP43NJvmJzLR5iV
QAX76QIDAQABo4G/MIG8MA8GA1UdEwEB/wQFMAMBAf8wXQYIKwYBBQUHAQEEUTBPMCMGCCsGAQUF
BzABhhdodHRwOi8vb2NzcC5DQWNlcnQub3JnLzAoBggrBgEFBQcwAoYcaHR0cDovL3d3dy5DQWNl
cnQub3JnL2NhLmNydDBKBgNVHSAEQzBBMD8GCCsGAQQBgZBKMDMwMQYIKwYBBQUHAgEWJWh0dHA6
Ly93d3cuQ0FjZXJ0Lm9yZy9pbmRleC5waHA/aWQ9MTAwDQYJKoZIhvcNAQEEBQADggIBAH8IiKHa
GlBJ2on7oQhy84r3HsQ6tHlbIDCxRd7CXdNlafHCXVRUPIVfuXtCkcKZ/RtRm6tGpaEQU55tiKxz
biwzpvD0nuB1wT6IRanhZkP+VlrRekF490DaSjrxC1uluxYG5sLnk7mFTZdPsR44Q4Dvmw2M77in
YACHV30eRBzLI++bPJmdr7UpHEV5FpZNJ23xHGzDwlVks7wU4vOkHx4y/CcVBc/dLq4+gmF78CEQ
GPZE6lM5+dzQmiDgxrvgu1pPxJnIB721vaLbLmINQjRBvP+LivVRIqqIMADisNS8vmW61QNXeZvo
3MhN+FDtkaVSKKKs+zZYPumUK5FQhxvWXtaMzPcPEAxSTtAWYeXlCmy/F8dyRlecmPVsYGN6b165
Ti/Iubm7aoW8mA3t+T6XhDSUrgCvoeXnkm5OvfPi2RSLXNLrAWygF6UtEOucekq9ve7O/e0iQKtw
OIj1CodqwqsFYMlIBdpTwd5Ed2qz8zw87YC8pjhKKSRf/lk7myV6VmMAZLldpGJ9VzZPrYPvH5JT
oI53V93lYRE9IwCQTDz6o2CTBKOvNfYOao9PSmCnhQVsRqGP9Md246FZV/dxssRuFFxtbUFm3xuT
sdQAw+7Lzzw9IYCpX2Nl/N3gX6T0K/CFcUHUZyX7GrGXrtaZghNB0m6lG5kngOcLqagAMYIC7TCC
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQxODE1MzYy
OFowTwYJKoZIhvcNAQkEMUIEQNnLmjQ/NofaXCNJzrj4xKO9SwiXH9OKCSSEZgwJhM8WuyV65tvB
7fYABF/EBq1Gqh8vYvITVqWiq2tPFiYtBEswagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQATeCX8CAhM8WrhTWSe+XN6VU75tkyR
d44u+WtL2/rvJk101uGUnJvAr/EH4Rusx39hU1yV7VYa+BrISf3ggfSmXfzasshur9Fj0zNuq+6O
27UJ8vRNWRnHAD29ysj/Ydqj/5BvBTJrAvM6r/wviZPWFEy/vpRJxRq7T3CJBrYigkIIsFeE/bZ8
ycnTdvFla7uvLm/MHeU5F2W7+BczJ1SaQ8FE2POOm9/TLab9TkicaULsWMpVtEsHj5qO3cRdoAbr
ksAzbmSvMnumAGgDw4wQEZ814KWss5icHnMwtG8HEWEgISR2Qzo50VQ/D0wOGyLTciZRwWbYurjY
j+yPnerMAAAAAAAA


--=-kHFz8x+dmmFnUgSYhnoA--

