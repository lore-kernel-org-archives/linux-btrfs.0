From: Hubert Kario <hka@qbs.com.pl>
Subject: Creation time
Date: Sun, 14 Mar 2010 02:55:12 +0100
Message-ID: <201003140255.13309.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

=46rom what I could find, btrfs supports only the trinity of UNIX time =
stamps:=20
atime, ctime and mtime.

Is there any plan to support crtime (creation time)?

Side note: ZFS already supports it, ext4 and cifs (samba) are waiting f=
or APIs=20
and userland support, so it could be a good time to coordinate efforts =
and=20
solidify the interface.

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=C3=B3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
