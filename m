Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41107 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755666AbcIKQog (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 12:44:36 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bj7rq-0003FB-Ay
        for linux-btrfs@vger.kernel.org; Sun, 11 Sep 2016 18:44:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Small fs
Date: Sun, 11 Sep 2016 16:44:23 +0000 (UTC)
Message-ID: <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
        <5440522.9CHaGU5Wjs@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 11 Sep 2016 17:32:44 +0200 as excerpted:

> Am Sonntag, 11. September 2016, 18:27:30 CEST schrieben Sie:
>> What is the smallest recommended fs size for btrfs?
>> 
>> - There are mentions of 256MB around the net.
>> - Gparted reserves minimum of 256MB for btrfs.
>> 
>> With an ordinary partition on a single disk,
>> fs created with just "mkfs.btrfs /dev/sdxx":
>> - 128MB works fine.
>> - 127MB works but as if it is 64MB.
>> 
>> Can we say size should be in multiples of 64MB?
> 
> Do you want to know the smalled *recommended* or the smallest *possible*
> size?
> 
> I personally wouldn´t go below one or two GiB or or so with BTRFS. On
> small filesystems, I don´t know the treshold right now it uses a mixed
> metadata/data format. And I think using smaller BTRFS filesystem invited
> any left over "filesystem is full while it isn´t" issues.

I agree with the general recommendations and *strongly* recommend (and 
use) mixed-mode below say 2 GiB myself, but I don't necessarily agree 
that the practical bottom limit is 1 GiB, as I partition heavily and have 
a couple smaller btrfs myself.

There are some limits that should be kept in mind, however.

* Metadata, and thus mixed-bg, defaults to DUP mode on a single-device 
filesystem (except on ssd where I actually still use it myself, and 
recommend it except for ssds that do firmware dedupe).  In mixed-mode 
this means two copies of data as well, which halves the usable space.

IOW, when using mixed-mode, which is recommended under a gig, and dup 
replication which is then the single-device default, effective usable 
space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)

When the filesystem is that small, space tends to be at a premium in any 
case, and halving the available space can take a big bite out of things, 
so one considering such a btrfs should consider carefully, and possibly 
specify single mode if the loss of the data on the filesystem won't be a 
big deal, or double the filesystem size to account for dup data, if it 
would be more appropriate.

Or do pair-device which defaults to raid1 mode for metadata and mixed.  
Or choose a more traditional filesystem, perhaps ext* based, perhaps even 
without a journal if size is that constrained, because the journal takes 
space as well, because fscking that small a filesystem in the event of a 
crash shouldn't take that long anyway.

* There's also a system chunk to consider.  This too is normally dup mode 
on single device, raid1 on multi.  While it shrinks to some extent with 
size of filesystem, my 256 MiB /boot still has a 15.5 MiB system chunk, 
doubled due to dup mode to 31 MiB.  This is overhead you won't be able to 
use for anything else.

* There's also global reserve.  This is a part of metadata (and thus 
mixed-mode) that cannot be used under normal circumstances either.  
However, unlike normal metadata, the accounting here is single -- it's X 
space reserved no matter the replication type.  On my 256 MiB /boot, it's 
4 MiB.

So of my 256 MiB btrfs mixed-mode /boot, 31+4=35 MiB is overhead, leaving 
221 MiB for actual data and metadata.  But due to dup mode that's halved, 
to 110.5 MiB usable space.

For something like a dedicated /boot that may be acceptable.  For many 
applications it wouldn't be, and either the target size would need 
doubled, or filesystem robustness would need compromised by switching to 
single mode instead of dup.  Or use a different filesystem.

Tho to compare apples to apples, most other filesystems are only single 
mode anyway, and if it's an acceptable usage for them, it may well be an 
acceptable usage for btrfs as well.  It's just that btrfs likes a bit 
more metadata robustness than that.  But with such limited sizes, backing 
up the data if it's worth the hassle shouldn't be horribly time or 
resource consuming, and single mode can then make a bit more sense.

FWIW, in addition to my previously mentioned 256 MiB /boot, and a backup 
/boot (selectable via bios) on another device, I have a 640 MiB btrfs 
pair-device raid1 /var/log.  It's mixed-mode too, 640 MiB per device, but 
pair-device raid1, so I don't have to worry about the 2X data factor on a 
single device.

All my other "system" partitions are btrfs raid1 as well, including /, 
/home, and the packages/build partition.  But those are all over 2 GiB 
each.  All my btrfs are on ssd, with only my media partitions and backups 
on spinning rust (reiserfs).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

