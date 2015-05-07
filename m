Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:35631 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbEGCv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 22:51:29 -0400
Received: by ykec202 with SMTP id c202so7980282yke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 19:51:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5549DD61.8050502@oracle.com>
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
	<1430384845-9666-2-git-send-email-xuw2015@gmail.com>
	<20150505153816.GJ5099@twin.jikos.cz>
	<5549DB94.3050704@oracle.com>
	<5549DD61.8050502@oracle.com>
Date: Thu, 7 May 2015 10:51:29 +0800
Message-ID: <CAPBX1xLhRXPyEMy_Dqkmsr_T-GmOUdt5Dt8yH4CMRm0UdpFkYw@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: support to find missing device by path
From: George Wang <xuw2015@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for reply.

On Wed, May 6, 2015 at 5:22 PM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>
> fix typo. (I have to blame thunderbird's bug which vanishes
> some of the words as I scroll up and down in the 'write' window.).
>
> On 05/06/2015 05:15 PM, Anand Jain wrote:
>>
>>
>>
>> On 05/05/2015 11:38 PM, David Sterba wrote:
>>>
>>> On Thu, Apr 30, 2015 at 05:07:24PM +0800, xuw2015@gmail.com wrote:
>>>>
>>>> From: George Wang <xuw2015@gmail.com>
>>>>
>>>> First try to find the device matches specified device path, if
>>>> nothing, then
>>>> find the device by (devid, dev_uuid). This can fix the regression for
>>>> replacing an offline device which path is held in btrfs_device.
>>>
>>>
>>> I vaguely remember similar patches sent by Anand, CCed.
>>
>>
>> George,
>>
>>   Critically we don't need this patch. right ?
Yes, I agree it.

>>   Anyway user of replace cli can use devid if device read fails.
>>
>>   I think David is talking about:
>>     [PATCH] device delete by devid
We can delete the device by devid on behalf of "btrfs_find_device".
In my opinion, the dev path is easier and humanized to use.
This was OK before, but now I can not replace offline device
by path. So I consider it as a regression.

Anyway, maybe we should support replace offline device by path
in the future.

Thanks,

George

>>
>>   it was critical for device delete. since there wasn't device
>>   delete by devid. I used device delete by devid instead of
>>   device path strcmp mainly because to maintain consistency
>>   between device replace and delete.
>>   the above patch set also provides code cleanups between
>>   device replace and delete codes.
>>
>> Thanks, Anand
