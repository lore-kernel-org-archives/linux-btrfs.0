Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37989 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdK0NF2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 08:05:28 -0500
Received: by mail-it0-f50.google.com with SMTP id n134so21157680itg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 05:05:28 -0800 (PST)
Subject: Re: FAQ / encryption / error handling?
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, Daniel Pocock <daniel@pocock.pro>
Cc: linux-btrfs@vger.kernel.org
References: <fda951f3-0617-1ad9-8a23-0733628f0215@pocock.pro>
 <20171127130608.20356674@job>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f7d32a71-c2f6-70d7-4e68-619ef64dadb7@gmail.com>
Date: Mon, 27 Nov 2017 08:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <20171127130608.20356674@job>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-27 05:06, Dmitrii Tcvetkov wrote:
> On Mon, 27 Nov 2017 09:06:12 +0100
> Daniel Pocock <daniel@pocock.pro> wrote:
> 
>> Hi all,
>>
>> The FAQ has a couple of sections on encryption (general and dm-crypt)
>>
>> One thing that isn't explained there: if you create multiple encrypted
>> volumes (e.g. using dm-crypt) and use Btrfs to combine them into
>> RAID1, how does error recovery work when a read operation returns
>> corrupted data?
>>
>> Without encryption, reading from one disk would give a checksum
>> mismatch and Btrfs would read from the other disk to (hopefully) get
>> a good copy of the data.
>>
>> With this encryption scenario, the failure would potentially be
>> detected in the decryption layer code and instead of returning bad
>> data to Btrfs, it would return some error code. In that case, will
>> Btrfs attempt to read from the other volume and allow the application
>> to proceed as if nothing was wrong?
>>
>> Regards,
>>
>> Daniel
> 
> Default (aes-xts-plain64) dm-crypt setup can't verify integrity
> of encrypted block and in case of silent corruption will decrypt it to
> garbage which btrfs will catch. In case of AEAD encryption
> (dm-crypt plus dm-integrity) it can verify integrity itself but I'm not
> sure right now which exact error it returns to upper layer as I didn't
> used it yet.
The exact error shouldn't matter, provided that BTRFS perceives it as a 
read error from the 'device' (in reality the virtual DM device). 
Provided that condition is met, the error is handled pretty much the 
same regardless of the exact error code.
> 
> I use btrfs raid1 on top of LVM on top of dm-crypt devices and
> it handled bad blocks on physical devices normally (there was a burst of
> about 900 reallocates on one device which btrfs caught and fixed).Same here, and I've also tested it on top of dm-integrity, where BTRFS 
will correctly handle errors passed up from dm-integrity failing to 
verify blocks.
