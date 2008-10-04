From: Martin =?utf-8?q?B=C3=BCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: space info full
Date: Sat, 4 Oct 2008 09:45:55 +0200
Message-ID: <200810040945.56118.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
'space info full' was the only message I got from dmesg. df reports:

/dev/sdb1             33551720  28504548   5047172 =20
85% /mnt/btrfstest

df -i reports:
/dev/sdb1                  0       0       0    -  /mnt/btrfstest

Any (e.g., touch, rm) operation on that mounted filesystem lets the=20
CPU rise and the system hang...

I was filling up the partition with compilebench to the ration=20
mentioned above. During this process I tried to create a subvolume=20
with
	btrfsctl -s sub_vol /mnt/btrfstest
which did not, as opposed to the advices from the INSTALL file,=20
create anything within /mnt/btrfstest.

Regards,
--=20
Martin B=C3=BCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
