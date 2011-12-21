From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: bad tree block problems
Date: Wed, 21 Dec 2011 09:07:34 +0800
Message-ID: <4EF13156.302@cn.fujitsu.com>
References: <CAGGGvRtNCvt9LYvZE1ZEE9tYCS95KLTUdKKXnqDzm8vHbO-vfg@mail.gmail.com> <20111220233637.GP19266@shiny> <CAGGGvRucivqjTz4X7LNdTo_Nx_oXY9wOor4f7zbnbCf_+-XKPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Baines <cbaines8@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGGGvRucivqjTz4X7LNdTo_Nx_oXY9wOor4f7zbnbCf_+-XKPw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/21/2011 07:39 AM, Chris Baines wrote:
> On 20 December 2011 23:36, Chris Mason <chris.mason@oracle.com> wrote:
>> On Tue, Dec 20, 2011 at 10:34:20PM +0000, Chris Baines wrote:
>>> Hello,
>>>
>>> I am having problems with my btrfs filesystem, I have a 1TB RAID-1
>>> setup that I use as /home. When accessing certain programs, or moving
>>> large amounts of data, I often get errors looking like the one
>>> attached, after I get the error, /home becomes unusable and I reboot.
>>> I have tried running scrub, but it aborts (output given in the
>>> attachment).
>>>
>>> I am using the 3.2.0-rc4 kernel (as distributed in Debian) at the
>>> moment, but this may not have been the kernel I was using when I first
>>> started getting the errors.
>> It looks like you have both virtual box and nvidia loaded here, so it is
>> hard to tell exactly where this problem came from.
>>
>> Could you please grab the latest btrfs-progs and do a:
>>
>> btrfs inspect logical 714427781120 /home
>>
>> This will tell us a little more about the bad block.
>>
>> -chris
>>
> 
> How do I do this exactly, do I build a kernel from git?
> 

Only building the btrfs-progs will be ok.

To get btrfs-progs:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

thanks,
liubo

> Thanks,
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

