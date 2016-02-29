Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38313 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbcB2Hzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 02:55:37 -0500
Subject: Re: [PATCH v2 RESEND 2/5] fstests: btrfs: Add basic test for btrfs
 in-band de-duplication
To: Dave Chinner <david@fromorbit.com>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-3-git-send-email-quwenruo@cn.fujitsu.com>
 <20160228222627.GA29057@dastard> <56D3A733.7010608@cn.fujitsu.com>
 <20160229064345.GH29057@dastard>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D3F970.6040509@cn.fujitsu.com>
Date: Mon, 29 Feb 2016 15:55:28 +0800
MIME-Version: 1.0
In-Reply-To: <20160229064345.GH29057@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave Chinner wrote on 2016/02/29 17:43 +1100:
> On Mon, Feb 29, 2016 at 10:04:35AM +0800, Qu Wenruo wrote:
>> Hi Dave,
>>
>> Thanks for the review.
>>
>> All comment are correct and I'll update the patchset soon.
>>
>> Only one small question below
>>
>> Dave Chinner wrote on 2016/02/29 09:26 +1100:
>> ...
>>>> +# File size is twice the maximum file extent of btrfs
>>>> +# So even fallbacked to non-dedup, it will have at least 2 extents
>>>> +file_size=$(( 256 * 1024 * 1024 ))
>>>
>>> Used for xfs_io, so "file_size=256m" is all that is needed here.
>>
>> Super nice feature for support unit suffix, I checked man page of
>> xfs_io but only value for extsize mentioned the support for such
>> suffix.
>>
>> I assume all offset/length/bsize/value support suffix, right?
>
> Yes, they do, always have, originally came from other XFS commands
> (i.e see the mkfs.xfs for the "usual units suffixes" description).
>
>> Hope man page get updated.
>
> Can you send a patch?

My pleasure.

Will send it soon.

Thanks,
Qu
>
> Cheers,
>
> Dave.
>


