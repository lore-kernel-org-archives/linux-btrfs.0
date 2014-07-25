Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9031 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbaGYB3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:29:08 -0400
Message-ID: <53D1B2E1.60008@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 09:29:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
References: <1405648543-8966-1-git-send-email-quwenruo@cn.fujitsu.com> <20140724121721.GW1553@twin.jikos.cz>
In-Reply-To: <20140724121721.GW1553@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Return right extent when fiemap gives 
unaligned offset and len.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月24日 20:17
> On Fri, Jul 18, 2014 at 09:55:43AM +0800, Qu Wenruo wrote:
>> When page aligned start and len passed to extent_fiemap(), the result is
>> good, but when start and len is not aligned, e.g. start = 1 and len =
>> 4095 is passed to extent_fiemap(), it returns no extent.
>>
>> The problem is that start and len is all rounded down which causes the
>> problem.
> ALIGN rounds up, not down. So the wrong rounding will use incorrect start
> (4096) and finds no extents if there's eg. only one [0,4095].
Sorry for the wrong description in patch.
Should I reword the patch and send a v2 patch?

Thanks,
Qu
>
>> This patch will round down start and round up (start + len) to
>> return right extent.
>>
>> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>

