Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44956 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753363AbbA1Dqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 22:46:43 -0500
Date: Tue, 27 Jan 2015 22:46:38 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Stef Bon <stefbon@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Get the diff from a file in two snapshots.
Message-ID: <20150128034636.GA13452@hungrycats.org>
References: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
 <CAJCQCtRyv+m0kxBL6LW=xZv=sUzf2to4R6xPsxy6CkihHmrV0A@mail.gmail.com>
 <CANXojcxps7KPRC2dbfU7hFvUDzkK2CmT4EroDrO6HO56h7j3cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
In-Reply-To: <CANXojcxps7KPRC2dbfU7hFvUDzkK2CmT4EroDrO6HO56h7j3cg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 12:43:52AM +0100, Stef Bon wrote:
> 2015-01-26 22:14 GMT+01:00 Chris Murphy <lists@colorremedies.com>:
> >> is there a way to get the difference between these two files by making
> >> use of btrfs?
> >
> > Snapper has this functionality built into it. I'm not sure if it uses
> > diff or something else. But the Snapper GUI in yast2 on opensuse will
> > let you see what files have changed between snapshots, click on the
> > file and it shows a color coded diff.
>=20
> Hi Chris,
>=20
> I think (I'm not sure) it's using a high level tool like diff/rdiff.
>=20
> I will contact the developers of snapper anyway, since my project is
> simular to theirs.
>=20
> But what I'm asking is is there a lowlevel tool to give you a list of
> blocks where two versions
> of one file differ. I'm asking since btrfs keeps track of the blocks
> where files differ, and where they
> are the same.
>=20
> So a lowlevel call to the btrfs filesystem.

You could try the FIEMAP ioctl, which is not btrfs-specific.  The same
ioctl also works on e.g. ext4; however, since ext4 can't share blocks
between files and btrfs can, it's much more interesting on btrfs.  ;)

FIEMAP will give you a list of physical block ranges (btrfs logical
extent addresses).  Run it on both files and analyse the results.
Any blocks with the same physical addresses are trivially identical,
since they refer to the same physical storage.  If your system is full of
huge lightly modified files (e.g. VM images or large databases) that can
save you an awful lot of I/O because you'd only have to compare blocks
=66rom a pair of files if they had different physical addresses.

You can also look up blocks by logical address (see btrfs-tools 'inspect
logical-resolve') and find out what files they belong to.  This gives
you a "which files are similar to this one" sort of query, especially
after you've run dedup over the files in question.

> Stef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTIW5wACgkQgfmLGlazG5xYVQCgiQA+EYnur7G5vWbFPt33nEgo
WgAAn01BTZB5ljBpB5MZemtO6tbQ9c07
=7eQD
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
