From: Hubert Kario <hka@qbs.com.pl>
Subject: Cross-subvolume reflink copy (BTRFS_IOC_CLONE over subvolume boundaries)
Date: Tue, 14 Feb 2012 00:52:33 +0100
Message-ID: <2704295.VfXjvSRAYV@bursa01>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It's been nearly a year since the patches needed to implement a reflink=
ed copy=20
between subvolumes have been posted=20
(http://permalink.gmane.org/gmane.comp.file-systems.btrfs/9865 ) and I =
still=20
get "Invalid cross-device link" error with Linux 3.2.4 while I try to d=
o a cp=20
--reflink between subvolumes.

This is a *very* useful feature to have (think offline file-level dedup=
lication=20
for one thing).

=46rom what I was able to find in the archives, the only objection (use=
rland=20
operation crossing subvolume boundaries) was rebutted by Chris Mason.=20

Is there something else that I missed?

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
