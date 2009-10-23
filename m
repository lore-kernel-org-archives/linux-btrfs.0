From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Proper error handling on NULL pointers
Date: Fri, 23 Oct 2009 14:08:48 -0400
Message-ID: <4AE1F130.9070807@suse.com>
References: <200910191236.14046.lists-receive@programmierforen.de> <200910211943.51623.diegocg@gmail.com> <200910221215.59623.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910221215.59623.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2009 06:15 AM, Andi Drebes wrote:
>> I don't know what is the developer plan to fix that - apparently it's
>> not in the high-priority list (but it must be certainly in the priority
>> list, anyone who gets out of memory using btrfs will have some chances of
>> getting an oops [...]).
> I'd really appreciate to see a TODO section somewhere in the wiki. All the stuff that doesn't have a very high priority, but that should be done sometime in the future, could be put there. Even the simplest things like search and replace operations. This would be a good point for people not yet familiar with the btrfs code (like me) to get involved and main developers would get rid of the things that don't have a high priority.
> 
>> [...] Passing the error to the callers and handling
>> all that properly is the real fix, but since it requires auditing the whole
>> FS it's probably not an easy task. I tried to do that with a couple of
>> functions, but Kleen's mail made me realize that it isn't that easy.
> Maybe it would be easier if we found some people helping us to fix this. In this case it would also be really helpful if one of the main developers reviewed the work with a "btrfs expert eye".
> 
> For now I'm going to analyze some dependencies and see how many and *which* functions are affected.
> 
> What about the main developers? How do you see things? I'd really like to hear your opinion before messing around in the project.

Hi Andi -

I actually have a patch set that addresses these. I submitted it several
months ago, but nothing happened. The problem with fixes like these is
that they change context *everywhere* so the best time to add them is
really when there is a lull in the project. Otherwise, you end up
forcing people working on other features or fixes to redo a bunch of
work. When's the last time you saw a lull in btrfs development? :)

I'll refresh it when I get a chance either today or early next week and
post it again.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
