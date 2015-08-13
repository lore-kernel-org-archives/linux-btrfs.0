Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbHMQYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 12:24:15 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t7DGOEmE003133
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:24:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t7DGOE2O021755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:24:14 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t7DGODAX002901
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:24:14 GMT
Message-ID: <55CCC4AB.2080600@oracle.com>
Date: Fri, 14 Aug 2015 00:24:11 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
References: <20150812130758.GA26529@rus.uni-stuttgart.de> <55CC488D.4020203@oracle.com> <20150813120211.GA24122@rus.uni-stuttgart.de> <20150813145556.GA27405@rus.uni-stuttgart.de>
In-Reply-To: <20150813145556.GA27405@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/13/2015 10:55 PM, Ulli Horlacher wrote:
> On Thu 2015-08-13 (14:02), Ulli Horlacher wrote:
>> On Thu 2015-08-13 (15:34), anand jain wrote:
>>
>>>> root@toy02:~# df -T /data
>>>> Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
>>>> /dev/sdb       btrfs 3906909856 140031696 3765056176   4% /data
>>>>
>>>> root@toy02:~# btrfs filesystem show /data
>>>> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>>>>           Total devices 2 FS bytes used 129.81GiB
>>>>           devid    3 size 1.82TiB used 67.03GiB path /dev/drbd2
>>>>           devid    4 size 1.82TiB used 67.03GiB path /dev/sdb
>>>>
>>>> Btrfs v3.12
>>>>
>>>> ==> btrfs shows the wrong (raw) device /dev/sdb instead of /dev/drbd3 !
>>>
>>> Don't be too alarmed by that, progs do a bit of user land fabrication
>>> (wrong). kernel may /may-not be using sdb. try -m option.
>>
>> It is really weird: meanwhile (without any mount change or even reboot) I
>> get:
>>
>> root@toy02:~# btrfs filesystem show
>> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>>          Total devices 2 FS bytes used 106.51GiB
>>          devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
>>          devid    4 size 1.82TiB used 82.03GiB path /dev/drbd3
>
> And now, after a reboot:
>
> root@toy02:~/bin# btrfs filesystem show
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>          Total devices 2 FS bytes used 119.82GiB
>          devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
>          devid    4 size 1.82TiB used 82.03GiB path /dev/sde
>
> GRMPF!

pls use 'btrfs fi show -m' and just ignore no option or -d if fs is 
mounted, as -m reads from the kernel.

at mount you could assemble correct set of devices using mount -o device 
option.

Thanks, -Anand


