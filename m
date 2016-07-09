Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36815 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbcGIRay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 13:30:54 -0400
Received: by mail-wm0-f48.google.com with SMTP id f126so47263052wma.1
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jul 2016 10:30:53 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
 <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
 <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com>
 <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com>
 <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com>
Date: Sat, 9 Jul 2016 19:30:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 sudo btrfs rescue super-recover -v /dev/sda
All Devices:
        Device: id = 1, name = /dev/sdc
        Device: id = 2, name = /dev/sdb
        Device: id = 3, name = /dev/sda

Before Recovering:
        [All good supers]:
                device name = /dev/sdc
                superblock bytenr = 65536

                device name = /dev/sdc
                superblock bytenr = 67108864

                device name = /dev/sdc
                superblock bytenr = 274877906944

                device name = /dev/sdb
                superblock bytenr = 65536

                device name = /dev/sdb
                superblock bytenr = 67108864

                device name = /dev/sdb
                superblock bytenr = 274877906944

                device name = /dev/sda
                superblock bytenr = 65536

                device name = /dev/sda
                superblock bytenr = 67108864

                device name = /dev/sda
                superblock bytenr = 274877906944

        [All bad supers]:

All supers are valid, no need to recover


I hope, a made it right:


sudo btrfs-image -c9 -t4 /dev/sda /mnt/btrfs-image
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536
Error going to next leaf -5
create failed (Success)


sudo btrfs-debug-tree /dev/sda > /mnt/btrfs-debug-tree 2>
/mnt/btrfs-debug-tree-err

btrfs-debug-tree file have 10MB
btrfs-debug-tree-err
http://sebsauvage.net/paste/?12cf2fb771b93bdd#Ajv5gPoxDKjaWExcJnMZLVhcU5wVw77abeZ4tIGTazU=


I used btrfs restore and everything except the newest files was restored.
I can get those files again from the internet, so now it is save to do
changes to filesystem and try to repair it.
In the end, I will create new fs, but I can try to repair it and
hopefully gather some helpful information.

Thank you for help...

Tomas

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Wednesday, July 06, 2016 8:12PM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

btrfs rescue super-recover -v /dev/sda


---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

