From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 13:52:25 -0800
Message-ID: <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<201101061342.23991.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061342.23991.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 1:42 PM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
> On Thu 06 January 2011 11:16:49 Freddie Cash wrote:
>> > Also with this system, I'm concerned that if there is corruption o=
n the HTPC, it could be propagated to the backup server. =C2=A0Is there=
 some way to address this? =C2=A0Longer intervals to sync, so I have a =
chance to discover?
>>
>> Using snapshots on the backup server allows you to go back in time t=
o
>> recover files that may have been accidentally deleted, or to recover
>> files that have been corrupted.
>
> How? =C2=A0I can see that rsync will not transfer the files that have=
 not changed, but I assume it transfers the changed ones. =C2=A0How can=
 you go back in time? =C2=A0Is there like a snapshot file that records =
the state of all files there?

I don't know the specifics of how it works in btrfs, but it should be
similar to how ZFS does it.  The gist of it is:

Each snapshot gives you a point-in-time view of the entire filesystem.
 Each snapshot can be mounted (ZFS is read-only; btrfs is read-only or
read-write).  So, you mount the snapshot for 2010-12-15 onto /mnt,
then cd to the directory you want (/mnt/htpc/home/fcash/videos/) and
copy the file out that you want to restore (cp coolvid.avi ~/).

With ZFS, things are nice and simple:
  - each filesystem has a .zfs/snapshot directory
  - in there are sub-directories, each named after the snapshot name
  - cd into the snapshot name, the OS auto-mounts the snapshot, and off=
 you go

Btrfs should be similar?  Don't know the specifics.

How it works internally, is some of the magic and the beauty of
Copy-on-Write filesystems.  :)
--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
