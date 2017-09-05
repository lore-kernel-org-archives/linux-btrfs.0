Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35653 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdIENAn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 09:00:43 -0400
Received: by mail-io0-f171.google.com with SMTP id i200so15691315ioa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 06:00:43 -0700 (PDT)
Subject: Re: Is autodefrag recommended?
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
 <20170904105444.GA23980@carfax.org.uk>
 <533ebd2e-8b95-d875-4cbc-48821b150eac@gmail.com>
 <CAPmG0jZApuPggvJ98Ko9Yps+N3ixNjAEzTgfDNWoqa2a_Tdd2w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <60a91979-5452-4935-d20b-cf593e2c868c@gmail.com>
Date: Tue, 5 Sep 2017 09:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZApuPggvJ98Ko9Yps+N3ixNjAEzTgfDNWoqa2a_Tdd2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-05 08:49, Henk Slager wrote:
> On Tue, Sep 5, 2017 at 1:45 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>>>    - You end up duplicating more data than is strictly necessary. This
>>>      is, IIRC, something like 128 KiB for a write.
>>
>> FWIW< I'm pretty sure you can mitigate this first issue by running a regular
>> defrag on a semi-regular basis (monthly is what I would probably suggest).
> 
> No, both autodefrag and regular defrag duplicate data, so if you keep
> snapshots around for weeks or months, it can eat up a significant
> amount of space.
> 
I'm not talking about data duplication due to broken reflinks, I'm 
talking about data duplication due to how partial extent rewrites are 
handled in BTRFS.

As a more illustrative example, suppose you've got a 256k file that has 
just one extent.  Such a file will require 256k of space for the data 
Now rewrite from 128k to 192k.  The file now technically takes up 320k, 
because the region you rewrote is still allocated in the original extent.

I know that sub-extent-size reflinks are handled like this (in the above 
example, if you instead use the CLONE ioctl to create a new file 
reflinking that range, then delete the original, the remaining 192k of 
space in the extent ends up unreferenced, but gets kept around until the 
referenced region is no longer referenced (and the easiest way to ensure 
this is to either rewrite the whole file, or defragment it)), and I'm 
pretty sure from reading the code that mid-extent writes are handled 
this way too, in which case, a full defrag can reclaim that space.
