Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE149C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 05:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC66A21927
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 05:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfBOFks (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 00:40:48 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47872 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbfBOFks (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 00:40:48 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id CE30B21FA2D; Fri, 15 Feb 2019 00:40:46 -0500 (EST)
Date:   Fri, 15 Feb 2019 00:40:45 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190215054031.GC9995@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
 <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
 <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2019 at 01:21:29PM +0100, Christoph Anton Mitterer wrote:
> On Thu, 2019-02-14 at 01:22 +0000, Filipe Manana wrote:
> > The following one liner fixes it:
> > https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3
>=20
> Great to see that fixed... is there any advise that can be given for
> users/admins?
>=20
>=20
> Like whether and how any occurred corruptions can be detected (right
> now, people may still have backups)?

The problem occurs only on reads.  Data that is written to disk will
be OK, and can be read correctly by a fixed kernel.

A kernel without the fix will give corrupt data on reads with no
indication of corruption other than the changes to the data itself.

Applications that copy data may read corrupted data and write it back
to the filesystem.  This will make the corruption permanent in the
copied data.

Given the age of the bug, backups that can be corrupted by this bug
probably already are.  Verify files against internal CRC/hashes where
possible.  The original files are likely to be OK, since the bug does
not affect writes.  If your situation has the risk factors listed below,
it may be worthwhile to create a fresh set of non-incremental backups
after applying the kernel fix.

> Or under which exact circumstances did the corruption happen? And under
> which was one safe?

Compression is required to trigger the bug, so you are safe if you (or
the applications you run) never enabled filesystem compression.  Even if
compression is enabled, the file data must be compressed for the bug to
corrupt it.  Incompressible data extents will never be affected by
this bug.

If you do use compression, you are still safe if:

	- you never punch holes in files

	- you never dedupe or clone files

If you do use compression and do the other things, the probability of
corruption by this particular bug is non-zero.  Whether you get corruption
and how often depends on the technical details of what you're doing.

To get corruption you have to have one data extent that is split in
two parts by punching a hole, or an extent that is cloned/deduped in
two parts to adjacent logical offsets in the same file.  Both of these
methods create the pattern on disk which triggers the bug.

Files that consist entirely of unique data will not be affected by dedupe
so will not trigger the bug that way.  Files that consist partially of
unique data may or may not be affected depending on the dedupe tool,
data alignment, etc.

> E.g. only on specific compression algos (I've been using -o compress
> (which should be zlib) for quite a while but never found any

All decompress algorithms are affected.  The bug is in the generic btrfs
decompression handling, so it is not limited to any single algorithm.

Compression (i.e. writing) is not affected--whatever data is written to
disk should be readable correctly with a fixed kernel.

> compression),... or only when specific file operations were done (I did
> e.g. cp with refcopy, but I think none of the standard tools does hole-
> punching)?

That depends on whether you consider fallocate or qemu to be standard
tools.  The hole-punching function has been a feature of several Linux
filesystems for some years now, so we can expect it to be more widely
adopted over time.  You'd have to do an audit to be sure none of the
tools you use are punching holes.

"Ordinary" sparse files (made by seeking forward while writing, as done
by older Unix utilities including cp, tar, rsync, cpio, binutils) do not
trigger this bug.  An ordinary sparse file has two distinct data extents
=66rom two different writes separated by a hole which has never contained
file data.  A punched hole splits an existing single data extent into two
pieces with a newly created hole between them that replaces previously
existing file data.  These actions create different extent reference
patterns and only the hole-punching one is affected by the bug.

Files that contain no blocks full of zeros will not be affected by
fallocate-d-style hole punching (it searches for existing zeros and
punches holes over them--no zeros, no holes).  If the the hole punching
intentionally introduces zeros where zeros did not exist before (e.g. qemu
discard operations on raw image files) then it may trigger the bug.

btrfs send and receive may be affected, but I don't use them so I don't
have any experience of the bug related to these tools.  It seems from
reading the btrfs receive code that it lacks any code capable of punching
a hole, but I'm only doing a quick search for words like "punch", not
a detailed code analysis.

bees continues to be an awesome tool for discovering btrfs kernel bugs.
It compresses, dedupes, *and* punches holes.

>=20
> Cheers,
> Chris.
>=20

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXGZQyAAKCRCB+YsaVrMb
nE9hAKC3w7WHTrhph63rnpbHYhZAcB0bFQCfagiMpSPguD7QYHykiiTXoVBbfbA=
=r2Xw
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
