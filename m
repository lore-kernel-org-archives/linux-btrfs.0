Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A757C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 05:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02888222C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 05:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfBNFBI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 00:01:08 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41242 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfBNFBG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 00:01:06 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id C35E321CC4B; Thu, 14 Feb 2019 00:00:54 -0500 (EST)
Date:   Thu, 14 Feb 2019 00:00:54 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190214050043.GE23918@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
 <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
Content-Disposition: inline
In-Reply-To: <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2019 at 01:22:49AM +0000, Filipe Manana wrote:
> On Wed, Feb 13, 2019 at 6:14 PM Filipe Manana <fdmanana@gmail.com> wrote:
> > On Wed, Feb 13, 2019 at 5:36 PM Filipe Manana <fdmanana@gmail.com> wrot=
e:
[...]
> > > Tried it today and I got it reproduced (different vm, but still debian
> > > and kernel built from source).
> > > Not sure what was different last time. Yes, I had compression enabled.
> > >
> > > I'll look into it.
> >
> > So the problem is caused by hole punching. The script can be reduced
> > to the following:
> >
> > https://friendpaste.com/22t4OdktHQTl0aMGxckc86
> >
> > file size: 384K am
> > digests after file creation:   7c8349cc657fbe61af53fbc5cfacae6e9a402e83=
  am
> > digests after file creation 2: 7c8349cc657fbe61af53fbc5cfacae6e9a402e83=
  am
> > 262144 total bytes deduped in this operation
> > digests after dedupe:          7c8349cc657fbe61af53fbc5cfacae6e9a402e83=
  am
> > digests after dedupe 2:        7c8349cc657fbe61af53fbc5cfacae6e9a402e83=
  am
> > am: 24 KiB (24576 bytes) converted to sparse holes.
> > digests after hole punching:   7c8349cc657fbe61af53fbc5cfacae6e9a402e83=
  am
> > digests after hole punching 2: 5a357b64f4004ea38dbc7058c64a5678668420da=
  am
> >
> > So hole punching is screwing things, and only after dropping the page
> > cache we can see the bug.
> > I'll send a fix likely tomorrow.
>=20
> So it turns out it's a problem in the read of compressed extents part,
> a variant of a bug I found back in 2015:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D005efedf2c7d0a270ffbe28d8997b03844f3e3e7
>=20
> The following one liner fixes it:
> https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3
>=20
> While you test it there (if you want/can), I'll write a change log and
> a proper test case for fstests and submit them later.

Works here (and produces the correct sha1sum, which turns out to be
dae78e303edfb8b8ad64ecae01dc1bf233770cfd).

Nice work!

> Thanks!
> >
> > >
> > > >
> > > > > > > >
> > > > > > > > The behavior is slightly different on current kernels (4.20=
=2E7, 4.14.96)
> > > > > > > > which makes the problem a bit more difficult to detect.
> > > > > > > >
> > > > > > > >         # repro-hole-corruption-test
> > > > > > > >         i: 91, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 92, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 93, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 94, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 95, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 96, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 97, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 98, status: 0, bytes_deduped: 131072
> > > > > > > >         i: 99, status: 0, bytes_deduped: 131072
> > > > > > > >         13107200 total bytes deduped in this operation
> > > > > > > >         am: 4.8 MiB (4964352 bytes) converted to sparse hol=
es.
> > > > > > > >         94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >
> > > > > > > > The sha1sum seems stable after the first drop_caches--until=
 a second
> > > > > > > > process tries to read the test file:
> > > > > > > >
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >         # cat am > /dev/null              (in another shell)
> > > > > > > >         19294e695272c42edb89ceee24bb08c13473140a am
> > > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >
> > > > > > > > On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrot=
e:
> > > > > > > > > This is a repro script for a btrfs bug that causes corrup=
ted data reads
> > > > > > > > > when reading a mix of compressed extents and holes.  The =
bug is
> > > > > > > > > reproducible on at least kernels v4.1..v4.18.
> > > > > > > > >
> > > > > > > > > Some more observations and background follow, but first h=
ere is the
> > > > > > > > > script and some sample output:
> > > > > > > > >
> > > > > > > > >       root@rescue:/test# cat repro-hole-corruption-test
> > > > > > > > >       #!/bin/bash
> > > > > > > > >
> > > > > > > > >       # Write a 4096 byte block of something
> > > > > > > > >       block () { head -c 4096 /dev/zero | tr '\0' "\\$1";=
 }
> > > > > > > > >
> > > > > > > > >       # Here is some test data with holes in it:
> > > > > > > > >       for y in $(seq 0 100); do
> > > > > > > > >               for x in 0 1; do
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 21;
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 22;
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 43;
> > > > > > > > >                       block 44;
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 0;
> > > > > > > > >                       block 61;
> > > > > > > > >                       block 62;
> > > > > > > > >                       block 63;
> > > > > > > > >                       block 64;
> > > > > > > > >                       block 65;
> > > > > > > > >                       block 66;
> > > > > > > > >               done
> > > > > > > > >       done > am
> > > > > > > > >       sync
> > > > > > > > >
> > > > > > > > >       # Now replace those 101 distinct extents with 101 r=
eferences to the first extent
> > > > > > > > >       btrfs-extent-same 131072 $(for x in $(seq 0 100); d=
o echo am $((x * 131072)); done) 2>&1 | tail
> > > > > > > > >
> > > > > > > > >       # Punch holes into the extent refs
> > > > > > > > >       fallocate -v -d am
> > > > > > > > >
> > > > > > > > >       # Do some other stuff on the machine while this run=
s, and watch the sha1sums change!
> > > > > > > > >       while :; do echo $(sha1sum am); sysctl -q vm.drop_c=
aches=3D{1,2,3}; sleep 1; done
> > > > > > > > >
> > > > > > > > >       root@rescue:/test# ./repro-hole-corruption-test
> > > > > > > > >       i: 91, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 92, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 93, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 94, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 95, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 96, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 97, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 98, status: 0, bytes_deduped: 131072
> > > > > > > > >       i: 99, status: 0, bytes_deduped: 131072
> > > > > > > > >       13107200 total bytes deduped in this operation
> > > > > > > > >       am: 4.8 MiB (4964352 bytes) converted to sparse hol=
es.
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       072a152355788c767b97e4e4c0e4567720988b84 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       60831f0e7ffe4b49722612c18685c09f4583b1df am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > > >       ^C
> > > > > > > > >
> > > > > > > > > Corruption occurs most often when there is a sequence lik=
e this in a file:
> > > > > > > > >
> > > > > > > > >       ref 1: hole
> > > > > > > > >       ref 2: extent A, offset 0
> > > > > > > > >       ref 3: hole
> > > > > > > > >       ref 4: extent A, offset 8192
> > > > > > > > >
> > > > > > > > > This scenario typically arises due to hole-punching or de=
duplication.
> > > > > > > > > Hole-punching replaces one extent ref with two references=
 to the same
> > > > > > > > > extent with a hole between them, so:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 16384
> > > > > > > > >
> > > > > > > > > becomes:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > > >       ref 2:  hole, length 8192
> > > > > > > > >       ref 3:  extent A, offset 12288, length 4096
> > > > > > > > >
> > > > > > > > > Deduplication replaces two distinct extent refs surroundi=
ng a hole with
> > > > > > > > > two references to one of the duplicate extents, turning t=
his:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > > >       ref 2:  hole, length 8192
> > > > > > > > >       ref 3:  extent B, offset 0, length 4096
> > > > > > > > >
> > > > > > > > > into this:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > > >       ref 2:  hole, length 8192
> > > > > > > > >       ref 3:  extent A, offset 0, length 4096
> > > > > > > > >
> > > > > > > > > Compression is required (zlib, zstd, or lzo) for corrupti=
on to occur.
> > > > > > > > > I am not able to reproduce the issue with an uncompressed=
 extent nor
> > > > > > > > > have I observed any such corruption in the wild.
> > > > > > > > >
> > > > > > > > > The presence or absence of the no-holes filesystem featur=
e has no effect.
> > > > > > > > >
> > > > > > > > > Ordinary writes can lead to pairs of extent references to=
 the same extent
> > > > > > > > > separated by a reference to a different extent; however, =
in this case
> > > > > > > > > there is data to be read from a real extent, instead of p=
ages that have
> > > > > > > > > to be zero filled from a hole.  If ordinary non-hole writ=
es could trigger
> > > > > > > > > this bug, every page-oriented database engine would be cr=
ashing all the
> > > > > > > > > time on btrfs with compression enabled, and it's unlikely=
 that would not
> > > > > > > > > have been noticed between 2015 and now.  An ordinary writ=
e that splits
> > > > > > > > > an extent ref would look like this:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > > >       ref 2:  extent C, offset 0, length 8192
> > > > > > > > >       ref 3:  extent A, offset 12288, length 4096
> > > > > > > > >
> > > > > > > > > Sparse writes can lead to pairs of extent references surr=
ounding a hole;
> > > > > > > > > however, in this case the extent references will point to=
 different
> > > > > > > > > extents, avoiding the bug.  If a sparse write could trigg=
er the bug,
> > > > > > > > > the rsync -S option and qemu/kvm 'raw' disk image files (=
among many
> > > > > > > > > other tools that produce sparse files) would be unusable,=
 and it's
> > > > > > > > > unlikely that would not have been noticed between 2015 an=
d now either.
> > > > > > > > > Sparse writes look like this:
> > > > > > > > >
> > > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > > >       ref 2:  hole, length 8192
> > > > > > > > >       ref 3:  extent B, offset 0, length 4096
> > > > > > > > >
> > > > > > > > > The pattern or timing of read() calls seems to be relevan=
t.  It is very
> > > > > > > > > hard to see the corruption when reading files with 'hd', =
but 'cat | hd'
> > > > > > > > > will see the corruption just fine.  Similar problems exis=
t with 'cmp'
> > > > > > > > > but not 'sha1sum'.  Two processes reading the same file a=
t the same time
> > > > > > > > > seem to trigger the corruption very frequently.
> > > > > > > > >
> > > > > > > > > Some patterns of holes and data produce corruption faster=
 than others.
> > > > > > > > > The pattern generated by the script above is based on ins=
tances of
> > > > > > > > > corruption I've found in the wild, and has a much better =
repro rate than
> > > > > > > > > random holes.
> > > > > > > > >
> > > > > > > > > The corruption occurs during reads, after csum verificati=
on and before
> > > > > > > > > decompression, so btrfs detects no csum failures.  The da=
ta on disk
> > > > > > > > > seems to be OK and could be read correctly once the kerne=
l bug is fixed.
> > > > > > > > > Repeated reads do eventually return correct data, but the=
re is no way
> > > > > > > > > for userspace to distinguish between corrupt and correct =
data reliably.
> > > > > > > > >
> > > > > > > > > The corrupted data is usually data replaced by a hole or =
a copy of other
> > > > > > > > > blocks in the same extent.
> > > > > > > > >
> > > > > > > > > The behavior is similar to some earlier bugs related to h=
oles and
> > > > > > > > > Compressed data in btrfs, but it's new and not fixed yet-=
-hence,
> > > > > > > > > "2018 edition."
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Filipe David Manana,
> > > > > > >
> > > > > > > =E2=80=9CWhether you think you can, or you think you can't =
=E2=80=94 you're right.=E2=80=9D
> > > > > > >
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Filipe David Manana,
> > > > >
> > > > > =E2=80=9CWhether you think you can, or you think you can't =E2=80=
=94 you're right.=E2=80=9D
> > > > >
> > >
> > >
> > >
> > > --
> > > Filipe David Manana,
> > >
> > > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 =
you're right.=E2=80=9D
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D
>=20
>=20
>=20
> --=20
> Filipe David Manana,
>=20
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D
>=20

--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXGT16gAKCRCB+YsaVrMb
nOJ3AKC8vYM+beZWAkjU9q0gU2QiyAmF9QCfR/VONthRF0ou4M/YnZzy69WNhYc=
=s24z
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
