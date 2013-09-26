Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33779 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IZNqi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 09:46:38 -0400
Date: Thu, 26 Sep 2013 14:46:05 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: miaou sami <miaousami@hotmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [raidX vs single/dup]
Message-ID: <20130926134605.GB2865@carfax.org.uk>
References: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>
 <20130926123233.GA2865@carfax.org.uk>
 <DUB116-W515338D8267F1A703A1452A6280@phx.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
In-Reply-To: <DUB116-W515338D8267F1A703A1452A6280@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 01:40:57PM +0000, miaou sami wrote:
> Thank you, it is quite clear now.
> 
> 
> I guess that on multi device, raid0 vs single would be a matter of performance vs ease of low level hardware data recovery.
> 
> 
> The wiki https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices says:
> "When you have drives with differing sizes and want to use the full capacity of each drive, you have to use the single profile for the data blocks."
> Let's assume the following configuration: 1x10GB disk and 2x5GB disks
> --> Does it mean I cannot use the full capacity AND have a duplication of my data in the configuration above? (full capacity would be 10GB here)

   No, that will give you the full usable space. A 20 GB drive and two
5 GB drives would not, though.

> --> If I try to setup either -d raid1 or -d dup on that
>     configuration, what will I get?

   Try it for yourself in the space simulator:

http://carfax.org.uk/btrfs-usage/

> --> Is there any behavior difference between raid1 / dup in that case?

   If you have multiple disks, I think DUP gets automatically upgraded
to RAID-1 (i.e. the "different copies on different devices"
requirement is enforced). So, no.

> --> Can raid1 ensure that data are always duplicated on different devices AND take advantage of all available space?

   Depends on the relative sizes of the devices. If your largest
device is bigger than the rest put together, then you'll lose some
space.

   Hugo.

> Regards,
> Sam
> 
> 
> ----------------------------------------
> > Date: Thu, 26 Sep 2013 13:32:33 +0100
> > From: hugo@carfax.org.uk
> > To: miaousami@hotmail.com
> > CC: linux-btrfs@vger.kernel.org
> > Subject: Re: [raidX vs single/dup]
> >
> > On Thu, Sep 26, 2013 at 12:22:49PM +0000, miaou sami wrote:
> >> Hi btrfs guys,
> >>
> >> could someone explain to me the differences in mkfs.btrfs:
> >>
> >> - between -d raid0 and -d single
> >
> > In RAID0, data is striped across all the devices, so the first 64k
> > of a file will go on device 1, the next 64k will go on device 2, and
> > so on. With single, files are allocated linearly on one device.
> >
> > (This is assuming smallish files, a filesystem with lots of space.
> > Even with single, files can still end up being scattered around over
> > multiple devices -- but with RAID0, even non-fragmented files are
> > striped)
> >
> >> - between -m raid1 and -m dup
> >
> > In both cases, there are two copies of each metadata block. With
> > RAID1, it *requires* the two copies to live on different devices. With
> > DUP, it allows the two copies to live on the same device (e.g. if
> > there's only one device).
> >
> >> - between -m raid0 and -m single
> >
> > As for -draid0 and -dsingle, but for metadata instead of data.
> >
> >> My understanding is that raidX should be used in case of multi
> >> devices and single/dup should be used in case of single device to
> >> allow duplication, but it is not 100% clear to me...
> >
> >> As btrfs raid concepts are quite different from traditionnal raid,
> >> shouldn't we use the words "stripped" and "mirrored" instead of
> >> raid0/raid1? or even "single" and "duplicated"?
> >> Then there would be no difference between single/raid0 and
> >> duplicated/raid1...
> >
> > But there _are_ differences between them, as explained above. :)
> >
> > I posted a patch a while ago to change the names to something more
> > logical and expressive, but it didn't get merged.
> >
> > Hugo.
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkQ6nFheFHXiqx3kAQIs8Q//bK9LQCnXKWGGJTdvfkKdNHSfgiWoPOrw
0slcZQjZdoclyHTZwMzuzaXD7B11AJDzFjsctHmrp7rZZmSzi3QD+Gmy/QAWvVMz
eZeRa5+a1Ci4hOUTzWs8PVnKaoL06frBs6qfPI7SZG4uvj3Etm1y4zIEJkP5MEs4
yNvL5lTMv7HxJYxOwHxqknce5SaAM03ZoBPQNbGH6R8rNNzByvPLNbXzFpeMcwPL
lCHqKcf4bpuPEyPfdBBOFcaFfB6pMZZUk6crEy/edMYLok/wdl+/+zjdv8UUfCQa
dVLV74fKEBlfriY0eg1huUWIyTQVmgbls7vjoKr316AA4z/wfWnDgEbCTPtArTPy
Td/y5u5qz3EJ9Ng3hDS0a3mrr+K9qanWB2f7Bzjow5Cd0PtjBb9zPQZTt3exEII3
RrXEzw7Uru25PIZtie94nBkVpUElibDK31zsGUBlt5xjMWe4C3xrPIrMHE6nrr6v
NDwXhdSq0/IfxoQ5xdgpcY4Z1X+rmfoEGfRly6Sa35B/uUjWNmgGeMSTNQxS3x3Z
xwINJg4NBwoIxtxgplugjzssqdXCe1vMHxXwGl5brojYmId1014AJKPR6umI+3Vi
nCpVfp5kqd0ndriwOhBHRogr3msm94zFwWKh2lLm5+GB83jgi3dyAribLSgCl9eA
PDP9tCb0gYI=
=jKpx
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
