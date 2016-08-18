Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766950AbcHROZH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 10:25:07 -0400
Subject: Re: [PATCH] btrfs: do not background blkdev_put()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1469138693-810-1-git-send-email-anand.jain@oracle.com>
 <20160818124629.GD16983@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c2e8f393-a723-593c-9a4a-8414fe573bd6@oracle.com>
Date: Thu, 18 Aug 2016 22:26:35 +0800
MIME-Version: 1.0
In-Reply-To: <20160818124629.GD16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/18/2016 08:46 PM, David Sterba wrote:
> On Fri, Jul 22, 2016 at 06:04:53AM +0800, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> At the end of unmount/dev-delete, if the device exclusive open is not
>> actually closed, then there might be a race with another program in
>> the userland who is trying to open the device in exclusive mode and
>> it may fail for eg:
>>       unmount /btrfs; fsck /dev/x
>>       btrfs dev del /dev/x /btrfs; fsck /dev/x
>> so here background blkdev_put() is not a choice
>
> missing signed-off, I'll add it

Err.

> Reviewed-by: David Sterba <dsterba@suse.com>
>
Thanks, Anand
