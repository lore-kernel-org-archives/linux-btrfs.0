Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42115 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbbGPH7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 03:59:20 -0400
Date: Thu, 16 Jul 2015 07:59:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Paul Harvey <csirac2@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Johannes Ernst <johannes.ernst@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
Message-ID: <20150716075917.GT10539@carfax.org.uk>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
 <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
 <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T/yvDUeUQRtJzDrt"
In-Reply-To: <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--T/yvDUeUQRtJzDrt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2015 at 01:12:03PM +1000, Paul Harvey wrote:
> On 16 July 2015 at 11:35, Chris Murphy <lists@colorremedies.com> wrote:
> > On Wed, Jul 15, 2015 at 6:11 PM, Johannes Ernst
> > <johannes.ernst@gmail.com> wrote:
> >
> >> Cleaning this all up is a bit of pain, and
> >>         btrfs subvolume delete -r dir
> >> would solve it nicely.
> 
> [snip]
> 
> > How is all of this backed up properly? How is it restored properly? I
> > think recursive snapshotting and subvolume deletion is not a good
> > idea. I think it's a complicated and inelegant work around for
> > improper subvolume organization.
> 
> I for one would love to see authoritative documentation on "proper"
> subvolume organization. I was completely lost when writing snazzer and
> have so far received very little guidance or even offers of opinions
> on this ML.

   Advice on this point has been on the btrfs wiki for several years,
at:

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_snapshots

   Hugo.

> I've had to create my own logic in my scripts that automatically walk
> all subvolumes on all filesystems for the simple reason that
> explicitly enumerating it all for dozens of servers becomes a
> significant administration burden.
> 
> I have different retention needs for /var (particularly /var/cache)
> than I do for /home, for example, so carving up my snapshots so that I
> can easily drop them from those parts of my filesystems which have a
> high churn rate (= more unique extents, occupying a lot of disk) and
> yet aren't as important (I need to retain fewer of them) is very
> useful.

-- 
Hugo Mills             | Hail and greetings. We are a flat-pack invasion
hugo@... carfax.org.uk | force from Planet Ikea. We come in pieces.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--T/yvDUeUQRtJzDrt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVp2RVAAoJEFheFHXiqx3kvycP/3urD/LTCBzNLBeC8p4NhRRr
ad+YBCXFxH746EOKm0bjFBwN0Dk3TZ6I58s/VIJYf+OcwqoKgD7PERHG8rLbMd67
qaBWhK3/iu64T9QujKoyMc2NYN55Uemsq8kbrgMH6+zkRdK0xFOsF4sohREbrNx+
BSVvxK6kxMrob7X+eBk/qmitlJJWp81LOZNXgFC8on5lVPeIHLmKcrFGmo++0aTY
GB4MHgSGe2KAjFlycalv2LZ1Xlf6Fk6G6rpgAL0BS8ckUpJ7fvP+fKv360GVLP/G
9wJUCi6L4IOw8D5R5oJ/WWAeXbYrgucBUfQZmfCbsQjqGMI2DJZe3ahf9+vpK+Ha
XwgXyDJigHRQUEpbTxbJIe5s4Znu0eiNxNu8dYV4zj01FeIb/uSL3t2PuX2k1fCs
U1wx5+38up23XzdWjm+A8pjM9mk1Qk5qPBUAGU6AIWEj3EC6BlrohF1GOA0bViNb
r1qgtrGcyasaDQt1k/NwIc7y20U5MRaUF2I/w5x6qlGskfiVmGuDC5lhfR85Q7El
guNQn+Eijj3kv3uZIxtc3d8FHa9wuiKjdZOcf1vUnuLFoOv6lyp3OolEQesFd+PO
O0e5sJ5gWXpqxNWIMBZ+RzeE/RXaDxXM/ikUzVyFJqXgD26JyynTPqh5FmaXZRJp
W77xDV0/g3YHUObYUB3g
=2ZET
-----END PGP SIGNATURE-----

--T/yvDUeUQRtJzDrt--
