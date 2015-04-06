Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34533 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbbDFNc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 09:32:28 -0400
Message-ID: <55228ADB.3000404@oracle.com>
Date: Mon, 06 Apr 2015 21:32:11 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz> <mfeo14$sib$1@ger.gmane.org> <551B98FF.8070000@oracle.com> <mfgiot$3ck$1@ger.gmane.org> <551BEF67.3040305@oracle.com> <mfh9rn$2if$1@ger.gmane.org>
In-Reply-To: <mfh9rn$2if$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Martin,

  presumably kernel failed to read SB from disk /dev/sdf5,
  bit strange it saw 'Inappropriate ioctl for device',
  logically that don't explain.

  Curios to know what does 'btrfs fi show -d' say ?
  and output of blkid if you could. The situation here
  is not same as destroying the SB though.

Thanks, Anand


On 02/04/2015 01:28, Martin wrote:
> Anand,
>
> Thanks for picking up.
>
> The devid option sounds good.
>
>
> Thanks,
> Martin
>
>
>
> On 01/04/15 14:15, Anand Jain wrote:
>>
>>
>>   Looks like an option to use devid to delete a device would
>>   have mitigated the issue.  Also the error reported is no
>>   where near the reality. Will fix them.
>>
>>   Thanks for reporting.
>>
>> Anand
>>
>>
>> On 04/01/2015 06:54 PM, Martin wrote:
>>> On 01/04/15 08:06, Anand Jain wrote:
>>>>
>>>>>>> btrfs device delete /dev/sdf5 /mnt/data2
>>>>>>>
>>>>>>> ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl
>>>>>>> for
>>>>>>> device
>>>>
>>>>    very strange. 'btrfs fi show -m' shows btrfs fs(s) that are mounted.
>>>
>>> Looks like my /dev/sdf isn't responding with anything useful at all... A
>>> firmware crash?... (This is for a 256GB SSD.)
>>>
>>>
>>> # btrfs fi show -m
>>>
>>> [...]
>>>
>>> Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
>>>           Total devices 3 FS bytes used 159.31GiB
>>>           devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
>>>           devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
>>>           devid    3 size 206.47GiB used 206.47GiB path /dev/sdf5
>>>
>>>
>>> btrfs-progs v3.19.1
>>>
>>>
>>>
>>> # smartctl -i /dev/sdf
>>> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.14.10-gentoo_s03a_11]
>>> (local build)
>>> Copyright (C) 2002-14, Bruce Allen, Christian Franke,
>>> www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Vendor:               /7:0:0:0
>>> Product:
>>> Compliance:           SPC-5
>>> User Capacity:        600,332,565,813,390,450 bytes [600 PB]
>>> Logical block size:   774843950 bytes
>>> scsiModePageOffset: response length too short, resp_len=47 offset=50
>>> bd_len=46
>>> scsiModePageOffset: response length too short, resp_len=47 offset=50
>>> bd_len=46
>>>>> Terminate command early due to bad response to IEC mode page
>>> A mandatory SMART command failed: exiting. To continue, add one or more
>>> '-T permissive' options.
>>>
>>>
>>>
>>> And btrfs is still running ok so far... I'll be swapping that device at
>>> the weekend. (First chance I have for a Sunday shutdown. :-( )
>>>
>>>
>>> Still... For administering btrfs, it is a little disturbing not to be
>>> able to remove/delete a device unless that device is both mounted and
>>> working...
>>>
>>> Or is that where the "missing" option comes in?
>>>
>>>
>>>
>>> Comments welcomed,
>>>
>>> Thanks,
>>> Martin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
