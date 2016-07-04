Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36457 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbcGDUnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 16:43:32 -0400
Received: by mail-oi0-f46.google.com with SMTP id f189so206275231oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 13:43:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 4 Jul 2016 14:43:30 -0600
Message-ID: <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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



-- 
Chris Murphy
