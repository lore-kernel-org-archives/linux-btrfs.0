Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:39032 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbeHAG01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 02:26:27 -0400
Received: by mail-vk0-f46.google.com with SMTP id e139-v6so8646484vkf.6
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 21:42:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1d1760be-ef7d-f0e0-7b6c-6575c7d68c5a@mendix.com>
References: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
 <1d1760be-ef7d-f0e0-7b6c-6575c7d68c5a@mendix.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Wed, 1 Aug 2018 07:42:47 +0300
Message-ID: <CAN4oSBe8GbAEK7Xd3L1XzH2NDEJaYeNh5JSmTjvKWVhC616dVg@mail.gmail.com>
Subject: Re: Unmountable root partition
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000091a4af057258538f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--00000000000091a4af057258538f
Content-Type: text/plain; charset="UTF-8"

That might be the case. Can't we recover anything with some data loss?

2018-08-01 2:04 GMT+03:00 Hans van Kranenburg <
hans.van.kranenburg@mendix.com>:

> Hi,
>
> On 07/31/2018 08:03 PM, Cerem Cem ASLAN wrote:
> > Hi,
> >
> > I'm having trouble with my server setup, which contains a BTRFS root
> > partition on top of LVM on top of LUKS partition.
> >
> > Yesterday server was shut down unexpectedly. I booted the system with a
> > pendrive which contains Debian 4.9.18 and tried to mount the BTRFS root
> > partition manually.
> >
> > 1. cryptsetup luksOpen /dev/sda5
> >
> > Seems to decrypt the partition (there are no errors)
> >
> > 2. /dev/mapper/foo--vg-root and /dev/mapper/foo--vg-swap_1 is created
> > automatically, so I suppose LVM works correctly.
> >
> > 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo
> > Gives the following error:
> >
> >     mount: wrong fs type, bad option, bad superblock on ...
> >
> > 4. dmesg | tail
> > Outputs the following:
> >
> >
> >     [17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:
> >     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> >     [17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0
> >     02 00 00 02 00
> >     [17755.840921] blk_update_request: I/O error, dev sda, sector 507906
> >     [17755.840941] EXT4-fs (dm-4): unable to read superblock
> >     [18140.052300] sd 3:0:0:0: [sda] tag#0 FAILED Result:
> >     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> >     [18140.052305] sd 3:0:0:0: [sda] tag#0 CDB: ATA command pass
> >     through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> >     [18142.991851] sd 3:0:0:0: [sda] tag#0 FAILED Result:
> >     hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> >     [18142.991856] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0
> >     80 00 00 08 00
> >     [18142.991860] blk_update_request: I/O error, dev sda, sector 508032
> >     [18142.991869] Buffer I/O error on dev dm-4, logical block 16, async
> >     page read
>
> This points at hardware level failure, regardless if the disk would hold
> a btrfs or ext4 or whatever other kind of filesystem. The disk itself
> cannot read data back when we ask for it.
>
> > 4.
> >
> >     # btrfs restore -i -D /dev/mapper/foo--vg-root /dev/null
> >     No valid Btrfs found on /dev/mapper/foo--vg-root
> >     Could not open root, trying backup super
> >     No valid Btrfs found on /dev/mapper/foo--vg-root
> >     Could not open root, trying backup super
> >     No valid Btrfs found on /dev/mapper/foo--vg-root
> >     Could not open root, trying backup super
> >
> > We are pretty sure that no unexpected electric cuts has been happened.
> >
> > At this point I don't know what information I should supply.
> >
>
>
> --
> Hans van Kranenburg
>

--00000000000091a4af057258538f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">That might be the case. Can&#39;t we recover anything with=
 some data loss?</div><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">2018-08-01 2:04 GMT+03:00 Hans van Kranenburg <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:hans.van.kranenburg@mendix.com" target=3D"_blank">hans.van.=
kranenburg@mendix.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi,=
<br>
<div><div class=3D"h5"><br>
On 07/31/2018 08:03 PM, Cerem Cem ASLAN wrote:<br>
&gt; Hi,=C2=A0<br>
&gt; <br>
&gt; I&#39;m having trouble with my server setup, which contains a BTRFS ro=
ot<br>
&gt; partition on top of LVM on top of LUKS partition.=C2=A0<br>
&gt; <br>
&gt; Yesterday server was shut down unexpectedly. I booted the system with =
a<br>
&gt; pendrive which contains Debian 4.9.18 and tried to mount the BTRFS roo=
t<br>
&gt; partition manually.=C2=A0<br>
&gt; <br>
&gt; 1. cryptsetup luksOpen /dev/sda5=C2=A0<br>
&gt; <br>
&gt; Seems to decrypt the partition (there are no errors)=C2=A0<br>
&gt; <br>
&gt; 2. /dev/mapper/foo--vg-root and /dev/mapper/foo--vg-swap_1 is created<=
br>
&gt; automatically, so I suppose LVM works correctly.=C2=A0<br>
&gt; <br>
&gt; 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo=C2=A0<br>
&gt; Gives the following error:=C2=A0<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0mount: wrong fs type, bad option, bad superblock on=
 ...<br>
&gt; <br>
&gt; 4. dmesg | tail=C2=A0<br>
&gt; Outputs the following:=C2=A0<br>
&gt; <br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0[17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Resul=
t:<br>
&gt;=C2=A0 =C2=A0 =C2=A0hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0[17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10=
) 28 00 00 07 c0<br>
&gt;=C2=A0 =C2=A0 =C2=A002 00 00 02 00<br>
&gt;=C2=A0 =C2=A0 =C2=A0[17755.840921] blk_update_request: I/O error, dev s=
da, sector 507906<br>
&gt;=C2=A0 =C2=A0 =C2=A0[17755.840941] EXT4-fs (dm-4): unable to read super=
block<br>
&gt;=C2=A0 =C2=A0 =C2=A0[18140.052300] sd 3:0:0:0: [sda] tag#0 FAILED Resul=
t:<br>
&gt;=C2=A0 =C2=A0 =C2=A0hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0[18140.052305] sd 3:0:0:0: [sda] tag#0 CDB: ATA com=
mand pass<br>
&gt;=C2=A0 =C2=A0 =C2=A0through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 =
00 e5 00<br>
&gt;=C2=A0 =C2=A0 =C2=A0[18142.991851] sd 3:0:0:0: [sda] tag#0 FAILED Resul=
t:<br>
&gt;=C2=A0 =C2=A0 =C2=A0hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0[18142.991856] sd 3:0:0:0: [sda] tag#0 CDB: Read(10=
) 28 00 00 07 c0<br>
&gt;=C2=A0 =C2=A0 =C2=A080 00 00 08 00<br>
&gt;=C2=A0 =C2=A0 =C2=A0[18142.991860] blk_update_request: I/O error, dev s=
da, sector 508032<br>
&gt;=C2=A0 =C2=A0 =C2=A0[18142.991869] Buffer I/O error on dev dm-4, logica=
l block 16, async<br>
&gt;=C2=A0 =C2=A0 =C2=A0page read<br>
<br>
</div></div>This points at hardware level failure, regardless if the disk w=
ould hold<br>
a btrfs or ext4 or whatever other kind of filesystem. The disk itself<br>
cannot read data back when we ask for it.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; 4.=C2=A0<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0# btrfs restore -i -D /dev/mapper/foo--vg-root /dev=
/null<br>
&gt;=C2=A0 =C2=A0 =C2=A0No valid Btrfs found on /dev/mapper/foo--vg-root<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0Could not open root, trying backup super<br>
&gt;=C2=A0 =C2=A0 =C2=A0No valid Btrfs found on /dev/mapper/foo--vg-root<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0Could not open root, trying backup super<br>
&gt;=C2=A0 =C2=A0 =C2=A0No valid Btrfs found on /dev/mapper/foo--vg-root<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0Could not open root, trying backup super<br>
&gt; <br>
&gt; We are pretty sure that no unexpected electric cuts has been happened.=
=C2=A0<br>
&gt; <br>
&gt; At this point I don&#39;t know what information I should supply.=C2=A0=
<br>
&gt; <br>
<br>
<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">-- <br>
Hans van Kranenburg<br>
</font></span></blockquote></div><br></div>

--00000000000091a4af057258538f--
