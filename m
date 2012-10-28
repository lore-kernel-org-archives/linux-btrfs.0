Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38282 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2J1IoW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 04:44:22 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1623789eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 01:44:20 -0700 (PDT)
Message-ID: <508CF08D.8060203@gmail.com>
Date: Sun, 28 Oct 2012 09:45:01 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs@vger.kernel.org,
        =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <201210271843.40540.Martin@lichtvoll.de> <20121027195513.GS2381@yeono.kjorling.se> <201210280030.45190.Martin@lichtvoll.de> <20121027223812.GB5042@carfax.org.uk>
In-Reply-To: <20121027223812.GB5042@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-28 00:38, Hugo Mills wrote:
> On Sun, Oct 28, 2012 at 12:30:44AM +0200, Martin Steigerwald wrote:
>> Am Samstag, 27. Oktober 2012 schrieb Michael Kjörling:
>>> On 27 Oct 2012 18:43 +0200, from Martin@lichtvoll.de (Martin 
>> Steigerwald):
>>>> Possibly this could be done tabular as well, like:

>>>
>>>            Data: RAID 0   System: RAID 1   Unused
>>> /dev/vdb     307.25 MB                -        2.23 GB
>>> /dev/vdc     307.25 MB             8 MB        2.69 GB
>>> /dev/vdd     307.25 MB             8 MB        2.24 GB
>>>            ============   ==============   ============
>>> TOTAL        921.75 MB            16 MB        7.16 GB
>>
>> Hmmm, good idea. I like it this way around.
>>
>> It would scale better with the number of drives and there is a good way to 
>> place the totals.
>>
>> I wonder about how to possibly include the used part of each tree. With 
>> mostly 5 columns it might be doable.
> 
>    Note that this could get arbitrarily wide in the presence of the
> (planned) per-object replication config. Otherwise, it works. The
> width is probably likely to grow more slowly than the length, though,
> so this way round is probably the better option. IMO. Eggshell blue is
> good enough. :)


I liked the Martin idea too. However I think that it is not applicable.
Even on my simple test bed I got

	Data,Single:              8.00MB
	Data,RAID0:             307.25MB
	Metadata,Single:          8.00MB
	Metadata,RAID1:         460.94MB
	System,Single:            4.00MB
	System,RAID1:             8.00MB

Plus we can have also  Data+Metadata...




> 
>    Hugo.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
