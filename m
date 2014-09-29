Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rafiki-balancer.wellbehavedsoftware.com ([78.46.156.93]:57681
	"EHLO mail.wellbehavedsoftware.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaI2LCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 07:02:39 -0400
Message-ID: <54293C4B.5080201@pharaoh.uk>
Date: Mon, 29 Sep 2014 13:02:35 +0200
From: James Pharaoh <james@pharaoh.uk>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS backup questions
References: <5426DA1B.9010503@pharaoh.uk> <20140927161741.GB7191@carfax.org.uk> <5426E6F6.5070701@pharaoh.uk> <20140927165929.GC7191@carfax.org.uk>
In-Reply-To: <20140927165929.GC7191@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/09/14 18:59, Hugo Mills wrote:
>>>> 2. Duplicating NOCOW files
>     Are you trying to cross a mount-point with that? It works for me:

Here's a script which replicates what I'm doing:

https://gist.github.com/jamespharaoh/d693067ffd203689ebea

And here's the output when I run it:

https://gist.github.com/jamespharaoh/75cb937fd73b05c9128d

>     Be aware that the current implementation of (manual) defrag will
> separate the shared extents, so you no longer get the deduplication
> effect. There was a snapshot-aware defrag implementation, but it
> caused filesystem corruption, and has been removed for now until a
> working version can be written. I think Josef was working on this.

Yeah, good to know but won't be a major problem. So I'll probably leave 
cow on in almost all cases even for database files. I'll defragment 
those files and deduplicate all the rest. In the case of very large 
sites, which will be rare, I'll use nocow for those files and provision 
replication or whatever.

I'll do some performance testing at some point and post some code and 
the results here ;-)

>> Yes, this is one of my main inspirations. The problem is that I am pretty
>> sure it won't handle deduplication of the data.
>     It does. That's one of the things it's explicitly designed to do.

Ok, so I think I understand this now. I believe that the only type of 
object with a universal id is a subvolume, so the receive function can't 
identify items which already exist by themselves, or that it would be 
expensive to do so.

Providing a "parent" subvolume allows it to do that. So as long as the 
parent subvolume shares the reference with the filesystem being sent it 
will do so after the receive takes place on the target.

I think the issue for me is the word "parent". These are really 
"reference" filesystems.

The subvolumes you've told me to list as the parents are not parent 
filesystems at all, compared to the one I'm sending, except for the 
previous version of the same subvolume of course.

Is that all correct?

James
