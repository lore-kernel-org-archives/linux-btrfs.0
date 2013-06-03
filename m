Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40023 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab3FCMNP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 08:13:15 -0400
Date: Mon, 3 Jun 2013 13:13:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Papp Tamas <tompos@martos.bme.hu>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
Message-ID: <20130603121308.GK20133@carfax.org.uk>
References: <51A73532.6060900@martos.bme.hu>
 <20130530123235.GA9829@localhost.localdomain>
 <51A74C5E.4030201@giantdisaster.de>
 <51AC845A.6000600@martos.bme.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTLCc13+3hfAZ6SL"
In-Reply-To: <51AC845A.6000600@martos.bme.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HTLCc13+3hfAZ6SL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2013 at 01:56:10PM +0200, Papp Tamas wrote:
> On 05/30/2013 02:55 PM, Stefan Behrens wrote:
> >
> >On Thu, 30 May 2013 08:32:35 -0400, Josef Bacik wrote:
> >>On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
> >>>hi All,
> >>>
> >>>I'm new on the list.
> >>>
> >>>System:
> >>>Distributor ID:	Ubuntu
> >>>Description:	Ubuntu 13.04
> >>>Release:	13.04
> >>>Codename:	raring
> >>>
> >>>Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> >>>
> >>>The symptom is the same with Saucy 3.9 kernel.
> >>
> >>Can you try btrfs-next
> >>
> >>git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> >>
> >>if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
> >>the component is set to btrfs.  Thanks,
> >
> >Papp is using an Intel X18-M/X25-M/X25-V G2 SSD. At least with an Intel
> >X25 SSD that identifies itself with "INTEL SSDSA2M080" and on one with
> >the ID "INTEL SSDSA2M040", I've tested whether they honor the flush
> >request. And these two SSDs don't do so, they ignore it. If you cut the
> >power after a flush request completes, the data that was written before
> >the flush request is gone, the write cache was _not_ flushed.
> >
> >You can only disable the write cache during/after every boot "hdparm -W
> >0 /dev/sd..." (which reduces the SSDs write speed to about 4 MB/s), or
> >avoid such SSDs, or prepare to restore from backup occasionally.
> 
> Basically it means it's not safe to use this SSD?

   Correct.

> I used it for 2 years with ext4 without any issue, before I switched
> to btrfs (on the root partition). In the meantime btrfs also was
> quite stable on my /data partition.
> 
> After I reinstalled thr system with btrfs, this issue happened two times.
> But anyway, I thought cow should be able to handle these kind of issues by design. Am I wrong?

   CoW writes out everything that's going to be changed first, and
finally writes one piece of data which points to the new version of
the data. *Provided* you can guarantee that the final piece of data
(the superblock) gets written only after everything else has made it
to permanent storage, then everything is good.

   However, most hardware (and most operating systems) reorder the
data which is being sent to the disk, for performance reasons. This is
fine, as long as you can enforce the dependency in some way -- this is
what barriers/flushes do: they say "ensure that all of this is fully
written out to real permanent storage before you try to write the
superblock".

   If the hardware ignores flushes or barriers, there's no mechanism
for ensuring that the data is fully consistent, because you may find
that the superblock gets reordered to be written before some of the
other writes to the device. If that happens and then the power gets
cut before the rest of the data can be written, you have a corrupt
filesystem.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- In theory, theory and practice are the same. In ---         
                      practice,  they're different.                      

--HTLCc13+3hfAZ6SL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUayIVFheFHXiqx3kAQJ2hxAAt0QFztNZuqFlFstDh+SfmfVB9/rM/TlV
3fi+2wFOe4di7lL6cBnEw5BwZdL/zpEMKyPzVYP5bjypFDoGD4atG0PhCGhydDCs
644ZyMvWYf/VBTAQJIfHKjnoTBQKnH7TjDD5gbTKJ92DZMK6AtDmy2bP59KTbeA1
sQPR50MtVrlmJUhBDGw8XDZSu0/rYW5jzIBpbYnkdzcWKAmFlsmpEOvtpQindkge
Vp0+AuPBYs/zOGM0a52W/AWwpK/guG7eoCl+ljIXKya5AYuCXBZVqOKh2ZSe1Xcw
HSLcTbP30A3OfKJfPyGe9t8Izoi53zHXGIdnu9t26G1n6ah5SSFZNkEB3dA0LFJd
igiuGbjWxgK39gsUTz/eGJF+ysLM0wWAGyAhoRsogXQtunjTBukcEkavzV7/uwPB
txBtD/V0s44d7u5hNADLfMFyes214KSbbShywgywEqAWLvXbTQpuF8NbE5nnrruc
Xh1yrQ52045CE89/ttHREZ6KBcFVbngZsj0DoJeajUvs6T1ZvMy2upajH9/gx5zL
cIlwy9FbpkNFxFQvGDmFTTsYrFzMzbOJeBQPCg6z/T631OB/sqOCZzxyRvNfKAHK
WhtrZ3CDVG+DyB2ifIWGMQzICTQuPRQ5LZdCRvCWDqMaRsAPEK+z1YXRi4K3dxig
nfoz4xhj4ew=
=b8g7
-----END PGP SIGNATURE-----

--HTLCc13+3hfAZ6SL--
