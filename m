From: Liuwenyi <qingshenlwy@gmail.com>
Subject: Re: [BUG] 2.6.35 btrfs oops at extent_range_uptodate
Date: Wed, 19 Jan 2011 20:08:09 +0800
Message-ID: <4D36D429.1060604@gmail.com>
References: <20110119062747.GA16063@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	meego-kernel@meego.com
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110119062747.GA16063@darkstar>
List-ID: <linux-btrfs.vger.kernel.org>


=E4=BA=8E 2011-1-19 14:27, Yang Ruirui =E5=86=99=E9=81=93:
> Boot with meego kernel 2.6.35.9-6.5-adaptation-n900 on n900, an oops =
happend, I see similar reporting in lkml:
> https://lkml.org/lkml/2010/8/26/103
>
> I just happened once, so I don't know hot to reproduce it.
>
> `addr2line -e vmlinux 0xc0197888` show
> fs/btrfs/extent_io.c:3358
>
>   ret =3D test_range_bit(tree, eb->start, eb->start + eb->len - 1,
>                             EXTENT_UPTODATE, 1, cached_state);
Maybe, this is caused by (tree=3D=3Dnull). We can add a judgement in=20
test_tange_bit to avoid this situation.
> <3>[ 7872.955352] mmcblk0: error -9 sending status comand
> <3>[ 7872.960083] mmcblk0: error -9 sending read/write command, respo=
nse 0x0, card status 0x0
> <3>[ 7872.968383] mmcblk0: error -9 transferring data, sector 89484, =
nr 4, card status 0x0
> <3>[ 7872.977142] end_request: I/O error, dev mmcblk0, sector 89484
> <3>[ 7872.984466] mmcblk0: error -9 sending status comand
> <3>[ 7872.989257] mmcblk0: error -9 sending read/write command, respo=
nse 0x0, card status 0x0
> <3>[ 7872.998535] mmcblk0: error -9 transferring data, sector 89485, =
nr 3, card status 0x0
> <3>[ 7873.007019] end_request: I/O error, dev mmcblk0, sector 89485
> <3>[ 7873.012878] mmcblk0: error -9 sending status comand
> <3>[ 7873.017669] mmcblk0: error -9 sending read/write command, respo=
nse 0x0, card status 0x0
> <3>[ 7873.025939] mmcblk0: error -9 transferring data, sector 89486, =
nr 2, card status 0x0
> <3>[ 7873.040283] end_request: I/O error, dev mmcblk0, sector 89486
> <3>[ 7873.046203] mmcblk0: error -9 sending status comand
> <3>[ 7873.050994] mmcblk0: error -9 sending read/write command, respo=
nse 0x0, card status 0x0
> <3>[ 7873.059265] mmcblk0: error -9 transferring data, sector 89487, =
nr 1, card status 0x0
> <3>[ 7873.067108] end_request: I/O error, dev mmcblk0, sector 89487
> <1>[ 7873.073120] Unable to handle kernel NULL pointer dereference at=
 virtual address 00000000
> <1>[ 7873.082031] pgd =3D c0004000
> <1>[ 7873.084747] [00000000] *pgd=3D00000000
> <0>[ 7873.088439] Internal error: Oops: 17 [#1] PREEMPT
> <0>[ 7873.093170] last sysfs file: /sys/devices/platform/isp1704_char=
ger.0/power_supply/isp1704/online
> <4>[ 7873.102020] Modules linked in: rfcomm sco wl1251_spi wl1251 cmt=
_speech ssi_protocol mac80211 cmt hsi_char smc91x tsl2563(C) isp1704_ch=
arger leds_lp5523 lis3lv02d_i2c cfg80211 power_supply led_class rtc_twl=
 industrialio(C) omap_ssi lis3lv02d mii input_polldev crc7 bnep l2cap h=
ci_h4p bluetooth gpio_keys omaplfb pvrsrvkm g_nokia vfat fat
> <4>[ 7873.132232] CPU: 0    Tainted: G         C   (2.6.35.9-6.5-adap=
tation-n900 #1)
> <4>[ 7873.139495] PC is at extent_range_uptodate+0x5c/0x9c
> <4>[ 7873.144531] LR is at lock_release+0x38/0x48
> <4>[ 7873.148742] pc : [<c0197888>]    lr : [<c007cbc4>]    psr: 6000=
0013
> <4>[ 7873.148742] sp : cffcbf00  ip : 00000001  fp : 00000000
> <4>[ 7873.160278] r10: 023b2dff  r9 : 00000000  r8 : 00001000
> <4>[ 7873.165557] r7 : 00000001  r6 : cf909908  r5 : 00000000  r4 : 0=
23b2000
> <4>[ 7873.172119] r3 : 00000000  r2 : 00000000  r1 : 00000001  r0 : 0=
0000000
> <4>[ 7873.178680] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM=
  Segment kernel
> <4>[ 7873.186035] Control: 10c5387d  Table: 8ffe8019  DAC: 00000017
> <0>[ 7873.191833] Process btrfs-endio-met (pid: 475, stack limit =3D =
0xcffca2e8)
> <0>[ 7873.198577] Stack: (0xcffcbf00 to 0xcffcc000)
> <0>[ 7873.202972] bf00: 023b2dff 00000000 00000004 00000001 00000000 =
cff9feec 00000000 023b1e00
> <0>[ 7873.211212] bf20: 00000000 c300cc60 cff413e0 ffffffff ffffffff =
023b2dff 00000000 c016cf44
> <0>[ 7873.219421] bf40: 023b2dff 00000000 023b1000 00000000 cff9feec =
cff413c0 cff78000 00000001
> <0>[ 7873.227661] bf60: cff9fec0 cff9fec0 cffca000 cffcbf88 cff413e0 =
cff9fecc 00000000 cff9fec4
> <0>[ 7873.235900] bf80: 00000000 c01a038c cffcbf88 cffcbf88 cffcbf90 =
cffcbf90 cff81ef4 c01a0308
> <0>[ 7873.244140] bfa0: cff9fec0 00000013 00000000 00000000 00000000 =
c006b8f8 00000000 00000000
> <0>[ 7873.252380] bfc0: 00000000 00000001 dead4ead ffffffff ffffffff =
c0503878 00000000 c042f88a
> <0>[ 7873.260620] bfe0: cffcbfe0 cffcbfe0 cff81ef4 c006b874 c002e980 =
c002e980 00801000 00000000
> <4>[ 7873.268859] [<c0197888>] (extent_range_uptodate+0x5c/0x9c) from=
 [<c016cf44>] (end_workqueue_fn+0x11c/0x174)
> <4>[ 7873.278686] [<c016cf44>] (end_workqueue_fn+0x11c/0x174) from [<=
c01a038c>] (worker_loop+0x84/0x320)
> <4>[ 7873.287719] [<c01a038c>] (worker_loop+0x84/0x320) from [<c006b8=
f8>] (kthread+0x84/0x8c)
> <4>[ 7873.295806] [<c006b8f8>] (kthread+0x84/0x8c) from [<c002e980>] =
(kernel_thread_exit+0x0/0x8)
> <0>[ 7873.304229] Code: e1a01624 e5960008 e1811a05 ebfc1508 (e5907000=
)
> <4>[ 7873.320831] ---[ end trace e366e719494232ee ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
