Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57764 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdGZXIO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 19:08:14 -0400
Date: Wed, 26 Jul 2017 23:07:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: waxhead <waxhead@dirtcellar.net>,
        =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170726230751.GS7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk>
 <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
 <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
 <20170725214505.GP7140@carfax.org.uk>
 <3ae7c0e5-ce84-cbc7-9e68-9e4df9aa4f18@gmail.com>
 <20170726122720.GQ7140@carfax.org.uk>
 <c9ec498e-05b3-7120-8042-f423fca0de92@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BoUn3CGrEP/1RgSh"
In-Reply-To: <c9ec498e-05b3-7120-8042-f423fca0de92@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BoUn3CGrEP/1RgSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 26, 2017 at 08:36:54AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-07-26 08:27, Hugo Mills wrote:
> >On Wed, Jul 26, 2017 at 08:12:19AM -0400, Austin S. Hemmelgarn wrote:
> >>On 2017-07-25 17:45, Hugo Mills wrote:
> >>>On Tue, Jul 25, 2017 at 11:29:13PM +0200, waxhead wrote:
> >>>>
> >>>>
> >>>>Hugo Mills wrote:
> >>>>>
> >>>>>>>    You can see about the disk usage in different scenarios with the
> >>>>>>>online tool at:
> >>>>>>>
> >>>>>>>http://carfax.org.uk/btrfs-usage/
> >>>>>>>
> >>>>>>>    Hugo.
> >>>>>>>
> >>>>As a side note, have you ever considered making this online tool
> >>>>(that should never go away just for the record) part of btrfs-progs
> >>>>e.g. a proper tool? I use it quite often (at least several timers
> >>>>per. month) and I would love for this to be a visual tool
> >>>>'btrfs-space-calculator' would be a great name for it I think.
> >>>>
> >>>>Imagine how nice it would be to run....
> >>>>
> >>>>btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1
> >>>>/dev/sdc2 /dev/sdd2 /dev/sde3 for example and instantly get
> >>>>something similar to my example below (no accuracy intended)
> >>>
> >>>    It's certainly a thought. I've already got the algorithm written
> >>>up. I'd have to resurrect my C skills, though, and it's a long way
> >>>down my list of things to do. :/
> >>>
> >>>    Also on the subject of this tool, I'd like to make it so that the
> >>>parameters get set in the URL, so that people can copy-paste the URL
> >>>of the settings they've got into IRC for discussion. However, that
> >>>would involve doing more JavaScript, which is possibly even lower down
> >>>my list of things to do than starting doing C again...
> >
> >>Is the core logic posted somewhere?  Because if I have some time, I
> >>might write up a quick Python script to do this locally (it may not
> >>be as tightly integrated with the regular tools, but I can count on
> >>half a hand how many distros don't include Python by default).
> >
> >    If it's going to be done in python, I might as well do it myself --
> >I can do python with my eyes closed. It's just C and JS I'm rusty with.
> Same here ironically :)
> >
> >    There is a write-up of the usable-space algorithm somewhere. I
> >wrote it up in detail (with pseudocode) in a mail on this list. I've
> >also got several pages of LaTeX somewhere where I tried and failed to
> >prove the correctness of the formula. I'll see if I can dig them out
> >this evening.
> It looks like the Message-ID for the one on the mailing list is
> <20160311221703.GJ17196@carfax.org.uk>
> I had forgotten that I'd archived that with the intent of actually
> doing something with it eventually...

   Here's the write-up of my attempted proof of the optimality of the
current allocator algorithm:

http://carfax.org.uk/files/temp/btrfs-allocator-draft.pdf

   Section 1 is a general (allocator-agnostic) description of the
process. Section 2 finds a bound on how well _any_ allocator can
do. That's the formula (eq 9) used in the online btrfs-usage
tool. Section 3 described the current allocator. Section 4 is a failed
attempt at proving that the algorithm achieves the bound from section
2. I wasn't able to complete the proof.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Interview with the Umpire
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BoUn3CGrEP/1RgSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZeSDHAAoJEFheFHXiqx3kxbkQALL0pZi2+/oyVEpWdEUbHwj4
wXaZJt2Q3jaqeznynePBMYjU2uMPBhiaUgnP3zmhoRGV/Tyo/6GqKA5b6l9QCI06
LxHRHbpXRoBtV8dAOn/dFYpFJMpy7zF0TkCGsnlREfr4hSwfKDc4kTXTpRafSDAP
zrKRB5pFnr8+v6ZLS5Pss8Rw/yEa5WgZlj2g70Petx8Ii0eF3NuC8WvjO5w4DADd
qS1mBey9YqEuf/5TupC+a20Yb8LLZriNDQuoD19uEi1byYJZHcLOKSrF9aS9sqL/
oVcNrx7kI4+GmBIX4H9GkK2r/l8A7sKgoaIyroqs8q2IraC7tIP6JIro+PS5PYQS
4F+FGPk2DMcUhVCpeVgssEFtghrGrS3pU7lxtE2lrMUiWfepLM92HMMWWswzT/8j
8BC6jKDdKy80ZgpnR3m5AuaQ3XEmSzkVtQKY8v7IL3HBdSGqXz8e8Q8Pix0hZKz7
v2Wj//+O5KQDcIIPdt02zujuBZMTEdYKM8NhIpJbesG20foHZm6Lf4QGvJw4amB0
7daY6727qpdPNon8SHHfCecXKFjVFWfA0py6gVY5n6uXGnCb/7V/3flUia3pQ5KC
lINWTW8+VqS043wCByrMknzMm2Xmw3icLTS0KhhHxzG44LRiA5Ypo7J34LIc4ChR
WU/hcRi0IMTRZlXX/Ry0
=ieg9
-----END PGP SIGNATURE-----

--BoUn3CGrEP/1RgSh--
