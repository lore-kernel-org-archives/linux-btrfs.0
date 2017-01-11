Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:60565 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdAKT7a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 14:59:30 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 865435FC34
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 19:59:14 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id XAz14CCKck6a for <linux-btrfs@vger.kernel.org>;
        Wed, 11 Jan 2017 19:59:12 +0000 (UTC)
Received: from heisenberg.fritz.box (host-82-135-95-36.customer.m-online.net [82.135.95.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 19:59:12 +0000 (UTC)
Message-ID: <1484164751.10253.1.camel@scientia.net>
Subject: yet another call trace during send/receive
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 11 Jan 2017 20:59:11 +0100
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-ibnxiSwfkKBPNzbgT7p+"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-ibnxiSwfkKBPNzbgT7p+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

On Debian sid:
$ uname -a
Linux heisenberg 4.8.0-2-amd64 #1 SMP Debian 4.8.15-2 (2017-01-04) x86_64 G=
NU/Linux

$ btrfs version
btrfs-progs v4.7.3

During a:
#=C2=A0btrfs send -p foo bar | btrfs receive baz


Jan 11 20:43:10 heisenberg kernel: ------------[ cut here ]------------
Jan 11 20:43:10 heisenberg kernel: WARNING: CPU: 6 PID: 10042 at /build/lin=
ux-zDY19G/linux-4.8.15/fs/btrfs/send.c:6117 btrfs_ioctl_send+0x533/0x1280 [=
btrfs]
Jan 11 20:43:10 heisenberg kernel: Modules linked in: udp_diag tcp_diag ine=
t_diag algif_skcipher af_alg uas vhost_net vhost macvtap macvlan xt_CHECKSU=
M iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_i=
pv4 nf_nat tun bridge stp llc fuse ctr ccm ebtable_filter ebtables joydev r=
tsx_pci_ms memstick rtsx_pci_sdmmc mmc_core iTCO_wdt iTCO_vendor_support cp=
ufreq_userspace cpufreq_powersave cpufreq_conservative ip6t_REJECT nf_rejec=
t_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_table=
s xt_policy ipt_REJECT nf_reject_ipv4 xt_comment nf_conntrack_ipv4 nf_defra=
g_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_filter binfmt_misc in=
tel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqby=
pass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_u=
ncore
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0intel_rapl_perf psmouse pcspk=
r uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core=
 videodev media btusb btrtl btbcm btintel sg bluetooth crc16 arc4 iwldvm ma=
c80211 iwlwifi cfg80211 rtsx_pci rfkill fjes snd_hda_codec_hdmi snd_hda_cod=
ec_realtek snd_hda_codec_generic tpm_tis tpm_tis_core tpm i915 fujitsu_lapt=
op battery snd_hda_intel snd_hda_codec lpc_ich i2c_i801 ac mfd_core shpchp =
i2c_smbus snd_hda_core snd_hwdep snd_pcm snd_timer e1000e snd soundcore ptp=
 pps_core video button mei_me mei drm_kms_helper drm i2c_algo_bit loop parp=
ort_pc ppdev sunrpc lp parport ip_tables x_tables autofs4 dm_crypt dm_mod r=
aid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq async_xor a=
sync_tx raid1 raid0 multipath linear md_mod btrfs crc32c_generic xor raid6_=
pq uhci_hcd usb_storage
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0sd_mod crc32c_intel ahci liba=
hci aesni_intel xhci_pci aes_x86_64 xhci_hcd libata glue_helper lrw ehci_pc=
i gf128mul ablk_helper ehci_hcd cryptd evdev usbcore scsi_mod serio_raw usb=
_common
Jan 11 20:43:10 heisenberg kernel: CPU: 6 PID: 10042 Comm: btrfs Tainted: G=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A04.8.0-2-amd64 #1 Debian 4.8.15-2
Jan 11 20:43:10 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJN=
B23E, BIOS Version 1.11 05/24/2012
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A00000000000000286 00000000248a=
dbdb ffffffffb3b1f925 0000000000000000
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A00000000000000000 ffffffffb387=
4ffe ffff9ebe7e9f4424 00007ffcbf0ea5d0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0ffff9ebc0d644000 ffff9ebe7e9f=
4000 ffff9ebe5e44fb20 ffff9ebd4270ae00
Jan 11 20:43:10 heisenberg kernel: Call Trace:
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb3b1f925>] ? dump_s=
tack+0x5c/0x77
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb3874ffe>] ? __warn=
+0xbe/0xe0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc034a533>] ? btrfs_=
ioctl_send+0x533/0x1280 [btrfs]
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb39f1500>] ? memcg_=
kmem_get_cache+0x50/0x150
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb39da242>] ? kmem_c=
ache_alloc+0x122/0x530
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb38a4bf1>] ? sched_=
slice.isra.57+0x51/0xc0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb38a4f10>] ? update=
_cfs_rq_load_avg+0x200/0x4c0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb389bc96>] ? task_r=
q_lock+0x46/0xa0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc030f9fc>] ? btrfs_=
ioctl+0x97c/0x2370 [btrfs]
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb38aa7bc>] ? enqueu=
e_task_fair+0x5c/0x940
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb382e8a5>] ? sched_=
clock+0x5/0x10
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb389d5b0>] ? check_=
preempt_curr+0x50/0x90
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb389f366>] ? wake_u=
p_new_task+0x156/0x200
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb3a0ebef>] ? do_vfs=
_ioctl+0x9f/0x5f0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb38742bd>] ? _do_fo=
rk+0x14d/0x3f0
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb3a0f1b4>] ? SyS_io=
ctl+0x74/0x80
Jan 11 20:43:10 heisenberg kernel:=C2=A0=C2=A0[<ffffffffb3de8cb6>] ? system=
_call_fast_compare_end+0xc/0x96
Jan 11 20:43:10 heisenberg kernel: ---[ end trace 3831b8afbd0cbc9e ]---
Jan 11 20:43:45 heisenberg kernel: BTRFS info (device dm-2): The free space=
 cache file (7525348933632) is invalid. skip it


The send/receive seems to continue running...
Not sure if the free space cache file entry is related (btw: a btrfs
check directly before didn't find that error - actually yet another
fsck directly before that, brought a message that the super generation
and space file generation would mismatch (or something like that) and
it would be invalidated... so kinda strange that this happens at all).


Cheers,
Chris.
--=-ibnxiSwfkKBPNzbgT7p+
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMTExMTk1OTExWjBPBgkqhkiG9w0BCQQxQgRA4jum
rUrTYSu+KIV0+y3ktMBWanZkU2/4YZ+tGsVSw/3fVFZJVgu29vXBqnUdgCXUze6fn/fMBZOc2W1q
YUwALDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAiZqm
iHSsD6pOEL2HVZbaW30us2I5AZCwe7GDYOgg8pfKXSzaudX2soId63oDV0WiRI7ut9FRvZ+gPgni
bPbzTqgtN/H3bpQs3PO4rdO42LIJYLlZ1oClY4VEv5j2kuzsECzq7UBvRT04OmrkNnRY6L+9309D
cWGmo50oo2LZQp/xyiIV7pxUlDDQh0ypwGW8nD2L4TAIt2FPFRbr+V/a5P8cU5auf4FNDaztnVbU
SRbDfQnoelHw7/iZ2oyQrUMzIEsgbwyvB4sLcFBqw72fh+z81+7Gz0tYRQgQitQ7DCZfiLD5XAYB
oqF2NIoV2UbSy/EE8nr5KAhCkiHsRann++cQlyaL/LwDGvCgjJS9DD/07IgKcIG2IFH5PdMLv4VJ
XZuVnM53sL2S2i7UHPcGjEVBNAD9pYtFUr+GC2tSTSIQ7KLprkZaCdR+3i1rBKVRZxj09Q+GdUGc
kw5q9Bq70OkF0RW/tQYmoOpBoTCsT4YxAF/bT0O/bCPtAIF5CZz2LDMaR76pbCl13vLA+b5bLobi
pytZB35eIjbN6mEHo/5tUHNbYxvZB0n4KXjt7dhlP/b8GDzfFInhOR6CXIsjex6HJVgk23Dcf+S2
ieH/afSXVi7nP6jy8hih2AWFAoHfBoO5ynRNlnoAQ3he8IUaADqZ0zm+GX0kgrWpcFOhhYoAAAAA
AAA=


--=-ibnxiSwfkKBPNzbgT7p+--

