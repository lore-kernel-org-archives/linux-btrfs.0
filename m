Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:44431 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756624AbeAHQeW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 11:34:22 -0500
Received: by mail-io0-f180.google.com with SMTP id k18so14879862ioc.11
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jan 2018 08:34:22 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: ein <ein.net@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
Date: Mon, 8 Jan 2018 11:34:18 -0500
MIME-Version: 1.0
In-Reply-To: <5A539A3A.10107@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-08 11:20, ein wrote:
> On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:
>> [...]
>>
>> And here's the FAQ entry:
>>
>> Q: Do I need to run a balance regularly?
>>
>> A: In general usage, no. A full unfiltered balance typically takes a
>> long time, and will rewrite huge amounts of data unnecessarily. You may
>> wish to run a balance on metadata only (see Balance_Filters) if you find
>> you have very large amounts of metadata space allocated but unused, but
>> this should be a last resort.
> 
> IHMO three more sentencens and the answer would be more useful:
> 1. BTRFS balance command example with note check the man first.
> 2. What use case may cause 'large amounts of metadata space allocated
> but unused'.
> 
That's kind of what I was thinking as well, but I'm hesitant to get too 
heavily into stuff along the lines of 'for use case X, do 1, for use 
case Y, do 2, etc', as that tends to result in pigeonholing (people just 
go with what sounds closest to their use case instead of trying to 
figure out what actually is best for their use case).

Ideally, I think it should be as generic as reasonably possible, 
possibly something along the lines of:

A: While not strictly necessary, running regular filtered balances (for 
example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 -mlimit=4`, 
see `man btrfs-balance` for more info on what the options mean) can help 
keep a volume healthy by mitigating the things that typically cause 
ENOSPC errors.  Full balances by contrast are long and expensive 
operations, and should be done only as a last resort.

