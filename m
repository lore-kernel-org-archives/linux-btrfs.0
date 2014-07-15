Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37523 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaGOJJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 05:09:55 -0400
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 40A2D1CD
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 11:09:53 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS claims that empty directory is not empty and refuses to delete it
Date: Tue, 15 Jul 2014 11:09:53 +0200
Message-ID: <5988448.153L8540y0@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

This is with 3.16-rc4 – stepped back to this one after having two hangs in one 
day with 3.16-rc5, see other thread started by me:

martin@merkaba:~/Zeit/undeletable/db_data> ls -lid akonadi
450598 drwx------ 1 martin martin 1232 Jun 22 14:11 akonadi
martin@merkaba:~/Zeit/undeletable/db_data> ls -lai akonadi 
insgesamt 0
450598 drwx------ 1 martin martin 1232 Jun 22 14:11 .
450595 drwxr-xr-x 1 martin martin   14 Jun 22 14:11 ..
martin@merkaba:~/Zeit/undeletable/db_data> LANG=C rmdir akonadi
rmdir: failed to remove 'akonadi': Directory not empty
martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=C rm -r akonadi
rm: cannot remove 'akonadi': Directory not empty
martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=C rm -rf akonadi
rm: cannot remove 'akonadi': Directory not empty
martin@merkaba:~/Zeit/undeletable/db_data#1>


Whats this?

I had this weeks ago already and just moved it out of the way at that time, 
just now stumbled upon it again.


This is the same BTRFS Dual SSD RAID as mentioned in the other post:


merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 123.20GiB
        devid    1 size 160.00GiB used 159.98GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 159.98GiB path /dev/dm-3

Btrfs v3.14.1
merkaba:~#1> btrfs fi df /home
Data, RAID1: total=154.95GiB, used=120.61GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=2.59GiB
unknown, single: total=512.00MiB, used=0.00
merkaba:~> df -hT /home
Dateisystem            Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/mapper/msata-home btrfs  320G    247G   69G   79% /home

merkaba:~> file -sk /dev/sata/home
/dev/sata/home: symbolic link to `../dm-3'
merkaba:~> file -sk /dev/dm-3     
/dev/dm-3: BTRFS Filesystem label "home", sectorsize 4096, nodesize 16384, 
leafsize 16384, UUID=b96c4f72- 523-45ac-a401-f7be73dd624a, 
132303151104/343597383680 bytes used, 2 devices


Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
