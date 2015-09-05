Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37750 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbIEKmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Sep 2015 06:42:55 -0400
Date: Sat, 5 Sep 2015 10:42:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ivan Petrovic <ivan@ipplus.rs>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount multi disk volume with recovery mode
Message-ID: <20150905104253.GD23944@carfax.org.uk>
References: <loom.20150904T230705-944@post.gmane.org>
 <20150904211738.GB23944@carfax.org.uk>
 <CAEyaVk+U5dFt79d_yd+LAujQLRsy8o7_VfPS+==uRPa_2f-oVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
In-Reply-To: <CAEyaVk+U5dFt79d_yd+LAujQLRsy8o7_VfPS+==uRPa_2f-oVg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 05, 2015 at 12:13:30PM +0200, Ivan Petrovic wrote:
> I don't know... but after btrfs-zero-log now I can't:
> 
> ivan@ipplus-dev:~$ sudo btrfs filesystem df /dev/sdb
> [sudo] password for ivan:
> ERROR: couldn't get space info - Inappropriate ioctl for device
> ERROR: get_df failed Inappropriate ioctl for device
> ivan@ipplus-dev:~$

   You can only use this command while the FS is mounted, and you
can't give it a device, only a mountpoint.

   Also, note that btrfs-zero-log won't help you at all here. It's not
a magic "fix everything for me" tool.

> So you're saying that I can't make first and third partition to work
> with it's data? Maybe I'll try with btrfs-restore, do you think it can
> rescue this 2 drives?

   Unlikely. Like I said, if the FS was using single storage for
everything, a random 33% of the filesystem has gone away. There's
probably not enough of it left to make anything coherent.

   Hugo.

> Thanks
> 
> 2015-09-04 23:17 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
> > On Fri, Sep 04, 2015 at 09:07:34PM +0000, Ivan wrote:
> >>
> >> Just to add this:
> >>
> >> ivan@ipplus-dev:~$ sudo btrfs filesystem df /mnt/ambis/
> >> Data, single: total=108.76GiB, used=107.11GiB
> >> System, single: total=32.00MiB, used=20.00KiB
> >> Metadata, single: total=3.00GiB, used=2.34GiB
> >> ivan@ipplus-dev:~$
> >
> >    (If you can't mount the FS, how did you get this output? -- In what
> > I say below, I'm asuming that this was the last output from btrfs fi
> > df on the broken filesystem before it broke).
> >
> >    This is the problem: You're using single for everything. That means
> > that with the loss of one device, approximately one part in three of
> > your filesystem is missing, including the metadata. If the missing
> > drive is truly broken, this filesystem is dead, without any good means
> > of recovery. You'll need to use your backups.
> >
> >    You would have to have RAID-1 system and metadata for the FS to be
> > even partly recoverable with a missing device. (Or RAID-10, -5 or -6).
> >
> >    Hugo.
> >

-- 
Hugo Mills             | Preventing talpidian orogenesis.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--/2994txjAzEdQwm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV6sctAAoJEFheFHXiqx3kX9sP/RUjtTPA4i5qcA6Ykm7LyOye
d7PHwJHf2/iFzxoFL2MUSHk4ccuxVaGZ2P46xD7iF6TfhfiAuNJgmwjNOc8OJIsu
ZpZF4JMypchUguVmQU209rsW0rDxjCR0KC1YL61ZdB2qkLeObKr/Gq8KYJyorqly
kEVsUxE3XI4+fCO7hoeSlIq6vmGEE6etkXvL/No/H/CRAvNFYmkzMrAPj3WkQDiJ
QHzMAfC25Mm6AtuPT7l9uGt5atrCmZR8A+wrY8NEAq77bZ+jb1vKhJgo2jz++X0g
qr+iZT4PJLYJ9VZ6hF7mthaWkoJqdU6kpwqhBDOZjaUxLVO5a3Z3cUuxS1M+7w+1
VwP4b7XK9pYBxefD5TyxcSvbLf+IQM7Rgw5Octl7uTqiOh6hL+K1WOMBUsgQPxJN
EaHxyJXjrgPZol7eGxEBlral5akX/3mmRKDqNqBmXg9WTI6DZ04VtbSeVP193OpA
I3bKM1g5D34iqnKHCPk7Yph7fNp/gQCT4fvVbLRF9oSF6iPQDyRzEdZWSP2HDUBG
T44HDKmIPxVNvoclI6wivebGPpOoJPS3Q+jpmTBfVOaIL32ogxSrirpRuM7O+ib9
y1ZGY3tCkHpZru9BELnGBrs9ofLcnu5YPGJGyzhwkeOGWhYCHUhenDFUVNpe1N4I
t1K+cMcdNEtP9EXNKLCV
=Qb6o
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--
