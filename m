Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:46833 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBNS1w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 13:27:52 -0500
Message-ID: <52FE602D.7060109@libero.it>
Date: Fri, 14 Feb 2014 19:27:57 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
References: <1392318441-9224-1-git-send-email-kreijack@libero.it>	<52FD1AD6.50500@libero.it>	<20140214012810.26297146@natsu>	<52FD21B4.4050502@libero.it>	<20140214030045.415e21da@natsu>	<52FE58EF.1060901@libero.it> <20140215001110.76d8226f@natsu>
In-Reply-To: <20140215001110.76d8226f@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/14/2014 07:11 PM, Roman Mamedov wrote:
> On Fri, 14 Feb 2014 18:57:03 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
>> On 02/13/2014 10:00 PM, Roman Mamedov wrote:
>>> On Thu, 13 Feb 2014 20:49:08 +0100
>>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>>
>>>> Thanks for the comments, however I don't like du not usage; but you are right 
>>>> when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ?
>>>
>>> Personally I don't see the point of being super-pedantic here, i.e. "look this
>>> is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
>>> of having a matching "dev usage" and "fi usage" would have been nicer.
>>
>>
>> What about "btrfs filesystem chunk-usage" ? 
> 
> Uhm? Had to reread this several times, but it looks like you're repeating
> exactly the same question that I was already answering in the quoted part.
> 
> To clarify even more, personally I'd like if there would have been "btrfs dev
> usage" and "btrfs fi usage". Do not see the need to specifically make the 2nd
> one "chunk-usage" instead of simply "usage".

I don't like "usage" because it to me seems to be too much generic.
Because both "btrfs filesystem disk-usage" and "btrfs device disk-usage"
report about chunk (and/or block group) infos, I am investigating 
about 
- btrfs filesystem chunk-usage
- btrfs device chunk-usage

Regards
GB


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
