From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Synching a Backup Server
Date: Sun, 9 Jan 2011 20:54:48 +0700
Message-ID: <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061342.23991.CACook@quantum-sci.com>
	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
	<201101071720.08298.hka@qbs.com.pl>
	<4D29A033.7000803@chandlerfamily.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alan Chandler <alan@chandlerfamily.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D29A033.7000803@chandlerfamily.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 9, 2011 at 6:46 PM, Alan Chandler
<alan@chandlerfamily.org.uk> wrote:
>> then create snapshots of these directories:
>>
>> /mnt/btrfs/
>> =A0 =A0 =A0 =A0 |- server-a
>> =A0 =A0 =A0 =A0 |- server-b
>> =A0 =A0 =A0 =A0 |- server-c
>> =A0 =A0 =A0 =A0 |- snapshots-server-a
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|- @GMT-2010.12.21-16.48.09
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\- @GMT-2010.12.22-16.45.14
>> =A0 =A0 =A0 =A0 |- snapshots-server-b
>> =A0 =A0 =A0 =A0 \- snapshots-server-c

> For instance, if I create the initial file system using mkfs.btrfs an=
d then
> mount it on /mnt/btrfs is there already a default subvolume? =A0or do=
 I have
> to make one?

from btrfs FAQ:
"A subvolume is like a directory - it has a name, there's nothing on
it when it is created, and it can hold files and other directories.
There's at least one subvolume in every Btrfs filesystem, the
"default" subvolume.
The equivalent in Ext4 would be a filesystem. Each subvolume behaves
as a individual filesystem. "

>=A0What happens when you unmount the whole filesystem and then
> come back

whatever subvolume and snapshot you already have will still be there.

>
> The wiki also makes the following statement
>
> *"Note:* to be mounted the subvolume or snapshot have to be in the ro=
ot of
> the btrfs filesystem."
>
>
> but you seems to have snapshots at one layer down from the root.

By default, when you do something like

mount /dev/sdb1 /mnt/btrfs

the default subvolume will be mounted under /mnt/btrfs. Snapshots and
subvolumes will be visible as subdirectories under it, regardless
whether it's in the root or several directories under it. Most likely
this is enough for what you need, no need to mess with mounting
subvolumes.

Mounting subvolumes allows you to see a particular subvolume directly
WITHOUT having to see the default subvolume or other subvolumes. This
is particularly useful when you use btrfs as "/" or "/home" and want
to "rollback" to a previous snapshot. So assuming "snapshots-server-b"
above is a snapshot, you can run

mount /dev/sdb1 /mnt/btrfs -o subvol=3Dsnapshots-server-b

and what previously was in /mnt/btrfs/snapshots-server-b will now be
accessible under /mnt/btrfs directly, and you can NOT see what was
previously under /mnt/btrfs/snapshots-server-c.

Also on a side note, you CAN mount subvolumes not located in the root
of btrfs filesystem using "subvolid" instead of "subvol". It might
require a newer kernel/btrfs-progs version though (works fine in
Ubuntu maverick.)

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
