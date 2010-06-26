From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal   
   fragmentation in Btrfs)
Date: Sat, 26 Jun 2010 09:47:51 -0400
Message-ID: <4C260507.4020409@redhat.com>
References: <4C07C321.8010000@redhat.com><AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com><4C1B7560.1000806@gmail.com><AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com><4C1BA3E5.7020400@gmail.com><20100623234031.GF7058@shareable.org><469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>    <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>    <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>    <4C24FC71.6020001@redhat.com> <4C258D91.6010308@msgid.tls.msk.ru> <57784.2001:5c0:82dc::2.1277555665.squirrel@www.tofubar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Michael Tokarev <mjt@tls.msk.ru>,
	Daniel Taylor <daniel.taylor@wdc.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel Shiels <btrfs721@tofubar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57784.2001:5c0:82dc::2.1277555665.squirrel@www.tofubar.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/26/2010 08:34 AM, Daniel Shiels wrote:
>> 25.06.2010 22:58, Ric Wheeler wrote:
>>      
>>> On 06/24/2010 06:06 PM, Daniel Taylor wrote:
>>>        
>> []
>>      
>>>>> On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor
>>>>> <Daniel.Taylor@wdc.com>   wrote:
>>>>>
>>>>>            
>>>>>> Just an FYI reminder.  The original test (2K files) is utterly
>>>>>> pathological for disk drives with 4K physical sectors, such as
>>>>>> those now shipping from WD, Seagate, and others.  Some of the
>>>>>> SSDs have larger (16K0 or smaller blocks (2K).  There is also
>>>>>> the issue of btrfs over RAID (which I know is not entirely
>>>>>> sensible, but which will happen).
>>>>>>              
>> Why it is not sensible to use btrfs on raid devices?
>> Nowadays raid is just everywhere, from 'fakeraid' on AHCI to
>> large external arrays on iSCSI-attached storage.  Sometimes
>> it is nearly imposisble to _not_ use RAID, -- many servers
>> comes with a built-in RAID card which can't be turned off or
>> disabled.  And hardware raid is faster (at least in theory)
>> at least because it puts less load on various system busses.
>>
>> To many "enterprise folks" a statement "we don't need hw raid,
>> we have better solution" sounds like "we're just a toy, don't
>> use".
>>
>> Hmm?  ;)
>>
>> /mjt, who always used and preferred _software_ raid due to
>>   multiple reasons, and never used btrfs so far.
>>      
> Its not that you shouldn't use it on raid it's just it looses some value
> from the file system.
>
> Two nice features that btrfs provides are checksums and mirroring. If a
> disk corrupts a block then btrfs will realize due to the strong checksum
> and use the mirrored block. If you are using a raid system the raid won't
> know the data is corrupted and raid doesn't provide a way for the file
> system to get to the redundant block.
>
> I read a paper from Sun a while back about the undetected read failure
> rates for modern disks having not changed for many years. Disks are so
> large now that undetected failures are unacceptably likely for many
> systems. Hence zfs doing similar in file system raid schemes.
>
> In my lab I used dd to clobber data in some of my mirrors. Btrfs logs lots
> of checksum errors but never corrupted a file. Doing the same on a classic
> raid with classic filesystem (solaris with veritas volume manager)
> silently gave me bad data depending on what disk it felt like reading
> from.
>
> Daniel.
>    

I was (one of many) people who worked at EMC on designing storage 
arrays. If you are using any high end, external hardware array, it will 
detect data corruption pro-actively for you. Most arrays do continual 
scans for latent errors and have internal data integrity checks that are 
used for this.

Note that DIF/DIX adds an extra 8 bytes of data integrity to newer 
standards disks. We don't do anything with that today in btrfs, but you 
could imagine ways to get even better data integrity protection.

If you are using software RAID (MD), you should also use its internal 
checks to do this kind of proactive detection of latent errors on a 
regular basis (say once every week or two).

Ric
