Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55647 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751372AbdAYJbp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 04:31:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <mkl@pengutronix.de>)
        id 1cWJvb-0006Lp-Bc
        for linux-btrfs@vger.kernel.org; Wed, 25 Jan 2017 10:31:43 +0100
Received: from [IPv6:2001:470:7eea:1122:114a:81d7:217e:5622] (unknown [IPv6:2001:470:7eea:1122:114a:81d7:217e:5622])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (verified OK))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 456AA1BF3D2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 10:31:41 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Marc Kleine-Budde <mkl@pengutronix.de>
Subject: NULL pointer dereference in btrfs_async_reclaim_metadata_space
Message-ID: <29d12d8d-30f6-f0d4-847e-d11edf7aa9f5@pengutronix.de>
Date: Wed, 25 Jan 2017 10:31:32 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="rKogrWOLq9cxRi0C3lQM0fd13fDLQ9NqE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rKogrWOLq9cxRi0C3lQM0fd13fDLQ9NqE
Content-Type: multipart/mixed; boundary="cbSH55l9CTwOEBdxShAvnfenwjuxgv5VM";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <29d12d8d-30f6-f0d4-847e-d11edf7aa9f5@pengutronix.de>
Subject: NULL pointer dereference in btrfs_async_reclaim_metadata_space

--cbSH55l9CTwOEBdxShAvnfenwjuxgv5VM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I'm using debian's latest 4.9 Kernel on a 32bit armhf SMP board. The
filesystem is in raid1 mode using two harddrives. After the system
crashed (for yet unknown reason) the mounting of the raid1 failed
with the following backtrace:

[   31.163013] BTRFS info (device sda): The free space cache file (169207=
8702592) is invalid. skip it
[   31.163013]=20
[   36.257271] Unable to handle kernel NULL pointer dereference at virtua=
l address 000001dc
[   36.265421] pgd =3D c0004000
[   36.268131] [000001dc] *pgd=3D00000000
[   36.271778] Internal error: Oops: 5 [#1] SMP ARM
[   36.276393] Modules linked in: arc4 ath9k_htc ath9k_common ath9k_hw rt=
2800usb rt2x00usb rt2800lib ath rt2x00lib mac80211 cfg80211 crc_ccitt rfk=
ill usbhid hid mcs7830 usbnet mii evdev ext4 sun4i_codec crc16 jbd2 fscry=
pto ecb mbcache snd_soc_core snd_pcm_dmaengine snd_pcm axp20x_usb_power s=
nd_timer axp20x_pek ir_lirc_codec lirc_dev snd soundcore sunxi_cir sun4i_=
ts nvmem_sunxi_sid nvmem_core sunxi_wdt sg spi_sun4i sun4i_ss des_generic=
 leds_gpio cpufreq_dt ip_tables x_tables autofs4 btrfs crc32c_generic xor=
 zlib_deflate raid6_pq sd_mod axp20x_regulator realtek ahci_sunxi libahci=
_platform libahci sunxi ohci_platform phy_generic libata dwmac_sunxi stmm=
ac_platform ohci_hcd musb_hdrc ehci_platform stmmac udc_core ehci_hcd i2c=
_mv64xxx scsi_mod usbcore phy_sun4i_usb extcon_core sunxi_mmc usb_common
[   36.347114] CPU: 1 PID: 6 Comm: kworker/u4:0 Not tainted 4.9.0-1-armmp=
 #1 Debian 4.9.2-2
[   36.355193] Hardware name: Allwinner sun7i (A20) Family
[   36.360747] Workqueue: events_unbound btrfs_async_reclaim_metadata_spa=
ce [btrfs]
[   36.368149] task: ee8ac0c0 task.stack: ee8ec000
[   36.372830] PC is at can_overcommit.part.7+0x18/0x174 [btrfs]
[   36.378695] LR is at btrfs_async_reclaim_metadata_space+0x4e4/0x884 [b=
trfs]
[   36.385649] pc : [<bf3a11d4>]    lr : [<bf3adf20>]    psr: 80070013
[   36.385649] sp : ee8ede10  ip : ee8ede50  fp : ee8ede4c
[   36.397111] r10: c9bf6800  r9 : 00000000  r8 : c9bf6890
[   36.402328] r7 : 00000000  r6 : c9bf6898  r5 : 00000000  r4 : 00000004=

[   36.408847] r3 : 00000000  r2 : 00200000  r1 : c9bf6800  r0 : 00000000=

[   36.415367] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segme=
nt none
[   36.422492] Control: 10c5387d  Table: 49e4406a  DAC: 00000051
[   36.428232] Process kworker/u4:0 (pid: 6, stack limit =3D 0xee8ec220)
[   36.434490] Stack: (0xee8ede10 to 0xee8ee000)
[   36.438845] de00:                                     ee8ede94 ee8ede2=
0 c0191798 c01c707c
[   36.447014] de20: 00000000 00000004 00000000 c9bf6898 00000000 c9bf689=
0 00000000 c9bf6800
[   36.455184] de40: ee8eded4 ee8ede50 bf3adf20 bf3a11c8 00000002 c011478=
0 ee956018 ee8ac0c0
[   36.463353] de60: 00000000 ee8f7880 ee8ac0c0 ee8f7880 ef6d5140 0000000=
0 eeb3c1c0 ee8ac0c0
[   36.471522] de80: c0bfa140 c0c05408 ee8edefc c9c23ac4 c07f3e5c c01787b=
8 00000000 00000000
[   36.479692] dea0: 00000000 c0168f68 ee8eded4 c9c23ac4 ee89e400 ee8a980=
0 00000000 ee8ad700
[   36.487861] dec0: c0ce3334 ee8ad705 ee8edf14 ee8eded8 c0169170 bf3ada4=
8 ee8a9800 00000088
[   36.496030] dee0: c0c03d00 00000000 ee8ec000 ee8a9800 ee89e418 0000008=
8 c0c03d00 ee8a9818
[   36.504200] df00: ee8ec000 ee89e400 ee8edf5c ee8edf18 c0169ff8 c0168fe=
c ee8edf3c c0934934
[   36.512369] df20: 00000000 ee8a9990 ee8ec000 c0c4614e 00000000 0000000=
0 ee8a8d40 ee89e400
[   36.520538] df40: c0169f98 00000000 00000000 00000000 ee8edfac ee8edf6=
0 c016f94c c0169fa4
[   36.528707] df60: 00000000 ee8a8d40 ee89e400 00000000 00000000 ee8edf7=
4 ee8edf74 00000000
[   36.536877] df80: 00000000 ee8edf84 ee8edf84 00040902 ee8a8d40 c016f85=
0 00000000 00000000
[   36.545045] dfa0: 00000000 ee8edfb0 c010a2f8 c016f85c 00000000 0000000=
0 00000000 00000000
[   36.553214] dfc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
[   36.561383] dfe0: 00000000 00000000 00000000 00000000 00000013 0000000=
0 19238001 83218006
[   36.569857] [<bf3a11d4>] (can_overcommit.part.7 [btrfs]) from [<bf3adf=
20>] (btrfs_async_reclaim_metadata_space+0x4e4/0x884 [btrfs])
[   36.581811] [<bf3adf20>] (btrfs_async_reclaim_metadata_space [btrfs]) =
from [<c0169170>] (process_one_work+0x190/0x49c)
[   36.592507] [<c0169170>] (process_one_work) from [<c0169ff8>] (worker_=
thread+0x60/0x538)
[   36.600596] [<c0169ff8>] (worker_thread) from [<c016f94c>] (kthread+0x=
fc/0x114)
[   36.607907] [<c016f94c>] (kthread) from [<c010a2f8>] (ret_from_fork+0x=
14/0x3c)
[   36.615126] Code: e24cb004 e24dd014 e52de004 e8bd4000 (e59061dc)=20
[   36.621363] ---[ end trace 692c04410689c7f2 ]---
[   36.639082] Unable to handle kernel paging request at virtual address =
ffffffec
[   36.646317] pgd =3D c0004000
[   36.649023] [ffffffec] *pgd=3D6fffd861, *pte=3D00000000, *ppte=3D00000=
000
[   36.655332] Internal error: Oops: 37 [#2] SMP ARM
[   36.660033] Modules linked in: arc4 ath9k_htc ath9k_common ath9k_hw rt=
2800usb rt2x00usb rt2800lib ath rt2x00lib mac80211 cfg80211 crc_ccitt rfk=
ill usbhid hid mcs7830 usbnet mii evdev ext4 sun4i_codec crc16 jbd2 fscry=
pto ecb mbcache snd_soc_core snd_pcm_dmaengine snd_pcm axp20x_usb_power s=
nd_timer axp20x_pek ir_lirc_codec lirc_dev snd soundcore sunxi_cir sun4i_=
ts nvmem_sunxi_sid nvmem_core sunxi_wdt sg spi_sun4i sun4i_ss des_generic=
 leds_gpio cpufreq_dt ip_tables x_tables autofs4 btrfs crc32c_generic xor=
 zlib_deflate raid6_pq sd_mod axp20x_regulator realtek ahci_sunxi libahci=
_platform libahci sunxi ohci_platform phy_generic libata dwmac_sunxi stmm=
ac_platform ohci_hcd musb_hdrc ehci_platform stmmac udc_core ehci_hcd i2c=
_mv64xxx scsi_mod usbcore phy_sun4i_usb extcon_core sunxi_mmc usb_common
[   36.730749] CPU: 1 PID: 6 Comm: kworker/u4:0 Tainted: G      D        =
 4.9.0-1-armmp #1 Debian 4.9.2-2
[   36.740040] Hardware name: Allwinner sun7i (A20) Family
[   36.745269] task: ee8ac0c0 task.stack: ee8ec000
[   36.749810] PC is at kthread_data+0x18/0x20
[   36.753991] LR is at wq_worker_sleeping+0x18/0xe0
[   36.758692] pc : [<c01705fc>]    lr : [<c016a578>]    psr: 20070093
[   36.758692] sp : ee8edb08  ip : ee8edb18  fp : ee8edb14
[   36.770153] r10: c0c05408  r9 : c0bfa140  r8 : ee8ac0c0
[   36.775371] r7 : 00000000  r6 : ee8ac4ec  r5 : ef6d5140  r4 : c0bfa140=

[   36.781889] r3 : 00000000  r2 : 00000020  r1 : 00000000  r0 : ee8ac0c0=

[   36.788409] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segm=
ent none
[   36.795620] Control: 10c5387d  Table: 49a4c06a  DAC: 00000051
[   36.801359] Process kworker/u4:0 (pid: 6, stack limit =3D 0xee8ec220)
[   36.807617] Stack: (0xee8edb08 to 0xee8ee000)
[   36.811973] db00:                   ee8edb2c ee8edb18 c016a578 c01705f=
0 c0bfa140 ef6d5140
[   36.820143] db20: ee8edb94 ee8edb30 c07f40a4 c016a56c eef60880 eef6088=
c 60070013 c03e3ef0
[   36.828312] db40: ee8edb6c ee8edb50 2eadb000 c017e120 c0cf5100 eef6088=
0 ef6d5140 60070013
[   36.836482] db60: ee8edb8c ee8edb70 c03e4268 ee8ac0c0 ee8edbbc ee8ed7f=
c ee8edbbc ee8ed7fc
[   36.844651] db80: 00000000 c0c0a10c ee8edba4 ee8edb98 c017e120 c07f3b2=
4 ee8edbdc ee8edba8
[   36.852821] dba0: c01525c8 c017e094 c0cf1ca0 ee8eddc0 0000000b 0000000=
1 bf3a11d6 ee8edbbc
[   36.860991] dbc0: ee8edbbc 00040902 c014caf4 00000001 ee8edc74 ee8edbe=
0 c010f7d0 c0151e64
[   36.869160] dbe0: ee8ec220 0000000b c091ee08 c091ee00 00000008 bf00000=
0 ee8ec000 00000000
[   36.877330] dc00: 60070113 bf3a11d8 c01b2a04 651b22c4 62633432 2034303=
0 64343265 34313064
[   36.885500] dc20: 32356520 30306564 38652034 30346462 28203030 3039356=
5 63643136 ee002029
[   36.893669] dc40: c011e11c 00040902 c0921514 000001dc ee8eddc0 0000000=
5 00000000 00000000
[   36.901839] dc60: ee8ec000 c9bf6800 ee8edc8c ee8edc78 c0123850 c010f32=
8 ee8eddc0 000001dc
[   36.910009] dc80: ee8edce4 ee8edc90 c07f98ac c01237e8 00000010 ee8edca=
0 c0408a8c c0d33320
[   36.918179] dca0: eeeaa228 ee8edd0c ee8edd10 0000000e 00000000 eeeaa26=
0 ee8edcec 00000005
[   36.926349] dcc0: 00000005 c0c0aba4 000001dc ee8eddc0 ee8ec000 c9bf680=
0 ee8edd04 ee8edce8
[   36.934519] dce0: c07f9b4c c07f96bc c0c0414c 00000005 c0c0aba4 000001d=
c ee8eddbc ee8edd08
[   36.942689] dd00: c010128c c07f9a9c c0183948 c0188f9c ee8ac140 c0cf510=
0 ef6d5178 00000001
[   36.950859] dd20: ee8eddc4 ee8edd30 c0188f9c c018743c 00000000 c01c852=
4 ee8edd74 ee8edd48
[   36.959028] dd40: c01c8524 c01c84b0 ef6d1500 eeeaa270 ee8edd74 ee8edd6=
0 ee8ac140 c01c8408
[   36.967197] dd60: eeeaa270 00000400 00000000 ee8edd78 00000000 0000000=
1 637cfae5 00000008
[   36.975367] dd80: 0000004b 00000000 40070093 00040902 ee8ede3c 0004090=
2 bf3a11d4 80070013
[   36.983537] dda0: ffffffff ee8eddf4 c9bf6890 ee8ec000 ee8ede4c ee8eddc=
0 c07f8db8 c010123c
[   36.991707] ddc0: 00000000 c9bf6800 00200000 00000000 00000004 0000000=
0 c9bf6898 00000000
[   36.999877] dde0: c9bf6890 00000000 c9bf6800 ee8ede4c ee8ede50 ee8ede1=
0 bf3adf20 bf3a11d4
[   37.008046] de00: 80070013 ffffffff 00000051 00000000 ee8ede94 ee8ede2=
0 c0191798 c01c707c
[   37.016215] de20: 00000000 00000004 00000000 c9bf6898 00000000 c9bf689=
0 00000000 c9bf6800
[   37.024385] de40: ee8eded4 ee8ede50 bf3adf20 bf3a11c8 00000002 c011478=
0 ee956018 ee8ac0c0
[   37.032555] de60: 00000000 ee8f7880 ee8ac0c0 ee8f7880 ef6d5140 0000000=
0 eeb3c1c0 ee8ac0c0
[   37.040724] de80: c0bfa140 c0c05408 ee8edefc c9c23ac4 c07f3e5c c01787b=
8 00000000 00000000
[   37.048894] dea0: 00000000 c0168f68 ee8eded4 c9c23ac4 ee89e400 ee8a980=
0 00000000 ee8ad700
[   37.057064] dec0: c0ce3334 ee8ad705 ee8edf14 ee8eded8 c0169170 bf3ada4=
8 ee8a9800 00000088
[   37.065234] dee0: c0c03d00 00000000 ee8ec000 ee8a9800 ee89e418 0000008=
8 c0c03d00 ee8a9818
[   37.073403] df00: ee8ec000 ee89e400 ee8edf5c ee8edf18 c0169ff8 c0168fe=
c ee8edf3c c0934934
[   37.081573] df20: 00000000 ee8a9990 ee8ec000 c0c4614e 00000000 0000000=
0 ee8a8d40 ee89e400
[   37.089743] df40: c0169f98 00000000 00000000 00000000 ee8edfac ee8edf6=
0 c016f94c c0169fa4
[   37.097913] df60: 00000000 ee8a8d40 ee89e400 00000000 00000000 ee8edf7=
4 ee8edf74 00000001
[   37.106082] df80: 00010001 ee8edf84 ee8edf84 00040902 ee8a8d40 c016f85=
0 00000000 00000000
[   37.114252] dfa0: 00000000 ee8edfb0 c010a2f8 c016f85c 00000000 0000000=
0 00000000 00000000
[   37.122420] dfc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
[   37.130590] dfe0: 00000000 00000000 00000000 00000000 00000013 0000000=
0 19238001 83218006
[   37.138778] [<c01705fc>] (kthread_data) from [<c016a578>] (wq_worker_s=
leeping+0x18/0xe0)
[   37.146864] [<c016a578>] (wq_worker_sleeping) from [<c07f40a4>] (__sch=
edule+0x58c/0x8a8)
[   37.154955] [<c07f40a4>] (__schedule) from [<c017e120>] (do_task_dead+=
0x98/0x9c)
[   37.162351] [<c017e120>] (do_task_dead) from [<c01525c8>] (do_exit+0x7=
70/0xadc)
[   37.169660] [<c01525c8>] (do_exit) from [<c010f7d0>] (die+0x4b4/0x4d4)=

[   37.176190] [<c010f7d0>] (die) from [<c0123850>] (__do_kernel_fault.pa=
rt.0+0x74/0x1f4)
[   37.184106] [<c0123850>] (__do_kernel_fault.part.0) from [<c07f98ac>] =
(do_page_fault+0x1fc/0x3e0)
[   37.192973] [<c07f98ac>] (do_page_fault) from [<c07f9b4c>] (do_transla=
tion_fault+0xbc/0xc0)
[   37.201320] [<c07f9b4c>] (do_translation_fault) from [<c010128c>] (do_=
DataAbort+0x5c/0xec)
[   37.209582] [<c010128c>] (do_DataAbort) from [<c07f8db8>] (__dabt_svc+=
0x58/0x80)
[   37.216967] Exception stack(0xee8eddc0 to 0xee8ede08)
[   37.222016] ddc0: 00000000 c9bf6800 00200000 00000000 00000004 0000000=
0 c9bf6898 00000000
[   37.230185] dde0: c9bf6890 00000000 c9bf6800 ee8ede4c ee8ede50 ee8ede1=
0 bf3adf20 bf3a11d4
[   37.238350] de00: 80070013 ffffffff
[   37.242167] [<c07f8db8>] (__dabt_svc) from [<bf3a11d4>] (can_overcommi=
t.part.7+0x18/0x174 [btrfs])
[   37.251414] [<bf3a11d4>] (can_overcommit.part.7 [btrfs]) from [<bf3adf=
20>] (btrfs_async_reclaim_metadata_space+0x4e4/0x884 [btrfs])
[   37.263364] [<bf3adf20>] (btrfs_async_reclaim_metadata_space [btrfs]) =
from [<c0169170>] (process_one_work+0x190/0x49c)
[   37.274054] [<c0169170>] (process_one_work) from [<c0169ff8>] (worker_=
thread+0x60/0x538)
[   37.282143] [<c0169ff8>] (worker_thread) from [<c016f94c>] (kthread+0x=
fc/0x114)
[   37.289454] [<c016f94c>] (kthread) from [<c010a2f8>] (ret_from_fork+0x=
14/0x3c)
[   37.296674] Code: e24cb004 e52de004 e8bd4000 e59033fc (e5130014)=20
[   37.302765] ---[ end trace 692c04410689c7f3 ]---
[   37.307379] Fixing recursive fault but reboot is needed!
[   57.628778] INFO: rcu_sched self-detected stall on CPU
[   57.633944] 	0-...: (4199 ticks this GP) idle=3Dd75/140000000000001/0 =
softirq=3D4233/4233 fqs=3D1=20
[   57.642369] 	 (t=3D4200 jiffies g=3D1102 c=3D1101 q=3D133)
[   57.647171] rcu_sched kthread starved for 4198 jiffies! g1102 c1101 f0=
x0 RCU_GP_WAIT_FQS(3) ->state=3D0x1
[   57.656550] rcu_sched       S    0     7      2 0x00000000
[   57.662062] [<c07f3e58>] (__schedule) from [<c07f4410>] (schedule+0x50=
/0xa8)
[   57.669111] [<c07f4410>] (schedule) from [<c07f7834>] (schedule_timeou=
t+0x1f8/0x3c0)
[   57.676856] [<c07f7834>] (schedule_timeout) from [<c01c3fa0>] (rcu_gp_=
kthread+0x574/0x908)
[   57.685118] [<c01c3fa0>] (rcu_gp_kthread) from [<c016f94c>] (kthread+0=
xfc/0x114)
[   57.692513] [<c016f94c>] (kthread) from [<c010a2f8>] (ret_from_fork+0x=
14/0x3c)
[   57.699735] Task dump for CPU 0:
[   57.702959] mount           R  running task        0   307      1 0x00=
000002
[   57.710038] [<c0115108>] (unwind_backtrace) from [<c010f318>] (show_st=
ack+0x20/0x24)
[   57.717778] [<c010f318>] (show_stack) from [<c017f6a4>] (sched_show_ta=
sk+0xb8/0x10c)
[   57.725519] [<c017f6a4>] (sched_show_task) from [<c01822c0>] (dump_cpu=
_task+0x48/0x4c)
[   57.733435] [<c01822c0>] (dump_cpu_task) from [<c026dd54>] (rcu_dump_c=
pu_stacks+0xb8/0xd4)
[   57.741697] [<c026dd54>] (rcu_dump_cpu_stacks) from [<c01c4f0c>] (rcu_=
check_callbacks+0x82c/0x990)
[   57.750652] [<c01c4f0c>] (rcu_check_callbacks) from [<c01cb420>] (upda=
te_process_times+0x44/0x6c)
[   57.759523] [<c01cb420>] (update_process_times) from [<c01df698>] (tic=
k_sched_handle+0x64/0x70)
[   57.768217] [<c01df698>] (tick_sched_handle) from [<c01df70c>] (tick_s=
ched_timer+0x68/0xbc)
[   57.776564] [<c01df70c>] (tick_sched_timer) from [<c01cc9e8>] (__hrtim=
er_run_queues+0x1b4/0x394)
[   57.785344] [<c01cc9e8>] (__hrtimer_run_queues) from [<c01cce1c>] (hrt=
imer_interrupt+0xd4/0x240)
[   57.794126] [<c01cce1c>] (hrtimer_interrupt) from [<c06a12a0>] (arch_t=
imer_handler_phys+0x40/0x48)
[   57.803084] [<c06a12a0>] (arch_timer_handler_phys) from [<c01b9560>] (=
handle_percpu_devid_irq+0x98/0x24c)
[   57.812648] [<c01b9560>] (handle_percpu_devid_irq) from [<c01b3b98>] (=
generic_handle_irq+0x34/0x44)
[   57.821688] [<c01b3b98>] (generic_handle_irq) from [<c01b41a8>] (__han=
dle_domain_irq+0x6c/0xc4)
[   57.830380] [<c01b41a8>] (__handle_domain_irq) from [<c01017d0>] (gic_=
handle_irq+0x64/0xa8)
[   57.838728] [<c01017d0>] (gic_handle_irq) from [<c07f8e4c>] (__irq_svc=
+0x6c/0x90)
[   57.846200] Exception stack(0xed99f8e8 to 0xed99f930)
[   57.851250] f8e0:                   c9bf6800 00000000 00000392 0000039=
1 c9bf6800 c9c23110
[   57.859420] f900: 00080000 00000000 00080000 00000000 c0c0414c ed99f94=
4 ed99f948 ed99f938
[   57.867586] f920: bf3ae304 c07f86c0 800e0013 ffffffff
[   57.872641] [<c07f8e4c>] (__irq_svc) from [<c07f86c0>] (_raw_spin_lock=
+0x40/0x54)
[   57.880312] [<c07f86c0>] (_raw_spin_lock) from [<bf3ae304>] (reserve_m=
etadata_bytes+0x44/0x1138 [btrfs])
[   57.890044] [<bf3ae304>] (reserve_metadata_bytes [btrfs]) from [<bf3af=
428>] (btrfs_block_rsv_add.part.11+0x30/0x5c [btrfs])
[   57.901404] [<bf3af428>] (btrfs_block_rsv_add.part.11 [btrfs]) from [<=
bf3af484>] (btrfs_block_rsv_add+0x30/0x38 [btrfs])
[   57.912501] [<bf3af484>] (btrfs_block_rsv_add [btrfs]) from [<bf3c6308=
>] (start_transaction+0x308/0x4d0 [btrfs])
[   57.922906] [<bf3c6308>] (start_transaction [btrfs]) from [<bf3c64f0>]=
 (btrfs_start_transaction+0x20/0x24 [btrfs])
[   57.933482] [<bf3c64f0>] (btrfs_start_transaction [btrfs]) from [<bf3d=
3880>] (btrfs_truncate+0x90/0x2b4 [btrfs])
[   57.943886] [<bf3d3880>] (btrfs_truncate [btrfs]) from [<bf3d5878>] (b=
trfs_orphan_cleanup+0x2d0/0x644 [btrfs])
[   57.954114] [<bf3d5878>] (btrfs_orphan_cleanup [btrfs]) from [<bf3be14=
0>] (btrfs_cleanup_fs_roots+0x13c/0x1bc [btrfs])
[   57.965037] [<bf3be140>] (btrfs_cleanup_fs_roots [btrfs]) from [<bf3c2=
580>] (open_ctree+0x1e44/0x2378 [btrfs])
[   57.975263] [<bf3c2580>] (open_ctree [btrfs]) from [<bf3906a8>] (btrfs=
_mount+0xecc/0xf9c [btrfs])
[   57.984252] [<bf3906a8>] (btrfs_mount [btrfs]) from [<c02dfe38>] (moun=
t_fs+0x54/0x16c)
[   57.992172] [<c02dfe38>] (mount_fs) from [<c02fefd8>] (vfs_kern_mount+=
0x58/0x104)
[   57.999773] [<c02fefd8>] (vfs_kern_mount) from [<bf38faec>] (btrfs_mou=
nt+0x310/0xf9c [btrfs])
[   58.008412] [<bf38faec>] (btrfs_mount [btrfs]) from [<c02dfe38>] (moun=
t_fs+0x54/0x16c)
[   58.016327] [<c02dfe38>] (mount_fs) from [<c02fefd8>] (vfs_kern_mount+=
0x58/0x104)
[   58.023809] [<c02fefd8>] (vfs_kern_mount) from [<c03022f4>] (do_mount+=
0x1bc/0xc54)
[   58.031374] [<c03022f4>] (do_mount) from [<c0303138>] (SyS_mount+0x9c/=
0xc4)
[   58.038335] [<c0303138>] (SyS_mount) from [<c010a240>] (ret_fast_sysca=
ll+0x0/0x3c)
[   84.073780] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [mou=
nt:307]
[   84.080914] Modules linked in: arc4 ath9k_htc ath9k_common ath9k_hw rt=
2800usb rt2x00usb rt2800lib ath rt2x00lib mac80211 cfg80211 crc_ccitt rfk=
ill usbhid hid mcs7830 usbnet mii evdev ext4 sun4i_codec crc16 jbd2 fscry=
pto ecb mbcache snd_soc_core snd_pcm_dmaengine snd_pcm axp20x_usb_power s=
nd_timer axp20x_pek ir_lirc_codec lirc_dev snd soundcore sunxi_cir sun4i_=
ts nvmem_sunxi_sid nvmem_core sunxi_wdt sg spi_sun4i sun4i_ss des_generic=
 leds_gpio cpufreq_dt ip_tables x_tables autofs4 btrfs crc32c_generic xor=
 zlib_deflate raid6_pq sd_mod axp20x_regulator realtek ahci_sunxi libahci=
_platform libahci sunxi ohci_platform phy_generic libata dwmac_sunxi stmm=
ac_platform ohci_hcd musb_hdrc ehci_platform stmmac udc_core ehci_hcd i2c=
_mv64xxx scsi_mod usbcore phy_sun4i_usb extcon_core sunxi_mmc usb_common
[   84.151649] CPU: 0 PID: 307 Comm: mount Tainted: G      D         4.9.=
0-1-armmp #1 Debian 4.9.2-2
[   84.160505] Hardware name: Allwinner sun7i (A20) Family
[   84.165724] task: c9df87c0 task.stack: ed99e000
[   84.170258] PC is at _raw_spin_lock+0x40/0x54
[   84.174779] LR is at reserve_metadata_bytes+0x44/0x1138 [btrfs]
[   84.180692] pc : [<c07f86c0>]    lr : [<bf3ae304>]    psr: 800e0013
[   84.180692] sp : ed99f938  ip : ed99f948  fp : ed99f944
[   84.192153] r10: c0c0414c  r9 : 00000000  r8 : 00080000
[   84.197371] r7 : 00000000  r6 : 00080000  r5 : c9c23110  r4 : c9bf6800=

[   84.203889] r3 : 00000391  r2 : 00000392  r1 : 00000000  r0 : c9bf6800=

[   84.210408] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segme=
nt none
[   84.217534] Control: 10c5387d  Table: 49e4406a  DAC: 00000051
[   84.223275] CPU: 0 PID: 307 Comm: mount Tainted: G      D         4.9.=
0-1-armmp #1 Debian 4.9.2-2
[   84.232132] Hardware name: Allwinner sun7i (A20) Family
[   84.237370] [<c0115108>] (unwind_backtrace) from [<c010f318>] (show_st=
ack+0x20/0x24)
[   84.245116] [<c010f318>] (show_stack) from [<c040e23c>] (dump_stack+0x=
90/0xa4)
[   84.252338] [<c040e23c>] (dump_stack) from [<c010b0a4>] (show_regs+0x1=
c/0x20)
[   84.259473] [<c010b0a4>] (show_regs) from [<c02116d0>] (watchdog_timer=
_fn+0x248/0x2b8)
[   84.267389] [<c02116d0>] (watchdog_timer_fn) from [<c01cc9e8>] (__hrti=
mer_run_queues+0x1b4/0x394)
[   84.276255] [<c01cc9e8>] (__hrtimer_run_queues) from [<c01cce1c>] (hrt=
imer_interrupt+0xd4/0x240)
[   84.285036] [<c01cce1c>] (hrtimer_interrupt) from [<c06a12a0>] (arch_t=
imer_handler_phys+0x40/0x48)
[   84.293993] [<c06a12a0>] (arch_timer_handler_phys) from [<c01b9560>] (=
handle_percpu_devid_irq+0x98/0x24c)
[   84.303557] [<c01b9560>] (handle_percpu_devid_irq) from [<c01b3b98>] (=
generic_handle_irq+0x34/0x44)
[   84.312597] [<c01b3b98>] (generic_handle_irq) from [<c01b41a8>] (__han=
dle_domain_irq+0x6c/0xc4)
[   84.321289] [<c01b41a8>] (__handle_domain_irq) from [<c01017d0>] (gic_=
handle_irq+0x64/0xa8)
[   84.329637] [<c01017d0>] (gic_handle_irq) from [<c07f8e4c>] (__irq_svc=
+0x6c/0x90)
[   84.337108] Exception stack(0xed99f8e8 to 0xed99f930)
[   84.342156] f8e0:                   c9bf6800 00000000 00000392 0000039=
1 c9bf6800 c9c23110
[   84.350325] f900: 00080000 00000000 00080000 00000000 c0c0414c ed99f94=
4 ed99f948 ed99f938
[   84.358491] f920: bf3ae304 c07f86c0 800e0013 ffffffff
[   84.363547] [<c07f8e4c>] (__irq_svc) from [<c07f86c0>] (_raw_spin_lock=
+0x40/0x54)
[   84.371174] [<c07f86c0>] (_raw_spin_lock) from [<bf3ae304>] (reserve_m=
etadata_bytes+0x44/0x1138 [btrfs])
[   84.380896] [<bf3ae304>] (reserve_metadata_bytes [btrfs]) from [<bf3af=
428>] (btrfs_block_rsv_add.part.11+0x30/0x5c [btrfs])
[   84.392253] [<bf3af428>] (btrfs_block_rsv_add.part.11 [btrfs]) from [<=
bf3af484>] (btrfs_block_rsv_add+0x30/0x38 [btrfs])
[   84.403348] [<bf3af484>] (btrfs_block_rsv_add [btrfs]) from [<bf3c6308=
>] (start_transaction+0x308/0x4d0 [btrfs])
[   84.413750] [<bf3c6308>] (start_transaction [btrfs]) from [<bf3c64f0>]=
 (btrfs_start_transaction+0x20/0x24 [btrfs])
[   84.424325] [<bf3c64f0>] (btrfs_start_transaction [btrfs]) from [<bf3d=
3880>] (btrfs_truncate+0x90/0x2b4 [btrfs])
[   84.434727] [<bf3d3880>] (btrfs_truncate [btrfs]) from [<bf3d5878>] (b=
trfs_orphan_cleanup+0x2d0/0x644 [btrfs])
[   84.444956] [<bf3d5878>] (btrfs_orphan_cleanup [btrfs]) from [<bf3be14=
0>] (btrfs_cleanup_fs_roots+0x13c/0x1bc [btrfs])
[   84.455877] [<bf3be140>] (btrfs_cleanup_fs_roots [btrfs]) from [<bf3c2=
580>] (open_ctree+0x1e44/0x2378 [btrfs])
[   84.466103] [<bf3c2580>] (open_ctree [btrfs]) from [<bf3906a8>] (btrfs=
_mount+0xecc/0xf9c [btrfs])
[   84.475090] [<bf3906a8>] (btrfs_mount [btrfs]) from [<c02dfe38>] (moun=
t_fs+0x54/0x16c)
[   84.483008] [<c02dfe38>] (mount_fs) from [<c02fefd8>] (vfs_kern_mount+=
0x58/0x104)
[   84.490606] [<c02fefd8>] (vfs_kern_mount) from [<bf38faec>] (btrfs_mou=
nt+0x310/0xf9c [btrfs])
[   84.499243] [<bf38faec>] (btrfs_mount [btrfs]) from [<c02dfe38>] (moun=
t_fs+0x54/0x16c)
[   84.507157] [<c02dfe38>] (mount_fs) from [<c02fefd8>] (vfs_kern_mount+=
0x58/0x104)
[   84.514637] [<c02fefd8>] (vfs_kern_mount) from [<c03022f4>] (do_mount+=
0x1bc/0xc54)
[   84.522202] [<c03022f4>] (do_mount) from [<c0303138>] (SyS_mount+0x9c/=
0xc4)
[   84.529164] [<c0303138>] (SyS_mount) from [<c010a240>] (ret_fast_sysca=
ll+0x0/0x3c)

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--cbSH55l9CTwOEBdxShAvnfenwjuxgv5VM--

--rKogrWOLq9cxRi0C3lQM0fd13fDLQ9NqE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEES2FAuYbJvAGobdVQPTuqJaypJWoFAliIcHcACgkQPTuqJayp
JWrj5QgAmFyQ3P0BXq6Z3GN1JF3+PspBI5BlaXs+iSMnPh/5mfsdPr3iA9PLVa5J
M2gc7sinB7e6q59THfNLIn49LGCoulIf4RE/2Qh0oCaOnHfX/rMkuZ6p1WT4s3Wx
r3FZGRHNtenAj2yFYWMLUq55TCjSEQ8GMdRmGpU5jzHGD3aFPOKi27w37Ol8/tBC
WrJlIQohawbuPtN1Io8ArOJp31FuIy3SBSrpz8OlC2FDaqhEA25/PV8bUL29+r6U
alO5OCUj9RxH9nnNs4I+B3fz2EaPiZdWOrsMJIxMkdV6liKTf+QTjqa0XLieJiZ8
a8Fnd5/uJr3QJVP3UvubdW/apyR24w==
=xC2r
-----END PGP SIGNATURE-----

--rKogrWOLq9cxRi0C3lQM0fd13fDLQ9NqE--
