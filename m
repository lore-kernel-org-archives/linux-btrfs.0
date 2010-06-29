From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Tue, 29 Jun 2010 18:34:13 +0200
Message-ID: <201006291834.13488.hka@qbs.com.pl>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net> <AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com> <AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "Rodrigo E. De =?iso-8859-1?q?Le=F3n?= Plicet" <rdeleonp@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 29 June 2010 12:37:45 Daniel Kozlowski wrote:
> On Mon, Jun 28, 2010 at 10:31 PM, Rodrigo E. De Le=F3n Plicet
>=20
> <rdeleonp@gmail.com> wrote:
> > On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
> >=20
> > <dan.kozlowski@gmail.com> wrote:
> >> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
> >>> > Is there a more aggressive filesystem restorer than btrfsck?  I=
t
> >>> > simply gives up immediately with the following error:
> >>> >=20
> >>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion
> >>> > `!(!tree_root->node)' failed.
> >>>=20
> >>> btrfsck currently only checks whether a filesystem is consistent.=
 It
> >>> doesn't try to perform any recovery or error correction at all, s=
o it's
> >>> mostly useful to developers. Any error handling occurs while the
> >>> filesystem is mounted.
> >>=20
> >> Is there any plan to implement this functionality. It would seem t=
o me
> >> to be a pretty basic feature that is missing ?
> >=20
> > If Btrfs aims to be at least half of what ZFS is, then it will not
> > impose a need for fsck at all.
> >=20
> > Read "No, ZFS really doesn't need a fsck" at the following URL:
> >=20
> > http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-=
fsck.h
> > tml
>=20
> Interesting idea. it would seem to me however that the functionality
> described in that article is more concerned with a bad transaction
> rather then something like a hardware failure where a block written
> more then 128 transactions ago is now corrupted and consiquently the
> entire partition is now unmountable( that is what I think i am lookin=
g
> at with BTRFS )

Still, the FS alone should be able to recover from such situations. Wit=
h=20
multiple superblocks the probability that the fs is unmountable is very=
 small
and if all superblocks are corrupted then you need a data recovery pror=
gram,=20
not fsck.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
