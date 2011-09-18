From: Hubert Kario <hubert@kario.pl>
Subject: Re: btrfs vs data deduplication
Date: Sun, 18 Sep 2011 22:15:51 +0200
Message-ID: <201109182215.58477.hubert@kario.pl>
References: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3907711.b6zH8dh1Hv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: =?utf-8?q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3907711.b6zH8dh1Hv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 09 of July 2011 08:19:30 Pawe=C5=82 Brodacki wrote:
> Hello,
>
> I've stumbled upon this article:
> http://storagemojo.com/2011/06/27/de-dup-too-much-of-good-thing/
>
> Reportedly Sandforce SF1200 SSD controller does internally block-level
> data de-duplication. This effectively removes the additional
> protection given by writing multiple metadata copies. This technique
> may be used, or can be used in the future by manufactureres of other
> drives too.

Only a problem in a single disk installation

> I would like to ask, if the metadata copies written to a btrfs system
> with enabled metadata mirroring are identical, or is there something
> that makes them unique on-disk, therefore preventing their
> de-duplication. I tried googling for the answer, but didn't net
> anything that would answer my question.

There is a difference between root inode copies, don't think there's any=20
difference between metadata tree copies. I'm quite certain they are bit for=
=20
bit identical.

> If the metadata copies are identical, I'd like to ask if it would be
> possible to change this without major disruption? I know that changes
> to on-disk format aren't a thing made lightly, but I'd be grateful for
> any comments.

That would be a big change for little to no benefit.

> The increase of the risk of file system corruption introduced by data
> de-duplication on Sandforce controllers was down-played in the
> vendor's reply included in the article, but still, what's the point of
> duplicating metadata on file system level, if storage below can remove
> that redundancy?

You shouldn't depend on single drive, metadata raid is there to protect=20
against single bad blocks, not disk crash.

If you want redundancy, use mulitple disks. Either HDD or SSD. And have=20
readable backups.

Regards,
Hubert


--nextPart3907711.b6zH8dh1Hv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOdlF4AAoJEKHQa8mJVtz+KJ8P/1BXVMh1WfqEYo0TpPM8ue0D
yFjTCuV0b4py1L7OFmHeS3uf0oQkybOv0rEWlzMekBSHn620HZM6xMRYEFSBv/J2
esOy/AUKu9KBZIyPtu3T67np2Zcg473s/diNWdnjH4Lys4LgPVB5NEcPOmvp6zoA
GrPtPJlZyfY2G+JYIBX4QE8A4Qeo7dOi1o+EFX25cXmRZUEyEV3gvA8WTihGq4FJ
vYnByrg/jbFEvIFQss9P9bP2cNhGgp+kI0030HmH/NlzhkaIZfPKQmYAqap0i3Aw
nXS/I6Ilb3jBw/Eww6/7CVCnLIeRrgMKXtt9Q0hrhpbUj62pCCt19McqUAmCdw/9
TFJDuHB7fPvxJz8as/m5DfCTOCVU+dO5Hs0o8Ra93Zd+mKMPIingtVMCxA2ScV7d
VL+z6v6OpGHCutqP3iolWfSgmHkebdhpZajn/J8OOKPUSLqQB/hKr8Zh4Ws/40Ju
t8dvx1W+ZK71e2WLm4a8l7p0gJ9ZRU2VzmSjarcW2Zx/6EErXtlZQiYlS/5A7M6V
Rlg1hynpbAm9KLXxwGUExw0/XiXTZc4IBCCB0fcuFeTuOvg9BbBRWA393zze+FVK
QXZKLeTv1XcNhM6Yu6WA9KgU4/fnHklH/CrS/KSprGuOEoXxhzeSdDBXbkmmc+Ej
gzwHzjv/ly5ZpZiekwpk
=yqoG
-----END PGP SIGNATURE-----

--nextPart3907711.b6zH8dh1Hv--
