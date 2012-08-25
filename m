Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49516 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2HYDVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 23:21:21 -0400
Message-ID: <503844B7.4080205@oracle.com>
Date: Sat, 25 Aug 2012 11:21:27 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: turbo charge fsync
References: <1345833808-1539-1-git-send-email-jbacik@fusionio.com> <20120824184208.GA22819@shiny>
In-Reply-To: <20120824184208.GA22819@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2012 02:42 AM, Chris Mason wrote:
> On Fri, Aug 24, 2012 at 12:43:28PM -0600, Josef Bacik wrote:
>>
>>                 Original        Patched
>> SATA drive      82KB/s          140KB/s
>> Fusion drive    431KB/s         2532KB/s
>>
>> So around 2-6 times faster depending on your hardware.  There are a few
>> corner cases, for example if you truncate at all we have to do it the old
>> way since there is no way to be sure what is in the log is ok.  This
>> probably could be done smarter, but if you write-fsync-truncate-write-fsync
>> you deserve what you get.  All this work is in RAM of course so if your
>> inode gets evicted from cache and you read it in and fsync it we'll do it
>> the slow way if we are still in the same transaction that we last modified
>> the inode in.
> 
> I think I sent Liubo down the wrong path on this one, and Josef and I
> banged out some ideas for a different (hopefully less complex) way to
> solve the problem.  Josef, these results look fantastic.
> 

hehe, never mind.

In fact I also felt a little worried about my sub transid patchset because
it somehow changes how we use transid and makes developers harder to deal with
transid.

This patch overall looks good, but I'll take some time on reviewing it.

thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

