Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38972 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbcKORwl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 12:52:41 -0500
Date: Tue, 15 Nov 2016 12:52:01 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161115175201.GL21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
 <20161114211013.GJ21290@hungrycats.org>
 <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLOnmNMLAcnry0J+"
In-Reply-To: <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SLOnmNMLAcnry0J+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2016 at 07:26:53AM -0500, Austin S. Hemmelgarn wrote:
> On 2016-11-14 16:10, Zygo Blaxell wrote:
> >Why is deduplicating thousands of blocks of data crazy?  I already
> >deduplicate four orders of magnitude more than that per week.
> You missed the 'tiny' quantifier.  I'm talking really small blocks, on the
> order of less than 64k (so, IOW, stuff that's not much bigger than a few
> filesystem blocks), and that is somewhat crazy because it ends up not only
> taking _really_ long to do compared to larger chunks (because you're runn=
ing
> more independent hashes than with bigger blocks), but also because it will
> often split extents unnecessarily and contribute to fragmentation, which
> will lead to all kinds of other performance problems on the FS.

Like I said, millions of extents per week...

64K is an enormous dedup block size, especially if it comes with a 64K
alignment constraint as well.

These are the top ten duplicate block sizes from a sample of 95251
dedup ops on a medium-sized production server with 4TB of filesystem
(about one machine-day of data):

        total bytes     extent count    dup size
        2750808064      20987           131072
        803733504       1533            524288
        123801600       975             126976
        103575552       8429            12288
        97443840        793             122880
        82051072        10016           8192
        77492224        18919           4096
        71331840        645             110592
        64143360        540             118784
        63897600        650             98304

        all bytes       all extents     average dup size
        6129995776      95251           64356

128K and 512K are the most common sizes due to btrfs compression (it
limits the block size to 128K for compressed extents and seems to limit
uncompressed extents to 512K for some reason).  12K is #4, and 3 of the
top ten sizes are below 16K.  The average size is just a little below 64K.

These are the duplicates with block sizes smaller than 64K:

        total bytes     extent count    extent size
        41615360        635             65536
        46264320        753             61440
        45817856        799             57344
        41267200        775             53248=20
        45760512        931             49152
        46948352        1042            45056
        43417600        1060            40960
        47296512        1283            36864
        59277312        1809            32768
        49029120        1710            28672
        43745280        1780            24576
        53616640        2618            20480
        43466752        2653            16384
        103575552       8429            12288
        82051072        10016           8192=20
        77492224        18919           4096=20

        all bytes <=3D64K extents <=3D64K   average dup size <=3D64K
        870641664       55212           15769

14% of my duplicate bytes are in blocks smaller than 64K or blocks not
aligned to a 64K boundary within a file.  It's too large a space saving
to ignore on machines that have constrained storage.

It may be worthwhile skipping 4K and 8K dedups--at 250 ms per dedup,
they're 30% of the total run time and only 2.6% of the total dedup bytes.
On the other hand, this machine is already deduping everything fast enough
to keep up with new data, so there's no performance problem to solve here.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SLOnmNMLAcnry0J+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgrS0EACgkQgfmLGlazG5xScACg5C8KE0UqYFR83LYyEgefs88L
nmkAn27BcQrQUriRMJlch6RtyAoV01aE
=XsHn
-----END PGP SIGNATURE-----

--SLOnmNMLAcnry0J+--
