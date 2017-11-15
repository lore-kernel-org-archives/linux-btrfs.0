Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:53752 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756166AbdKOCyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 21:54:16 -0500
Received: by mail-oi0-f54.google.com with SMTP id h6so15116731oia.10
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 18:54:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114123829.r4kmvsp6aeuylo67@angband.pl>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114123829.r4kmvsp6aeuylo67@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 14 Nov 2017 19:54:14 -0700
Message-ID: <CAJCQCtSWU81jZSiY0KRgPC2ufgihnvxfWtZbQNB5SJMZP+e0BA@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Adam Borowski <kilobyte@angband.pl>
Cc: Klaus Agnoletti <klaus@agnoletti.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 5:38 AM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Tue, Nov 14, 2017 at 10:36:22AM +0200, Klaus Agnoletti wrote:
>> I used to have 3x2TB in a btrfs in raid0. A few weeks ago, one of the
>                                      ^^^^^
>> 2TB disks started giving me I/O errors in dmesg like this:
>>
>> [388659.188988] Add. Sense: Unrecovered read error - auto reallocate failed
>
> Alas, chances to recover anything are pretty slim.  That's RAID0 metadata
> for you.
>
> On the other hand, losing any non-trivial file while being able to gape at
> intact metadata isn't that much better, thus -mraid0 isn't completely
> unreasonable.

I don't know the statistics on UNC read error vs total drive failure.
If I thought that total drive failure was 2x or more likely than a
single UNC then maybe raid0 is reasonable. But it's a 64KB block size
for raid0. I think metadata raid0 probably doesn't offer that much
performance improvement over raid1, and if it did, that's a case for
raid10 metadata.

In the UNC case, chances are it hits a data extent of a single file,
in which case Btrfs can handle this fine, you just lose that one file.
And if it hits the smaller target of metadata, it's fine if metadata
is raid1 or raid10.

In a previous email in the archives, I did a test where I
intentionally formatted one member drive of a Btrfs data raid0,
metadata raid1, and it was totally recoverable with a bunch of scary
messages and sometimes a file was corrupted. So it actually is pretty
darn resilient when there is a copy of metadata. (I did not try DUP.)




-- 
Chris Murphy
