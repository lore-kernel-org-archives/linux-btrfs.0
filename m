Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33350 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755874AbdEKTbp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 15:31:45 -0400
Received: by mail-ua0-f177.google.com with SMTP id e28so35210771uah.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 12:31:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4b68cf7d-e6df-676c-6ee4-4f564f136eff@cn.fujitsu.com>
References: <CAGN98i72XfTo5Pjodn0MF20S_yCqXh026Ai_BP+n_X_G4yF2nw@mail.gmail.com>
 <4b68cf7d-e6df-676c-6ee4-4f564f136eff@cn.fujitsu.com>
From: Xiaochu Liu <xiaochu@chromium.org>
Date: Thu, 11 May 2017 12:31:44 -0700
Message-ID: <CAGN98i7hApEpgtwqw1HNXGD1ftaHJ0Ojn_Q0SMtV-V4aFfQ+mw@mail.gmail.com>
Subject: Re: Question on compression unit
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Qu!

I wonder if there is anyway we can easily configure the extent size
(maximum extent size, extent size for files to compress, etc.)? I was
trying to see if it helps reduce random read latency on compressed
files by using smaller extent...

On Wed, May 10, 2017 at 6:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 05/11/2017 04:11 AM, Xiaochu Liu wrote:
>>
>> Hi there,
>>
>> I'm trying to tune compression options for btrfs. Specifically, I want
>> to know the performance impact on the system under different
>> compression unit (block) sizes.
>
>
> Compression unit size is fixed in btrfs.
> It's sectorsize, determined at mkfs time, and only 4K (page size) is
> supported for x86 yet.
>
>>
>> I'm aware of '--nodesize' parameter which sets the block size of
>> metadata tree. Does that also set the block size in an extent? (from
>> my understanding, file data are mostly stored in extent unless small
>> enough to be inline-d in metadata leaf node?)
>
>
> nodesize only affects metadata, nothing to do with data size.
>
>>
>> Also from btrfs's wikipedia page:
>>
>> In compressed extents, individual blocks are not compressed
>> separately; rather, the compression stream spans the entire extent.
>>
>> Is that still true?
>
>
> Yes.
>
> For example if there is one continuous range represents 0~1M data of one
> file, and all this data is dirty (not written to disk).
>
> Then compress will happen when trying to writing them to disk.
> And since the maximum uncompressed size for compressed extent is 128K
> (fixed), the 0~1M will be split into 8 extents (if compression ratio is
> acceptable).
>
> And then each 128K extent will be compressed then compressed data will be
> written to disk. (compressed extent still meet sectorsize alignment).
>
> So the wiki page is still right and we must read out the whole (compressed)
> extent to get its content.
>
> And since both uncompressed data and compressed extent must meet sectorsize
> alignment, data smaller than or equal to sectorsize won't go through
> compression since it will just waste CPU time and no space saving.
>
> Thanks,
> Qu
>
>>
>> Thanks,
>> Xiaochu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
