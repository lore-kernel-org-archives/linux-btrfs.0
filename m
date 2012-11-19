Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab2KSIQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 03:16:53 -0500
Message-ID: <50A9EB0A.8030002@cn.fujitsu.com>
Date: Mon, 19 Nov 2012 16:17:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix a deadlock in aborting transaction due
 to ENOSPC
References: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com> <20121116141948.GA3102@twin.jikos.cz> <20121119075853.GA31552@gmail.com>
In-Reply-To: <20121119075853.GA31552@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 19 Nov 2012 15:58:55 +0800, Liu Bo wrote:
> On Fri, Nov 16, 2012 at 03:19:49PM +0100, David Sterba wrote:
>> On Mon, Nov 05, 2012 at 08:42:08PM +0800, Liu Bo wrote:
>>> When committing a transaction, we may bail out of running delayed refs
>>> due to ENOSPC, and then abort the current transaction to flip into readonly.
>>>
>>> But we'll hit a deadlock on ref head's lock since we forget to release
>>> its lock and other cleanup stuff.
>>
>> Miao sent a patch for this on Tue, 08 May 2012
>>
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16361.html
>>
>> and it does more things than just the unlock, I can't tell which one of
>> the patches is the right one, only letting you know.
>>
> 
> Thanks for pointing that, David.  Yes, that patch will work.
> 
> Miao, can you send it here again?
> [PATCH] Btrfs: fix deadlock when the process of delayed refs fails

OK, I will send it out again.

Thanks
Miao

> 
> thanks,
> liubo
> 
> 
>> david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

