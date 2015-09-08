Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49214 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbbIHUkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:40:09 -0400
Date: Tue, 8 Sep 2015 20:40:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs tools] ability to fail a device...
Message-ID: <20150908204006.GP23944@carfax.org.uk>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk>
 <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
 <CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
 <CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com>
 <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
 <CAA85sZueV2NuTeUdvWjEJKc8L1u6h7Tbdne0vPtd75zxshPBgw@mail.gmail.com>
 <CAJCQCtSz7YAEyTGtga73Ze29qtsgDCHLsrsWtqP_-r4YwhxhEA@mail.gmail.com>
 <20150908202839.GO23944@carfax.org.uk>
 <CAA85sZt+xsE9i7-kWtm-Mt2jb=voUG4vt40rnY7oTMDOYrcnSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OxDG9cJJSSQMUzGF"
In-Reply-To: <CAA85sZt+xsE9i7-kWtm-Mt2jb=voUG4vt40rnY7oTMDOYrcnSw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OxDG9cJJSSQMUzGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 08, 2015 at 10:33:54PM +0200, Ian Kumlien wrote:
> On 8 September 2015 at 22:28, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Tue, Sep 08, 2015 at 02:17:55PM -0600, Chris Murphy wrote:
> >> On Tue, Sep 8, 2015 at 2:13 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> >> > On 8 September 2015 at 22:08, Chris Murphy <lists@colorremedies.com> wrote:
> >> >> On Tue, Sep 8, 2015 at 2:00 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> 
> [--8<--]
> 
> >> > -o degraded should allow readwrite *IF* the data can be written to....
> >> > My question is also, would this keep me from "adding devices"?
> >> > I mean, it did seem like a catch 22 earlier, but that would really
> >> > make a mess of things...
> >>
> >> It is not possible to add a device to an ro filesystem, so effectively
> >> the fs read-writeability is broken in this case.
> >
> >    I thought this particular issue had already been dealt with in 4.2?
> > (i.e. you can still mount an FS RW if it's degraded, but there are
> > still some single chunks on it).
> 
> Single chunks are only on sda - not on sdb...
> 
> There should be no problem...

   The check is more primitive than that at the moment, sadly. It just
checks that the number of missing devices is smaller than or equal to
the acceptable device loss for each RAID profile present on the FS.

> >    Ian: If you can still mount the FS read/write with both devices in
> > it, then it might be worth trying to balance away the problematic
> > single chunks with:
> >
> > btrfs bal start -dprofiles=single -mprofiles=single /mountpoint
> >
> >    Then unmount, pull the dead drive, and remount -odegraded.
> 
> It never completes, too many errors and eventually the disk disappears
> until the machine is turned off and on again... (normal disk reset
> doesn't work)

   The profiles= parameters should limit the balance to just the three
single chunks, and will remove them (because they're empty). It
shouldn't hit the metadata too hard, even if it's raising lots of
errors.

   Hugo.

-- 
Hugo Mills             | The early bird gets the worm, but the second mouse
hugo@... carfax.org.uk | gets the cheese.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--OxDG9cJJSSQMUzGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV70elAAoJEFheFHXiqx3kWVQQAK3GJISUirNPullFtAuBt2nV
GWDKbnzPgKcItLstL/Ef0SpZA87imHtYZ9qDaGaZ75SQtB56oDPB/1qqBTm0zvCR
DIrz4zW3B4sQXjhjdwfH6hTe+kX0CQgXK/kzjjfsmAEXMgVu/vKu3QYgiuy6sKL3
EzXTs7TZFOmqzF0hPzoUrbd3GSa/hLjGgKH4HmtkQyQ1+yj7T6LGpKSrKvawZTbX
pDwrjeQMVpYXqc8/lGYMsSvbjl4y4g0ayBxT1k/JqZy2k0KHbfe80xwrPAN/5uND
rvre2epL1NCoDFnw6l7765uO9DnKgzf3yXh/9u7KOBEJQbv7h0uX1grTLDZ7oi0D
KkPaDQUrvluX0lkjcxnyFgOc81WEo9ib/9PIbO3k+rlthglB7Yy4GPY1nVbVQ7He
869W6dRa45ZQkkjsJQn1qonnJG4+eH7NOaHtercaLBdlERwqkKceyvtNI5YL63Sc
996qtnkmnDYxSydBrJQGxyQj44bwBvseiO2t17onOcADTMC6XO/FfmgrNHJCi9OU
S2z6ijKtN6iG4L7VaWH/7/xxmuoSe16agwUAjsNlMojE6WxrqnxtJootDg4hHqyc
lWjTws5APtxpJLYcmNlXtrrJQWUCnXrSei5aLjJaK4QnucvfnVb+YUK2vZKEt4uY
eOrg3JQw8HjgJH8cqAoT
=R5/u
-----END PGP SIGNATURE-----

--OxDG9cJJSSQMUzGF--
