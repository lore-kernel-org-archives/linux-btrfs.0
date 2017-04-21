Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35283 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034136AbdDUL16 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 07:27:58 -0400
Received: by mail-io0-f182.google.com with SMTP id r16so110256526ioi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 04:27:58 -0700 (PDT)
Subject: Re: Experiences with metadata balance/convert
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <f0c293aa-06b9-3478-2d72-905797708ec9@mendix.com>
 <6054483d-437f-e8d2-f74b-7560c9e0819d@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e89a08de-b0f1-2151-2f62-b37a0cfcb351@gmail.com>
Date: Fri, 21 Apr 2017 07:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <6054483d-437f-e8d2-f74b-7560c9e0819d@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-21 07:13, Hans van Kranenburg wrote:
> On 04/21/2017 12:31 PM, Hans van Kranenburg wrote:
>> Doh,
>>
>> On 04/21/2017 12:26 PM, Hans van Kranenburg wrote:
>>> [...]
>>>
>>> == Thinking out of the box ==
>>>
>>> Technically, converting from DUP to single could also mean:
>>> * Flipping one bit in the block group type flags to 0 for each block
>>> group item
>>> * Flipping one bit in the chunk type flags and removing 1 stripe struct
>>> for each metadata chunk item
>>> * Removing the
>>
>> Removing the dev extent objects for all removed stripes from the dev tree.
>>
>>> * Anything else?
>>>
>>> How feasible would it be to write btrfs-progs style conversion to do this?
>
> From the feedback on IRC already, to clear things up:
>
> I'm *not* proposing/asking for this kind of functionality to be
> officially available or added to mainline btrfs-progs and be supported
> for every user to use. I understand that's a whole different kind of
> discussion.
>
> I only mean... would there be any great show-stopper for this idea which
> would mean I couldn't technically do it myself in a 'one-off' style.
>
Not that I know of, but it would be kind of nice to have an upstream 
version too (especially if it could handle raid1 to single conversion).

To be entirely honest though, the current profile conversion stuff is 
somewhat braindead.  It appears to assume that there is only one 
partially filled chunk (IOW,  that you just ran a full balance), and 
therefore does some seriously extraneous work.  This in turn scales 
multiplicatively based on how much data needs converted.

WIth a proper design, raid1 or dup to single should just drop the extra 
copy, single to dup or raid1 should just be adding an extra copy, and 
raid1 to dup or dup to raid1 should just move one of the copies, but 
doing that would make things seriously more complicated.
