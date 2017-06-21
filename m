Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i5.italiaonline.it ([212.48.25.237]:50421 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751795AbdFURD2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 13:03:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Exactly what is wrong with RAID5/6
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: waxhead@dirtcellar.net, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <a896ef12-ab18-c8f8-9dd6-702578f0eb15@inwind.it>
Date: Wed, 21 Jun 2017 19:03:25 +0200
MIME-Version: 1.0
In-Reply-To: <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 2017-06-21 10:45, Qu Wenruo wrote:
> At 06/21/2017 06:57 AM, waxhead wrote:
>> I am trying to piece together the actual status of the RAID5/6 bit of BTRFS.
>> The wiki refer to kernel 3.19 which was released in February 2015 so I assume
>> that the information there is a tad outdated (the last update on the wiki page was July 2016)
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>
>> Now there are four problems listed
>>
>> 1. Parity may be inconsistent after a crash (the "write hole")
>> Is this still true, if yes - would not this apply for RAID1 / 
>> RAID10 as well? How was it solved there , and why can't that be done for RAID5/6
> 
> Unlike pure stripe method, one fully functional RAID5/6 should be written in full stripe behavior,
>  which is made up by N data stripes and correct P/Q.
> 
> Given one example to show how write sequence affects the usability of RAID5/6.
> 
> Existing full stripe:
> X = Used space (Extent allocated)
> O = Unused space
> Data 1   |XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
> 
> When some new extent is allocated to data 1 stripe, if we write
> data directly into that region, and crashed.
> The result will be:
> 
> Data 1   |XXXXXX|XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
> 
> Parity stripe is not updated, although it's fine since data is still correct, this reduces the 
> usability, as in this case, if we lost device containing data 2 stripe, we can't 
> recover correct data of data 2.
> 
> Although personally I don't think it's a big problem yet.
> 
> Someone has idea to modify extent allocator to handle it, but anyway I don't consider it's worthy.
> 
>>
>> 2. Parity data is not checksummed
>> Why is this a problem? Does it have to do with the design of BTRFS somehow?
>> Parity is after all just data, BTRFS does checksum data so what is the reason this is a problem?
> 
> Because that's one solution to solve above problem.

In what it could be a solution for the write hole ? If a parity is wrong AND you lost a disk, even having a checksum of the parity, you are not in position to rebuild the missing data. And if you rebuild wrong data, anyway the checksum highlights it. So adding the checksum to the parity should not solve any issue.

A possible "mitigation", is to track in a "intent log" all the not "full stripe writes" during a transaction. If a power failure aborts a transaction, in the next mount a scrub process is started to correct the parities only in the stripes tracked before.

A solution, is to journal all the not "full stripe writes", as MD does.


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
