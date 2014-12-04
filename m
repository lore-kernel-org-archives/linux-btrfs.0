Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15915 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752215AbaLDDKc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 22:10:32 -0500
Message-ID: <547FD069.5050407@ubuntu.com>
Date: Wed, 03 Dec 2014 22:09:29 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Anand Jain <Anand.Jain@oracle.com>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Robert White <rwhite@pobox.com>, Chris Mason <clm@fb.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com>	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>	<547CF8B1.4000303@pobox.com>	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>	<547D6F42.9000009@inwind.it> <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com> <547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com> <547DAF2A.7020902@gmail.com> <547E0EE5.2040504@ubuntu.com> <547EC8B5.1060002@inwind.it>
In-Reply-To: <547EC8B5.1060002@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/03/2014 03:24 AM, Goffredo Baroncelli wrote:
> I am thinking about that. Today the device discovery happens: a)
> when a device appears, two udev rules run "btrfs dev scan
> <device>"
> 
> /lib/udev/rules.d/70-btrfs.rules 
> /lib/udev/rules.d/80-btrfs-lvm.rules
> 
> b) during the boot it is ran a "btrfs device scan", which scan all
>  the device (this happens in debian for other distros may be
> different)
> 
> c) after a btrfs.mkfs, which starts a device scan on each devices
> of the new filesystem
> 
> d) by the user

Are you sure the kernel only gains awareness of btrfs volumes when
user space runs btrfs device scan?  If that is so then that means you
can not boot from a multi device btrfs root without using an
initramfs.  I thought the kernel auto scanned all devices if you tried
to mount a multi device volume, but if this is so, then yes, the udev
rules could be fixed to not call btrfs device scan on an lvm snapshot.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUf9BpAAoJENRVrw2cjl5RgcQIALCGfplK/xgX/QaiRjNW96l2
DWNPQMIhPesci0gF7Th3sNboew0hrc3g6S0a55wAO12CBhMPdzHxHjd9iFVpKi9O
vzvU36XyzwdcPJkBqRdPJMT2kX+428gYUW7jkyC8usj5eSCyeiIodJuxirGDL5Nb
3TttEJOpbPHGlTzHjAqEcK2ybzYi9HCN3CD3fuLagP9n+4zmFE7tGaGglZ9+7P58
wZjlP5xKDCR4Cu5Hr+5ErrmT2EoOvFC+PLKOT8xXhD9Y2emk2AtuY+5l/w7I+SIS
42gTUqPOx/8AOxBhOhkI0pPO8eK7S/lP1LKoXF0WWHhX8CgJLIHwj5KniDYcjBA=
=HI90
-----END PGP SIGNATURE-----
