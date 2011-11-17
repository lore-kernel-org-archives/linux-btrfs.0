From: "Thomas Schmidt" <Schmidt-T@gmx.de>
Subject: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 01:27:34 +0100
Message-ID: <20111117002734.70530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I wrote a small patch to improve allocation on differently sized raid d=
evices.

With 2.6.38 I frequently ran into a no space left error that I attribut=
e to
this. But I'm not entierly sure. The fs was an 8 device -d raid0 -m rai=
d10.
The used space was the same across all devices. 5 were full and 3 bigge=
r ones still had plenty of space.
I was unable to use the remaning space and a balance did not fix it for
long.

Now I tried to avoid getting there again.

The basic idea to not allocate space on the devices with the least free
space. The amount of devices to leave out is calculated on each allocat=
ion
to ajust to changing circumstances. It leaves the minimum number that s=
till
can achieve full space usage.

Additionally I tought leaving at least one out might be of use in devic=
e removal.

Please take extra care with this. I'm new to btrfs, kernel and C in gen=
eral.
It was written and tested with 3.0.0.


--- volumes.c.orig      2011-10-07 16:50:04.000000000 +0200
+++ volumes.c   2011-11-16 23:49:08.097085568 +0100
@@ -2329,6 +2329,8 @@ static int __btrfs_alloc_chunk(struct bt
        u64 stripe_size;
        u64 num_bytes;
        int ndevs;
+       u64 fs_total_avail;
+       int opt_ndevs;
        int i;
        int j;
=20
@@ -2404,6 +2406,7 @@ static int __btrfs_alloc_chunk(struct bt
         * about the available holes on each device.
         */
        ndevs =3D 0;
+       fs_total_avail =3D 0;
        while (cur !=3D &fs_devices->alloc_list) {
                struct btrfs_device *device;
                u64 max_avail;
@@ -2448,6 +2451,7 @@ static int __btrfs_alloc_chunk(struct bt
                devices_info[ndevs].total_avail =3D total_avail;
                devices_info[ndevs].dev =3D device;
                ++ndevs;
+               fs_total_avail +=3D total_avail;
        }
=20
        /*
@@ -2456,6 +2460,20 @@ static int __btrfs_alloc_chunk(struct bt
        sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
             btrfs_cmp_device_info, NULL);
=20
+       /*
+        * do not allocate space on all devices
+        * instead balance free space to maximise space utilization
+        * (this needs tweaking if parity raid gets implemented
+        * for n parity ignore the n first (after sort) devs in the sum=
 and division)
+        */
+       opt_ndevs =3D fs_total_avail / devices_info[0].total_avail;
+       if (opt_ndevs >=3D ndevs)
+               opt_ndevs =3D ndevs - 1; //optional, might be used for =
faster dev remove?
+       if (opt_ndevs < devs_min)
+               opt_ndevs =3D devs_min;
+       if (ndevs > opt_ndevs)
+               ndevs =3D opt_ndevs;
+
        /* round down to number of usable stripes */
        ndevs -=3D ndevs % devs_increment;

--=20
NEU: FreePhone - 0ct/min Handyspartarif mit Geld-zur=C3=BCck-Garantie!	=
=09
Jetzt informieren: http://www.gmx.net/de/go/freephone
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
