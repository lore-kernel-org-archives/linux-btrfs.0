Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbbHPOd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 10:33:56 -0400
Received: from [127.0.0.1] ([88.71.43.181]) by mrelayeu.kundenserver.de
 (mreue002) with ESMTPA (Nemesis) id 0MTKPG-1ZJvim1ZG2-00S3vm for
 <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2015 16:33:54 +0200
Message-ID: <55D09F50.5070900@friedels.name>
Date: Sun, 16 Aug 2015 16:33:52 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: understanding btrfs fi df
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am struggling to understand the output of btrfs fi df:

btrfs fi df /mnt/__Complete_Disk/
Data, RAID5: total=3.85TiB, used=3.85TiB
System, RAID5: total=32.00MiB, used=576.00KiB
Metadata, RAID5: total=6.46GiB, used=5.14GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

I have three disks:

btrfs fi show
Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
         Total devices 3 FS bytes used 3.85TiB
         devid    1 size 2.73TiB used 2.73TiB path /dev/sdf
         devid    2 size 2.73TiB used 2.24TiB path /dev/sdd
         devid    3 size 2.73TiB used 2.73TiB path /dev/sde


So I would expect around 5.4TiB to be available. In fact I am currently 
using 4.4TiB and the drive seems to be full (I cannot store more data).

I went through Marcs Blog post on this, but the hints there did not 
help. In particular:
  btrfs balance start -dusage=95 /mnt/__Complete_Disk/ (started with 55)

What's wrong here?

Regards,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

