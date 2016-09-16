Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xkh98.infr.xiaoka.com ([78.47.138.98]:46750 "EHLO
        xkh98.infr.xiaoka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965204AbcIPUzZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 16:55:25 -0400
Received: from host-109-233-89-149.jmdi.pl ([109.233.89.149] helo=lair.home.lan)
        by xkh98.infr.xiaoka.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <tomek@xiaoka.com>)
        id 1bkzkA-0004p7-AC
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 22:28:18 +0200
Message-ID: <1474057691.16275.16.camel@xiaoka.com>
Subject: stat(2) returning device ID not existing in mountinfo
From: Tomasz Sterna <tomek@xiaoka.com>
To: linux-btrfs@vger.kernel.org
Date: Fri, 16 Sep 2016 22:28:11 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-C1B6ND+3rhKI2+1bXgwn"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-C1B6ND+3rhKI2+1bXgwn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

I have spotted an issue with stat(2) call on files on btrfs.
It is giving me=C2=A0dev_t st_dev number that does not correspond to any
mounted filesystem in proc's mountinfo.

A quick example:

$ grep btrfs /proc/self/mountinfo=C2=A0
61 0 0:36 /root / rw,relatime shared:1 - btrfs /dev/bcache0 rw,ssd,space_ca=
che,subvolid=3D535,subvol=3D/root
75 61 0:36 /home /home rw,relatime shared:30 - btrfs /dev/bcache0 rw,ssd,sp=
ace_cache,subvolid=3D258,subvol=3D/home

As you can see both btrfs subvolumes are 0:36, but files on these:

$ stat -c "%d" /etc/passwd
38
$ stat -c "%d" /home/smoku/test.txt
44

Passing these through major(3)/minor(3) give: 0:38 and 0:44

There is clearly something fishy going on. :-)
Simple one-liner shows that only btrfs and autofs misbehave like this:

$ </proc/self/mountinfo cut -d' ' -f3,5,9 | while read DEV PATH FS; do echo=
 $DEV $(/usr/bin/stat -c "%d" $PATH) $FS; done
0:16 16 sysfs
0:4 4 proc
0:6 6 devtmpfs
0:17 17 securityfs
0:18 18 tmpfs
0:19 19 devpts
0:20 20 tmpfs
0:21 21 tmpfs
0:22 22 cgroup
0:23 23 pstore
0:24 24 efivarfs
0:25 25 cgroup
0:26 26 cgroup
0:27 27 cgroup
0:28 28 cgroup
0:29 29 cgroup
0:30 30 cgroup
0:31 31 cgroup
0:32 32 cgroup
0:33 33 cgroup
0:34 34 cgroup
0:35 35 configfs
0:36 38 btrfs
0:15 15 hugetlbfs
0:39 68 autofs
0:14 14 mqueue
0:40 40 tmpfs
0:7 7 debugfs
0:42 42 nfsd
0:36 44 btrfs
8:2 2050 ext3
8:1 2049 vfat
0:47 47 rpc_pipefs
0:50 50 fusectl
0:51 51 tmpfs
0:49 49 fuse.gvfsd-fuse
0:68 68 binfmt_misc


I already attempted a illinformed-patch in=C2=A0fs/btrfs/super.c:

@@ -1127,6 +1127,7 @@ static int btrfs_fill_super(struct super_block *sb,
=C2=A0		goto fail_close;
=C2=A0	}
=C2=A0
+	sb->s_dev =3D inode->i_sb->s_dev;
=C2=A0	sb->s_root =3D d_make_root(inode);
=C2=A0	if (!sb->s_root) {
=C2=A0		err =3D -ENOMEM;

but it didn't help.

I would like to dig deeper and fix it, but first I have to ask:
- Which number is wrong?
=C2=A0 The one returned by stat() or the one in mountinfo?

I am running:

$ uname -a
Linux lair.home.lan 4.7.3-200.pf3.fc24.x86_64 #1 SMP Tue Sep 13 12:34:03 CE=
ST 2016 x86_64 x86_64 x86_64 GNU/Linux



--=20
smoku @ http://abadcafe.pl/ @ http://xiaoka.com/
--=-C1B6ND+3rhKI2+1bXgwn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX3FXbAAoJEMbh7DlLbipiwJAH/R4AT3Lq28vYVlLUxfplwUlc
o43Nl0QdSjbBzz9v/q9edny3f7TX/nyFYbAgo6N+DxINrFIbAAS4LHpii4He+E4E
EYUgupMKBb8KKdnIH46Tcx/jVWd8+Ms3qsivGvKkKOYNkwmTBCP/fEX7NP/ra5wA
cFaHjEhtVS4aSNDe3hql9MdsCq3d/FqUteaGwmkwcuAHzaNiY28r36ADL5TpnSjd
CjnhowVDoCVr8ckkTaeHIaaqzWfobZ2iAqURIKVw0hMMore9Z66IC+Pbxm9FMlVq
fQCvR1OsKvZKCOOEjgCsa7+TTQRbKfRPA5q9Wg6LE2gVokjSJW5JhdP7+UQMMnI=
=I4uW
-----END PGP SIGNATURE-----

--=-C1B6ND+3rhKI2+1bXgwn--

