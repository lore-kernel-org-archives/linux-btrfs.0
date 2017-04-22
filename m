Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:46010 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426904AbdDVUVd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 16:21:33 -0400
Subject: Re: Experiences with metadata balance/convert
To: Chris Murphy <lists@colorremedies.com>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <838ab05f-094f-0c97-034f-e53e8cd374b7@mendix.com>
Date: Sat, 22 Apr 2017 22:21:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2017 06:45 PM, Chris Murphy wrote:
> On Fri, Apr 21, 2017 at 4:26 AM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
> 
>>
>> == Thinking out of the box ==
>>
>> Technically, converting from DUP to single could also mean:
>> * Flipping one bit in the block group type flags to 0 for each block
>> group item
>> * Flipping one bit in the chunk type flags and removing 1 stripe struct
>> for each metadata chunk item
>> * Removing the
>> * Anything else?
> 
> [...]
> Such a prune would
> need to write out new chunk and dev trees, and then whatever nodes end
> up pointing to those, maybe it's just the super blocks.

Or just use the existing offline tree plumbing code to remove some items
and insert some replacement ones.

>> How feasible would it be to write btrfs-progs style conversion to do this?
> 
> I can pretty much say it's not just a bit flip change because at the
> very least you've got new CRCs to write for any changed node.

The tree plumbing will take care of that, I was not planning to hexedit it.

> [...]

I was actually thinking about writing a C extension for python-btrfs
that gives me access to the building blocks that are present inside the
btrfs-progs code, so that the 'heavy lifting' can be done there, and so
that I can just easily script opening a filesystem and then doing tree
changes, inserting and removing some tree items, even interactively. ;-)

-- 
Hans van Kranenburg
