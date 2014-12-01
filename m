Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44275 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaLAWKB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 17:10:01 -0500
Received: by mail-vc0-f171.google.com with SMTP id hy4so5166173vcb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 14:10:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547CA4E7.8060209@pobox.com>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
Date: Mon, 1 Dec 2014 23:10:01 +0100
Message-ID: <CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Robert White <rwhite@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-01 18:27 GMT+01:00 Robert White <rwhite@pobox.com>:
> On 12/01/2014 04:56 AM, MegaBrutal wrote:
>>
>> Since the other thread went off into theoretical debates about UUIDs
>> and their generic relation to BTRFS, their everyday use cases, and the
>> philosophical meaning behind uniqueness of copies and UUIDs; I'd like
>> to specifically ask you to only post here about the ACTUAL problem at
>> hand. Don't get me wrong, I find the discussion in the other thread
>> really interesting, I'm following it, but it is only very remotely
>> related to the original issue, so please keep it there! If you're
>> interested to catch up about the actual bug symptoms, please read the
>> bug report linked above, and (optionally) reproduce the problem
>> yourself!
>
>
> That discussion _was_ the actual discussion of the actual problem. A problem
> that is not particularly theoretical, a problem that is common to
> block-level snapshots, and a discussion that contained the actual
> work-arounds.
>
> I suggest a re-read. 8-)
>

The majority of the discussion was about how the kernel should react
UPON mounting a file system when more than one device of the same UUID
exist on the system. While it is a very legit problem worth to discuss
and mitigate, this is not the same situation as how the kernel behaves
when an identical device appears WHILE the file system is being
mounted.

Actually, I would not identify devices by UUIDs when I know that
duplicates could exist due to snapshots, therefore I mount devices by
LVM paths. And when a file system is already mounted with all its
devices, that is a clear situation: all devices are open and locked by
the kernel, any mixup at that point is an error. What is the case with
multiple-device file systems? Supply all their devices with device=
mount options. Just don't identify devices by UUIDs when you know
there could be duplicates. Use UUIDs when you don't use LVM.
Identifying file systems by UUIDs were invented because classic
/dev/sdXX device names might change. But LVM names don't change. They
only change when you intentionally change them e.g. with lvrename.

Since having duplicate UUIDs on devices is not a problem for me since
I can tell them apart by LVM names, the discussion is of little
relevance to my use case. Of course it's interesting and I like to
read it along, it is not about the actual problem at hand.
