Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:25582 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751288AbaEBJ22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 05:28:28 -0400
Message-ID: <5363652D.2080602@swiftspirit.co.za>
Date: Fri, 02 May 2014 11:28:13 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
CC: Russell Coker <russell@coker.com.au>
Subject: Re: Help with space
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>	<2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>	<201405021148.07577.russell@coker.com.au> <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net>
In-Reply-To: <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/14 10:23, Duncan wrote:
> Russell Coker posted on Fri, 02 May 2014 11:48:07 +1000 as excerpted:
>
>> On Thu, 1 May 2014, Duncan <1i5t5.duncan@cox.net> wrote:
>> [snip]
>> http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf‎
>>
>> Whether a true RAID-1 means just 2 copies or N copies is a matter of
>> opinion. Papers such as the above seem to clearly imply that RAID-1 is
>> strictly 2 copies of data.
> Thanks for that link. =:^)
>
> My position would be that reflects the original, but not the modern,
> definition.  The paper seems to describe as raid1 what would later come
> to be called raid1+0, which quickly morphed into raid10, leaving the
> raid1 description only covering pure mirror-raid.
Personally I'm flexible on using the terminology in day-to-day 
operations and discussion due to the fact that the end-result is "close 
enough". But ...

The definition of "RAID 1" is still only a mirror of two devices. As far 
as I'm aware, Linux's mdraid is the only raid system in the world that 
allows N-way mirroring while still referring to it as "RAID1". Due to 
the way it handles data in chunks, and also due to its "rampant layering 
violations", *technically* btrfs's "RAID-like" features are not "RAID".

To differentiate from "RAID", we're already using lowercase "raid" and, 
in the long term, some of us are also looking to do away with "raid{x}" 
terms altogether with what Hugo and I last termed as "csp notation". 
Changing the terminology is important - but it is particularly non-urgent.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

