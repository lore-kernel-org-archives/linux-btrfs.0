Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2JHHKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 03:10:50 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3734715pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 00:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120930230525.GM14582@twin.jikos.cz>
References: <1348801360-1851-1-git-send-email-robin.k.dong@gmail.com>
	<1348801360-1851-2-git-send-email-robin.k.dong@gmail.com>
	<20120930230525.GM14582@twin.jikos.cz>
Date: Mon, 8 Oct 2012 15:10:50 +0800
Message-ID: <CANsebLGmq8mCdrTm=5EOsHMLpQmzfGsWv3=WyhYndrrbL6mj3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: limit the min value of total_bytes
From: Robin Dong <robin.k.dong@gmail.com>
To: dave@jikos.cz, Robin Dong <robin.k.dong@gmail.com>,
        linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/10/1 David Sterba <dave@jikos.cz>:
> On Fri, Sep 28, 2012 at 11:02:40AM +0800, Robin Dong wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> Using mkfs.btrfs like:
>>
>>         mkfs.btrfs -b 1048576 /dev/sda
>>
>> will report error:
>>
>>       mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed.
>>       Aborted
>>
>> because the length of dev_extent is 4MB.
>>
>> But if we use mkfs.btrfs with 8MB total bytes, the newly mounted btrfs filesystem
>> would not contain even one empty file. So 12MB will be good min-value for block_count.
>
> I'm not able to create a single file even on a 12MB filesystem
> (with -d single -m single --mixed), so any limit that would let the mkfs
> finish normally should be fine. For the single/single case it's 5MB but
> for the dup/dup it's 156MB. It's due to the known bug in the blockgroup
> creation with multiple devices (applies on dup as well here) that leads
> to:
>
> # btrfs fi df .
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Data+Metadata, DUP: total=64.00MB, used=24.00KB
> Data+Metadata: total=8.00MB, used=0.00
>
> 8*2 + 4 + 64*2 + 8 = 156
>
> so, 12M is too small to avoid the mkfs crash.

Thanks for your notice!
>
> david



-- 
--
Best Regard
Robin Dong
