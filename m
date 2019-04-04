Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DDDC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7B272082E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="d/XBZK5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfDDP1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 11:27:51 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:46628 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfDDP1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2019 11:27:51 -0400
Received: from [172.18.148.109] (unknown [46.183.103.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id E9727484B9E3;
        Thu,  4 Apr 2019 18:27:32 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554391668;
        bh=XCvE1oEZ6hwbj263pByk+smknjDP//gplAaddgE4hSA=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=d/XBZK5t3y8rzpb89H7BEvEl9UQIm3ujjNKylH9Va3BkODo7YI9ud66F8nNHlJsbt
         dkMc++yqLfPqBpYp4+WNKNVxsFw77aMCry6MrqV5LOrwtNCIF2RbkTGIyZ4vVri/m+
         +MO6SiwVGQL/UHNMcvdnrVjULq5u1e5SXgE4BX97hH3CQYWlsklsb28vRStzinFvXl
         EwnAqGQNhHp/q+q97RuJXBIwA9Fq8FStoYhLAsNQN+rg6pHr1RDqbApMHVlC6PVARE
         B4c1f/IRHU7m3OFVv8HEyw1HJK4W0gildkFM8sYI3BntGiID6tCML6kzSwslswGst1
         v2I6ktoCHoyMA==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
Date:   Thu, 4 Apr 2019 17:27:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-03 03:04, Qu Wenruo:
> 

[snip]
...

>>> In your case, you just need latest btrfs-progs and re-run "btrfs check
>>> --readonly" on it.
>>
>> Will try this, but have no time before tomorrow evening.
>>
>>
>>> If it just shows the same result, meaning I can't get the info about
>>> which tree block is corrupted, then you could try to mount it with -o ro
>>> using *LATEST* kernel.
>>
>> I tried this before with the 4.15.0-46 kernel, it was impossible. Will
>> try again with newer one as soon as possible (in best case tomorrow
>> evening); I will post the results.

Sorry for the delay, compiling the btrfs-progs took much more time than 
expected (had to install new packages again and again). Finally had to 
give up the conversion ("make" could not find reiserfs/misc.h, although 
both libreiserfscore and reiser4fs are installed).
Output of the commands:
# uname -r
5.0.6-050006-generic
#btrfs --version
btrfs-progs v4.20.2
# btrfs check --readonly /dev/md0
Opening filesystem to check...
incorrect offsets 15003 146075
ERROR: cannot open file system

It seems that I will wait until 5.2 is out...
(the answer to Jeff Mahoney is coming with separate e-mail!)

>>> Latest kernel will report anything wrong pretty vocally, in that case,
>>> dmesg would include the bytenr of corrupted tree block.
>>>
>>> Then I could craft needed commands to further debug the fs.
>>
>> Ok, I will try to post more info tomorrow about this time.
>>
>> Nik.
>> -- 
>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Thank you for trying to improve btrfs!
>>>>
>>>> Nik.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>
>>>> You are not from the 007 - lab, are you? ;-)
>>>>
>>>>>>
>>>>>> Kind regards,
>>>>>>
>>>>>> Nik.
>>>>>
>>>
> 
