Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38532 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbbGXCuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 22:50:40 -0400
Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
To: Chris Mason <clm@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <559C9A75.60506@cn.fujitsu.com> <55AF6250.8070602@cn.fujitsu.com>
 <20150723202155.GC28964@ret.masoncoding.com> <55B186D1.30109@cn.fujitsu.com>
 <20150724015738.GD28964@ret.masoncoding.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B1A7FC.2010807@cn.fujitsu.com>
Date: Fri, 24 Jul 2015 10:50:36 +0800
MIME-Version: 1.0
In-Reply-To: <20150724015738.GD28964@ret.masoncoding.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2015/07/23 21:57 -0400:
> On Fri, Jul 24, 2015 at 08:29:05AM +0800, Qu Wenruo wrote:
>
> [ deadlock with the 070 patches ]
>
>> Thanks Chris
>>
>> We will investigate it with highest priority.
>>
>> Thanks,
>> Qu
>>
>
> Thanks!  I'm doing a few more runs to make sure the lockup is new with
> these patches.
>
> -chris
>
BTW, are this patchset rebased to your for-linus-4.2 branch?

Also, how reproducible is the lockup in btrfs/061?

Thanks,
Qu
