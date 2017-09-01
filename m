Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:49244 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdIAENC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 00:13:02 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 3F1B35FDC1
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Sep 2017 04:13:01 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id ACBnr45qcTAX for <linux-btrfs@vger.kernel.org>;
        Fri,  1 Sep 2017 04:12:59 +0000 (UTC)
Received: from heisenberg.fritz.box (host-82-135-95-124.customer.m-online.net [82.135.95.124])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Sep 2017 04:12:58 +0000 (UTC)
Message-ID: <1504239178.4710.3.camel@scientia.net>
Subject: call trace on send/receive
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Fri, 01 Sep 2017 06:12:58 +0200
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-P9ywsBCGMYAXp5zhif8R"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-P9ywsBCGMYAXp5zhif8R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

Just got the following call trace with:
$ uname -a
Linux heisenberg 4.12.0-1-amd64 #1 SMP Debian 4.12.6-1 (2017-08-12) x86_64 =
GNU/Linux
$ btrfs version
btrfs-progs v4.12


Sep 01 06:10:12 heisenberg kernel: ------------[ cut here ]------------
Sep 01 06:10:12 heisenberg kernel: WARNING: CPU: 3 PID: 7411 at /build/linu=
x-fHlJSJ/linux-4.12.6/fs/btrfs/send.c:6310 btrfs_ioctl_send+0x6c7/0x1100 [b=
trfs]
Sep 01 06:10:12 heisenberg kernel: Modules linked in: udp_diag tcp_diag ine=
t_diag ext4 jbd2 fscrypto ecb mbcache algif_skcipher af_alg uas vhost_net v=
host tap xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 i=
ptable_nat nf_nat_ipv4 nf_nat tun bridge stp llc ctr ccm fuse ebtable_filte=
r ebtables cpufreq_userspace cpufreq_powersave cpufreq_conservative joydev =
rtsx_pci_sdmmc ip6t_REJECT nf_reject_ipv6 xt_tcpudp mmc_core rtsx_pci_ms ar=
c4 memstick nf_conntrack_ipv6 nf_defrag_ipv6 intel_rapl ip6table_filter x86=
_pkg_temp_thermal intel_powerclamp ip6_tables coretemp iTCO_wdt iTCO_vendor=
_support iwldvm kvm_intel mac80211 kvm xt_policy irqbypass crct10dif_pclmul=
 ipt_REJECT nf_reject_ipv4 crc32_pclmul snd_hda_codec_hdmi xt_comment ghash=
_clmulni_intel btusb btrtl nf_conntrack_ipv4 btbcm nf_defrag_ipv4 intel_cst=
ate btintel
Sep 01 06:10:12 heisenberg kernel:  iwlwifi uvcvideo videobuf2_vmalloc blue=
tooth videobuf2_memops videobuf2_v4l2 videobuf2_core xt_multiport intel_unc=
ore videodev snd_hda_codec_realtek xt_conntrack cfg80211 i915 ecdh_generic =
media crc16 intel_rapl_perf pcspkr psmouse i2c_i801 snd_hda_codec_generic s=
g nf_conntrack rtsx_pci rfkill iptable_filter snd_hda_intel snd_hda_codec s=
nd_hda_core snd_hwdep drm_kms_helper fujitsu_laptop snd_pcm mei_me snd_time=
r sparse_keymap mei drm button video snd battery ac soundcore i2c_algo_bit =
lpc_ich loop mfd_core shpchp binfmt_misc parport_pc ppdev lp parport sunrpc=
 ip_tables x_tables autofs4 dm_crypt dm_mod raid10 raid456 async_raid6_reco=
v async_memcpy async_pq async_xor async_tx libcrc32c raid1 raid0 multipath =
linear md_mod btrfs crc32c_generic xor raid6_pq uhci_hcd sd_mod usb_storage=
 crc32c_intel
Sep 01 06:10:12 heisenberg kernel:  aesni_intel aes_x86_64 crypto_simd cryp=
td glue_helper ahci libahci xhci_pci evdev libata ehci_pci xhci_hcd ehci_hc=
d serio_raw scsi_mod e1000e ptp usbcore pps_core usb_common
Sep 01 06:10:12 heisenberg kernel: CPU: 3 PID: 7411 Comm: btrfs Not tainted=
 4.12.0-1-amd64 #1 Debian 4.12.6-1
Sep 01 06:10:12 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJN=
B253, BIOS Version 2.11 07/15/2014
Sep 01 06:10:12 heisenberg kernel: task: ffff8e278c6b9040 task.stack: ffffa=
24888cb4000
Sep 01 06:10:12 heisenberg kernel: RIP: 0010:btrfs_ioctl_send+0x6c7/0x1100 =
[btrfs]
Sep 01 06:10:12 heisenberg kernel: RSP: 0018:ffffa24888cb7cb8 EFLAGS: 00010=
293
Sep 01 06:10:12 heisenberg kernel: RAX: 0000000000000000 RBX: ffff8e26c914d=
40c RCX: 0000000000000015
Sep 01 06:10:12 heisenberg kernel: RDX: 0000000000000001 RSI: 0000000000200=
000 RDI: ffff8e26c914d40c
Sep 01 06:10:12 heisenberg kernel: RBP: 00007ffd0be90c60 R08: ffffffff8b43c=
5c0 R09: 0000000000000020
Sep 01 06:10:12 heisenberg kernel: R10: ffffa24888cb7ea0 R11: ffff8e278c6b9=
040 R12: 00007ffd0be90c60
Sep 01 06:10:12 heisenberg kernel: R13: ffff8e255392c000 R14: ffff8e26c914d=
000 R15: ffff8e246b9a3600
Sep 01 06:10:12 heisenberg kernel: FS:  00007fc1fd0b28c0(0000) GS:ffff8e285=
e2c0000(0000) knlGS:0000000000000000
Sep 01 06:10:12 heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
Sep 01 06:10:12 heisenberg kernel: CR2: 00007fc1fc084e38 CR3: 000000013f0ee=
000 CR4: 00000000001406e0
Sep 01 06:10:12 heisenberg kernel: Call Trace:
Sep 01 06:10:12 heisenberg kernel:  ? memcg_kmem_get_cache+0x50/0x160
Sep 01 06:10:12 heisenberg kernel:  ? cpumask_next_and+0x26/0x40
Sep 01 06:10:12 heisenberg kernel:  ? select_task_rq_fair+0x9bf/0xa40
Sep 01 06:10:12 heisenberg kernel:  ? btrfs_ioctl+0x80b/0x2450 [btrfs]
Sep 01 06:10:12 heisenberg kernel:  ? account_entity_enqueue+0xc5/0xf0
Sep 01 06:10:12 heisenberg kernel:  ? enqueue_entity+0x110/0x6e0
Sep 01 06:10:12 heisenberg kernel:  ? enqueue_task_fair+0x7e/0x6b0
Sep 01 06:10:12 heisenberg kernel:  ? do_vfs_ioctl+0x9f/0x600
Sep 01 06:10:12 heisenberg kernel:  ? do_vfs_ioctl+0x9f/0x600
Sep 01 06:10:12 heisenberg kernel:  ? _do_fork+0x148/0x3e0
Sep 01 06:10:12 heisenberg kernel:  ? SyS_ioctl+0x74/0x80
Sep 01 06:10:12 heisenberg kernel:  ? system_call_fast_compare_end+0xc/0x97
Sep 01 06:10:12 heisenberg kernel: Code: 4c 89 e7 89 ee 49 89 dc e8 47 01 5=
7 ca 48 c7 04 24 ff ff ff ff c7 44 24 28 00 00 00 00 48 c7 44 24 10 00 00 0=
0 00 e9 2e fb ff ff <0f> ff e9 bd f9 ff ff 48 63 44 24 08 48 89 04 24 e9 5a=
 fd ff ff=20
Sep 01 06:10:12 heisenberg kernel: ---[ end trace 9f9174d6f4d21959 ]---


send/receive processes seem to continue running... so either there is
actually something broken (and then the userland tools should also
notice this) or this is harmless and it shouldn't go to the kernel log,
I guess...

Cheers,
Chris.
--=-P9ywsBCGMYAXp5zhif8R
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwOTAxMDQxMjU4WjBPBgkqhkiG9w0BCQQxQgRAhqBX
ypC4dPFDa+X/9B7OqUXQ0w/xfmiZYinNZMcdAQnYOT59UUIMlYoQa7NdGyeefA+BvO/0r8VYdcYe
niWzQjCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAOVpE
MWFeKAb8TfDvzt+1B3BPAVPJHJyEj79NdZ5MkGeHuhCOWCd1O5Jul05kpzNffx1M0H9xagz+Lovf
PtNRrqD5zNC3hnNsN48UQqDQCmRefZIMuHVJ0bCKc7qHtrljW6LCA5UFMWyXqMOn1KRmdJ7EDpsx
DRZM543FUqI8Sa6TCa1ATfx8ODREcYCJPtvjAUdxYO3xYsr6MAxY7HKX/6gN8Um6tIhw14QgGMFn
Z+252Hzn7w+9MVLmT1P5ydQ9e9okDTX7z+2ocqQTKr0MXclhZnGaHVVI+2dvhE3GZR/BF+d8x+Fd
HPFRS2kV+mPjdkJtw3m8QK+uPZgajkkZtKIYxsCv34XUtu3lhcwoRsVlv31ijFy3scnBnj9AUCOJ
r4Gahcpfx5I1hsOZzE5pzJBvyHeuLKjLrpVqmxtcwsoepQ0qBPUDmhKpcG1X+lcwKSYMRhhJLDIl
Ga9FGlEXaSpI8ssXV/VftkCelaG4Z3xtp2ZEX3BQZRSi9H7hFsFF3mcQEwTXuj8sCJY4BDWR3P7s
loDSBOu8Fd4J0htUguFXUFXgb55r+jW1EynazQUkGZceWBtBzau+UjTtWO71R7pqX05whtNGKHF0
WGszlmdrbzxeoQyT4dhgFRVDXRohOAfMymDOh5CyrVifUa7lb/QpyJ8zzNgg4B4ExBBjnwkAAAAA
AAA=


--=-P9ywsBCGMYAXp5zhif8R--

