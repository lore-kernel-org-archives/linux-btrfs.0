Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34750 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbcGDVKQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 17:10:16 -0400
Received: by mail-wm0-f46.google.com with SMTP id 187so23605225wmz.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 14:10:15 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <6253136e-51bd-29cc-e8d2-d2cf9a6a0aef@gmail.com>
Date: Mon, 4 Jul 2016 23:10:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One disk got reallocated sectors in SMART, so i did extended smart test
and it passed. Then I ran scrub and it found nothing. Everything was ok.
After this, it was started another extended smart test, weekly
scheduled, and I thing that sometime during this, disk went offline.

Maybe problem can be, that another disk have smart stat: Reported
Uncorrect on 1.


sudo mount -o ro,degraded,recovery /dev/sda /shares
mount: wrong fs type, bad option, bad superblock on /dev/sda,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
 
sudo btrfs-show-super -fa /dev/sda and sdb
http://sebsauvage.net/paste/?39c73a3440b2e903#WZnUJXNFPNz/fFuOK3QquVeOWQUopcCl0JabtuYMWew=

sudo btrfs-find-root /dev/sda
warning, device 3 is missing
Couldn't read chunk tree
ERROR: open ctree failed

Thank you
Tomáš

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Monday, July 04, 2016 10:43PM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

On Mon, Jul 4, 2016 at 1:11 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> Result from dmesg:
> http://sebsauvage.net/paste/?4e8e95b5eafbf675#ybToBzZ/WAoRjjugeH6N2YXZKEBlswaNI/J41GBmFYU=

[10849.041749] BTRFS info (device sda): allowing degraded mounts
[10849.041754] BTRFS info (device sda): disk space caching is enabled
[10849.041756] BTRFS: has skinny extents
[10849.090553] BTRFS error (device sda): bad tree block start
10160120763642806272 12678831570944
[10849.090676] BTRFS error (device sda): bad tree block start
10160120763642806272 12678831570944
[10849.090700] BTRFS: failed to read chunk tree on sda
[10849.100153] BTRFS: open_ctree failed


Try 'mount -o ro,degraded,recovery


> 
> sudo btrfs check /dev/sda
> warning, device 3 is missing
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> bytenr mismatch, want=12678831570944, have=10160133442474442752
> Couldn't read chunk tree
> Couldn't open file system

Want and have are way far apart. If the mount command above still
fails then I'd like to see:

# btrfs-show-super -fa /dev/sda
# btrfs-show-super -fa /dev/sdb

Pretty much look for any discrepancies in generation, root and
chunk_root addresses, both in the main part of the super as well as in
the backups.

# btrfs-find-root /dev/sda

Maybe it's possible to use a different tree to get it mounted. I don't
know what happened but merely a failing device should not either break
checksums or lose the ability to mount the proper tree; but for sure
one of the backups should work.

Have you done a scrub on this file system and do you know if anything
was fixed or if it always found no problem?





---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

