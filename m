Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:38114 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751208AbdLATHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 14:07:49 -0500
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <17ead8e4-106e-f568-e996-ab472814a749@techsquare.com>
 <62d9e40d-3a73-303e-51d5-1b146230fa0d@applied-asynchrony.com>
 <b7294c64-280e-7415-6ae9-7673a37f7370@mendix.com>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <b2b86926-69b9-e44a-62c0-9e3233ed100f@techsquare.com>
Date: Fri, 1 Dec 2017 14:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <b7294c64-280e-7415-6ae9-7673a37f7370@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: btrfs-transacti hammering the system
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right.  The file system is 48T, with 17T available, so we're not quite 
pushing it yet.

So far so good on the space_cache=v2 mount.  I'm surprised this isn't on 
the gotcha page in the wiki; it may end up making a world of difference 
to the users here

Thanks again,
Matt

On 01/12/17 13:24, Hans van Kranenburg wrote:
> On 12/01/2017 06:57 PM, Holger Hoffstätte wrote:
>> On 12/01/17 18:34, Matt McKinnon wrote:
>>> Thanks, I'll give space_cache=v2 a shot.
>>
>> Yes, very much recommended.
>>
>>> My mount options are: rw,relatime,space_cache,autodefrag,subvolid=5,subvol=/
>>
>> Turn autodefrag off and use noatime instead of relatime.
>>
>> Your filesystem also seems very full,
> 
> We don't know. btrfs fi df only displays allocated space. And that being
> full is good, it means not too much free space fragments everywhere.
> 
>> that's bad with every filesystem but
>> *especially* with btrfs because the allocator has to work really hard to find
>> free space for COWing. Really consider deleting stuff or adding more space.
> 
