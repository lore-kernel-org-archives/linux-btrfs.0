Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:55394 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750997AbcKZNNA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 08:13:00 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
Date: Sat, 26 Nov 2016 14:12:56 +0100
MIME-Version: 1.0
In-Reply-To: <20161125043119.GG8685@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-25 05:31, Zygo Blaxell wrote:
>>> Do you mean, read the corrupted data won't repair it?
>>>
>>> IIRC that's the designed behavior.
>> :O
>>
>> You are right... I was unaware of that....
> This is correct.
> 
> Ordinary reads shouldn't touch corrupt data, they should only read
> around it.  Scrubs in read-write mode should write corrected data over
> the corrupt data.  Read-only scrubs can only report errors without
> correcting them.
> 
> Rewriting corrupt data outside of scrub (i.e. on every read) is a
> bad idea.  Consider what happens if a RAM controller gets too hot:
> checksums start failing randomly, but the data on disk is still OK.
> If we tried to fix the bad data on every read, we'd probably just trash
> the filesystem in some cases.



I cant agree. If the filesystem is mounted read-only this behavior may be correct; bur in others cases I don't see any reason to not correct wrong data even in the read case. If your ram is unreliable you have big problem anyway.

The likelihood that the data contained in a disk is "corrupted" is higher than the likelihood that the RAM is bad.

BTW Btrfs in RAID1 mode corrects the data even in the read case. So I am still convinced that is the RAID5/6 behavior "strange".

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
