Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35540 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcGEHM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 03:12:56 -0400
Received: by mail-wm0-f44.google.com with SMTP id z126so63437904wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 00:12:56 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <6253136e-51bd-29cc-e8d2-d2cf9a6a0aef@gmail.com>
 <CAJCQCtTPaxWBkmX=ADY7oh5bFjvODmuUNiGXtcBCfxw-c646LA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <74e4e27b-5046-0045-292a-c65367c445e1@gmail.com>
Date: Tue, 5 Jul 2016 09:12:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPaxWBkmX=ADY7oh5bFjvODmuUNiGXtcBCfxw-c646LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sudo btrfs-debug-tree -d /dev/sdc
btrfs-progs v4.6.1
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
ERROR: unable to open /dev/sdc
 

Thank you
Tomas

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Tuesday, July 05, 2016 12:42AM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

On Mon, Jul 4, 2016 at 3:10 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:

> http://sebsauvage.net/paste/?39c73a3440b2e903#WZnUJXNFPNz/fFuOK3QquVeOWQUopcCl0JabtuYMWew=


Both backup 0 and 1 have bad information for backup_fs_root.

backup_fs_root: 0 gen: 0 level: 0

Presumably it automatically tries backup 2 or 3 even though they have
older generations but I'm not sure.


> sudo btrfs-find-root /dev/sda
> warning, device 3 is missing
> Couldn't read chunk tree
> ERROR: open ctree failed

I'm gonna guess the system chunk is bad or damaged somehow and
therefore there's no way to get to the chunk tree. What do you get
for:

# btrfs-debug-tree -d /dev/sda





---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

