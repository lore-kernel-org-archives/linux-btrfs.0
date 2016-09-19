Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:50575 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbcISVSd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 17:18:33 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 788765FC49
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 21:18:31 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id MhzHye9wRzlM for <linux-btrfs@vger.kernel.org>;
        Mon, 19 Sep 2016 21:18:29 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-200-251.dynamic.mnet-online.de [46.244.200.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 21:18:29 +0000 (UTC)
Message-ID: <1474319908.10189.28.camel@scientia.net>
Subject: spurious call trace during send
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Mon, 19 Sep 2016 23:18:28 +0200
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-P1j7Tr5h73UYkGbzQOsC"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-P1j7Tr5h73UYkGbzQOsC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

FYI:

Just got this call trace during a send/receive (with -p) between two
btrfs on=C2=A04.7.0.

Neither btrfs-send nor -receive showed an error though and seem to have
completed successfully (at least a diff of the changes implied that.


Sep 19 20:24:38 heisenberg kernel: BTRFS info (device dm-2): disk space cac=
hing is enabled
Sep 19 20:25:53 heisenberg kernel: ------------[ cut here ]------------
Sep 19 20:25:53 heisenberg kernel: WARNING: CPU: 2 PID: 24266 at /build/lin=
ux-m2Twzh/linux-4.7.2/fs/btrfs/send.c:5964 btrfs_ioctl_send+0x537/0x1260 [b=
trfs]
Sep 19 20:25:53 heisenberg kernel: Modules linked in: udp_diag tcp_diag ine=
t_diag algif_skcipher af_alg uas hmac drbg ansi_cprng ctr ccm vhost_net vho=
st macvtap macvlan xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquer=
ade_ipv4 iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp tun bridge stp llc fuse e=
btable_filter ebtables joydev rtsx_pci_ms rtsx_pci_sdmmc memstick mmc_core =
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative iTCO=
_wdt iTCO_vendor_support intel_rapl x86_pkg_temp_thermal intel_powerclamp c=
oretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni=
_intel psmouse uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 v=
ideobuf2_core videodev media btusb pcspkr btrtl btbcm btintel bluetooth crc=
16 sg rtsx_pci arc4 iwldvm mac80211 iwlwifi cfg80211 rfkill snd_hda_codec_h=
dmi snd_hda_codec_realtek
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0snd_hda_codec_generic fjes i9=
15 tpm_tis tpm battery fujitsu_laptop ac i2c_i801 snd_hda_intel video snd_h=
da_codec lpc_ich mfd_core button snd_hda_core snd_hwdep drm_kms_helper snd_=
pcm shpchp snd_timer e1000e snd drm soundcore mei_me ptp i2c_algo_bit pps_c=
ore mei ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6tabl=
e_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment nf_connt=
rack_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_fil=
ter binfmt_misc loop sunrpc parport_pc ppdev lp parport ip_tables x_tables =
autofs4 dm_crypt dm_mod raid10 raid456 libcrc32c async_raid6_recov async_me=
mcpy async_pq async_xor async_tx raid1 raid0 multipath linear md_mod btrfs =
crc32c_generic xor raid6_pq uhci_hcd usb_storage sd_mod crc32c_intel ahci l=
ibahci aesni_intel
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0libata aes_x86_64 xhci_pci gl=
ue_helper lrw xhci_hcd gf128mul ablk_helper cryptd ehci_pci ehci_hcd scsi_m=
od evdev usbcore serio_raw usb_common
Sep 19 20:25:53 heisenberg kernel: CPU: 2 PID: 24266 Comm: btrfs Not tainte=
d 4.7.0-1-amd64 #1 Debian 4.7.2-1
Sep 19 20:25:53 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJN=
B23E, BIOS Version 1.11 05/24/2012
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A00000000000000286 000000007d5a=
d1ff ffffffffaff16655 0000000000000000
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A00000000000000000 ffffffffafc7=
895e ffff8802d1ebf42c 00007fff6fcb1800
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0ffff8800c15da000 000000004048=
9426 ffff8802d1ebf000 ffff8803da842100
Sep 19 20:25:53 heisenberg kernel: Call Trace:
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffaff16655>] ? dump_s=
tack+0x5c/0x77
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafc7895e>] ? __warn=
+0xbe/0xe0
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc043e357>] ? btrfs_=
ioctl_send+0x537/0x1260 [btrfs]
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb009b35e>] ? intel_=
pstate_update_util+0x1be/0x320
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafdeb568>] ? __memc=
g_kmem_get_cache+0x48/0x150
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafdd68b9>] ? kmem_c=
ache_alloc+0x149/0x560
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafca9cdb>] ? attach=
_task_cfs_rq+0x3b/0x70
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc04074c8>] ? btrfs_=
ioctl+0x8f8/0x2300 [btrfs]
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffaff1646a>] ? cpumas=
k_next_and+0x2a/0x40
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafcae95d>] ? enqueu=
e_task_fair+0x5d/0x960
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafc34675>] ? sched_=
clock+0x5/0x10
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafca0940>] ? check_=
preempt_curr+0x50/0x90
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafe0840e>] ? do_vfs=
_ioctl+0x9e/0x5d0
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafc77c1d>] ? _do_fo=
rk+0x14d/0x3f0
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffafe089b4>] ? SyS_io=
ctl+0x74/0x80
Sep 19 20:25:53 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb01d84b6>] ? system=
_call_fast_compare_end+0xc/0x96
Sep 19 20:25:53 heisenberg kernel: ---[ end trace b61b956fbe6451d3 ]---


Any ideas?

Cheers,
Chris.
--=-P1j7Tr5h73UYkGbzQOsC
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEmow
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwcz1F+2kRA
DzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIzNlowejEL
MAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAfBgNVBAMM
GENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50
aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqeP2vwE3Cp
YosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjrFe0zmZWZ
0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ0+c1NYFQ
T6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJnmiiId9e
0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7r2NVLkpo
Gbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA0BtydQC0
mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS7XEGOuCU
09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6a1rkhJl7
1rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8bxPJiX2/
VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/MAsGA1Ud
DwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4E
FgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI9PsJzxYw
bwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYI
KwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQyLmNydDA4
BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50Mi5jcmww
IAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAq
BggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUA
A4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7SG3MQkyO
kvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndjZIHMfSkn
hdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9RS51K1gt
H4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11Yeq6UTW/
JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwc
z1F+2kRADzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20g
THRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMT
GlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIz
NlowejELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAf
BgNVBAMMGENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9A
c2NpZW50aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqe
P2vwE3CpYosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjr
Fe0zmZWZ0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ
0+c1NYFQT6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJ
nmiiId9e0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7
r2NVLkpoGbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA
0BtydQC0mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS
7XEGOuCU09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6
a1rkhJl71rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8
bxPJiX2/VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAd
BgNVHQ4EFgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI
9PsJzxYwbwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5j
b20wOQYIKwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQy
LmNydDA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50
Mi5jcmwwIAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcB
AgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3
DQEBCwUAA4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7
SG3MQkyOkvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndj
ZIHMfSknhdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9
RS51K1gtH4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11
Yeq6UTW/JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMYIEfjCCBHoCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBD
QQIQPZ6tDP/RHLwcz1F+2kRADzANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwOTE5MjExODI4WjBPBgkqhkiG9w0BCQQxQgRA8/mh
VkW6EaYJzmQRTt7eVHmNB2ZfUlsU1aXxSqp7gl/UNeZOhHvK4R+fQdCHX3PO0Hbk1FDhzLUvMi+1
30cA6DCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIADOw4
I9fblC7RV6CR6EWoNeLwSMsMbJarAb9xun/kE6wl2Wg3Y19gK1QkxNGtwiT/OTKI+S+D1NrjdaJg
xNzf8pvXCzuAa3jSJVX2Ka3IZFesI06iM2SR7mktSdvdJQGV0KWpKQ9XQXFDryhHoekQStwsjsnM
C+dES8NPaDAnoR/E1sFvWz9RM/cZYBeW7BFzAwAPb64+vcgMBCqFBxXc3Ha0BlJY8qyn+1BoUl5o
KpwjkZz1DR0GwoJFufwLm2qI0uc5fA2bJW4GOwMRvfrgld+VP7G9ChZ7hTf4hhqa1OPYvMsSb+5w
ErRtsMG8WZ4XgPWCq0A9/uNYz8+B8jCaO8TUrmv6rgqt6gHKrmUlIsNdBkYzEOsH6CjD0tqiCzq3
2hMOiwKEsBRFCZHuB7le7hLUyTnEep28zfB/OC6FnVN8PY7KMt+dDW7Ltcxqn2GeRwxcGVXVAerF
o0FKyd0ea460NuuFt57hQlp2/2lW9lK1ZfkzPAwIZlbworMl0WrVZEaOeztN1NvTzE98yd6/4uSv
HGhmID25VNyQmWd4RGM11jbmnEGv48sKVJ///yVVBkISHqu8a2zrn4ZdZFG00vOQvTAw7AdIbBmP
raPNP4fcJnn1xLHO7gVSqznfzTlz5OvjdAusN7t+2zGaYOtN3mi2wCXpqIp2QHCOXhM58JoAAAAA
AAA=


--=-P1j7Tr5h73UYkGbzQOsC--

