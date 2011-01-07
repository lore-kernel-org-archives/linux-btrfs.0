From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Fri, 7 Jan 2011 17:20:08 +0100
Message-ID: <201101071720.08298.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061342.23991.CACook@quantum-sci.com> <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Carl Cook <CACook@quantum-sci.com>, linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 06, 2011 22:52:25 Freddie Cash wrote:
> On Thu, Jan 6, 2011 at 1:42 PM, Carl Cook <CACook@quantum-sci.com> wr=
ote:
> > On Thu 06 January 2011 11:16:49 Freddie Cash wrote:
> >> > Also with this system, I'm concerned that if there is corruption=
 on
> >> > the HTPC, it could be propagated to the backup server.  Is there=
 some
> >> > way to address this?  Longer intervals to sync, so I have a chan=
ce to
> >> > discover?
> >>=20
> >> Using snapshots on the backup server allows you to go back in time=
 to
> >> recover files that may have been accidentally deleted, or to recov=
er
> >> files that have been corrupted.
> >=20
> > How?  I can see that rsync will not transfer the files that have no=
t
> > changed, but I assume it transfers the changed ones.  How can you g=
o
> > back in time?  Is there like a snapshot file that records the state=
 of
> > all files there?
>=20
> I don't know the specifics of how it works in btrfs, but it should be
> similar to how ZFS does it.  The gist of it is:
>=20
> Each snapshot gives you a point-in-time view of the entire filesystem=
=2E
>  Each snapshot can be mounted (ZFS is read-only; btrfs is read-only o=
r
> read-write).  So, you mount the snapshot for 2010-12-15 onto /mnt,
> then cd to the directory you want (/mnt/htpc/home/fcash/videos/) and
> copy the file out that you want to restore (cp coolvid.avi ~/).
>=20
> With ZFS, things are nice and simple:
>   - each filesystem has a .zfs/snapshot directory
>   - in there are sub-directories, each named after the snapshot name
>   - cd into the snapshot name, the OS auto-mounts the snapshot, and o=
ff you
> go
>=20
> Btrfs should be similar?  Don't know the specifics.
>=20
> How it works internally, is some of the magic and the beauty of
> Copy-on-Write filesystems.  :)

I usually create subvolumes in btrfs root volume:

/mnt/btrfs/
        |- server-a
        |- server-b
        \- server-c

then create snapshots of these directories:

/mnt/btrfs/
        |- server-a
        |- server-b
        |- server-c
        |- snapshots-server-a
                 |- @GMT-2010.12.21-16.48.09
	            \- @GMT-2010.12.22-16.45.14
        |- snapshots-server-b
        \- snapshots-server-c

This way I can use the shadow_copy module for samba to publish the snap=
shots =20
to windows clients.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
