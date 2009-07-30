From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: BTRFS file clone support for cp
Date: Wed, 29 Jul 2009 17:57:03 -0700
Message-ID: <20090730005702.GA32157@mail.oracle.com>
References: <87d47o3fip.fsf@master.homenet>
 <4A6CEA48.5050208@draigBrady.com>
 <8763defuvq.fsf@meyering.net>
 <87ws5tvrq8.fsf@master.homenet>
 <4A6E3ADE.6050008@draigBrady.com>
 <8763dcvagk.fsf@master.homenet>
 <20090729130106.GF13940@think>
 <4A705959.7010303@draigBrady.com>
 <20090729161014.GJ13940@think>
 <4A70918D.6020003@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Jim Meyering <jim@meyering.net>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A70918D.6020003@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2009 at 07:14:37PM +0100, P=E1draig Brady wrote:
> Chris Mason wrote:
> > On Wed, Jul 29, 2009 at 03:14:49PM +0100, P=E1draig Brady wrote:
> >>
> >> We may need to play around with fallocate()
> >> if we want to get back to the original
> >> cp semantics of actually allocating space
> >> on the file system for the new file.
> >
> > Well, best to just use the original cp code.  I was talking with
> > Giuseppe about this as well, I think we should the option to do reg=
ular
> > cp via a flag.
>=20
> Right. Well we can turn off this cloning by doing --sparse=3D{never,a=
lways}
> but that has side effects. If we need an option then maybe we should =
have
> it turn on cloning rather than restore default cp behaviour?
> The side effects I thought of earlier, of COW without corresponding a=
llocation
> were possible fragmentation on write or unexpected/mishandled ENOSPC.
> Also for endangered mechanical disks, subsequent processing could
> be slowed as the head seeks between the old and new data to be copied=
=2E
> Perhaps these are a small price to pay, especially considering that
> solid state disks will only be affected by the write()=3DENOSPC issue=
=2E
>=20
> At the moment we have these linking options:
>=20
> cp -l, --link #for hardlinks
> cp -s, --symbolic-link #for symlinks
>=20
> So perhaps we should support:
>=20
> cp --link=3D{soft,hard,cow}
> for symlink(), link() and reflink() respectively?
> I.E. link to the name, inode or extents respectively.

	I've cooked up 'ln -r' for reflinks, which works for ln(1) but
not for cp(1).  I have a git tree with the (in-flux) code on
oss.oracle.com:

[View]
http://oss.oracle.com/git/?p=3Djlbec/reflink.git;a=3Dsummary
[Pull]
git://oss.oracle.com/git/jlbec/reflink.git master

	This repository isn't designed to be an authorative patch for
coreutils.  Instead it provides a reflink(1) program that is actually l=
n
-r in disguise.  Later work would be to get coreutils updated
"properly".

Joel

--=20

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
