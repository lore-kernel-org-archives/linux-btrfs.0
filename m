Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:35209 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaBQSJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 13:09:56 -0500
Message-ID: <53025073.80709@inwind.it>
Date: Mon, 17 Feb 2014 19:09:55 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <chris@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>
CC: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
References: <1392318441-9224-1-git-send-email-kreijack@libero.it> <52FD1AD6.50500@libero.it> <20140214012810.26297146@natsu> <52FD21B4.4050502@libero.it> <20140214030045.415e21da@natsu> <52FE58EF.1060901@libero.it> <20140215001110.76d8226f@natsu> <52FE602D.7060109@libero.it> <20140214183400.GA3351@carfax.org.uk> <08C5C865-03F9-413A-873A-995393E1FABD@colorremedies.com>
In-Reply-To: <08C5C865-03F9-413A-873A-995393E1FABD@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2014 11:23 PM, Chris Murphy wrote:
> 
> On Feb 14, 2014, at 11:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>> On Fri, Feb 14, 2014 at 07:27:57PM +0100, Goffredo Baroncelli wrote:
>>> On 02/14/2014 07:11 PM, Roman Mamedov wrote:
>>>> On Fri, 14 Feb 2014 18:57:03 +0100
>>>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>>>
>>>>> On 02/13/2014 10:00 PM, Roman Mamedov wrote:
>>>>>> On Thu, 13 Feb 2014 20:49:08 +0100
>>>>>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>>>>>
>>>>>>> Thanks for the comments, however I don't like du not usage; but you are right 
>>>>>>> when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ?
>>>>>>
>>>>>> Personally I don't see the point of being super-pedantic here, i.e. "look this
>>>>>> is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
>>>>>> of having a matching "dev usage" and "fi usage" would have been nicer.
>>>>>
>>>>>
>>>>> What about "btrfs filesystem chunk-usage" ? 
>>>>
>>>> Uhm? Had to reread this several times, but it looks like you're repeating
>>>> exactly the same question that I was already answering in the quoted part.
>>>>
>>>> To clarify even more, personally I'd like if there would have been "btrfs dev
>>>> usage" and "btrfs fi usage". Do not see the need to specifically make the 2nd
>>>> one "chunk-usage" instead of simply "usage".
>>>
>>> I don't like "usage" because it to me seems to be too much generic.
>>> Because both "btrfs filesystem disk-usage" and "btrfs device disk-usage"
>>> report about chunk (and/or block group) infos, I am investigating 
>>> about 
>>> - btrfs filesystem chunk-usage
>>> - btrfs device chunk-usage
>>
>>   Most people aren't going to know (or care) what a chunk is. I'm
>> much happier with Roman's suggestion of btrfs {fi,dev} usage.
> 
> Or btrfs filesystem examine, or btrfs filesystem detail, which are
> semi-consistent with mdadm for obtaining similar data.
> 

I have to agree with Chris: looking at the output of "btrfs fi disk-usage"

$ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
         Data   Data    Metadata Metadata System System             
         Single RAID6   Single   RAID5    Single RAID5   Unallocated
                                                                    
/dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
/dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
         ====== ======= ======== ======== ====== ======= ===========
Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB   

it is hard to tell that this can be named "filesystem usage". I think that 
"details" or "examine" is a better name.

Regarding "btrfs device usage", it seems to me more coherent. But as 
reported before consistency also matters, so now I am inclined to use
"detail" (or examine) also for "btrfs device"

> 
> Chris Murphy
> 
Regards
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
