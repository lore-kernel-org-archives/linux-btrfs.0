Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33156 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756551AbcILMpz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:45:55 -0400
Received: by mail-oi0-f43.google.com with SMTP id y2so310942202oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:45:55 -0700 (PDT)
Subject: Re: Small fs
To: Martin Steigerwald <martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <14309857.N6fGUh6qoJ@merkaba> <20160911194632.GF7138@carfax.org.uk>
 <34273168.IdA9o4YR3V@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7efbc874-d1e8-011e-20c8-f887aef8a4ac@gmail.com>
Date: Mon, 12 Sep 2016 08:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <34273168.IdA9o4YR3V@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-11 15:51, Martin Steigerwald wrote:
> Am Sonntag, 11. September 2016, 19:46:32 CEST schrieb Hugo Mills:
>> On Sun, Sep 11, 2016 at 09:13:28PM +0200, Martin Steigerwald wrote:
>>> Am Sonntag, 11. September 2016, 16:44:23 CEST schrieb Duncan:
>>>> * Metadata, and thus mixed-bg, defaults to DUP mode on a single-device
>>>> filesystem (except on ssd where I actually still use it myself, and
>>>> recommend it except for ssds that do firmware dedupe).  In mixed-mode
>>>> this means two copies of data as well, which halves the usable space.
>>>>
>>>> IOW, when using mixed-mode, which is recommended under a gig, and dup
>>>> replication which is then the single-device default, effective usable
>>>> space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)
>>>
>>> I don´t get this part. That is just *metadata* being duplicated, not the
>>> actual *data* inside the files. Or am I missing something here?
>>
>>    In mixed mode, there's no distinction: Data and metadata both use
>> the same chunks. If those chunks are DUP, then both data and metadata
>> are duplicated, and you get half the space available.
>
> In german I´d say "autsch", in english according to pda.leo.org "ouch", to
> this.
>
> Okay, I just erased using mixed mode as an idea from my mind altogether :).
Until recently (when DUP mode for data on a single device got added), it 
did have advantages.  If you're running on a single disk and need 
replication, it's a lot more efficient to just run a single partition in 
DUP mode than two in RAID1 mode.  It also makes it a bit less likely to 
hit ENOSPC issues on small filesystems.
>
> Just like I think I will never use a BTRFS below 5 GiB. Well, with one
> exception, maybe on the eMMC flash of the new Omnia Turris router that I hope
> will arrive soon at my place.
>
FWIW, I don't use anything smaller than 8G unless I have to (with the 
notable exception of /boot), and when I do need to, I usually just use 
mixed mode because once you get that small, you need all the help you 
can get to keep from the whole FS being allocated to chunks.

