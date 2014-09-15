Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19469 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaIORkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 13:40:00 -0400
Message-ID: <54172465.80002@oracle.com>
Date: Tue, 16 Sep 2014 01:39:49 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de>	<54110AEC.6040301@oracle.com>	<54135AE7.40400@gmail.com>	<5413D7E5.6080905@oracle.com>	<20140913195525.333f93a4@datenkhaos.de>	<20140913232320.64fd189c@datenkhaos.de>	<5416DC7A.1070608@oracle.com> <20140915191445.35ad18d2@datenkhaos.de>
In-Reply-To: <20140915191445.35ad18d2@datenkhaos.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16/09/2014 01:14, Johannes Hirte wrote:
> On Mon, 15 Sep 2014 20:32:58 +0800
> Anand Jain <Anand.Jain@oracle.com> wrote:
>
>>
>>
>> Hi Johannes,
>>
>>    Can I have you this tested.. ? Thanks.
>>
>>
>> -------
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e9676a4..1224b61 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -533,7 +533,7 @@ static noinline int device_list_add(const char
>> *path,
>>                    * the btrfs dev scan cli, after FS has been mounted.
>>                    */
>>                   if (fs_devices->opened) {
>> -                       return -EBUSY;
>> +                       goto out;
>>                   } else {
>>                           /*
>>                            * That is if the FS is _not_ mounted and if
>> you @@ -566,6 +566,7 @@ static noinline int device_list_add(const
>> char *path, if (!fs_devices->opened)
>>                   device->generation = found_transid;
>>
>> +out:
>>           *fs_devices_ret = fs_devices;
>>
>>           return ret;
>> -------
>
> With this change, it works again without initramfs.

  Thanks. I am bit confused, is there any configuration that is
  still not working, even with the above changes.

Anand


> regards,
>    Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
