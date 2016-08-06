Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33774 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcHFWgf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 18:36:35 -0400
Received: by mail-qt0-f196.google.com with SMTP id j37so16130307qta.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 15:36:35 -0700 (PDT)
MIME-Version: 1.0
From: Chris McFaul <mcfaul@gmail.com>
Date: Sat, 6 Aug 2016 23:36:14 +0100
Message-ID: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
Subject: Unmountable and unrepairable BTRFS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, if anyone is able to help with a rather large (34TB of data on it)
BTRFS RAID 6 I would be very grateful (pastebins below) - at this
point I am only interested in recovery since I am obviously switching
to RAID 1 once/if I get my data back.

Many thanks in advance

Chris

Linux rockstor 4.6.0-1.el7.elrepo.x86_64 #1 SMP Mon May 16 10:54:52
EDT 2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.6


Label: 'rockstor_rockstor'  uuid: af53ae5b-419e-4246-9366-611b710eead6
        Total devices 1 FS bytes used 1.50GiB
        devid    1 size 100.12GiB used 4.02GiB path /dev/sda3


This one is fine:

Label: '2'  uuid: 815fa02f-4871-4703-9208-03ccc48cc816
        Total devices 9 FS bytes used 38.98TiB
        devid    1 size 7.28TiB used 6.27TiB path /dev/sdg
        devid    2 size 7.28TiB used 6.27TiB path /dev/sdh
        devid    3 size 7.28TiB used 6.27TiB path /dev/sdi
        devid    4 size 7.28TiB used 6.27TiB path /dev/sdj
        devid    5 size 7.28TiB used 6.27TiB path /dev/sdc
        devid    6 size 7.28TiB used 6.27TiB path /dev/sdd
        devid    7 size 7.28TiB used 6.27TiB path /dev/sde
        devid    8 size 7.28TiB used 6.27TiB path /dev/sdf
        devid   11 size 7.28TiB used 6.27TiB path /dev/sdb


this one wont mount:

Label: '1'  uuid: ba29167b-e0cf-4029-92a4-f12a97f7e472
        Total devices 11 FS bytes used 34.23TiB
        devid    2 size 5.46TiB used 3.82TiB path /dev/sdk
        devid    3 size 5.46TiB used 3.82TiB path /dev/sdl
        devid    4 size 5.46TiB used 3.82TiB path /dev/sdm
        devid    5 size 5.46TiB used 3.82TiB path /dev/sdn
        devid    6 size 5.46TiB used 3.82TiB path /dev/sdo
        devid    7 size 5.46TiB used 3.82TiB path /dev/sdp
        devid    8 size 5.46TiB used 3.82TiB path /dev/sdq
        devid    9 size 5.46TiB used 3.82TiB path /dev/sdr
        devid   10 size 5.46TiB used 3.82TiB path /dev/sds
        devid   11 size 5.46TiB used 3.82TiB path /dev/sdt
        devid   12 size 5.46TiB used 3.82TiB path /dev/sdu

full dmesg : http://pastebin.com/xgwfkGum

trying to mount: http://pastebin.com/DSfHsda6

btrfs restore: http://pastebin.com/EAuPW1pg

btrfs check: http://pastebin.com/FjM7amEv

finding roots: http://pastebin.com/SBsn12d9
