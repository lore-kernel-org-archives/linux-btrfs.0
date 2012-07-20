Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52834 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab2GTBhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 21:37:17 -0400
Message-ID: <5008B62E.8070606@cn.fujitsu.com>
Date: Fri, 20 Jul 2012 09:36:46 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfs-oss <xfs@oss.sgi.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Xfstests/254: add more cases for testing btrfs snapshot
 in 254
References: <5007E0FB.9040208@cn.fujitsu.com> <20120720002433.GH23387@dastard>
In-Reply-To: <20120720002433.GH23387@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2012 08:24 AM, Dave Chinner wrote:

> On Thu, Jul 19, 2012 at 06:27:07PM +0800, Liu Bo wrote:
>> From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
>>
>> This patch adds more cases in 254 for testing btrfs snapshot.
>>
>> Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
> 
> I think it is better to create a new test than modify the old one.
> That way it is easy to tell the difference between a new failure and
> regression.
> 


Sure, that makes sense.

thanks,
liubo

> Cheers,
> 
> Dave.


