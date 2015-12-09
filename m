Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:50426 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbbLIElQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 23:41:16 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
	by mailgw-02.dd24.net (Postfix) with ESMTP id C2DAC5FB74
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 04:41:14 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
	with ESMTP id kefJsjgqCqZA for <linux-btrfs@vger.kernel.org>;
	Wed,  9 Dec 2015 04:41:12 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-93-104-122-99.dynamic.mnet-online.de [93.104.122.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw-02.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 04:41:12 +0000 (UTC)
Message-ID: <1449636072.20578.4.camel@scientia.net>
Subject: Re: kernel call trace during send/receive
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 09 Dec 2015 05:41:12 +0100
In-Reply-To: <1448588940.11377.12.camel@scientia.net>
References: <1448588940.11377.12.camel@scientia.net>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-WyZKnLHMVJhJairuAY9z"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-WyZKnLHMVJhJairuAY9z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

Hmm I guess no one has any clue about that error?

Well it seems at least that an fsck over the receiving fs passes
through without any error.

Cheers,
Chris.

On Fri, 2015-11-27 at 02:49 +0100, Christoph Anton Mitterer wrote:
> Hey.
>=20
> Just got the following during send/receiving a big snapshot from one
> btrfs to another fresh one.
>=20
> Both under kernel=C2=A04.2.6, tools 4.3
>=20
> The send/receive seems to continue however...
>=20
> Any ideas what that means?
>=20
> Cheers,
> Chris.
>=20
> Nov 27 01:52:36 heisenberg kernel: ------------[ cut here ]--------
> ----
> Nov 27 01:52:36 heisenberg kernel: WARNING: CPU: 7 PID: 18086 at
> /build/linux-CrHvZ_/linux-4.2.6/fs/btrfs/send.c:5794
> btrfs_ioctl_send+0x661/0x1120 [btrfs]()
> Nov 27 01:52:36 heisenberg kernel: Modules linked in: ext4 mbcache
> jbd2 nls_utf8 nls_cp437 vfat fat uas vhost_net vhost macvtap macvlan
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp tun bridge stp llc fuse ccm
> ebtable_filter ebtables seqiv ecb drbg ansi_cprng algif_skcipher md4
> algif_hash af_alg binfmt_misc xfrm_user xfrm4_tunnel tunnel4 ipcomp
> xfrm_ipcomp esp4 ah4 cpufreq_userspace cpufreq_powersave
> cpufreq_stats cpufreq_conservative ip6t_REJECT nf_reject_ipv6
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy
> ipt_REJECT nf_reject_ipv4 xt_comment nf_conntrack_ipv4 nf_defrag_ipv4
> xt_multiport xt_conntrack nf_conntrack iptable_filter ip_tables
> x_tables joydev rtsx_pci_ms rtsx_pci_sdmmc mmc_core memstick iTCO_wdt
> iTCO_vendor_support x86_pkg_temp_thermal
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0intel_powerclamp intel_rapl
> iosf_mbi coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul evdev
> deflate ctr psmouse serio_raw twofish_generic pcspkr btusb btrtl
> btbcm btintel bluetooth crc16 uvcvideo videobuf2_vmalloc
> videobuf2_memops videobuf2_core v4l2_common videodev media
> twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common
> sg arc4 camellia_generic iwldvm mac80211 iwlwifi cfg80211 rtsx_pci
> rfkill camellia_aesni_avx_x86_64 snd_hda_codec_hdmi tpm_tis tpm
> 8250_fintek camellia_x86_64 snd_hda_codec_realtek
> snd_hda_codec_generic processor battery fujitsu_laptop i2c_i801 ac
> lpc_ich serpent_avx_x86_64 mfd_core snd_hda_intel snd_hda_codec
> snd_hda_core snd_hwdep snd_pcm shpchp snd_timer e1000e snd soundcore
> i915 ptp pps_core video button drm_kms_helper drm thermal_sys mei_me
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0i2c_algo_bit mei
> serpent_sse2_x86_64 xts serpent_generic blowfish_generic
> blowfish_x86_64 blowfish_common cast5_avx_x86_64 cast5_generic
> cast_common des_generic cbc cmac xcbc rmd160 sha512_ssse3
> sha512_generic sha256_ssse3 sha256_generic hmac crypto_null af_key
> xfrm_algo loop parport_pc ppdev lp parport autofs4 dm_crypt dm_mod
> md_mod btrfs xor raid6_pq uhci_hcd usb_storage sd_mod crc32c_intel
> aesni_intel aes_x86_64 glue_helper ahci lrw gf128mul ablk_helper
> libahci cryptd libata ehci_pci xhci_pci ehci_hcd scsi_mod xhci_hcd
> usbcore usb_common
> Nov 27 01:52:36 heisenberg kernel: CPU: 7 PID: 18086 Comm: btrfs Not
> tainted 4.2.0-1-amd64 #1 Debian 4.2.6-1
> Nov 27 01:52:36 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK
> E782/FJNB23E, BIOS Version 1.11 05/24/2012
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A00000000000000000 ffffffffa0=
2e6260
> ffffffff8154e2f6 0000000000000000
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0ffffffff8106e5b1 ffff880235=
a3c42c
> 00007ffd3d3796c0 ffff8802f0e5c000
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A00000000000000004 ffff880105=
43c500
> ffffffffa02d2d81 ffff88041e5ebb00
> Nov 27 01:52:36 heisenberg kernel: Call Trace:
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8154e2f6>] ?
> dump_stack+0x40/0x50
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8106e5b1>] ?
> warn_slowpath_common+0x81/0xb0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffffa02d2d81>] ?
> btrfs_ioctl_send+0x661/0x1120 [btrfs]
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8115a8c4>] ?
> __alloc_pages_nodemask+0x194/0x9e0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffffa029bfac>] ?
> btrfs_ioctl+0x26c/0x2a10 [btrfs]
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81098e5a>] ?
> sched_move_task+0xca/0x1d0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff812c50ee>] ?
> cpumask_next_and+0x2e/0x50
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8109b7cf>] ?
> select_task_rq_fair+0x23f/0x5c0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8109ef87>] ?
> enqueue_task_fair+0x387/0x1120
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8101c814>] ?
> native_sched_clock+0x24/0x80
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8101c875>] ?
> sched_clock+0x5/0x10
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff811cf2c3>] ?
> do_vfs_ioctl+0x2c3/0x4a0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8106d9f6>] ?
> _do_fork+0x146/0x3a0
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff811cf516>] ?
> SyS_ioctl+0x76/0x90
> Nov 27 01:52:36 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81553a32>] ?
> system_call_fast_compare_end+0xc/0x6b
> Nov 27 01:52:36 heisenberg kernel: ---[ end trace f5fa91e2672eead0 ]-
> --
--=-WyZKnLHMVJhJairuAY9z
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
+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
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIwOTA0NDEx
MlowTwYJKoZIhvcNAQkEMUIEQEOtuHbBW5C7babNnEMtelxqsGU+S8yd6oUfJFW2AcwBDARA83s3
93j5IGhe2HJHT3NfbA9D3da8Rv1vMlh4HPkwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQBlHIxvf680kfexlIkubAmXftnerMA4
xyqhlbJ6xjZnd0Zyc6HuPe374mUIXDg7ECN4/yVZFMKmVtw+9ftmKKTe2qYH8O20fD2wAdxBAh8Q
uDyMt5RF5Ij5LOkw8PbKZYDxOwtkleaDQND5jmKQ4/kAgc1gQ8hgsmLpH46zy82faK3FBQp3WzG/
RcI+KGgkiiV6x+0fi9GJdGhYwrCieU5yNEnXQ1Xqgiq5yvSq+a+aToQgpZPUNcQqvlvWmaICXjh8
xjWpCv6tpA8t8nYsi/GXLeP8L+xCD1tM5T4VBqMB1A3cB2uIEEl/jpJG6Eoo4t3lcphJ29Va2aOE
ZWBKjnQZAAAAAAAA


--=-WyZKnLHMVJhJairuAY9z--

