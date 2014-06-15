Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41313 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaFOVpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 17:45:39 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sun, 15 Jun 2014 23:45:37 +0200
Message-ID: <4701978.7NWinrON7D@merkaba>
In-Reply-To: <jhmt6b-j4j.ln1@hurikhan77.spdns.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net> <jhmt6b-j4j.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 14. Juni 2014, 12:59:31 schrieb Kai Krakow:
> Well, how did I accomblish that?

Setting no cow and defragmenting regularily?

Quite a complex setup for a casual Linux user.

Any solution should be automatic. I´d suggest by a combination of sane
application behaviour and measures within the filesystem.

> First, I've set the journal directories nocow. Of course, systemd should do 
> this by default. I'm not sure if this is a packaging or systemd code issue,
> tho. But I think the systemd devs are in common that for cow fs, the
> journal directories should be set nocow. After all, the journal is a
> transactional database - it does not need cow protection at all costs. And
> I think they have their own checksumming protection. So, why let systemd
> bother with that? A lot of other software has the same semantic problems
> with btrfs, too (ex. MySQL) where nobody shouts at the "inabilities" of the
> programmers. So why for systemd? Just because it's intrusive by its nature
> for being a radically and newly designed init system and thus requires some
> learning by its users/admins/packagers? Really? Come on... As admin and/or
> packager you have to stay with current technologies and developments
> anyways. It's only important to hide the details from the users.

But nocow also disables the possibilty to snapshot these files, AFAIK. Akonadi
does this for its database directory as well for new install. But I am not
completely happy with that approach.

And well I would say that the following differing results are caused by
specific application behavior – my bet would be rsyslog sequentially
appending to the file while systemd used the journal files more than a
database, databases fragment heavily on BTRFS due to COW:


merkaba:/var/log/journal/1354039e4d4bb8de4f97ac8400000004> filefrag *
system@0004e2025580f3c5-c625739d3033b738.journal~: 1 extent found
system@0004f94fbee5f4d1-1cfb9bed12a79bde.journal~: 2771 extents found
system@0004f98240efba02-b465b39a7ed0bdbe.journal~: 2534 extents found
system@0004f9ff739ad927-4650a2ca62bf9378.journal~: 4951 extents found
system@0004fa17feb65603-a7597828f9823e38.journal~: 1244 extents found
system@0004fa3f0e96b653-d6f9d5795c9ef869.journal~: 1419 extents found
system@0004fa4c448b8a95-c95a3b7950fd704d.journal~: 1511 extents found
system@0004fa5dddb554e0-33c319ebb5f8100f.journal~: 1729 extents found
system@0004fad81852c750-20a36082c6006c8a.journal~: 10257 extents found
system@0004fad970b56567-44bf4a94314792fc.journal~: 932 extents found
system@0004fb128307b981-7f2104da8b2c9fb2.journal~: 6757 extents found
system@0004fb1c3eef86c3-8adbea51a1c98729.journal~: 1498 extents found
system@0004fb1c419fb301-7303f7fd9165ed26.journal~: 19 extents found
system@0004fb44feafbafd-b7433e90b1d3d718.journal~: 2265 extents found
system@0004fb6ddf63e4d3-b40e8f4701670bff.journal~: 1894 extents found
system@0004fb6e412c3f7e-3890be9c2119a7bb.journal~: 1038 extents found
system@54803afb1b1d42b387822c56e61bc168-000000000002b364-0004e1c4aabbeefa.journal: 2 extents found
system@54803afb1b1d42b387822c56e61bc168-000000000002b365-0004e1c4ab5b0246.journal: 1 extent found
system@bd18e6867b824ba7b572de31531218a9-0000000000000001-0004e202555a0493.journal: 3232 extents found
system.journal: 3855 extents found
user-1000@0004e202588086cf-3d4130a580b63101.journal~: 1 extent found
user-1000@0004f9ff74415375-6b5dd1c3d76b09ce.journal~: 1046 extents found
user-1000@0004fa17ff12ef0c-34297fcc8c06dd4b.journal~: 96 extents found
user-1000@0004fa3f0eee8e41-dfb1f54bd31e4967.journal~: 84 extents found
user-1000@0004fa4c475a0a63-d8badb620094bce8.journal~: 173 extents found
user-1000@0004fa5de0c650e0-522069bac82c754e.journal~: 319 extents found
user-1000@0004fad818a7a980-593b8f3971b2e697.journal~: 2465 extents found
user-1000@0004fad97160c3ad-552b27f891e7a24e.journal~: 106 extents found
user-1000@0004fb1283616e7e-1fbca0bef31bd92b.journal~: 283 extents found
user-1000@0004fb6de033b269-018b4cbc2b1f319b.journal~: 874 extents found
user-1000@bd18e6867b824ba7b572de31531218a9-00000000000007c7-0004e2025881a1ee.journal: 293 extents found
user-1000.journal: 4663 extents found
user-120.journal: 5 extents found
user-2012@0004fa4c02142cad-f97563ed0105bfb3.journal~: 749 extents found
user-2012@0004fa4d8255b2df-43248028d422ca78.journal~: 29 extents found
user-2012@0004fa5de40372db-d1f3c6428ddeec22.journal~: 122 extents found
user-2012@0004fad81b8cd9d8-ed2861a9fa1b163c.journal~: 575 extents found
user-2012@0004fad980139d4e-94ad07f4a8fae3cc.journal~: 25 extents found
user-2012@0004fb160f2d5334-99462eb429f4cb7b.journal~: 416 extents found
user-2012@54803afb1b1d42b387822c56e61bc168-0000000000011c75-0004ddb2be06d876.journal: 2 extents found
user-2012.journal: 453 extents found
user-65534@0004fa4c62bf4a71-6b4c53dfc06dd588.journal~: 46 extents found
user-65534.journal: 91 extents found
merkaba:/var/log/journal/1354039e4d4bb8de4f97ac8400000004> cd ..
merkaba:/var/log/journal> cd ..




merkaba:/var/log/journal/1354039e4d4bb8de4f97ac8400000004> ls -lh
insgesamt 495M
-rw-r-----+ 1 root root            6,8M Jul 21  2013 system@0004e2025580f3c5-c625739d3033b738.journal~
-rw-r-----+ 1 root systemd-journal  14M Mai 14 00:40 system@0004f94fbee5f4d1-1cfb9bed12a79bde.journal~
-rw-r-----+ 1 root systemd-journal  14M Mai 16 12:55 system@0004f98240efba02-b465b39a7ed0bdbe.journal~
-rw-r-----+ 1 root systemd-journal  26M Mai 22 18:17 system@0004f9ff739ad927-4650a2ca62bf9378.journal~
-rw-r-----+ 1 root systemd-journal 6,3M Mai 23 23:34 system@0004fa17feb65603-a7597828f9823e38.journal~
-rw-r-----+ 1 root systemd-journal 6,6M Mai 25 22:10 system@0004fa3f0e96b653-d6f9d5795c9ef869.journal~
-rw-r-----+ 1 root systemd-journal 7,7M Mai 26 13:56 system@0004fa4c448b8a95-c95a3b7950fd704d.journal~
-rw-r-----+ 1 root systemd-journal 9,7M Mai 27 10:56 system@0004fa5dddb554e0-33c319ebb5f8100f.journal~
-rw-r-----+ 1 root systemd-journal  50M Jun  2 12:45 system@0004fad81852c750-20a36082c6006c8a.journal~
-rw-r-----+ 1 root systemd-journal 5,2M Jun  2 14:21 system@0004fad970b56567-44bf4a94314792fc.journal~
-rw-r-----+ 1 root systemd-journal  34M Jun  5 10:27 system@0004fb128307b981-7f2104da8b2c9fb2.journal~
-rw-r-----+ 1 root systemd-journal 8,4M Jun  5 22:03 system@0004fb1c3eef86c3-8adbea51a1c98729.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Jun  5 22:04 system@0004fb1c419fb301-7303f7fd9165ed26.journal~
-rw-r-----+ 1 root systemd-journal  12M Jun  7 22:40 system@0004fb44feafbafd-b7433e90b1d3d718.journal~
-rw-r-----+ 1 root systemd-journal  11M Jun  9 23:27 system@0004fb6ddf63e4d3-b40e8f4701670bff.journal~
-rw-r-----+ 1 root systemd-journal 6,3M Jun  9 23:54 system@0004fb6e412c3f7e-3890be9c2119a7bb.journal~
-rw-r-----+ 1 root adm             128M Jul 18  2013 system@54803afb1b1d42b387822c56e61bc168-000000000002b364-0004e1c4aabbeefa.journal
-rw-r-----+ 1 root root            7,4M Jul 20  2013 system@54803afb1b1d42b387822c56e61bc168-000000000002b365-0004e1c4ab5b0246.journal
-rw-r-----+ 1 root systemd-journal  23M Mai 11 10:21 system@bd18e6867b824ba7b572de31531218a9-0000000000000001-0004e202555a0493.journal
-rw-r-----+ 1 root systemd-journal  19M Jun 15 23:37 system.journal
-rw-r-----+ 1 root root            3,6M Jul 21  2013 user-1000@0004e202588086cf-3d4130a580b63101.journal~
-rw-r-----+ 1 root systemd-journal 4,8M Mai 22 18:17 user-1000@0004f9ff74415375-6b5dd1c3d76b09ce.journal~
-rw-r-----+ 1 root systemd-journal 3,6M Mai 23 23:34 user-1000@0004fa17ff12ef0c-34297fcc8c06dd4b.journal~
-rw-r-----+ 1 root systemd-journal 3,6M Mai 25 22:10 user-1000@0004fa3f0eee8e41-dfb1f54bd31e4967.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Mai 26 13:57 user-1000@0004fa4c475a0a63-d8badb620094bce8.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Mai 27 10:56 user-1000@0004fa5de0c650e0-522069bac82c754e.journal~
-rw-r-----+ 1 root systemd-journal  15M Jun  2 12:45 user-1000@0004fad818a7a980-593b8f3971b2e697.journal~
-rw-r-----+ 1 root systemd-journal 3,6M Jun  2 14:22 user-1000@0004fad97160c3ad-552b27f891e7a24e.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Jun  5 10:27 user-1000@0004fb1283616e7e-1fbca0bef31bd92b.journal~
-rw-r-----+ 1 root systemd-journal 5,2M Jun  9 23:27 user-1000@0004fb6de033b269-018b4cbc2b1f319b.journal~
-rw-r-----+ 1 root systemd-journal 3,8M Mai 11 10:21 user-1000@bd18e6867b824ba7b572de31531218a9-00000000000007c7-0004e2025881a1ee.journal
-rw-r-----+ 1 root systemd-journal  35M Jun 15 23:38 user-1000.journal
-rw-r-----+ 1 root systemd-journal 3,6M Apr 28 09:52 user-120.journal
-rw-r-----+ 1 root systemd-journal 4,0M Mai 26 13:37 user-2012@0004fa4c02142cad-f97563ed0105bfb3.journal~
-rw-r-----+ 1 root systemd-journal 3,6M Mai 26 15:25 user-2012@0004fa4d8255b2df-43248028d422ca78.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Mai 27 10:57 user-2012@0004fa5de40372db-d1f3c6428ddeec22.journal~
-rw-r-----+ 1 root systemd-journal 4,3M Jun  2 12:46 user-2012@0004fad81b8cd9d8-ed2861a9fa1b163c.journal~
-rw-r-----+ 1 root systemd-journal 3,6M Jun  2 14:26 user-2012@0004fad980139d4e-94ad07f4a8fae3cc.journal~
-rw-r-----+ 1 root systemd-journal 3,8M Jun  5 14:41 user-2012@0004fb160f2d5334-99462eb429f4cb7b.journal~
-rw-r-----+ 1 root adm             200K Mai 11 10:21 user-2012@54803afb1b1d42b387822c56e61bc168-0000000000011c75-0004ddb2be06d876.journal
-rw-r-----+ 1 root systemd-journal 3,8M Jun 11 21:14 user-2012.journal
-rw-r-----+ 1 root systemd-journal 3,6M Mai 26 14:04 user-65534@0004fa4c62bf4a71-6b4c53dfc06dd588.journal~
-rw-r-----+ 1 root systemd-journal 3,7M Jun  9 23:26 user-65534.journal






merkaba:/var/log> filefrag syslog*
syslog: 361 extents found
syslog.1: 202 extents found
syslog.2.gz: 1 extent found
[well sure, cause repacked]
syslog.3.gz: 1 extent found
syslog.4.gz: 1 extent found
syslog.5.gz: 1 extent found
syslog.6.gz: 1 extent found

merkaba:/var/log> ls -lh syslog*
-rw-r----- 1 root adm 4,2M Jun 15 23:39 syslog
-rw-r----- 1 root adm 2,1M Jun 11 16:07 syslog.1



So we have ten times the extents on some systemd journal files than on
rsyslog.


With BTRFS RAID 1 on SSD with compress=lzo, so the 361 extents of syslog
may be due to the size limit of extents on compressed BTRFS filesystems.

Anyway, since it is flash, I never bothered about the fragmentation.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
