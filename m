Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59899 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbbKZAdq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 19:33:46 -0500
Date: Thu, 26 Nov 2015 00:33:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs: poor
 performance on deleting many large files?)
Message-ID: <20151126003342.GA24333@carfax.org.uk>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <56530DAD.9080607@gmail.com>
 <1448497439.28195.33.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2GlHqZBJuVUxZ2A"
In-Reply-To: <1448497439.28195.33.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a2GlHqZBJuVUxZ2A
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2015 at 01:23:59AM +0100, Christoph Anton Mitterer wrote:
> 2) Why does notdatacow imply nodatasum and can that ever be decoupled?

   Answering the second part first, no, it can't.

   The issue is that nodatacow bypasses the transactional nature of
the FS, making changes to live data immediately. This then means that
if you modify a modatacow file, the csum for that modified section is
out of date, and won't be back in sync again until the latest
transaction is committed. So you can end up with an inconsistent
filesystem if there's a crash between the two events.

> For me the checksumming is actually the most important part of btrfs
> (not that I wouldn't like its other features as well)... so turning it
> off is something I really would want to avoid.
>=20
> Plus it opens questions like: When there are no checksums, how can it
> (in the RAID cases) decide which block is the good one in case of
> corruptions?

   It doesn't decide -- both copies look equally good, because there's
no checksum, so if you read the data, the FS will return whatever data
was on the copy it happened to pick.


> 3) When I would actually disable datacow for e.g. a subvolume that
> holds VMs or DBs... what are all the implications?
> Obviously no checksumming, but what happens if I snapshot such a
> subvolume or if I send/receive it?

   After snapshotting, modifications are CoWed precisely once, and
then it reverts to nodatacow again. This means that making a snapshot
of a nodatacow object will cause it to fragment as writes are made to
it.

> I'd expect that then some kind of CoW needs to take place or does that
> simply not work?
>=20
>=20
> 4) Duncan mentioned that defrag (and I guess that's also for auto-
> defrag) isn't ref-link aware...
> Isn't that somehow a complete showstopper?

   It is, but the one attempt at dealing with it caused massive data
corruption, and it was turned off again. autodefrag, however, has
always been snapshot aware and snapshot safe, and would be the
recommended approach here. (Actually, it was broken in the same
incident I just described -- but fixed again when the broken patches
were reverted).

> As soon as one uses snapshot, and would defrag or auto defrag any of
> them, space usage would just explode, perhaps to the extent of ENOSPC,
> and rendering the fs effectively useless.
>=20
> That sounds to me like, either I can't use ref-links, which are crucial
> not only to snapshots but every file I copy with cp --reflink auto ...
> or I can't defrag... which however will sooner or later cause quite
> some fragmentation issues on btrfs?
>=20
>=20
> 5) Especially keeping (4) in mind but also the other comments in from
> Duncan and Austin...
> Is auto-defrag now recommended to be generally used?

   Absolutely, yes.

   It's late for me, and this email was longer than I suspected, so
I'm going to stop here, but I'll try to pick it up again and answer
your other questions tomorrow.

   Hugo.

> Are both auto-defrag and defrag considered stable to be used? Or are
> there other implications, like when I use compression
>=20
>=20
> 6) Does defragmentation work with compression? Or is it just filefrag
> which can't cope with it?
>=20
> Any other combinations or things with the typicaly btrfs technologies
> (cow/nowcow, compression, snapshots, subvols, compressions, defrag,
> balance) that one can do but which lead to unexpected problems (I, for
> example, wouldn't have expected that defragmentation isn't ref-link
> aware... still kinda shocked ;) )
>=20
> For example, when I do a balance and change the compression, and I have
> multiple snaphots or files within one subvol that share their blocks...
> would that also lead to copies being made and the space growing
> possibly dramatically?
>=20
>=20
> 7) How das free-space defragmentation happen (or is there even such a
> thing)?
> For example, when I have my big qemu images, *not* using nodatacow, and
> I copy the image e.g. with qemu-img old.img new.img ... and delete the
> old then.
> Then I'd expect that the new.img is more or less not fragmented,... but
> will my free space (from the removed old.img) still be completely
> messed up sooner or later driving me into problems?
>=20
>=20
> 8) why does a balance not also defragment? Since everything is anyway
> copied... why not defragmenting it?
> I somehow would have hoped that a balance cleans up all kinds of
> things,... like free space issues and also fragmentation.
>=20
>=20
> Given all these issues,... fragmentation, situations in which space may
> grow dramatically where the end-user/admin may not necessarily expect
> it (e.g. the defrag or the balance+compression case?)... btrfs seem to
> require much more in-depth knowledge and especially care (that even
> depends on the type of data)=A0on the end-user/admin side than the
> traditional filesystems.
> Are there for example any general recommendations what to regularly to
> do keep the fs in a clean and proper shape (and I don't count "start
> with a fresh one and copy the data over" as a valid way).
>=20
>=20
> Thanks,
> Chris.
>=20
> >=20



--=20
Hugo Mills             | "There's more than one way to do it" is not a
hugo@... carfax.org.uk | commandment. It is a dire warning.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--a2GlHqZBJuVUxZ2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVlNmAAoJEFheFHXiqx3kvJIQAIGB8ppU5aygpK13TDb/fuVp
WvIvfgWJWLV8Ku77h1qAQ113MBAadiJX6qCPV/2wiSSunzQETDo9LZ95NlOvsVAB
tAJJz/aWOpJr4oglefHka0YVB8cS3D1PMcLjWMk9MBWmy8uvYRdXftaF+UOgCYcU
ruzjUfUpUqLZaAkvJYpq1fF+D0oWYQIEFu+rg6sWSaJIKSxCTujh5+zhuosNm5Dc
yY75DB+OlzE0HOyEQpMkzBSlOEG8eqckuIG/bMqwp0PkssFEdsxD72tYiN1HjQSq
0mzYw/+NaMqCQrL5YZ+p7m8hRSktxSNl+hnFp90bNN1/BklosSRvvHeFt/jLwcB/
+prCPSGqPTpzzNW9PCwHGrloM5MN0zOaNnIy06Al6I92YF5zplDi8kf6yueagUzn
ZefL/IRyFHTieoKI7AjGxvQ8vF3SGcc4lk8Y+nzLgTAMXT/d3X/OcR3wFPvb0v99
HiKqg85lAXB9G+iRZJZFoB04c+9h9DfWs6iu9ppBObOFtqsIygbtfWch2hQVs7oP
77d7vAWXE5IwYuaJW9cwqlMivcSb6ecTgHw5L517Fke+lqfv78bQTDOnyc/Th4n2
ME/aGjGvsJ7fmWMM4thsnyk4KDLpcwgZruGh8Fzgqb6w7PvwOuTT+XxnDZi0T1w2
sdw/6HCZ3KmLkoN7E8Wt
=4HYx
-----END PGP SIGNATURE-----

--a2GlHqZBJuVUxZ2A--
