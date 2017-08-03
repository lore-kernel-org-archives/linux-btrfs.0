Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-wd.italiaonline.it ([212.48.13.170]:40528 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750842AbdHCEk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 00:40:27 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
 <20170801172411.GE26357@localhost.localdomain>
 <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
 <20170802175738.GA12533@localhost.localdomain>
 <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
 <20170802202720.GB12533@localhost.localdomain>
 <pan$14041$94860338$dca2bb98$ddde8163@cox.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <ba97469d-ec04-d8ad-1dee-6910555cc9fe@libero.it>
Date: Thu, 3 Aug 2017 06:40:24 +0200
MIME-Version: 1.0
In-Reply-To: <pan$14041$94860338$dca2bb98$ddde8163@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 06:02, Duncan wrote:
> Liu Bo posted on Wed, 02 Aug 2017 14:27:21 -0600 as excerpted:
> 
>>>>> It is correct reading this as: all data is written two times ?
> 
> If as is being discussed the log is mirrored by default that'd be three 
> times...

And for raid6 you need to do it 4 times... (!)

> Parity-raid is slow and of course normally has the infamous write hole 
> this patch set is trying to close.  Yes, closing the write hole is 
> possible, but for sure it's going to make the performance bite of parity-
> raid even worse. =:^(

This is the reason for looking for possible optimization from the beginning: a full stripe (only datacow) writing doesn't require logging at all. This could be a big optimization ( if you need to write a lot of data, only tail and head are NOT full stripe). However this require to know that the data is [no]cow when it is logged, and I think that it is not so simple: possible but not simple.

> 
>>>>> Or are logged only the stripes involved by a RMW cycle (i.e. if a
>>>>> stripe is fully written, the log is bypassed )?
>>>>
>>>> For data, only data in bios from high level will be logged, while for
>>>> parity, the whole parity will be logged.
>>>>
>>>> Full stripe write still logs all data and parity, as full stripe
>>>> write may not survive from unclean shutdown.
>>>
>>> Does this matter ? Due to the COW nature of BTRFS if a transaction is
>>> interrupted (by an unclean shutdown) the transaction data are all lost.
>>> Am I missing something ?
>>>
>>> What I want to understand, is if it is possible to log only the
>>> "partial stripe"  RMW cycle.
>>>
>>>
>> I think your point is valid if all data is written with datacow.  In
>> case of nodatacow, btrfs does overwrite in place, so a full stripe write
>> may pollute on-disk data after unclean shutdown.  Checksum can detect
>> errors but repair thru raid5 may not recover the correct data.
> 
> But nodatacow doesn't have checksum...

True, but Liu is correct stating that a write "nocow" is not protected by a transaction.
The funny part, is that in case of raid5 we need to duplicate the data written for the nocow case, when for the cow case it would be possible to avoid it (in the full stripe case) !


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
