From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH v2]btrfs: Update existing btrfs_device for renaming device
Date: Tue, 09 Feb 2010 15:36:45 +0900
Message-ID: <4B71027D.8080600@jp.fujitsu.com>
References: <69e11d1f0911071341n4c0a845ds7bbf5d64b039d8f@mail.gmail.com> <69e11d1f0911071344n7c059bd3o53896f4e8982e20b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: gjalves@gjalves.com.br
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <69e11d1f0911071344n7c059bd3o53896f4e8982e20b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates device name in btrfs device information.
We can mount a device if its name are changed.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 fs/btrfs/volumes.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/fs/btrfs/volumes.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/fs/btrfs/volumes.c	2010-02-09 12:11:33.000000000 +0900
+++ b/fs/btrfs/volumes.c	2010-02-09 13:54:39.000000000 +0900
@@ -365,6 +365,7 @@ static noinline int device_list_add(cons
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	u64 found_transid =3D btrfs_super_generation(disk_super);
+	char *name;

 	fs_devices =3D find_fsid(disk_super->fsid);
 	if (!fs_devices) {
@@ -411,6 +412,12 @@ static noinline int device_list_add(cons

 		device->fs_devices =3D fs_devices;
 		fs_devices->num_devices++;
+	} else if (strcmp(device->name, path)) {
+		name =3D kstrdup(path, GFP_NOFS);
+		if (!name)
+			return -ENOMEM;
+		kfree(device->name);
+		device->name =3D name;
 	}

 	if (found_transid > fs_devices->latest_trans) {



(2009/11/08 6:44), Gustavo Alves wrote:
> Hi Chris,
>=20
> I found the same problem on 2.6.32-0.33.rc5.git1 with btrfs-progs
> 0.19. This problem is already fixed?
>=20
> Thanks
>=20
> ----
> Gustavo Junior Alves
> Specchio Solu=E7=F5es em TI
> http://specchio.inf.br
> Tel: +55 19 9223-0500
>=20
>=20
>> From: Chris Mason <chris.mason_=E4t_oracle.com>
>> Date: Tue, 07 Apr 2009 07:35:56 -0400
>>
>> On Mon, 2009-04-06 at 18:41 +0100, Hugo Mills wrote:
>>> There seems to be some issue over changing the names of the device
>>> that a btrfs filesystem lives on:
>>>
>>> # lvcreate scratch -n fstest -L 2G
>>> Logical volume "fstest" created
>>> # mkfs -t btrfs /dev/scratch/fstest
>>>
>>> WARNING! - Btrfs v0.18-ge3b0f66 IS EXPERIMENTAL
>>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>>
>>> fs created label (null) on /dev/scratch/fs1
>>> nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
>>> Btrfs v0.18-ge3b0f66
>>>
>>> # mount /dev/scratch/fstest /mnt
>>> # umount /mnt
>>>
>>> # lvrename scratch fstest derek
>>> Renamed "fstest" to "derek" in volume group "scratch"
>>> # mount /dev/scratch/derek /mnt
>>> mount: /dev/mapper/scratch-derek: can't read superblock
>>>
>>> # lvrename scratch derek fstest
>>> Renamed "derek" to "fstest" in volume group "scratch"
>>> # mount /dev/scratch/fstest /mnt
>>> [success]
>>>
>>> The rename works properly on a completely virgin filesystem, but
>>> not on one that's been mounted and unmounted (as above).
>>
>> Whoops, we need to reset the pathname when a probe finds a given dev
>> uuid on a given device. I'll patch it up when I get back next week.
>>
>> Thanks for this bug report.
>>
>> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
taruisi

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
