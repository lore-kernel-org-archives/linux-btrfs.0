Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50781 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab3JMNCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Oct 2013 09:02:41 -0400
Received: from 3capp-webde-bs45.server.lan ([172.19.170.45]) by
 mriweb.server.lan (mriweb001) with ESMTP (Nemesis) id
 0Lhibn-1W95px1TcH-00mtlW for <linux-btrfs@vger.kernel.org>; Sun, 13 Oct 2013
 15:02:40 +0200
MIME-Version: 1.0
Message-ID: <trinity-f923ab06-8e1c-42f6-8266-b864c521187e-1381669360111@3capp-webde-bs45>
From: "Thomas Schneider" <c.monty@web.de>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS Multidevice Filesystem: Save to delete one device?
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 Oct 2013 15:02:40 +0200 (CEST)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!
I have the following disk setup:
1x 3TB WD
2x 2TB WD
On each disk I have created a single partition, and this partition is formatted in BTRFS.
Then, I have setup a multidevice filesystem:
root@pc5:/media# btrfs filesystem show
Label: 'WD30EZRX-00M'  uuid: 7008c941-a5e1-44b6-9965-de726d22cc21
Total devices 3 FS bytes used 4.07TB
   devid    2 size 1.82TB used 1.72TB path /dev/sdd1
   devid    1 size 2.73TB used 2.63TB path /dev/sdb1
   devid    3 size 1.82TB used 0.00 path /dev/sdc1

Btrfs Btrfs v0.19
root@pc5:/media# btrfs filesystem df /media/sdb1/
Data: total=4.17TB, used=4.07TB
System, DUP: total=8.00MB, used=472.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=94.00GB, used=5.30GB
Metadata: total=8.00MB, used=0.00
 
You can see that devid 3 (=/dev/sdc1) is not utilized at all.

Question:
How can I delete devid 2 (=/dev/sdd1) securely without loosing any data?

Please note that all data stored in this multidevice filesystem is located in a subvolume, means no data is stored in root tree.
 
root@pc5:/media# btrfs subvolume list /media/sdb1/
ID 258 top level 5 path @video
ID 2760 top level 5 path @musik
ID 3995 top level 5 path @bilder
ID 3996 top level 5 path @dokumente
ID 3997 top level 5 path @software
ID 3998 top level 5 path @hardware
