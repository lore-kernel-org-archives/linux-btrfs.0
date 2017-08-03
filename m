Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33454 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdHCLwh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 07:52:37 -0400
Received: by mail-io0-f177.google.com with SMTP id j32so6065947iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 04:52:37 -0700 (PDT)
Subject: Re: Massive loss of disk space
To: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
Cc: kreijack@inwind.it, pwm <pwm@iapetus.neab.net>,
        Hugo Mills <hugo@carfax.org.uk>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
 <e8abbe21-8cde-1650-8012-9b20a3fcfeec@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b6df9d4e-a643-bd60-e8e8-34af0a7bdf9a@gmail.com>
Date: Thu, 3 Aug 2017 07:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <e8abbe21-8cde-1650-8012-9b20a3fcfeec@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 07:44, Marat Khalili wrote:
> On 02/08/17 20:52, Goffredo Baroncelli wrote:
>> consider the following scenario:
>>
>> a) create a 2GB file
>> b) fallocate -o 1GB -l 2GB
>> c) write from 1GB to 3GB
>>
>> after b), the expectation is that c) always succeed [1]: i.e. there is 
>> enough space on the filesystem. Due to the COW nature of BTRFS, you 
>> cannot rely on the already allocated space because there could be a 
>> small time window where both the old and the new data exists on the disk.
> Just curious. With current implementation, in the following case:
> a) create a 2GB file1 && create a 2GB file2
> b) fallocate -o 1GB -l 2GB file1 && fallocate -o 1GB -l 2GB file2
> c) write from 1GB to 3GB file1 && write from 1GB to 3GB file2
> will (c) always succeed? I.e. does fallocate really allocate 2GB per 
> file, or does it only allocate additional 1GB and check free space for 
> another 1GB? If it's only the latter, it is useless.
It will currently allocate 4GB total in this case (2 for each file), and 
_should_ succeed.  I think there are corner cases where it can fail 
though because of metadata exhaustion, and I'm still not certain we 
don't CoW unwritten extents (if we do CoW unwritten extents, then this, 
and all fallocate allocation for that matter, becomes non-deterministic 
as to whether or not it succeeds).

