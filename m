Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33716 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaHDKje (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 06:39:34 -0400
Date: Mon, 4 Aug 2014 11:39:29 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Waller <peter@scraperwiki.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Message-ID: <20140804103929.GB31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com>
 <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
 <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk>
 <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0B3PZ1+h5f4cFxHi"
In-Reply-To: <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0B3PZ1+h5f4cFxHi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 11:31:57AM +0100, Peter Waller wrote:
> Thanks Hugo, this is the most informative e-mail yet! (more inline)
> 
> On 4 August 2014 11:22, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> >  * btrfs fi show
> >     - look at the total and used values. If used < total, you're OK.
> >       If used == total, then you could potentially hit ENOSPC.
> 
> Another thing which is unclear and undocumented anywhere I can find is
> what the meaning of `btrfs fi show` is.
> 
> I'm sure it is totally obvious if you are a developer or if you have
> used it for long enough. But it isn't covered in the manpage, nor in
> the oracle documentation, nor anywhere on the wiki that I could find.
> 
> When I looked at it in my problematic situation, it said "500 GiB /
> 500 GiB". That sounded fine to me because I interpreted the output as
> what fraction of which RAID devices BTRFS was using. In other words, I
> thought "Oh, BTRFS will just make use of the whole device that's
> available to it.". I thought that `btrfs fi df` was the source of
> information for how much space was free inside of that.

   That's actually pretty much accurate. The problem is that btrfs
distinguishes between "space available for data" and "space available
for metadata", and doesn't trade off one for the other once they've
been allocated. The balance operation frees up some of the allocation,
allowing the newly-freed space to be allocated again for something
else.

   All of the information about the data/metadata split, and what's
used out of that, is revealed by btrfs fi df.

> >  * btrfs fi df
> >     - look at metadata used vs total. If these are close to zero (on
> >       3.15+) or close to 512 MiB (on <3.15), then you are in danger of
> >       ENOSPC.
> 
> Hmm. It's unfortunate that this could indicate an amount of space
> which is free when it actually isn't.

   That's why the 512 MiB block reserve was split out of metadata --
so that you don't look at metadata and say "oh, I've got half a gig
free, that's OK".

> >     - look at data used vs total. If the used is much smaller than
> >       total, you can reclaim some of the allocation with a filtered
> >       balance (btrfs balance start -dusage=5), which will then give
> >       you unallocated space again (see the btrfs fi show test).
> 
> So the filtered balance didn't help in my situation. I understand it's
> something to do with the "5" parameter. But I do not understand what
> the impact of changing this parameter is. It is something to do with a
> fraction of something, but those things are still not present in my
> mental model despite a large amount of reading. Is there an
> illustration which could clear this up?

   The 5 is 5%. So, it'll only look at chunks which are less than 5%
full. David Sterba published a patch that would balance the
(approximately N) least-used chunks, which is a considerably more
usable approach, but I don't know what happened to that one.

> Among other things I also got the kernel stack trace I pasted at the
> bottom of the first e-mail to this thread when I did the rebalance.

   OK, I'll go back and read that. You probably shouldn't have had it,
though. :)

> >    This FAQ entry is pretty horrible, I'm afraid. I actually started
> > rewriting it here to try to make it clearer what's going on. I'll try
> > to work on it a bit more this week and put out a better version for
> > the wiki.
> 
> This is great to hear! :)
> 
> Thanks for your response Hugo, that really cleared up a lot of mental
> model problems. I hope the documentation can be improved so that
> others can learn from my mistakes.

   I do try to work on it every so often. Note to self: win lottery,
or get cloned.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---    
                         money? There's irony...                         

--0B3PZ1+h5f4cFxHi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99i4VheFHXiqx3kAQKXOhAAlGsrXX3nz8n0FXyBIsYH7z46qbIf0ZRl
itExF6Jf2eaGQHZmJrpsI7kztzGBdyGWADjxDGdgsLZNrLLbZNt52yX0o2nrEIiQ
o1cHYFOwjoib1Y22G6ZDGdb5To75CKDcyGiL73KKWE03V0EfZsmU6667OsT04PWq
UZV5G8yUSSCWQConfGae4xvB6o1n4A0MV5czLGdkd/tZtvUE0vWmTYD3zYsMeFFn
qluZ7sl3kXbcOvC3mQJfccwkps6+JNqCIlshT2tpaug6KTjp1zsUUZrM3+2TE7Kf
AF20Ab53PwoOKt9Dfw21Y+Sl4bjeLICMzU0c4XwPQciqGV95o3/jdDQjDU1dg/6E
UB7C6bWuvjVSWdony1AZq7aDkz9F1rpRi6RsRui/fpmNjFDj/QW9fnZXb5Ftowyv
FPt5jAelA/iVbc9C0wZmllQNvpnupjKJetJR47wwBcsrq0yz4u4O1hoacuCSQ2Ru
7rlL7ijUIzzLuzQy32grD74mPO7J5iTt5R9PK7mpu9Q6ctJeC0Avy61iFt+WIprR
dNYBCDv8q7CaYcM6bl1L5yscMdy+N40+DnBZuxoT2dK9HR+9bCAVZNNnZgv7xZYU
t5g663XvY3d0fZ0r3SuXSPWbolT4HY1FqWAQieLwtCBlWxVmJRkb6OVO3Lh0JyBB
9YKGpySUV18=
=eXPH
-----END PGP SIGNATURE-----

--0B3PZ1+h5f4cFxHi--
