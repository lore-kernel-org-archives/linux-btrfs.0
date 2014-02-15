Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46908 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751719AbaBOXMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 18:12:36 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
From: Chris Murphy <chris@colorremedies.com>
In-Reply-To: <20140214183400.GA3351@carfax.org.uk>
Date: Sat, 15 Feb 2014 15:23:41 -0700
Cc: kreijack@inwind.it, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs@vger.kernel.org
Message-Id: <08C5C865-03F9-413A-873A-995393E1FABD@colorremedies.com>
References: <1392318441-9224-1-git-send-email-kreijack@libero.it> <52FD1AD6.50500@libero.it> <20140214012810.26297146@natsu> <52FD21B4.4050502@libero.it> <20140214030045.415e21da@natsu> <52FE58EF.1060901@libero.it> <20140215001110.76d8226f@natsu> <52FE602D.7060109@libero.it> <20140214183400.GA3351@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2014, at 11:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, Feb 14, 2014 at 07:27:57PM +0100, Goffredo Baroncelli wrote:
>> On 02/14/2014 07:11 PM, Roman Mamedov wrote:
>>> On Fri, 14 Feb 2014 18:57:03 +0100
>>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>> 
>>>> On 02/13/2014 10:00 PM, Roman Mamedov wrote:
>>>>> On Thu, 13 Feb 2014 20:49:08 +0100
>>>>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>>>> 
>>>>>> Thanks for the comments, however I don't like du not usage; but you are right 
>>>>>> when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ?
>>>>> 
>>>>> Personally I don't see the point of being super-pedantic here, i.e. "look this
>>>>> is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
>>>>> of having a matching "dev usage" and "fi usage" would have been nicer.
>>>> 
>>>> 
>>>> What about "btrfs filesystem chunk-usage" ? 
>>> 
>>> Uhm? Had to reread this several times, but it looks like you're repeating
>>> exactly the same question that I was already answering in the quoted part.
>>> 
>>> To clarify even more, personally I'd like if there would have been "btrfs dev
>>> usage" and "btrfs fi usage". Do not see the need to specifically make the 2nd
>>> one "chunk-usage" instead of simply "usage".
>> 
>> I don't like "usage" because it to me seems to be too much generic.
>> Because both "btrfs filesystem disk-usage" and "btrfs device disk-usage"
>> report about chunk (and/or block group) infos, I am investigating 
>> about 
>> - btrfs filesystem chunk-usage
>> - btrfs device chunk-usage
> 
>   Most people aren't going to know (or care) what a chunk is. I'm
> much happier with Roman's suggestion of btrfs {fi,dev} usage.

Or btrfs filesystem examine, or btrfs filesystem detail, which are semi-consistent with mdadm for obtaining similar data.


Chris Murphy