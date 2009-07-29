From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: BTRFS file clone support for cp
Date: Wed, 29 Jul 2009 19:14:37 +0100
Message-ID: <4A70918D.6020003@draigBrady.com>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com> <8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet> <4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet> <20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com> <20090729161014.GJ13940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	=?ISO-8859-1?Q?P=E1draig_Brad?= =?ISO-8859-1?Q?y?=
	<P@draigBrady.com>, Giuseppe Scrivano <gscrivano@gnu.org>,
	Jim Meyering <jim@meyering.net>, b
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090729161014.GJ13940@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wed, Jul 29, 2009 at 03:14:49PM +0100, P=E1draig Brady wrote:
>>
>> We may need to play around with fallocate()
>> if we want to get back to the original
>> cp semantics of actually allocating space
>> on the file system for the new file.
>=20
> Well, best to just use the original cp code.  I was talking with
> Giuseppe about this as well, I think we should the option to do regul=
ar
> cp via a flag.

Right. Well we can turn off this cloning by doing --sparse=3D{never,alw=
ays}
but that has side effects. If we need an option then maybe we should ha=
ve
it turn on cloning rather than restore default cp behaviour?
The side effects I thought of earlier, of COW without corresponding all=
ocation
were possible fragmentation on write or unexpected/mishandled ENOSPC.
Also for endangered mechanical disks, subsequent processing could
be slowed as the head seeks between the old and new data to be copied.
Perhaps these are a small price to pay, especially considering that
solid state disks will only be affected by the write()=3DENOSPC issue.

At the moment we have these linking options:

cp -l, --link #for hardlinks
cp -s, --symbolic-link #for symlinks

So perhaps we should support:

cp --link=3D{soft,hard,cow}
for symlink(), link() and reflink() respectively?
I.E. link to the name, inode or extents respectively.

> There will soon be a reflink system call that can be used on ocfs2 an=
d
> btrfs as well.  Thanks for adding this to glibc!

I was thinking there would be a generic syscall for this.
So cp should call reflink() instead when it becomes available.

thanks for the info!
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
