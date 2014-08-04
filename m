Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35856 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaHDNfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 09:35:47 -0400
Date: Mon, 4 Aug 2014 14:35:43 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Waller <peter@scraperwiki.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Message-ID: <20140804133543.GE31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com>
 <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
 <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk>
 <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
 <20140804113231.GD31950@carfax.org.uk>
 <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="djTb5EnuS5qMpC9h"
In-Reply-To: <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--djTb5EnuS5qMpC9h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 02:17:02PM +0100, Peter Waller wrote:
> For anyone else having this problem, this article is fairly useful for
> understanding disk full problems and rebalance:
> 
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
> 
> It actually covers the problem that I had, which is that a rebalance
> can't take place because it is full.
> 
> I still am unsure what is really wrong with this whole situation. Is
> it that I wasn't careful to do a rebalance when I should have been
> doing? Is it that BTRFS doesn't do a rebalance automatically when it
> could in principle?

   This latter one.

   Well, actually two things: the FS should be capable of autonomously
rebalancing at low bandwidth to prevent this problem, but nobody's got
round to implementing it yet. Secondly, it should not be possible to
get into a state where you can't run the balance -- Josef spent about
three kernel revisions fixing the block reserve code to that end.
However, since about 3.14, there's been more cases like yours show up,
so I think there's been a regression. It's not very common, though. I
think we've had maybe a dozen reported instances in the last 6 months.
Someone on IRC had it just now, though, and captured a metadata image,
so at least we've got some (meta)data to work with now.

> It's pretty bad to end up in a situation (with spare space) where the
> only way out is to add more storage, which may be impractical,
> difficult or expensive.
> 
> The other thing that I still don't understand I've seen repeated in a
> few places, from the above article:
> 
> "because the filesystem is only 55% full, I can ask balance to rewrite
> all chunks that are more than 55% full"
> 
> Then he uses `btrfs balance start -dusage=55 /mnt/btrfs_pool1`. I
> don't understand the relationship between "the FS is 55% full" and
> "chunks more than 55% full". What's going on here?

   Pigeonhole principle -- if the FS is 55% full, there must be at
least one chunk <= 55% full.

> I conclude that now since I have added more storage, the rebalance
> won't fail and if I keep rebalancing from a cron job I won't hit this
> problem again (unless the filesystem fills up very fast! what then?).
> I don't know however what value to assign to `-dusage` in general for
> the cron rebalance. Any hints?

   Try with increasing values until you've moved as many chunks as you
want to. This is what David's "balance at least N chunks" patch did.
I'd suggest start with 5, and go up in increments of 5, if you're
making it an automatic process. Stop when you reach some threshold
(like, say, 80), or when it reports that it's actually moved some
chunks.

   Doing it manually, I usually recommend 5, 10, 20, 50, 80.

   Hugo.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--djTb5EnuS5qMpC9h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9+ML1heFHXiqx3kAQLhYxAAlVyVnsZj6hGQU8K/SPJczyUWX0ToqsgO
ThQcpePy/F6PjrOtrJCY8yXdUhFC/fYVQK5wUG1PZCZx0fQioU3g6SZ+3m+Hh0N2
GIA6Grhey6qHcciO0GGoeNSCiv9EEFAB55zui18P8luMlDEdRNpkhmb2+p2znt9O
1G1Uy81w1yD/TpfuNG0l+O2yoYbPheOx89LdP4p/OIv6WRdkoOieESgG5W/7/bnk
Ce9/1bBsbcVcYxqDMLAgpVz59P2yn/wWRfbLWKxtWJnNu9dvqmyIJOHzR0CQMdvy
b0RXJSx/jeoNOS98Mih5CWVXohE6Hk1xbSVaFteRr50bTCW79F53sDPMsy0pd4fn
nTv9PzY0azw4NHXBza7Uat7FyLSwppchpPNZANz51tMTXAozJEBVlYy3wbNmWpt/
ihdT60rofc3Pj12Nd91KlxYxjvuAiDCrh6S/SNKnt4HYQngPi6WtiNU8I6A4s2/h
7E33JlNcEQfIIgqG07a2JaQrLcrXNoDpCTA6iFpLl/NMMwx94qM3DS024IJK+vGB
2XLDHa9Bd/iPNugvtwq0OdQG9qzyUPlVkydCNp7OuIl7DH/YmWCXt4J43p6kO+7E
EY0hiWHp1sxFCWwvGQJzgO3HFwREz0SHH6Qd10TlNJOqfaDBqCnKgyNKRPtmmCqZ
VWXmAOqZF20=
=pLjq
-----END PGP SIGNATURE-----

--djTb5EnuS5qMpC9h--
