Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58765 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbaGQIsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:48:32 -0400
Message-ID: <53C78DDE.6040009@cn.fujitsu.com>
Date: Thu, 17 Jul 2014 16:48:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>,
        Chris Murphy <lists@colorremedies.com>, <zhe.zhang.research@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even
 with different options)?
References: <53C6FA3D.9010803@informatik.uni-bonn.de> <E49EC0AC-DD96-4D7F-9B36-9E28CEC0CD2A@colorremedies.com> <53C78212.2070204@informatik.uni-bonn.de>
In-Reply-To: <53C78212.2070204@informatik.uni-bonn.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes 
(even with different options)?
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
To: Chris Murphy <lists@colorremedies.com>, zhe.zhang.research@gmail.com
Date: 2014年07月17日 15:58
> Hello,
>
> I need to clarify, I'm _not_ sharing a drive between multiple 
> computers at the _same_ time. It's a portable device which I use at 
> different locations with different computers. I just wanted to give a 
> rationale for mounting the whole drive to some mountpoint and then 
> also part of that drive (a subvolume) to the respective computer's 
> /home mountpoint. So it's controlled by the same kernel in the same 
> computer, it's just that part of the filesystem is mounted at multiple 
> mountpoints, much like a bind-mount, but I'm interested in mounting a 
> subvolume of the already-mounted volume to some other mountpoint. 
> Sorry for the confusion.
>
> Best regards
> Sebastian
If you mean something like the following use case:
# mount /dev/sdb1 -o subvolid=257 /home
# mount /dev/sdb1 -o subvolid=5 /some/other/place

That is completly OK.

But when it comes to different mount option, especially different ro/rw 
mount option,
although it is working for 3.16-rc*, the ro/rw mount option is still 
under disscussion and the current rc implement
will cause a kernel warning mounting a subvolume rw when it's first 
mounted as ro.

So in short:
1) mount subvolumes when the btrfs fs is already mounted.
Completly OK.

2) different mount option for different subvolume in one btrfs fs.
For most mount option including ro/rw, No.

Thanks,
Qu
>
>
> On 17.07.2014 01:18, Chris Murphy wrote:
>>
>> On Jul 16, 2014, at 4:18 PM, Sebastian Ochmann 
>> <ochmann@informatik.uni-bonn.de> wrote:
>>
>>> Hello,
>>>
>>> I'm sharing a btrfs-formatted drive between multiple computers and 
>>> each of the machines has a separate home directory on that drive.
>>
>> 2+ computers writing to the same block device? I don't see how this 
>> is safe. Seems possibly a bug that the 1st mount event isn't setting 
>> some metadata so that another kernel instance knows not to allow 
>> another mount.
>>
>>
>> Chris Murphy
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

