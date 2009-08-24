From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: The first character disappears
Date: Mon, 24 Aug 2009 08:17:21 +0300
Message-ID: <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

After bcp the first character disappears.
Kernel:=A0 2.6.31-rc7
Btrfs v0.19-1-g4f89b6e


Way to reproduce:

htpc ~ # lvm lvcreate -L 5G -n btrfs_test /dev/vg_md1
=A0 Logical volume "btrfs_test" created

htpc ~ # mkbtrfs /dev/mapper/vg_md1-btrfs_test

WARNING! - Btrfs v0.19-1-g4f89b6e IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/mapper/vg_md1-btrfs_test
=A0=A0=A0=A0=A0=A0=A0 nodesize 4096 leafsize 4096 sectorsize 4096 size =
5.00GB
Btrfs v0.19-1-g4f89b6e

mount -t btrfs -o subvol=3D. /dev/mapper/vg_md1-btrfs_test /tmp/btrfs/

htpc ~ # btrfsctl -S test /tmp/btrfs/
operation complete
Btrfs v0.19-1-g4f89b6e

htpc ~ # cd /tmp/btrfs/test/

htpc test # git clone /usr/src/linux-2.6/
Initialized empty Git repository in /tmp/btrfs/test/linux-2.6/.git/
Checking out files: 100% (29110/29110), done.

htpc test # btrfs-bcp linux-2.6/ linux-2.6_copy
htpc test # ls -la linux-2.6_copy/
total 350
drwxr-xr-x 1 root root=A0=A0=A0 324 Aug 24 07:53 .
drwx------ 1 root root=A0=A0=A0=A0 46 Aug 24 07:53 ..
-rw-r--r-- 1 root root 152148 Aug 24 07:53 AINTAINERS
-rw-r--r-- 1 root root=A0 17459 Aug 24 07:53 EADME
-rw-r--r-- 1 root root=A0=A0 3371 Aug 24 07:53 EPORTING-BUGS
-rw-r--r-- 1 root root=A0 18693 Aug 24 07:53 OPYING
-rw-r--r-- 1 root root=A0 94027 Aug 24 07:53 REDITS
-rw-r--r-- 1 root root=A0 55145 Aug 24 07:53 akefile
drwxr-xr-x 1 root root=A0=A0=A0 118 Aug 24 07:54 amples
=2E...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
