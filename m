Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51894 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdL3An0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 19:43:26 -0500
Subject: Re: btrfs balance problems
To: Nikolay Borisov <n.borisov.lkml@gmail.com>,
        James Courtier-Dutton <james.dutton@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
 <e3629f7d-3278-bb11-d416-43e290c67e2a@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <82257976-5c34-45d1-d88f-fa12a66d24f4@mendix.com>
Date: Sat, 30 Dec 2017 01:43:24 +0100
MIME-Version: 1.0
In-Reply-To: <e3629f7d-3278-bb11-d416-43e290c67e2a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2017 12:15 PM, Nikolay Borisov wrote:
> 
> On 23.12.2017 13:19, James Courtier-Dutton wrote:
>>
>> During a btrfs balance, the process hogs all CPU.
>> Or, to be exact, any other program that wishes to use the SSD during a
>> btrfs balance is blocked for long periods. Long periods being more
>> than 5 seconds.
>> Is there any way to multiplex SSD access while btrfs balance is
>> operating, so that other applications can still access the SSD with
>> relatively low latency?
>>
>> My guess is that btrfs is doing a transaction with a large number of
>> SSD blocks at a time, and thus blocking other applications.
>>
>> This makes for atrocious user interactivity as well as applications
>> failing because they cannot access the disk in a relatively low latent
>> manner.
>> For, example, this is causing a High Definition network CCTV
>> application to fail.
>>
>> What I would really like, is for some way to limit SSD bandwidths to
>> applications.
>> For example the CCTV app always gets the bandwidth it needs, and all
>> other applications can still access the SSD, but are rate limited.
>> This would fix my particular problem.
>> We have rate limiting for network applications, why not disk access also?
> 
> So how are you running btrfs balance?

Or, to again take one step further back...

*Why* are you running btrfs balance at all?

:)

> Are you using any filters
> whatsoever? The documentation
> [https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-balance] has the
> following warning:
> 
> Warning: running balance without filters will take a lot of time as it
> basically rewrites the entire filesystem and needs to update all block
> pointers.

-- 
Hans van Kranenburg
