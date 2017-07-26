Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56092 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdGZM1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:27:46 -0400
Date: Wed, 26 Jul 2017 12:27:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: waxhead <waxhead@dirtcellar.net>,
        =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170726122720.GQ7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk>
 <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
 <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
 <20170725214505.GP7140@carfax.org.uk>
 <3ae7c0e5-ce84-cbc7-9e68-9e4df9aa4f18@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p5BJhDJf0owydRUK"
In-Reply-To: <3ae7c0e5-ce84-cbc7-9e68-9e4df9aa4f18@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p5BJhDJf0owydRUK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 26, 2017 at 08:12:19AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-07-25 17:45, Hugo Mills wrote:
> >On Tue, Jul 25, 2017 at 11:29:13PM +0200, waxhead wrote:
> >>
> >>
> >>Hugo Mills wrote:
> >>>
> >>>>>    You can see about the disk usage in different scenarios with the
> >>>>>online tool at:
> >>>>>
> >>>>>http://carfax.org.uk/btrfs-usage/
> >>>>>
> >>>>>    Hugo.
> >>>>>
> >>As a side note, have you ever considered making this online tool
> >>(that should never go away just for the record) part of btrfs-progs
> >>e.g. a proper tool? I use it quite often (at least several timers
> >>per. month) and I would love for this to be a visual tool
> >>'btrfs-space-calculator' would be a great name for it I think.
> >>
> >>Imagine how nice it would be to run....
> >>
> >>btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1
> >>/dev/sdc2 /dev/sdd2 /dev/sde3 for example and instantly get
> >>something similar to my example below (no accuracy intended)
> >
> >    It's certainly a thought. I've already got the algorithm written
> >up. I'd have to resurrect my C skills, though, and it's a long way
> >down my list of things to do. :/
> >
> >    Also on the subject of this tool, I'd like to make it so that the
> >parameters get set in the URL, so that people can copy-paste the URL
> >of the settings they've got into IRC for discussion. However, that
> >would involve doing more JavaScript, which is possibly even lower down
> >my list of things to do than starting doing C again...

> Is the core logic posted somewhere?  Because if I have some time, I
> might write up a quick Python script to do this locally (it may not
> be as tightly integrated with the regular tools, but I can count on
> half a hand how many distros don't include Python by default).

   If it's going to be done in python, I might as well do it myself --
I can do python with my eyes closed. It's just C and JS I'm rusty with.

   There is a write-up of the usable-space algorithm somewhere. I
wrote it up in detail (with pseudocode) in a mail on this list. I've
also got several pages of LaTeX somewhere where I tried and failed to
prove the correctness of the formula. I'll see if I can dig them out
this evening.

   Hugo.

-- 
Hugo Mills             | How do you become King? You stand in the marketplace
hugo@... carfax.org.uk | and announce you're going to tax everyone. If you
http://carfax.org.uk/  | get out alive, you're King.
PGP: E2AB1DE4          |                                        Harry Harrison

--p5BJhDJf0owydRUK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZeIqnAAoJEFheFHXiqx3kxw8P/2MRNuP0RYfdrS7qnK/ldNRq
q1lqMDGrRZWfJN9g9bQT5Y1ZOPg16qkUOT+rm9r7FvD7s26ZyAmsQiLXBtjCF0Wg
0hkXeAe60f+llT345Z53tdq93lphRUSsvSsBIKH9pIs5vj09241Fg5yvO0LhDPi9
9mLtOixQ8QwrFscAP33QMvxTrAbMyPugm/SKisM+CIu9QUpMzJh+tcV+tN6PsA8t
lZElfZtpfTeWKB8j2oKbAriXPJLdtuTCtPoK2pIB1Wj/1Etvsul5x1is+nT1JTKE
zMjZhOzZJUFjoFQ/ZE71hQ+IT6BXEHofeQIzhwiCu95eH8AI7JIlpjzb1sOQMMq+
sSQ+7KtGNBjaDh+hKT/Ns2aqxqJ55sWm5mBK+c+PJD2y7dwmotUuGbI7L8iOb0B+
xtKVyrM7HwQNl+d+byr2yzADuWalKeHvVm+E0geQxbQujUfR3GAgYCQ0Hz29R9IO
G6cWWRLS4UAOmY9nzqO0lvN7kCUrN+uoWlbF3tIL71AQpBGyLrQSbykbloetnmo8
51nF1Dugpc3uqv7rjnEcxzEn1Rx58ZKXMuqBiGb/Pw68C7Zm6P7+h3NzP9n+GOyk
3+PATke49ckPSBEgRlZunjbMXILbpqPzotxKs4QMy+ta8C0yH2W4xzmzGuPDSHTa
Gxp4Z2oS8mc6WD7QSjUQ
=g/fO
-----END PGP SIGNATURE-----

--p5BJhDJf0owydRUK--
