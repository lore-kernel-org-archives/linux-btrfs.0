Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54446 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdGYVp3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 17:45:29 -0400
Date: Tue, 25 Jul 2017 21:45:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: waxhead <waxhead@dirtcellar.net>
Cc: =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170725214505.GP7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk>
 <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
 <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2DT8m24oj8Onh3Jp"
In-Reply-To: <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2DT8m24oj8Onh3Jp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2017 at 11:29:13PM +0200, waxhead wrote:
> 
> 
> Hugo Mills wrote:
> >
> >>>    You can see about the disk usage in different scenarios with the
> >>>online tool at:
> >>>
> >>>http://carfax.org.uk/btrfs-usage/
> >>>
> >>>    Hugo.
> >>>
> As a side note, have you ever considered making this online tool
> (that should never go away just for the record) part of btrfs-progs
> e.g. a proper tool? I use it quite often (at least several timers
> per. month) and I would love for this to be a visual tool
> 'btrfs-space-calculator' would be a great name for it I think.
> 
> Imagine how nice it would be to run....
> 
> btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1
> /dev/sdc2 /dev/sdd2 /dev/sde3 for example and instantly get
> something similar to my example below (no accuracy intended)

   It's certainly a thought. I've already got the algorithm written
up. I'd have to resurrect my C skills, though, and it's a long way
down my list of things to do. :/

   Also on the subject of this tool, I'd like to make it so that the
parameters get set in the URL, so that people can copy-paste the URL
of the settings they've got into IRC for discussion. However, that
would involve doing more JavaScript, which is possibly even lower down
my list of things to do than starting doing C again...

   Hugo.

> d=data
> m=metadata
> .=unusable
> 
> {  500mb} [|ddddd|] /dev/sda1
> { 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mm...|] /dev/sdb1
> { 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmm..|] /dev/sdc2
> { 5000mb}
> [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|]
> /dev/sdb1
> --------
> {11500mb} Total space
> 
> usable for data (raid10): 1000mb / 2000mb
> usable for metadata (raid1): 4500mb / 9000mb
> unusable: 500mb
> 
> Of course this would have to change one (if ever) subvolumes can
> have different raid levels etc, but I would have loved using
> something like this instead of jumping around carfax abbey (!) at
> night.

   The core algorithm for the tool actually works pretty well for
dealing with different RAID levels, as long as you know how much of
each kind of data you're going to be using. (Although it's actually
path-dependent -- write 100 GB of RAID-0 then 100 GB of RAID-1 can
have different results than if you write them in the opposite order --
but that's a kind of edge effect).

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 4:
hugo@... carfax.org.uk | Future Perfect
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--2DT8m24oj8Onh3Jp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZd7vhAAoJEFheFHXiqx3kc64QAJjbVgoxZTPWvWlBq8Fbvo9F
YW9iX24gcypkBNCA/OZtAMbVw7LBzf7tQNhg4h4ffpNmQcCamxuvWjRuQyVdDiJN
3gCFlzC3qTQxVBK31yj5IFYjtlo3t7NlXWlse2imX+Hw09mqqS2SwLMjK6X9i316
rl8NrKXSgRO/0+fKscCNrxM7wdA38+BU0Cq4oeA9ki7Qp6mOBEWlvqmwyQvCNYtS
po3b8Eb3lbIDjprJZ7qbRT392Yhfcf5SZRtd2HfxTsZ01XGBNjSqhoLrK6nv1Kr/
ykNvKShsmSAbSF2MBVlcT4Rsaoz7tK7gbnCfoHuOVjUCck/NBwIWgtBjG/7i2Kou
R+G2B2+mBDHd6K7ONp2TkL8kUlbI0m2+ylY68oBWScIAgq+P8mevOc5V0E6tFyW1
7Wud2C6owI8dBsm91BiUQhB92Q8cMVKpZM4ZySRIJEVO2YmuJGsPwiSfk51XYuTg
ufjaA5ei4YCKP0+f4pVsEQmmDl+HPTq+hIEgIlfap4OgkpD8XocB/m3zEi08n1gO
clt44wqn5eaT7xBzcnPPx9vNfmd4UhsxHdW9kDRZ+6mOcdn6+9zefmW40kpCP3PL
1A3HY7OYVcOWZwRlnn2G0mEanEah+SNZSa5o/YX9P3l7c9y+wu9mPzHY7lzT6PkK
vQMxX3rqf52mlgcb4YC/
=Zar8
-----END PGP SIGNATURE-----

--2DT8m24oj8Onh3Jp--
