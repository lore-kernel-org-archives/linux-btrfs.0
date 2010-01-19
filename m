From: d binderman <dcb314@hotmail.com>
Subject: static analysis tool cppcheck meets the btrfs code - four issues
Date: Tue, 19 Jan 2010 13:18:04 +0000
Message-ID: <BLU108-W91E576564C5751190B2C59C650@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



Hello there,

I just ran the sourceforge tool cppcheck over the source code of the
new Linux kernel 2.6.32.4

It said

1.

[./btrfs/free-space-cache.c:600]: (style) Redundant condition. It is sa=
fe to deallocate a NULL pointer

The source code is

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (info->bitmap)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 k=
free(info->bitmap);

I agree with cppcheck. Suggest delete the if test.

2.

[./btrfs/free-space-cache.c:906]: (style) Redundant condition. It is sa=
fe to deallocate a NULL pointer

Duplicate.
3.

[./btrfs/relocation.c:3278]: (error) Memory leak: cluster

The source code is

=A0=A0=A0=A0=A0=A0=A0 cluster =3D kzalloc(sizeof(*cluster), GFP_NOFS);
=A0=A0=A0=A0=A0=A0=A0 if (!cluster)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;

=A0=A0=A0=A0=A0=A0=A0 path =3D btrfs_alloc_path();
=A0=A0=A0=A0=A0=A0=A0 if (!path)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;

Suggest new code

=A0=A0=A0=A0=A0=A0=A0 cluster =3D kzalloc(sizeof(*cluster), GFP_NOFS);
=A0=A0=A0=A0=A0=A0=A0 if (!cluster)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;

=A0=A0=A0=A0=A0=A0=A0 path =3D btrfs_alloc_path();
=A0=A0=A0=A0=A0=A0=A0 if (!path)
=A0=A0=A0=A0=A0=A0=A0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kfree( cluster);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
=A0=A0=A0=A0=A0=A0=A0 }

4.

[./btrfs/volumes.c:1257]: (error) Possible null pointer dereference: fs=
_devices

The source code is

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (fs_devices) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (fs_devices->seed =3D=3D device->fs_devices)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
s_devices =3D fs_devices->seed;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fs_devices->seed =3D devi=
ce->fs_devices->seed;

So presumably fs_devices can never be NULL i.e. the while loop will
always find what it is looking for and so no code to test for NULL is
required.


Regards

David Binderman


 		 	   		 =20
_________________________________________________________________
Do you have a story that started on Hotmail? Tell us now
http://clk.atdmt.com/UKM/go/195013117/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
