Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43785 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753726AbdEKBBf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 21:01:35 -0400
Subject: Re: Question on compression unit
To: Xiaochu Liu <xiaochu@chromium.org>, <linux-btrfs@vger.kernel.org>
References: <CAGN98i72XfTo5Pjodn0MF20S_yCqXh026Ai_BP+n_X_G4yF2nw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4b68cf7d-e6df-676c-6ee4-4f564f136eff@cn.fujitsu.com>
Date: Thu, 11 May 2017 09:01:29 +0800
MIME-Version: 1.0
In-Reply-To: <CAGN98i72XfTo5Pjodn0MF20S_yCqXh026Ai_BP+n_X_G4yF2nw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/11/2017 04:11 AM, Xiaochu Liu wrote:
> Hi there,
> 
> I'm trying to tune compression options for btrfs. Specifically, I want
> to know the performance impact on the system under different
> compression unit (block) sizes.

Compression unit size is fixed in btrfs.
It's sectorsize, determined at mkfs time, and only 4K (page size) is 
supported for x86 yet.

> 
> I'm aware of '--nodesize' parameter which sets the block size of
> metadata tree. Does that also set the block size in an extent? (from
> my understanding, file data are mostly stored in extent unless small
> enough to be inline-d in metadata leaf node?)

nodesize only affects metadata, nothing to do with data size.

> 
> Also from btrfs's wikipedia page:
> 
> In compressed extents, individual blocks are not compressed
> separately; rather, the compression stream spans the entire extent.
> 
> Is that still true?

Yes.

For example if there is one continuous range represents 0~1M data of one 
file, and all this data is dirty (not written to disk).

Then compress will happen when trying to writing them to disk.
And since the maximum uncompressed size for compressed extent is 128K 
(fixed), the 0~1M will be split into 8 extents (if compression ratio is 
acceptable).

And then each 128K extent will be compressed then compressed data will 
be written to disk. (compressed extent still meet sectorsize alignment).

So the wiki page is still right and we must read out the whole 
(compressed) extent to get its content.

And since both uncompressed data and compressed extent must meet 
sectorsize alignment, data smaller than or equal to sectorsize won't go 
through compression since it will just waste CPU time and no space saving.

Thanks,
Qu

> 
> Thanks,
> Xiaochu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


