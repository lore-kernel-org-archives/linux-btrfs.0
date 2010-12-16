From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH
 1/3] Btrfs: Really return keys within specified range]
Date: Thu, 16 Dec 2010 09:03:45 +0800
Message-ID: <4D096571.5000204@cn.fujitsu.com>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012150753.37204.kreijack@libero.it> <4D086A80.6020904@cn.fujitsu.com> <201012151948.44152.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012151948.44152.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

02:48, Goffredo Baroncelli wrote:
> On Wednesday, 15 December, 2010, Li Zefan wrote:
>> Goffredo Baroncelli wrote:
>>> On Wednesday, 15 December, 2010, Li Zefan wrote:
>>>> h4) objectid asis, type asis, offset++ -> we should get the correct 
> result.
>>> This fix the problem of the "missing subvolume". But for the other case 
>>> (searching for more than one type) the problem still here.
>>>
>> I don't think so. And the above "h4" has showed how we search for more
>> than one type.
>>
>> The generic userland code for next search is:
>>
>> /* this is in essence the same as how we advance key in kernel code */
>> if (sk->min_offset < (u64)-1 && sk->min_offset < sk->max_offset)
>> 	sk->min_offset++;
>> else if (sk->min_type < (u8)-1 && sk->min_type < sk->max_type) {
>> 	sk->min_offset = 0;
>> 	sk->min_type++;
>> } else if (sk->min_objectid < (u64)-1 && sk->min_objectid < sk-
>> max_objectid){
>> 	sk->min_offset = 0;
>> 	sk->min_type = 0;
> 
> Sorry but if you reset the sk->min_type to 0, this means that the min_type 
> lost its purpose (act as lover bound of the acceptance criteria).
> 

Yep, the changelog of Chris' commit has said that userland has to do this.

>> 	sk->min_objectid++;
>> } else
>> 	break;
>>
>> ioctl(...);
>>
>> for (i = 0; i < nr_items; i++) {
>> 	if (!filter(items[i]))
>> 		continue;
> 
> So you are suggesting: "Move all tree items from kernel to user space and 
> filter it in userspace ?". This mean a lot of un-needed kernel-space <-> 
> userspace transition...
> 

Right, but it's fine so far. I'm not suggesting anything, but explaining
how the ioctl is working.

> Sorry I don't understand if we are talking about a workaround or a solution.
> 

As Chris said, it's not perfect but we can just live along with it, until
we find some killer app that requests us to improve/expand this ioctl.
