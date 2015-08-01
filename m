Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:49481 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbHAUJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 16:09:41 -0400
Received: from [127.0.0.1] ([92.77.1.248]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPA (Nemesis) id 0McAfD-1ZcStZ2shL-00JdkU for
 <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 22:09:38 +0200
Message-ID: <55BD277F.2040201@friedels.name>
Date: Sat, 01 Aug 2015 22:09:35 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Data single *and* raid?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I converted an array to raid5 by
btrfs device add /dev/sdd /mnt/new_storage
btrfs device add /dev/sdc /mnt/new_storage
btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/

The Balance went through. But now:
Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
         Total devices 3 FS bytes used 5.28TiB
         devid    1 size 2.73TiB used 2.57TiB path /dev/sde
         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
         devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
btrfs-progs v4.1.1

Already the 2.57TiB is a bit surprising:
root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
Data, single: total=2.55TiB, used=2.55TiB
Data, RAID5: total=2.73TiB, used=2.72TiB
System, RAID5: total=32.00MiB, used=736.00KiB
Metadata, RAID1: total=6.00GiB, used=5.33GiB
Metadata, RAID5: total=3.00GiB, used=2.99GiB

Why is there Data single and Raid?
Why is Metadata RAID1 and Raid5?

A scrub is currently running and showed no errors yet.

Greetings,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

