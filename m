Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34477 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3IZO6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 10:58:30 -0400
Date: Thu, 26 Sep 2013 15:58:29 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: miaou sami <miaousami@hotmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [raidX vs single/dup]
Message-ID: <20130926145829.GC2865@carfax.org.uk>
References: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>
 <20130926123233.GA2865@carfax.org.uk>
 <DUB116-W515338D8267F1A703A1452A6280@phx.gbl>
 <20130926134605.GB2865@carfax.org.uk>
 <DUB116-W52A10619B6D4BEC0FA9DD9A6280@phx.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
In-Reply-To: <DUB116-W52A10619B6D4BEC0FA9DD9A6280@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 02:55:38PM +0000, miaou sami wrote:
> OK, that's clear.
> Nice space simulator btw :-) you should add a link somewhere in btrfs wiki...

   There is one, linked from the first line of the relevant section in
the FAQ.

   Hugo.

> Thanks
> ----------------------------------------
> > Date: Thu, 26 Sep 2013 14:46:05 +0100
> > From: hugo@carfax.org.uk
> > To: miaousami@hotmail.com
> > CC: linux-btrfs@vger.kernel.org
> > Subject: Re: [raidX vs single/dup]
> >
> > On Thu, Sep 26, 2013 at 01:40:57PM +0000, miaou sami wrote:
> >> Thank you, it is quite clear now.
> >>
> >>
> >> I guess that on multi device, raid0 vs single would be a matter of performance vs ease of low level hardware data recovery.
> >>
> >>
> >> The wiki https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices says:
> >> "When you have drives with differing sizes and want to use the full capacity of each drive, you have to use the single profile for the data blocks."
> >> Let's assume the following configuration: 1x10GB disk and 2x5GB disks
> >> --> Does it mean I cannot use the full capacity AND have a duplication of my data in the configuration above? (full capacity would be 10GB here)
> >
> > No, that will give you the full usable space. A 20 GB drive and two
> > 5 GB drives would not, though.
> >
> >> --> If I try to setup either -d raid1 or -d dup on that
> >> configuration, what will I get?
> >
> > Try it for yourself in the space simulator:
> >
> > http://carfax.org.uk/btrfs-usage/
> >
> >> --> Is there any behavior difference between raid1 / dup in that case?
> >
> > If you have multiple disks, I think DUP gets automatically upgraded
> > to RAID-1 (i.e. the "different copies on different devices"
> > requirement is enforced). So, no.
> >
> >> --> Can raid1 ensure that data are always duplicated on different devices AND take advantage of all available space?
> >
> > Depends on the relative sizes of the devices. If your largest
> > device is bigger than the rest put together, then you'll lose some
> > space.
> >
> > Hugo.
> >
> >> Regards,
> >> Sam
> >>
> >>
> >> ----------------------------------------
> >>> Date: Thu, 26 Sep 2013 13:32:33 +0100
> >>> From: hugo@carfax.org.uk
> >>> To: miaousami@hotmail.com
> >>> CC: linux-btrfs@vger.kernel.org
> >>> Subject: Re: [raidX vs single/dup]
> >>>
> >>> On Thu, Sep 26, 2013 at 12:22:49PM +0000, miaou sami wrote:
> >>>> Hi btrfs guys,
> >>>>
> >>>> could someone explain to me the differences in mkfs.btrfs:
> >>>>
> >>>> - between -d raid0 and -d single
> >>>
> >>> In RAID0, data is striped across all the devices, so the first 64k
> >>> of a file will go on device 1, the next 64k will go on device 2, and
> >>> so on. With single, files are allocated linearly on one device.
> >>>
> >>> (This is assuming smallish files, a filesystem with lots of space.
> >>> Even with single, files can still end up being scattered around over
> >>> multiple devices -- but with RAID0, even non-fragmented files are
> >>> striped)
> >>>
> >>>> - between -m raid1 and -m dup
> >>>
> >>> In both cases, there are two copies of each metadata block. With
> >>> RAID1, it *requires* the two copies to live on different devices. With
> >>> DUP, it allows the two copies to live on the same device (e.g. if
> >>> there's only one device).
> >>>
> >>>> - between -m raid0 and -m single
> >>>
> >>> As for -draid0 and -dsingle, but for metadata instead of data.
> >>>
> >>>> My understanding is that raidX should be used in case of multi
> >>>> devices and single/dup should be used in case of single device to
> >>>> allow duplication, but it is not 100% clear to me...
> >>>
> >>>> As btrfs raid concepts are quite different from traditionnal raid,
> >>>> shouldn't we use the words "stripped" and "mirrored" instead of
> >>>> raid0/raid1? or even "single" and "duplicated"?
> >>>> Then there would be no difference between single/raid0 and
> >>>> duplicated/raid1...
> >>>
> >>> But there _are_ differences between them, as explained above. :)
> >>>
> >>> I posted a patch a while ago to change the names to something more
> >>> logical and expressive, but it didn't get merged.
> >>>
> >>> Hugo.
> >>>
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The trouble with you, Ibid, is you think you know everything. ---  
                                                                         

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkRLlFheFHXiqx3kAQLUFg//af/1A1rzHYYR07B+kUdzVQufMTNTalCR
4Mg1CR6k998IZcJrC7t4gXiI2U84kpb+NkQkuAhC9bE29WEQ2ELxJg4OjOd48pnD
uX9wAjS9LmRgS70E8aT3P2xw05n5sUKxy5hzr9pPg5ZZ4u6u6y2vZGxx7sjv0KE/
D6n4/DzZjNSKNv2PTg+LepUhlOqJszOWWAKNwjwwtMfvKIJBjIv++klms0bi22l4
eXCb3Kv9GGIdJV9HWv3d1+tIfzaHSyX368hWUoVGyKt9q4Tu/v/A7fnHzk8pA01P
v+HOn4TCcrNRfQir0nM8NhXmqytWKiIPvbwIhGlFcjX2ZXfOcWm3xnT6tyVuMxZo
G1zoHZJcv37ohHB0/f1/jFphZ1sg+mFr7B3j5q0DRZXXhrHa9amjVYOWjDirLEUM
v5+8Z7fA91uw1BmgRQjtRJISrIMr9ZTbco/O4GSul/RFyiV/dxuJIVRc8aEPf2Pq
wGrVvidfa9nNSOr3YN2+JHjn0gD91RLIoq9nEv+8oXswkmEilZe284hyzpQinsvM
eJKFh2f3dS3uvsf4BaLGIt4LzFTWFslU4CXeryDSy2YPb1TabAOgPyEyD7Gx+heF
yL6p+40as4+p809hz+SxvM8qu5TKeomHVor6miDT6rPkvNeNp6H7qxlgtYm4Bal3
Rc6cJI8k8n8=
=nsnH
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
