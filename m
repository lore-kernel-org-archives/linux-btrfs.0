From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: btrfs and raid1 (restore)
Date: Wed, 8 Sep 2010 08:43:40 +0200
Message-ID: <20100908064340.GA3156@scooter>
References: <20100907222807.GA3546@scooter>
 <-3598551969956434661@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <-3598551969956434661@unknownmsgid>
List-ID: <linux-btrfs.vger.kernel.org>

The Questions are in my e-mail?!

=46irst of all the answers to your questions:

- All data still accessible
-
cooter ~ # btrfsck /dev/disk/by-label/home1
found 242881646593 bytes used err is 0
total csum bytes: 236710380
total tree bytes: 525582336
total fs tree bytes: 219082752
btree space waste bytes: 99723364
file data blocks allocated: 284825751552
 referenced 242200633344
Btrfs v0.19-16-g075587c-dirty

- ofc i did a balance before the mkfs, the raid was running for some we=
eks now.


My questions again in a short version:

- Is there a way to see if the 2 devices are still running in raid1 mod=
e? The 'btrfs
  filesystem show' doesn't fit to the old one (like described before) s=
o it seems
  that they are now running in a non raid1 mode.
- Is there a way to get those 2 devices running in raid1 mode again wit=
hout creating
  a new filesystem, adding the second device, copying data back etc.?


Regards,
=46elix

On 07. September 2010 - 20:46, J=E9r=F4me Poulin wrote:
> Date: Tue, 7 Sep 2010 20:46:19 -0400
> From: J=E9r=F4me Poulin <jeromepoulin@gmail.com>
> To: Felix Blanke <felixblanke@gmail.com>
> Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
> Subject: Re: btrfs and raid1 (restore)
>=20
> Now that we know the facts, what is the problem? Some simple question=
s first;
> Is the data still accessible?
> What did the rebalance do?
> Output of btrfsck/dmesg?
> mkfs.vfat does not write much on disk so if the rebalance was also
> made before the mkfs I guess most data is still present.
>=20
> Sent from my mobile device.
>=20
> On 2010-09-07, at 18:28, Felix Blanke <felixblanke@gmail.com> wrote:
>=20
> > Hi,
> >
> > I made a REALLY bad mistake today.
> >
> > I've two hdds which are running at raid1 via btrfs. Today I mistype=
d a device-node
> > and did a "mkfs.vfat" on one of them.
> >
> > Then I simply did a "btrfs filesystem balance /path/". "btrfs files=
ystem show /path/"
> > now looks like this:
> >
> > Label: 'home1'  uuid: c3c38f32-f176-4479-8c44-e832ea64639f
> >    Total devices 2 FS bytes used 226.12GB
> >    devid    2 size 465.76GB used 114.38GB path /dev/loop3
> >    devid    1 size 465.76GB used 114.39GB path /dev/loop4
> >
> >
> > Before my mistake the "FS bytes used" were all three the same, now =
the bottom two are
> > only half of the size. Am I right that those devices didnt run in r=
aid1 mode anymore?
> > :(
> >
> >
> > Is there a way, without copying back all data from my backup, to ge=
t those 2 running in
> > raid1 mode?
> > Or do I have to make a "mkfs.btrfs -m raid1 -d raid1 /dev/1", "btrf=
s device add /dev/2" and
> > "btrfs filesystem balance /path/"? :/ That would cost a lot of time=
=2E
> >
> >
> > Thanks for your help!
> >
> >
> > Regards,
> > Felix
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
