From: Bryce Myers <bmyers@ceradyne.com>
Subject: BTRFS Duplicated UUID on /home
Date: Mon, 25 Jul 2011 08:10:25 -0400
Message-ID: <4A4056E2BAF08843A2EC20D92A2136321572C78FE4@exch01lex.ceradyne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have 4 partitions on my hard drive
1 =3D /boot on ext2
2 =3D Swap
3 =3D / on brtfs
4 =3D /home on btrfs

The uuid on partition 3 on my last boot was cloned to partition 4, so w=
hen I try to mount either 3 or 4 they both mount the / partition.

We tried 7182011 git, and the current version in the ARCH 1062010, and =
neither had an option for resetting the UUID that we could find.=A0 Bot=
h partitions were btrfsck'd and returned no errors.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
