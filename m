Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34433 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdIELqD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 07:46:03 -0400
Received: by mail-io0-f194.google.com with SMTP id b142so1302581ioe.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 04:46:02 -0700 (PDT)
Subject: Re: Is autodefrag recommended?
To: Hugo Mills <hugo@carfax.org.uk>, Marat Khalili <mkh@rqc.ru>,
        linux-btrfs@vger.kernel.org
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
 <20170904105444.GA23980@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <533ebd2e-8b95-d875-4cbc-48821b150eac@gmail.com>
Date: Tue, 5 Sep 2017 07:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170904105444.GA23980@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-04 06:54, Hugo Mills wrote:
> On Mon, Sep 04, 2017 at 12:31:54PM +0300, Marat Khalili wrote:
>> Hello list,
>> good time of the day,
>>
>> More than once I see mentioned in this list that autodefrag option
>> solves problems with no apparent drawbacks, but it's not the
>> default. Can you recommend to just switch it on indiscriminately on
>> all installations?
>>
>> I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's
>> Ubuntu that gives us this strange choice, no idea why it's not 4.9).
>> Only spinning rust here, no SSDs.
> 
>     autodefrag effectively works by taking a small region around every
> write or cluster of writes and making that into a stand-alone extent.
I was under the impression that it had some kind of 'random access' 
detection heuristic, and onky triggered if that flagged the write 
patterns as 'random'.
> 
>     This has two consequences:
> 
>   - You end up duplicating more data than is strictly necessary. This
>     is, IIRC, something like 128 KiB for a write.
FWIW< I'm pretty sure you can mitigate this first issue by running a 
regular defrag on a semi-regular basis (monthly is what I would probably 
suggest).
> 
>   - There's an I/O overhead for enabling autodefrag, because it's
>     increasing the amount of data written.
And this issue may not be as much of an issue.  The region being 
rewritten gets written out sequentially, so it will increase the amount 
of data written, but in most cases probably won't increase IO request 
counts to the device by much.  If you care mostly about raw bandwidth, 
then this could still have an impact, but if you care about IOPS, it 
probably won't have much impact unless you're already running the device 
at peak capacity.
