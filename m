Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34184 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbaIOUiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 16:38:50 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so4412307wgg.6
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 13:38:48 -0700 (PDT)
Message-ID: <54174E57.3020401@gmail.com>
Date: Mon, 15 Sep 2014 22:38:47 +0200
From: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        Sam Thursfield <sam.thursfield@codethink.co.uk>
CC: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        baserock-dev@baserock.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <54171E51.2020709@codethink.co.uk> <54172018.1050300@oracle.com>
In-Reply-To: <54172018.1050300@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This diff on top of 3.17rc5 also fixes the issue on my box (encrypted 
/home subvolume)

Xavier
>
> Hi Sam,
>
>  Thanks for verifying.
>
> On 16/09/2014 01:13, Sam Thursfield wrote:
>> Hi Anand
>>
>> On 15/09/14 17:09, Anand Jain wrote:
>>>
>>> Sam,
>>>
>>>   Thanks for reporting. Can you apply the following diff
>>>   on top of 3.17rc5 and check if it helps.
>>
>> The patch fixes the issue, although it took a little tweaking to get it
>> to apply cleanly.
>>
>>> -------
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index e9676a4..1224b61 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -533,7 +533,7 @@ static noinline int device_list_add(const char 
>>> *path,
>>>                   * the btrfs dev scan cli, after FS has been mounted.
>>>                   */
>>>                  if (fs_devices->opened) {
>>> -                       return -EBUSY;
>>> +                       goto out;
>>>                  } else {
>>>                          /*
>>>                           * That is if the FS is _not_ mounted and 
>>> if you
>>> @@ -566,6 +566,7 @@ static noinline int device_list_add(const char 
>>> *path,
>>>          if (!fs_devices->opened)
>>>                  device->generation = found_transid;
>>>
>>> +out:
>>>          *fs_devices_ret = fs_devices;
>>>
>>>          return ret;
>>> -------
>>>
>>>
>>>
>>>
>>> Anand
>>>
>>>
>>>
>>> On 15/09/2014 23:54, Chris Mason wrote:
>>>> On 09/15/2014 11:13 AM, Sam Thursfield wro:
>>>>> Hi!
>>>>>
>>>>> I'm having an issue with the 3.17rc5 kernel which prevents having
>>>>> multiple subvolumes of the same disk mounted.
>>>>>
>>>>> I'm not sure exactly the cause. I thought it might be because in my
>>>>> system the root file system is itself a subvolume of the disk I'm
>>>>> trying
>>>>> to mount. But if I create a second disk image with two subvolumes, 
>>>>> the
>>>>> same thing occurs -- I can only mount one of them at a time.
>>>>>
>>>>> I've attached the output of a few commands, please let me know if you
>>>>> want more info (I'm not subscribed to the list, please keep me in 
>>>>> To:).
>>>>>
>>>>> We've bisected and found that the exact commit that changed the
>>>>> behaviour is this one:
>>>>> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id%3Db96de000bc8bc9688b3a2abea4332bd57648a49f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=qVtp3yxxUd8uElAkp118K4Bd0oZfeUOC%2BKUy3e6rRlA%3D%0A&s=0d2623956de100adc1185d2b75e9114384572b88c0330e74924baa1a2bce8d02 
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> I'm afraid I'm not familiar with the Btrfs code base and so I don't
>>>>> understand the exact meaning of the comments in that commit.
>>>>
>>>> Anand Jain is working on this in a separate thread.  I'll make sure 
>>>> the
>>>> fix goes into the next rc, thanks for all the time spent bisecting.
>>>>
>>>> -chris
>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

