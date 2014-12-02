Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51997 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaLBAPa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 19:15:30 -0500
Received: by mail-vc0-f179.google.com with SMTP id le20so5305732vcb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 16:15:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547CF8B1.4000303@pobox.com>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
	<547CF8B1.4000303@pobox.com>
Date: Tue, 2 Dec 2014 01:15:30 +0100
Message-ID: <CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Robert White <rwhite@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-02 0:24 GMT+01:00 Robert White <rwhite@pobox.com>:
> On 12/01/2014 02:10 PM, MegaBrutal wrote:
>>
>> Since having duplicate UUIDs on devices is not a problem for me since
>> I can tell them apart by LVM names, the discussion is of little
>> relevance to my use case. Of course it's interesting and I like to
>> read it along, it is not about the actual problem at hand.
>>
>
> Which is why you use the device= mount option, which would take LVM names
> and which was repeatedly discussed as solving this very problem.
>
> Once you decide to duplicate the UUIDs with LVM snapshots you take up the
> burden of disambiguating your storage.
>
> Which is part of why re-reading was suggested as this was covered in some
> depth and _is_ _exactly_ about the problem at hand.

Nope.

root@reproduce-1391429:~# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.18.0-031800rc5-generic
root=/dev/mapper/vg-rootlv ro
rootflags=device=/dev/mapper/vg-rootlv,subvol=@

Observe, device= mount option is added.


root@reproduce-1391429:~# ./reproduce-1391429.sh
#!/bin/sh -v
lvs
  LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
  rootlv vg   -wi-ao---   1.00g
  swap0  vg   -wi-ao--- 256.00m

grub-probe --target=device /
/dev/mapper/vg-rootlv

grep " / " /proc/mounts
rootfs / rootfs rw 0 0
/dev/dm-1 / btrfs rw,relatime,space_cache 0 0

lvcreate --snapshot --size=128M --name z vg/rootlv
  Logical volume "z" created

lvs
  LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
  rootlv vg   owi-aos--   1.00g
  swap0  vg   -wi-ao--- 256.00m
  z      vg   swi-a-s-- 128.00m      rootlv   0.11

ls -l /dev/vg/
total 0
lrwxrwxrwx 1 root root 7 Dec  2 00:12 rootlv -> ../dm-1
lrwxrwxrwx 1 root root 7 Dec  2 00:12 swap0 -> ../dm-0
lrwxrwxrwx 1 root root 7 Dec  2 00:12 z -> ../dm-2

grub-probe --target=device /
/dev/mapper/vg-z

grep " / " /proc/mounts
rootfs / rootfs rw 0 0
/dev/dm-2 / btrfs rw,relatime,space_cache 0 0

lvremove --force vg/z
  Logical volume "z" successfully removed

grub-probe --target=device /
/dev/mapper/vg-rootlv

grep " / " /proc/mounts
rootfs / rootfs rw 0 0
/dev/dm-1 / btrfs rw,relatime,space_cache 0 0


Problem still reproduces.
