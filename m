Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:48849 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcHPT0f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 15:26:35 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
	by mailgw-01.dd24.net (Postfix) with ESMTP id 362E25FC1C
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 19:21:17 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
	with ESMTP id VGmN996Vm1cC for <linux-btrfs@vger.kernel.org>;
	Tue, 16 Aug 2016 19:21:14 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-220-6.dynamic.mnet-online.de [46.244.220.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mailgw-01.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 19:21:14 +0000 (UTC)
Message-ID: <1471375274.18859.11.camel@scientia.net>
Subject: btrfs gives kernel call trace just because send/receive on a ro fs
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Aug 2016 21:21:14 +0200
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-gAdSPiHsOzXpcA177L/A"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-gAdSPiHsOzXpcA177L/A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

$ uname -a
Linux heisenberg 4.6.0-1-amd64 #1 SMP Debian 4.6.4-1 (2016-07-18) x86_64 GN=
U/Linux


The following call trace happens, just because of a send/receive to a
read-only mounted btrfs. Isn't that a bit overkill and shouldn't one
rather get just a user space warning/error?

Aug 16 21:15:49 heisenberg kernel: ------------[ cut here ]------------
Aug 16 21:15:49 heisenberg kernel: WARNING: CPU: 1 PID: 32585 at /build/lin=
ux-aOJbQa/linux-4.6.4/fs/btrfs/send.c:5963 btrfs_ioctl_send+0x670/0x1170 [b=
trfs]
Aug 16 21:15:49 heisenberg kernel: Modules linked in: hmac(E) drbg(E) ansi_=
cprng(E) ctr(E) ccm(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) snd_seq_d=
evice(E) ext4(E) ecb(E) jbd2(E) mbcache(E) algif_skcipher(E) af_alg(E) uas(=
E) vhost_net(E) vhost(E) macvtap(E) macvlan(E) xt_CHECKSUM(E) iptable_mangl=
e(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_nat_ipv4=
(E) nf_nat(E) xt_tcpudp(E) tun(E) bridge(E) stp(E) llc(E) fuse(E) ebtable_f=
ilter(E) ebtables(E) joydev(E) rtsx_pci_ms(E) memstick(E) rtsx_pci_sdmmc(E)=
 mmc_core(E) iTCO_wdt(E) iTCO_vendor_support(E) cpufreq_userspace(E) cpufre=
q_stats(E) cpufreq_powersave(E) cpufreq_conservative(E) ip6t_REJECT(E) nf_r=
eject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E) ip6table_filter(E) ip6=
_tables(E) xt_policy(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_comment(E) nf_co=
nntrack_ipv4(E)
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0nf_defrag_ipv4(E) xt_multipor=
t(E) xt_conntrack(E) nf_conntrack(E) iptable_filter(E) ip_tables(E) x_table=
s(E) binfmt_misc(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(=
E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_p=
clmul(E) ghash_clmulni_intel(E) btusb(E) btrtl(E) btbcm(E) btintel(E) bluet=
ooth(E) crc16(E) sg(E) uvcvideo(E) videobuf2_vmalloc(E) videobuf2_memops(E)=
 videobuf2_v4l2(E) videobuf2_core(E) videodev(E) media(E) psmouse(E) pcspkr=
(E) i2c_i801(E) arc4(E) iwldvm(E) mac80211(E) iwlwifi(E) rtsx_pci(E) cfg802=
11(E) rfkill(E) snd_hda_codec_hdmi(E) snd_hda_codec_realtek(E) snd_hda_code=
c_generic(E) 8250_fintek(E) snd_hda_intel(E) snd_hda_codec(E) snd_hda_core(=
E) snd_hwdep(E) e1000e(E) snd_pcm(E) snd_timer(E) lpc_ich(E) snd(E) fjes(E)=
 fujitsu_laptop(E)
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0ac(E) battery(E) ptp(E) mfd_c=
ore(E) soundcore(E) pps_core(E) shpchp(E) tpm_tis(E) tpm(E) processor(E) i9=
15(E) video(E) button(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) mei_me(E)=
 mei(E) loop(E) sunrpc(E) parport_pc(E) ppdev(E) lp(E) parport(E) autofs4(E=
) dm_crypt(E) dm_mod(E) raid10(E) raid456(E) libcrc32c(E) async_raid6_recov=
(E) async_memcpy(E) async_pq(E) async_xor(E) async_tx(E) raid1(E) raid0(E) =
multipath(E) linear(E) md_mod(E) btrfs(E) crc32c_generic(E) xor(E) raid6_pq=
(E) uhci_hcd(E) usb_storage(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes=
_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) ablk_helper(E) cryptd(E) evdev=
(E) serio_raw(E) ahci(E) libahci(E) libata(E) scsi_mod(E) xhci_pci(E) ehci_=
pci(E) xhci_hcd(E) ehci_hcd(E) usbcore(E) usb_common(E)
Aug 16 21:15:49 heisenberg kernel: CPU: 1 PID: 32585 Comm: btrfs Tainted: G=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0E=
=C2=A0=C2=A0=C2=A04.6.0-1-amd64 #1 Debian 4.6.4-1
Aug 16 21:15:49 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJN=
B23E, BIOS Version 1.11 05/24/2012
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A00000000000000286 00000000ef07=
eaba ffffffff81311505 0000000000000000
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A00000000000000000 ffffffff8107=
a50e ffff8802927ce42c 00007fff2ac54650
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0ffff8802b4e82000 000000004048=
9426 ffff8802a7aa29c8 ffff8802927ce000
Aug 16 21:15:49 heisenberg kernel: Call Trace:
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81311505>] ? dump_s=
tack+0x5c/0x77
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8107a50e>] ? __warn=
+0xbe/0xe0
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc0331d20>] ? btrfs_=
ioctl_send+0x670/0x1170 [btrfs]
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81208401>] ? dput+0=
x81/0x210
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff811fb109>] ? termin=
ate_walk+0x89/0xf0
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810aa1a8>] ? attach=
_task_cfs_rq+0x38/0x70
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc02fb69d>] ? btrfs_=
ioctl+0x151d/0x21a0 [btrfs]
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810afee9>] ? enqueu=
e_task_fair+0x59/0x950
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81035875>] ? sched_=
clock+0x5/0x10
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81204a8d>] ? do_vfs=
_ioctl+0x9d/0x5c0
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810797c1>] ? _do_fo=
rk+0x141/0x3f0
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81205024>] ? SyS_io=
ctl+0x74/0x80
Aug 16 21:15:49 heisenberg kernel:=C2=A0=C2=A0[<ffffffff815c6776>] ? system=
_call_fast_compare_end+0xc/0x96
Aug 16 21:15:49 heisenberg kernel: ---[ end trace 23571c17eb812726 ]---


Here I remount,rw:
Aug 16 21:16:30 heisenberg kernel: BTRFS info (device dm-2): disk space
caching is enabled


Interestingly, when I start the send/receive again, another call trace
occurs, but the user space tools move on just fine (at least
seemingly)??

Aug 16 21:16:51 heisenberg kernel: ------------[ cut here ]------------
Aug 16 21:16:51 heisenberg kernel: WARNING: CPU: 2 PID: 32624 at /build/lin=
ux-aOJbQa/linux-4.6.4/fs/btrfs/send.c:5963 btrfs_ioctl_send+0x670/0x1170 [b=
trfs]
Aug 16 21:16:51 heisenberg kernel: Modules linked in: hmac(E) drbg(E) ansi_=
cprng(E) ctr(E) ccm(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) snd_seq_d=
evice(E) ext4(E) ecb(E) jbd2(E) mbcache(E) algif_skcipher(E) af_alg(E) uas(=
E) vhost_net(E) vhost(E) macvtap(E) macvlan(E) xt_CHECKSUM(E) iptable_mangl=
e(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_nat_ipv4=
(E) nf_nat(E) xt_tcpudp(E) tun(E) bridge(E) stp(E) llc(E) fuse(E) ebtable_f=
ilter(E) ebtables(E) joydev(E) rtsx_pci_ms(E) memstick(E) rtsx_pci_sdmmc(E)=
 mmc_core(E) iTCO_wdt(E) iTCO_vendor_support(E) cpufreq_userspace(E) cpufre=
q_stats(E) cpufreq_powersave(E) cpufreq_conservative(E) ip6t_REJECT(E) nf_r=
eject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E) ip6table_filter(E) ip6=
_tables(E) xt_policy(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_comment(E) nf_co=
nntrack_ipv4(E)
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0nf_defrag_ipv4(E) xt_multipor=
t(E) xt_conntrack(E) nf_conntrack(E) iptable_filter(E) ip_tables(E) x_table=
s(E) binfmt_misc(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(=
E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_p=
clmul(E) ghash_clmulni_intel(E) btusb(E) btrtl(E) btbcm(E) btintel(E) bluet=
ooth(E) crc16(E) sg(E) uvcvideo(E) videobuf2_vmalloc(E) videobuf2_memops(E)=
 videobuf2_v4l2(E) videobuf2_core(E) videodev(E) media(E) psmouse(E) pcspkr=
(E) i2c_i801(E) arc4(E) iwldvm(E) mac80211(E) iwlwifi(E) rtsx_pci(E) cfg802=
11(E) rfkill(E) snd_hda_codec_hdmi(E) snd_hda_codec_realtek(E) snd_hda_code=
c_generic(E) 8250_fintek(E) snd_hda_intel(E) snd_hda_codec(E) snd_hda_core(=
E) snd_hwdep(E) e1000e(E) snd_pcm(E) snd_timer(E) lpc_ich(E) snd(E) fjes(E)=
 fujitsu_laptop(E)
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0ac(E) battery(E) ptp(E) mfd_c=
ore(E) soundcore(E) pps_core(E) shpchp(E) tpm_tis(E) tpm(E) processor(E) i9=
15(E) video(E) button(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) mei_me(E)=
 mei(E) loop(E) sunrpc(E) parport_pc(E) ppdev(E) lp(E) parport(E) autofs4(E=
) dm_crypt(E) dm_mod(E) raid10(E) raid456(E) libcrc32c(E) async_raid6_recov=
(E) async_memcpy(E) async_pq(E) async_xor(E) async_tx(E) raid1(E) raid0(E) =
multipath(E) linear(E) md_mod(E) btrfs(E) crc32c_generic(E) xor(E) raid6_pq=
(E) uhci_hcd(E) usb_storage(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes=
_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) ablk_helper(E) cryptd(E) evdev=
(E) serio_raw(E) ahci(E) libahci(E) libata(E) scsi_mod(E) xhci_pci(E) ehci_=
pci(E) xhci_hcd(E) ehci_hcd(E) usbcore(E) usb_common(E)
Aug 16 21:16:51 heisenberg kernel: CPU: 2 PID: 32624 Comm: btrfs Tainted: G=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=C2=A0=C2=A0=C2=A0E=C2=A0=
=C2=A0=C2=A04.6.0-1-amd64 #1 Debian 4.6.4-1
Aug 16 21:16:51 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJN=
B23E, BIOS Version 1.11 05/24/2012
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A00000000000000286 000000006055=
1fec ffffffff81311505 0000000000000000
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A00000000000000000 ffffffff8107=
a50e ffff8802927ce42c 00007ffda18deb50
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0ffff8802b4e82000 000000004048=
9426 ffff8802a7aa29c8 ffff8802927ce000
Aug 16 21:16:51 heisenberg kernel: Call Trace:
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81311505>] ? dump_s=
tack+0x5c/0x77
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8107a50e>] ? __warn=
+0xbe/0xe0
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc0331d20>] ? btrfs_=
ioctl_send+0x670/0x1170 [btrfs]
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81208401>] ? dput+0=
x81/0x210
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff811fb109>] ? termin=
ate_walk+0x89/0xf0
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810aa1a8>] ? attach=
_task_cfs_rq+0x38/0x70
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffffc02fb69d>] ? btrfs_=
ioctl+0x151d/0x21a0 [btrfs]
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff8131131a>] ? cpumas=
k_next_and+0x2a/0x40
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810afee9>] ? enqueu=
e_task_fair+0x59/0x950
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81035875>] ? sched_=
clock+0x5/0x10
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81204a8d>] ? do_vfs=
_ioctl+0x9d/0x5c0
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff810797c1>] ? _do_fo=
rk+0x141/0x3f0
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff81205024>] ? SyS_io=
ctl+0x74/0x80
Aug 16 21:16:51 heisenberg kernel:=C2=A0=C2=A0[<ffffffff815c6776>] ? system=
_call_fast_compare_end+0xc/0x96
Aug 16 21:16:51 heisenberg kernel: ---[ end trace 23571c17eb812727 ]---



Cheers,
Chris.
--=-gAdSPiHsOzXpcA177L/A
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwODE2MTkyMTE0WjBPBgkqhkiG9w0BCQQxQgRAuweJ
0R2Uvqo1TPDa6KR3tCsWo+KEB7IJgjSwpJLF8SLAynoO//nVCW4KXPaNip3UxCnmXA5/AsEmZgi7
e3+kHDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIATBzX
sX1qW9Lz/Fc3Fuwxjbxl/4A811FlZAtE9Dbyt30zRpPQh+agGprR2iNXjptDm5ckw6z2AI6qFHp+
2g18xlQVx/phaXDbdgOJmWULxq9Jd7HOIwgn8KzmbMnEq3YJothZRvZu24ZMYzJn8dEVYIDOVgcw
3aKci2mI4L2KjimkjFxbuGe7WzFXryfjNOjCBNdmN1c0yNd6PBGUkY17JaXoPm80tSyHv4pirWrh
ZC+ju9GTJT/O5y7k8cFTbwrN3ckjofqCJ+XLGhYvmP47swfoIBEJV8HMTXFhW+0Bw1RYxTbFnraD
NAAVQRdHJjye1d40tVV0PK9nvAuXaMMNLK9/Xoq6jO9EP6DPzsZwGWKZJSaVuzcmfg8gFfdf685G
ZhkDBW+HGyht2q9/rXB2pT9dfyjTT/lYEn05TGTP3p4upsvQBSzBlBdiB7jowZTHIednmECaq2VP
rMjBZKugJCJ/A+LNt73flM4Trm7N9iZcwCUEYTZ8t/J9SAZAVHjwrIT/py1hBzjRWZAOwTvcs3wO
YW+RNZKg9Cw/0HQ5jmT3iR1khBu7VlTPKXI2QZbV4gyK7JLaAJPT16xSgmuZIrb8393O2I0RsnNj
P9cjf5/yV+P7fJSYJ9qtGaRADBM4P1UowmUP7N2vkKPMrRzUqQn7m8xSlF8PXK1bPRPk56EAAAAA
AAA=


--=-gAdSPiHsOzXpcA177L/A--

