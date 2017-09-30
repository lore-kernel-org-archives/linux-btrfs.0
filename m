Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36657 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdI3SkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 14:40:08 -0400
Received: by mail-qk0-f193.google.com with SMTP id z14so1650125qkg.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 11:40:07 -0700 (PDT)
Date: Sat, 30 Sep 2017 14:40:05 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
Message-ID: <20170930184004.te3f722ktqmjqqr5@DigitalMercury.dynalias.net>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
 <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
 <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="igmq4jmjw5po7wqz"
In-Reply-To: <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--igmq4jmjw5po7wqz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 30, 2017 at 07:56:25PM +0200, Holger Hoffst=E4tte wrote:
> On 09/30/17 18:37, Graham Cobb wrote:
> > On 30/09/17 14:08, Holger Hoffst=E4tte wrote:
> >> A "root" subvolume is identified by a null parent UUID, so adding a new
> >> subvolume filter and flag -P ("Parent") does the trick.=20
> >=20
> > I don't like the naming. The flag you are proposing is really nothing to
> > do with whether a subvolume is a parent or not: it is about whether it
> > is a snapshot or not (many subvolumes are both snapshots and also
> > parents of other snapshots, and many non-snapshots are not the parent of
> > any subvolumes).
>=20
> You're completely right. I wrote that patch about a year ago because I
> needed it for my own homegrown backup program and spent approx. 5 seconds
> finding a free option letter; ultimately I ended up using the mentioned
> shell hackery as alternative. Anyway, I was sure that at the time the
> other letters sounded even worse/were taken, but that may just have been
> in my head. ;-)
>=20
> I just rechecked and -S is still available, so that's good.

Hi Holger,

On the topic of shell hackery, someone on #btrfs and I discussed this
two days ago.  The method I decided to use was blacklisting snapshots
(subvols with parent UUID) that also had to ro property set.

The rational was that a rw snapshot (with parent UUID but not ro
property) could contain live data.  eg: subvol containerA, containerB,
and containerC are all rw children of subvol containerX.  My backup
script would include containerA, containerB, and containerC in the
automatically generated list of live data subvols that need to be
snapshotted and backed up.  Because containerX has no parents it is
part of this list, regardless of whether or not it's ro.

Would you please consider addressing rw child subvols (eg: containers
cloned from a base subvol) in your patch?

> > I have two suggestions:
> >=20
> > 1) Use -S (meaning "not a snapshot", the inverse of -s). Along with this
> > change. I would change the usage text to say something like:
> >=20
> >  -s list subvolumes originally created as snapshots
> >  -S list subvolumes originally created not as snapshots
> >=20
> > Presumably specifying both -s and -S should be an error.
>=20
> That sounds much better indeed and is a quick fix. While I agree
> that the "-P <uuid>/none" filter would be useful too, it's also
> a different feature and more work than I want to invest in this
> right now. Maybe later "-S" can simply delegate to "-P none".

Proposed -s will exclude both containerX and container{A,B,C}
Proposed -S will add containerX (base subvolume) to list,
and will exclude container{A,B,C}

I believe the quickest way to solve this would be to add a check for
ro property to:
-s list read-only subvolumes originally created as snapshots

Then in the backup script:  1) get the full subvolume list  2) get the
ro snapshot list  3) Use #2 to remove ro snapshots from #1  4) Backup
subvols from #1 list

Thank you for working on this! :-)

Sincerely,
Nicholas

P.S. Please CC me for any replies

--igmq4jmjw5po7wqz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlnP5QIACgkQWogwR199
EGFLwhAArB1RTKS0/ZYfJcuQsIg5dqFAQGnaLLGgHoOrUCkGK6aN5oQLPsuYTuOs
BMSPby05m8CWZFCcOKlzM+HP/jmm8xXehBURFGs1pO5zEFrgYmLGPGecA6S2ttEW
4LHXT5Qu5+BdW017FrSGvo/YvvQeeo6iUDEWkzNBfzrPcrsJ2TD8GEVdR9UGM8p2
JpW0B00pz8lgg3w6xq00YA92x/A9JVqEekEwpMzD4uXX8Kfzngu88jBEw7OOYcsl
hm7afYjxsTKVo7d7fofMbsc6XLIRO8yXS4zxocDZ17OEdPnk80Y4+QT4K5AeQQOY
AerqjXgCMYkYzMe4H3cVVlhv6C5DU5exrhZRbBZSAFiJnMwr/v/gcgdot6oNEtGF
EaMo82MWIXrs1WfzSnSvNWySAs8qJqAYzyuR1bfAbr1hrgstXn/NX3O9ugZHqMEv
e6PDGELAiSmLLJPtbj85+duw52OiFYWmE2UUX4IF9fg3dfqZxC3TaQXHqGRbiZYW
bvDIM3s1WqoVlXQxoyjErIXDWLMf3FUXutRzf8UBY1wYAl5Hag1UId/uFEknTb27
gQ9RVhnFDbFJdh2w+JDsFqnUrXBDSHEcZWLdX+tt6kxDLfT7FUTxbHYS8iQhCrVf
BFwmqV6w0Kpo/oJNwRgqeLm/h5VtQJQ1i+mV5ibFv3Il/EAx9lw=
=0ARz
-----END PGP SIGNATURE-----

--igmq4jmjw5po7wqz--
