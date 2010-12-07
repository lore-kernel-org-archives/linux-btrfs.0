From: Chris Mason <chris.mason@oracle.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Tue, 07 Dec 2010 14:29:26 -0500
Message-ID: <1291750008-sup-1758@think>
References: <4CFDE978.9050407@jp.fujitsu.com> <1291743093-sup-2051@think> <AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mike Fedyk's message of 2010-12-07 14:16:55 -0500:
> On Tue, Dec 7, 2010 at 10:44 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > Excerpts from Tsutomu Itoh's message of 2010-12-07 02:59:52 -0500:
> >> Hi,
> >>
> >> I think that the disk allocation size of each file becomes a monot=
one increase
> >> when the file is made.
> >> But, it sometimes return to 0. =C2=A0Is it correct?
> >
> > Well, there's a window during the processing of delayed allocation =
where
> > we don't have the bytes recorded as delalloc and we don't have the =
bytes
> > recorded in the inode yet. =C2=A0That's why they are showing up as =
zero.
> >
> > We don't call inode_add_bytes() until after we insert the extent, b=
ut we
> > drop the delalloc byte count on the file before the IO is done.
> >
> > Fixing it will be a little tricky because all the extent accounting
> > assumes the inode_add_bytes happens at extent insertion time.
> >
>=20
> How does opening the inode with O_APPEND during this window know wher=
e
> to write the bytes?  If it's a pointer/cursor to the EOF then that
> size could be used during the window.  Is that right?

This counter records the number of blocks allocated to the file, and
reading it with ls -l or stat is somewhat racey by nature.  Most of the
time its fine, btrfs just has a really big window where the results fro=
m
ls -l seem wrong.

But, the counter really means nothing to the btrfs internals.  When we
do file operations we go based on the extent pointers we find in the
tree and i_size (i_size is strictly maintained).

The incorrect results are confusing but they don't hurt the metadata
itself.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
