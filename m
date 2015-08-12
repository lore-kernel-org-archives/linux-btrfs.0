Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58728 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463AbbHLHbH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 03:31:07 -0400
Date: Wed, 12 Aug 2015 07:31:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tristan Zajonc <tristan@sense.io>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scaling to 100k+ snapshots/subvolumes
Message-ID: <20150812073104.GL12976@carfax.org.uk>
References: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FYef6pHvFBuPZp1D"
In-Reply-To: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FYef6pHvFBuPZp1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 11, 2015 at 11:33:45AM -0700, Tristan Zajonc wrote:
> In an early thread Duncan mentioned that btrfs does not scale well in
> the number of subvolumes (including snapshots).  He recommended
> keeping the total number under 1000.  I just wanted to understand this
> limitation further.  Is this something that has been resolved or will
> be resolved in the future or is it something inherent to the design of
> btrfs?

   We've already discussed this on IRC yesterday, but I was reminded
this morning of one specific instance of poor scalability with lots of
snapshots, which is that balancing metadata scales poorly as the
number of copies of the same data increases. (So it's OK to have lots
of unrelated subvolumes, but many subvolumes that are snapshots of the
same thing would br problematic).

   I don't know what the exact scaling is, but it's superlinear, and
may be as bad as O(n^2).

> We have an application that could easily generate 100k-1M snapshots
> and 10s of thousands of subvolumes.  We use snapshots to track very
> fine-grained filesystem histories and subvolumes to enforce quotas
> across a large number of distinct projects.

   1e4 subvolumes and 1e6 snapshots will probably be OK, although
slow, when balancing. That's only 100 snapshots per subvolume, and
I've got that kind of scale here on my home machine -- it's very slow
(takes a couple of hours for some of the metadata chunks), but it's
not unusable.

   Hugo.

> Thanks,
> Tristan
> 
> Duncan >
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/43910
> 
> The question of number of subvolumes normally occurs in the context of
> snapshots, since snapshots are a special kind of subvolume.  Ideally,
> you'll want to keep the total number of subvolumes (including snapshots)
> to under 1000, with the number of snapshots of any single subvolume
> limited to 250-ish (say under 300).  However, even just four subvolumes
> being snapshotted to this level will reach the thousand, and 2000-3000
> total isn't /too/ bad as long as it's no more than 250-300 snapshots per
> subvolume.  But DEFINITELY try to keep it under 3000, and preferably
> under 2000, as the scaling really does start to go badly as the number of
> subvolumes increases beyond that.  If you're dealing with 10k subvolumes/
> snapshots, that's too many and you ARE likely to find yourself with
> problems.
> 
> (With something like snapper, configuring it for say half-hour or hourly
> snapshots at the shortest time, with twice-daily or daily being more
> reasonable in many circumstances, and then thinning it down to say daily
> after a few days and weekly after four weeks, goes quite a long way
> toward reducing the number of snapshots per subvolume.  Keeping it near
> 250-ish per subvolume is WELL within reason, and considering that a month
> or a year out, you're not likely to /care/ whether it's this hour or
> that, just pick a day or a week and if it's not what you want, go back or
> forward a day or a week, is actually likely to be more practical than
> having hundreds of half-hourly snapshots a year old to choose from.  And
> 250-ish snapshots per subvolume really does turn out to be VERY
> reasonable, provided you're doing reasonable thinning.)

-- 
Hugo Mills             | Some days, it's just not worth gnawing through the
hugo@... carfax.org.uk | straps
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FYef6pHvFBuPZp1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVyvY4AAoJEFheFHXiqx3kOjUP/28xjG3E5mtB14shBycFumxu
wZYWyp//yNoJRHdolF1qYCzdbDiA0rv3KYmjtH6XA68868SY7O0vRFjaJopxMwTS
M3FxW1KM70jAY1tBGuFefNzZHLWUQYPSigfXJjy0XWxI1JU7pFNF01M5s/9E940s
A59zcdCAQSeU99RAzkZQITU6FndQenPiSmZIPgsorZlk5V7G7Y8U+sfSNZl11DOt
pMs6esavxHahDE9Il5GWIK8oEf6TR5AqQcfFLLaEC9fvTJETOGiuexMZASJ5+3kX
UyY3dWjNDUmCQbFAXkeSxUvEjYyIUWl8j8Zn6JewnJvptUCvdwZRLK8TRp+chwwS
gkvBsLFfLRHU9n65Q2czy32BoXQOa7L1zO0Z94fPb3Z4l6VIfkD5s/Lv28QRe7+a
2D/dbJaMFIlLeqxTYJK2Pr/LHHJk/iKPVB6Cr3bSASMatQjngWNsFg0Ji1mr8BvJ
O+KOMmmAYEO6a2VNsmTdNjtsD3YderXvAYuzefHbA7AtJosbMwmcWooasofebj3a
LrA+gdzN3jgZCi+REpQ44g7MxemgU22jAB2vGw6FLHsG3Z3Lc2gKWmwFmj0Xkgny
HitYMl92V2naPv/InNT/Roe8SdTLc/0ODMFPTcgXZmkn7zSdE9F/yVy22Y5ARL4+
5LvKaQPN4BkAkCwFZtoS
=mXfb
-----END PGP SIGNATURE-----

--FYef6pHvFBuPZp1D--
