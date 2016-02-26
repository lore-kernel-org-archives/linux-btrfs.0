Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64292 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbcBZB3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 20:29:34 -0500
Subject: Re: how many chunk trees and extent trees present
To: <dsterba@suse.cz>, Hugo Mills <hugo@carfax.org.uk>,
        sri <toyours_sridhar@yahoo.co.in>, <linux-btrfs@vger.kernel.org>
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk> <20150417172928.GT25622@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CFAA79.9020706@cn.fujitsu.com>
Date: Fri, 26 Feb 2016 09:29:29 +0800
MIME-Version: 1.0
In-Reply-To: <20150417172928.GT25622@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/04/17 19:29 +0200:
> On Fri, Apr 17, 2015 at 09:19:11AM +0000, Hugo Mills wrote:
>>> In, some article i read that future there will be more chunk tree/ extent
>>> tree for single btrfs. Is this true.
>>
>>     I recall, many moons ago, Chris saying that there probably wouldn't
>> be.
>
> More extent trees tied to a set of fs trees/subvolumes would be very
> useful for certain usecases *cough*encryption*cough*.

BTW, will such design makes reflink between different set of extents 
fallback to normal copy?

And I'm pretty sure that inband dedup will be affected too...

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


