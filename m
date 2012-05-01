From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Create subvolume from a directory?
Date: Tue, 01 May 2012 19:09:21 +0200
Message-ID: <8026880.aVIK1HJLHr@bursa01>
References: <loom.20120327T190041-268@post.gmane.org> <4F734250.5030009@libero.it> <4F73B9DC.3040402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: kreijack@inwind.it, "Matthias G. Eckermann" <mge@suse.com>,
	Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F73B9DC.3040402@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 29 of March 2012 09:24:44 Liu Bo wrote:
> On 03/29/2012 12:54 AM, Goffredo Baroncelli wrote:
> > Could you elaborate which would be the issue ?
> > "cp --reflink"-ing a file is not different than snapshotting a file=
=2E In
> > any case I could mount a snapshot and not the source subvolume.
>=20
> We already have a debate about this "cross-link device":
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/9864
>=20
> "cp --reflink" will use clone feature, which can share data among fil=
es, but
> metadata is preserved individually.
>=20
> My case is that I can mount both a subvolume and a snapshot via "-o
> subvol=3Dxxx" or "-o subvolid=3Dxxx".

And how is this different from regular snapshot of subvolume? In the en=
d you=20
get two files pointing to same data on the disk while having different=20
metadata.

Let me rephrase it:

People don't want to be able to do:

mount /dev/lvm/btrfs /mnt/a -t btrfs -o subvol=3DvolA
mount /dev/lvm/btrfs /mnt/b -t btrfs -o subvol=3DvolB
cp --reflink=3Dalways /mnt/a/file /mnt/b

Just like you can't do hardlinks over `mount --bind` mountpoints, you=20
shouldn't be able to cp reflink over mountpoints. That's expected as th=
is=20
*does* break VFS semantics.

*But* people want to be able to do this:=20

mount /dev/lvm/btrfs /mnt/ -t btrfs
btrfs subvol create /mnt/subvol
big-file-creator > /mnt/subvol/BIG-file
btrfs subvol snapshot /mnt/subvol /mnt/subvol-bak
big-file-editor /mnt/subvol/BIG-file
rm /mnt/subvol-bak/BIG-file
cp --reflink=3Dalways /mnt/subvol/BIG-file /mnt/subvol-bak/BIG-file

This does not cross any VFS boundaries.

Regards,
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
