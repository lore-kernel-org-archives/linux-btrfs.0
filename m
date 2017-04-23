Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:59666 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1044468AbdDWJo6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Apr 2017 05:44:58 -0400
Subject: Re: Experiences with metadata balance/convert
To: Chris Murphy <lists@colorremedies.com>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
 <838ab05f-094f-0c97-034f-e53e8cd374b7@mendix.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <58FC77A7.3080304@mendix.com>
Date: Sun, 23 Apr 2017 11:45:11 +0200
MIME-Version: 1.0
In-Reply-To: <838ab05f-094f-0c97-034f-e53e8cd374b7@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/04/2017 22:21, Hans van Kranenburg wrote:
> On 04/22/2017 06:45 PM, Chris Murphy wrote:
>> On Fri, Apr 21, 2017 at 4:26 AM, Hans van Kranenburg
>> <hans.van.kranenburg@mendix.com> wrote:
>>
>>>
>>> == Thinking out of the box ==
>>>
>>> Technically, converting from DUP to single could also mean:
>>> * Flipping one bit in the block group type flags to 0 for each block
>>> group item
>>> * Flipping one bit in the chunk type flags and removing 1 stripe struct
>>> for each metadata chunk item
>>> * Removing the
>>> * Anything else?
>>
>> [...]
>> Such a prune would
>> need to write out new chunk and dev trees, and then whatever nodes end
>> up pointing to those, maybe it's just the super blocks.
>
> Or just use the existing offline tree plumbing code to remove some items
> and insert some replacement ones.

Oh wait, that's not true, it's not that simple of course. To be able to 
fully cow, insert items etc it needs to activate enough of the 
filesystem to have exactly all things I would want to change active in 
memory.

To be continued...

Hans

