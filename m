Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:37675 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaF1LCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:02:49 -0400
Message-ID: <53AEA0D3.8080905@free.fr>
Date: Sat, 28 Jun 2014 13:02:43 +0200
From: =?ISO-8859-1?Q?S=E9bastien_ROHAUT?= <sebastien.rohaut@free.fr>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount subvolume with ro option
References: <53ADCF0B.4010109@free.fr> <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com> <54D8214E-1C00-43AB-A68A-D450069D878C@colorremedies.com>
In-Reply-To: <54D8214E-1C00-43AB-A68A-D450069D878C@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/06/2014 00:12, Chris Murphy a écrit :
> On Jun 27, 2014, at 4:08 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> On Jun 27, 2014, at 2:07 PM, Sébastien ROHAUT <sebastien.rohaut@free.fr> wrote:
>>
>>> Hi,
>>>
>>> In the wiki, it's said we can mount subvolumes with different mount options. nosuid, nodev, rw and ro are listed, as valid generic mount options.
>> This might require 3.15. I don't recall it working with early 3.14 kernels, but by 3.14.3 I'd moved onto testing 3.15.
>
> [root@f20v ~]# mount /dev/sda3 /mnt
> [root@f20v ~]# btrfs subvol create /mnt/test
> Create subvolume '/mnt/test'
> [root@f20v ~]# umount /mnt
> [root@f20v ~]# mount -o ro,subvol=test /dev/sda3 /mnt
> mount: /dev/sda3 is already mounted or /mnt busy
>         /dev/sda3 is already mounted on /
>         /dev/sda3 is already mounted on /home
>         /dev/sda3 is already mounted on /var
>         /dev/sda3 is already mounted on /boot
> [root@f20v ~]# uname -r
> 3.14.6-200.fc20.x86_64
>
>
> I don't know if this feature will be backported to stable kernels. If not, then probably the wiki should say it's a 3.15+ feature.
> Chris Murphy
>
>
Thank you for your answer. I'm actually moving to a Fedora Rawhide (3.16 
kernel).

Sebastien Rohaut
