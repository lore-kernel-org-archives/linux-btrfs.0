Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.18.44]:40200 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbcCIWD7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 17:03:59 -0500
Subject: Re: How to move a btrfs volume to a smaller disk
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56E099A1.8040506@friedels.name>
 <20160309215029.GG17196@carfax.org.uk>
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <56E09DC9.7040402@friedels.name>
Date: Wed, 9 Mar 2016 23:03:53 +0100
MIME-Version: 1.0
In-Reply-To: <20160309215029.GG17196@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo,

thanks for your ultrafast reply.
Unfortunately, it does not work for me:
[root@homeserver mnt2]# btrfs filesystem resize 80G /mnt2/Data_Store/ && 
btrfs replace start /dev/sdb4 /dev/sda4 /mnt2/Data_Store/ -f && btrfs 
filesystem resize max /mnt2/Data_Store/
Resize '/mnt2/Data_Store/' of '80G'
ERROR: target device smaller than source device (required 119121379328 
bytes)
[root@homeserver mnt2]# btrfs filesystem show /mnt2/Data_Store/
Label: 'Data_Store'  uuid: 0ccc1e24-090d-42e2-9e61-d0a1b3101f93
         Total devices 1 FS bytes used 47.95GiB
         devid    1 size 80.00GiB used 66.03GiB path /dev/sdb4

[root@homeserver mnt2]# lsblk | grep sda4
└─sda4    8:4    0 103.5G  0 part


Greetings,
Hendrik

On 09.03.2016 22:50, Hugo Mills wrote:
> On Wed, Mar 09, 2016 at 10:46:09PM +0100, Hendrik Friedel wrote:
>> Hello,
>>
>> I intend to move this subvolume to a new device.
>> btrfs fi show /mnt2/Data_Store/
>> Label: 'Data_Store'  uuid: 0ccc1e24-090d-42e2-9e61-d0a1b3101f93
>>          Total devices 1 FS bytes used 47.93GiB
>>          devid    1 size 102.94GiB used 76.03GiB path /dev/sdb4
>>
>> (fi usage at the bottom of this message)
>>
>> The new device (sda4) is 8G smaller unfortunately.
>> sda       8:0    0 111.8G  0 disk
>> └─sda4    8:4    0 103.5G  0 part
>> sdb       8:16   0 119.2G  0 disk
>> └─sdb4    8:20   0   111G  0 part  /mnt2/Data_Store
>>
>> Thus, btrfs replace does not work
>>
>> What would you suggest now to move the FS (it does contain many subvolumes)?
>     btrfs dev resize to shrink it to (slightly smaller than) the
> replacement device, then btrfs replace should work. Then btrfs dev
> resize max to fill up the replacement device completely.
>
>     Hugo.
>
>> I tried btrfs send /mnt2/Data_Store/read_only_snapshot/ | btrfs
>> receive /mnt/sda4/
>> but this only created an empty subvolume /mnt/sda4/read_only_snapshot/
>>
>> So, then
>> btrfs device add /dev/sda4 /mnt/Data_Store
>> btrfs balance start /mnt/Data_Store
>> btrfs device remove /dev/sdb4 /mnt/Data_Store
>> ?
>>
>> Or is there a better option?
>>
>> Regards,
>> Hendrik
>>
>>
>>   btrfs fi usage  /mnt2/Data_Store/
>> Overall:
>>      Device size:                 102.94GiB
>>      Device allocated:             74.03GiB
>>      Device unallocated:           28.91GiB
>>      Device missing:                  0.00B
>>      Used:                         47.96GiB
>>      Free (estimated):             53.24GiB      (min: 53.24GiB)
>>      Data ratio:                       1.00
>>      Metadata ratio:                   1.00
>>      Global reserve:              512.00MiB      (used: 0.00B)
>>
>> Data,single: Size:69.00GiB, Used:44.67GiB
>>     /dev/sdb4      69.00GiB
>>
>> Metadata,single: Size:5.00GiB, Used:3.29GiB
>>     /dev/sdb4       5.00GiB
>>
>> System,single: Size:32.00MiB, Used:16.00KiB
>>     /dev/sdb4      32.00MiB
>>
>> Unallocated:
>>     /dev/sdb4      28.91GiB
>>
>>
>> ---
>> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
>> https://www.avast.com/antivirus
>>


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

