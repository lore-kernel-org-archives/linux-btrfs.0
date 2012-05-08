From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 14:52:56 +0100
Message-ID: <20120508135256.GL8938@carfax.org.uk>
References: <C8TFFEueCXB@helmut.hullen.de>
 <4FA9232C.4020308@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFUYW7mPOLJ+Jd2A"
Cc: helmut@hullen.de, Helmut Hullen <Hullen@t-online.de>,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA9232C.4020308@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--bFUYW7mPOLJ+Jd2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 03:44:12PM +0200, Felix Blanke wrote:
> On 5/8/12 3:13 PM, Helmut Hullen wrote:
> >Hallo, Clemens,
> >
> >Du meintest am 08.05.12:
> >
> >>>>But where's the gain? If a disk fails I have a lot of tools for
> >>>>repairing an ext2/3/4 system.
> >
> >>Nope, when a disk in your ext4 raid0 array fails, you are just as
> >>doomed.
> >
> >Why should I use RAID0 with a bundle of ext2/3/4? Mounting on/in the
> >directory tree does the job.
> 
> Nobody told you that you should do it. What EVERYBODY here is
> telling you: The problem you have right now would be the same damn
> problem, no matter what fs you would you. Every fs will be unusable
> if you lose one disk in a raid0 setup. That's all what we are trying
> to tell you for the last 15 mails :)

   I think he's got the point by now. Can we stop this thread now,
please? It doesn't seem to be serving any further purpose.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- No names... I want to remain anomalous. ---             

--bFUYW7mPOLJ+Jd2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqSU4IKyzvlFcI40RAlGrAJ4u3O1892Zir49w1A+gnV+FIGtGsQCePe5N
PmQLSxztQ52T27FeqlmJZMY=
=yAPc
-----END PGP SIGNATURE-----

--bFUYW7mPOLJ+Jd2A--
