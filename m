Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35162 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbKNEid (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 23:38:33 -0500
Received: by pacej9 with SMTP id ej9so12645480pac.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 20:38:32 -0800 (PST)
Received: from paragon (ppp221-242.static.internode.on.net. [150.101.221.242])
        by smtp.googlemail.com with ESMTPSA id pb9sm12962487pac.38.2015.11.13.20.38.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 13 Nov 2015 20:38:32 -0800 (PST)
Message-ID: <1447475897.1804.5.camel@gmail.com>
Subject: Btrfs device initialisation is quite slow
From: Robbie Smith <zoqaeski@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Sat, 14 Nov 2015 15:38:17 +1100
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-6pnT5WXY0drntTBZh88+"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-6pnT5WXY0drntTBZh88+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey all

I've been trying to figure out why my system (home desktop) is taking
so long to boot. Systemd-analyze tells me that my root filesystem
partition (which is btrfs) takes ~11 seconds to become active, and I'm
curious as to why and whether or not I can optimise this.

The primary disk has 4 partitions: a EFI/BIOS boot partion (for GRUB);
a /boot partition (ext4); a swap partition; and the root partition. The
disk itself is not particularly large (320 GB), and I'm using
subvolumes to emulate partitions in btrfs. There are three top-level
subvolumes, for /, /home, and /var, none of which have quotas, and I'm
not at present doing snapshots because I backup every day to an
external drive formatted with ext4.=C2=A0

I've got a second 5 TB drive for multimedia that is also btrfs, but it
only takes ~3 seconds to come online. I had been using a number of bind
mounts from the multimedia drive to my home folder, so that $HOME/music
and $HOME/videos point to the library, and replacing them with symlinks
reduced the time by ~3 seconds, but it still doesn't account for why
the root device takes so long.

My fstab contains the following:

# /dev/sdc4 LABEL=3Dfilesystem
UUID=3D4ec80601-4799-4fa8-a711-0171c180f25b /
btrfs rw,noatime,space_cache,autodefrag,subvol=3Drootvol 0 0

# /dev/sdc4 LABEL=3Dfilesystem
UUID=3D4ec80601-4799-4fa8-a711-0171c180f25b /home btrfs rw,noatime,space_ca=
che,autodefrag,subvol=3Dhomevol 0 0

# /dev/sdc4 LABEL=3Dfilesystem
UUID=3D4ec80601-4799-4fa8-a711-0171c180f25b /var btrfs rw,noatime,space_cac=
he,autodefrag,subvol=3Dvar 0 0

# /dev/sdc2 LABEL=3Dboot
UUID=3Dca281471-0aac-4090-8660-33b8b9fee5a3 /boot ext4 rw,relatime,data=3Do=
rdered 0 2

# /dev/sdb1 LABEL=3Dlibrary
UUID=3D97226949-50e0-4a78-899e-863f5b436bcc /mnt/library btrfs rw,noatime,s=
pace_cache,autodefrag 0 0


Can anyone offer any insights or advice?
--=-6pnT5WXY0drntTBZh88+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCQAGBQJWRrq5AAoJEBbf8fhhZEOHdRIQAJ64lbeYACgK9qDjoYkgLH7g
pcDluCLG+R98NmrrZGjOnxpJfDG6LsJ8yV3nhY0M5bDzcocv9+PYjTMyC5Bpx3uM
7FPsj1sg4BVXEtKnIx3YxKXwA2z2Hm7vAXpWsYE06a4eGb8FTIkHjy17hDE+Kztn
JcSgwvCcYsP5n4B9piD20MSXoMWS9w7hYxTH4faobzn4izoBbBpItUMjk4OqrL69
FCdOxtUOmGdcdsu8/Gi2O14IQzgpr7ksZM3e5+ifVWvXsMf+ZkbnXBEw8n99nV+s
QMcnRsG0f5mAWPkThML1hcFlEC8bcnfQ6fEvJutw9zrUKO7LPVACshnLNybJKf8x
J4AIUZEEMXi3C5pWhffT0weGXkSwc7lotEEHdQZKvYnN4wIK7gtJF0P69mJDkiU0
BreDN24d9Tz5VXkTy9y7zRPjJO54zzODXCEUte1zIzM5YCBFRWUaD74sWkzN14gW
XQxzZObfd+r9RHmC1FEHDCtjNhOlyZas5+PONNzZ+hNtqasK+j8qzV7nHToNiKK2
suMTaegwXSqVDJU5KsThe7SQT/gw4JX6GwDVUnC/I8PMS/JBrh0gXkHVxYY7MzMZ
m/qv9xg5VarDV32yTHZNxZe7UAa2YY8uXGYev9tka8eWxqno4FgusbgMCSCsQmBz
2xXF4sEXcl/R6AB3317g
=foxw
-----END PGP SIGNATURE-----

--=-6pnT5WXY0drntTBZh88+--

