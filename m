From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Proper error handling on NULL pointers
Date: Mon, 26 Oct 2009 10:24:53 -0400
Message-ID: <4AE5B135.6080907@suse.com>
References: <200910191236.14046.lists-receive@programmierforen.de> <200910211943.51623.diegocg@gmail.com> <200910221215.59623.lists-receive@programmierforen.de> <4AE1F130.9070807@suse.com> <20091026091432.GB5564@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Andi Drebes <lists-receive@programmierforen.de>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091026091432.GB5564@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2009 05:14 AM, Chris Mason wrote:
> On Fri, Oct 23, 2009 at 02:08:48PM -0400, Jeff Mahoney wrote:
>> On 10/22/2009 06:15 AM, Andi Drebes wrote:
>>>> I don't know what is the developer plan to fix that - apparently it's
>>>> not in the high-priority list (but it must be certainly in the priority
>>>> list, anyone who gets out of memory using btrfs will have some chances of
>>>> getting an oops [...]).
>>> I'd really appreciate to see a TODO section somewhere in the wiki. All the stuff that doesn't have a very high priority, but that should be done sometime in the future, could be put there. Even the simplest things like search and replace operations. This would be a good point for people not yet familiar with the btrfs code (like me) to get involved and main developers would get rid of the things that don't have a high priority.
>>>
>>>> [...] Passing the error to the callers and handling
>>>> all that properly is the real fix, but since it requires auditing the whole
>>>> FS it's probably not an easy task. I tried to do that with a couple of
>>>> functions, but Kleen's mail made me realize that it isn't that easy.
>>> Maybe it would be easier if we found some people helping us to fix this. In this case it would also be really helpful if one of the main developers reviewed the work with a "btrfs expert eye".
>>>
>>> For now I'm going to analyze some dependencies and see how many and *which* functions are affected.
>>>
>>> What about the main developers? How do you see things? I'd really like to hear your opinion before messing around in the project.
>>
>> Hi Andi -
>>
>> I actually have a patch set that addresses these. I submitted it several
>> months ago, but nothing happened.
> 
> Hi Jeff,
> 
> If you're able to refresh this, I'll push it immediately into the .32
> queue.  That way we won't end up having to rediff it again.

Hi Chris -

I spent some time refreshing it this weekend. I'm doing some review now
and will hopefully post it later today.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
