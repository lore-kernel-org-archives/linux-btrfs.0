Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61927 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbbL3MC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 07:02:28 -0500
Subject: Re: [PATCH v3 2/2] btrfs: Enhance chunk validation check
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1449564042-5473-1-git-send-email-quwenruo@cn.fujitsu.com>
 <3370608.49fr4JG5K4@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5683C7BB.4060508@gmx.com>
Date: Wed, 30 Dec 2015 20:02:03 +0800
MIME-Version: 1.0
In-Reply-To: <3370608.49fr4JG5K4@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/29/2015 06:11 PM, Chandan Rajendra wrote:
> On Tuesday 08 Dec 2015 16:40:42 Qu Wenruo wrote:
>> Enhance chunk validation:
>> 1) Num_stripes
>>     We already have such check but it's only in super block sys chunk
>>     array.
>>     Now check all on-disk chunks.
>>
>> 2) Chunk logical
>>     It should be aligned to sector size.
>>     This behavior should be *DOUBLE CHECKED* for 64K sector size like
>>     PPC64 or AArch64.
>>     Maybe we can found some hidden bugs.
>>
>
> Sorry about the delayed response. I executed fstests on ppc64 with 64k block
> size and all the tests that used to pass earlier (i.e. without patch applied)
> continue to pass. Hence,
>
> Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>
Very glad to hear that.

Thanks for all the test.
Qu
