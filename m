From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: labelling
Date: Wed, 10 Nov 2010 11:18:11 +0000
Message-ID: <20101110111811.GA15973@vlad.carfax.org.uk>
References: <B$bGt2my1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$bGt2my1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 10, 2010 at 08:40:00AM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> I have problems with btrfs labels.
> 
> My way:
> 
> 2-TByte-disk:
> 
>         mkfs.btrs LABEL=MM2 /dev/sdd2
> 
> worked.
> Mounting "mount LABEL=MM2 /srv/MM" worked.
> 
> Additional 1.5-TByte-Disk:
> 
>         btrfs add device /dev/sdc3 /srv/MM
>         ... balance ...
> 
> worked.
> 
>         findfs LABEL=MM2
> 
> shows "/dev/sdd2" (the first partition)
> 
>         file -s /dev/sdd2
>         file -s /dev/sdc3
> 
> shows "LABEL=MM2" for both partitions (that's not good).

   No, this is both good and correct. You've got a single filesystem
spanning multiple block devices. The *filesystem* possesses the label,
and with btrfs you can mount the filesystem using *any* of the block
devices that compose it, so both block devices should indeed show the
FS label, which is what's happening here.

> Unmounting "/srv/MM" and
> 
>         mount LABEL=MM2 /srv/MM
> 
> doesn't work now, it tries to mount /dev/sdd2 and mourns.
> 
>         mount /dev/sdd2 /srv/MM
> 
> shows the same error message,

   What's the error message? What do you get in your kernel logs when
you do this? This should work, so there's something wrong, but it's
(probably) not to do with disk labels.

>         mount /dev/sdc3 /srv/MM
> 
> (mounting the added partition) works fine, the whole space is available.
> 
> But what can I do with the 2 identical labels? How can I delete (or  
> change) the label of the first btrfs partition?

   You can't, as I explained above.

> ----------------------------
> 
> By the way:
> 
> "df" shows about 3.4 TByte usable space (2 TByte and 1.5 TByte), but
> 
>         btrfs filesystem df /srv/MM
> 
> tells
> 
>         Data: total=2.70TB, used=1.64TB
> 
> I'm missing about 0.7 TByte!

   In "btrfs filesystem df", the "total" field is the space that has
been allocated to block groups. As more space is needed on the
filesystem, the "total" field will increase to use up the additional
raw storage (if you're using RAID1 or RAID10, this will be at a ratio
of 2:1; with RAID0 or simple allocation, the ratio is 1:1).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- In event of Last Trump,  please form an orderly queue ---      
                          and await judgement.                           

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM2n9zIKyzvlFcI40RAo6QAJ9rbF5qDD0jnd5PyGeTpQ1wyIuVhwCglnP/
t0kNvw6tbuFuPSkTm9yeczA=
=NMZi
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
