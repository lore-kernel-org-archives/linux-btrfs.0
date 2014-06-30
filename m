Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47295 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753435AbaF3CTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 22:19:05 -0400
Message-ID: <53B0C93E.8050500@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 10:19:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?U8OpYmFzdGllbiBST0hBVVQ=?= <sebastien.rohaut@free.fr>,
        Chris Murphy <lists@colorremedies.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Can't mount subvolume with ro option
References: <53ADCF0B.4010109@free.fr> <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com> <54D8214E-1C00-43AB-A68A-D450069D878C@colorremedies.com> <53AEA0D3.8080905@free.fr>
In-Reply-To: <53AEA0D3.8080905@free.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Can't mount subvolume with ro option
From: Sébastien ROHAUT <sebastien.rohaut@free.fr>
To: Chris Murphy <lists@colorremedies.com>
Date: 2014年06月28日 19:02
> Le 28/06/2014 00:12, Chris Murphy a écrit :
>> On Jun 27, 2014, at 4:08 PM, Chris Murphy <lists@colorremedies.com> 
>> wrote:
>>
>>> On Jun 27, 2014, at 2:07 PM, Sébastien ROHAUT 
>>> <sebastien.rohaut@free.fr> wrote:
>>>
>>>> Hi,
>>>>
>>>> In the wiki, it's said we can mount subvolumes with different mount 
>>>> options. nosuid, nodev, rw and ro are listed, as valid generic 
>>>> mount options.
>>> This might require 3.15. I don't recall it working with early 3.14 
>>> kernels, but by 3.14.3 I'd moved onto testing 3.15.
>>
>> [root@f20v ~]# mount /dev/sda3 /mnt
>> [root@f20v ~]# btrfs subvol create /mnt/test
>> Create subvolume '/mnt/test'
>> [root@f20v ~]# umount /mnt
>> [root@f20v ~]# mount -o ro,subvol=test /dev/sda3 /mnt
>> mount: /dev/sda3 is already mounted or /mnt busy
>>         /dev/sda3 is already mounted on /
>>         /dev/sda3 is already mounted on /home
>>         /dev/sda3 is already mounted on /var
>>         /dev/sda3 is already mounted on /boot
>> [root@f20v ~]# uname -r
>> 3.14.6-200.fc20.x86_64
>>
>>
>> I don't know if this feature will be backported to stable kernels. If 
>> not, then probably the wiki should say it's a 3.15+ feature.
>> Chris Murphy
>>
>>
> Thank you for your answer. I'm actually moving to a Fedora Rawhide 
> (3.16 kernel).
>
> Sebastien Rohaut
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
When testing on 3.15.2-ARCH alone with 3.16-rc2, the problem can also be 
reproduced.

But I can't always reproduce it, sometimes I was able to mount subvol 
with ro,
somtimes not.

So I think the problem needs to be investigated further.

Thanks,
Qu
