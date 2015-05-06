Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbEFJY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 05:24:59 -0400
Message-ID: <5549DD61.8050502@oracle.com>
Date: Wed, 06 May 2015 17:22:41 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: xuw2015@gmail.com
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: support to find missing device by path
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com> <1430384845-9666-2-git-send-email-xuw2015@gmail.com> <20150505153816.GJ5099@twin.jikos.cz> <5549DB94.3050704@oracle.com>
In-Reply-To: <5549DB94.3050704@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



fix typo. (I have to blame thunderbird's bug which vanishes
some of the words as I scroll up and down in the 'write' window.).

On 05/06/2015 05:15 PM, Anand Jain wrote:
>
>
> On 05/05/2015 11:38 PM, David Sterba wrote:
>> On Thu, Apr 30, 2015 at 05:07:24PM +0800, xuw2015@gmail.com wrote:
>>> From: George Wang <xuw2015@gmail.com>
>>>
>>> First try to find the device matches specified device path, if
>>> nothing, then
>>> find the device by (devid, dev_uuid). This can fix the regression for
>>> replacing an offline device which path is held in btrfs_device.
>>
>> I vaguely remember similar patches sent by Anand, CCed.
>
> George,
>
>   Critically we don't need this patch. right ?
>   Anyway user of replace cli can use devid if device read fails.
>
>   I think David is talking about:
>     [PATCH] device delete by devid
>
>   it was critical for device delete. since there wasn't device
>   delete by devid. I used device delete by devid instead of
>   device path strcmp mainly because to maintain consistency
>   between device replace and delete.
>   the above patch set also provides code cleanups between
>   device replace and delete codes.
>
> Thanks, Anand
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
