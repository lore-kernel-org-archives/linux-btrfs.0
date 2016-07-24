Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:54833 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcGXKwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 06:52:17 -0400
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Chris Murphy" <lists@colorremedies.com>
Subject: Re[2]: Chances to recover with bad partition table?
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Date: Sun, 24 Jul 2016 10:51:51 +0000
Message-Id: <em1b0c60b2-bda4-4b6c-86f1-ab645790eb88@laptophendrik>
In-Reply-To: <CAJCQCtSAMR8=QUW8DR5vriHOy-17cpfd94RoDiKZf8nGfKMQ6w@mail.gmail.com>
References: <6f4623c4-3e4c-7add-aa89-3857b0d48c61@friedels.name>
 <CAJCQCtQ+hVY27j5jOuAfTn4wPE_FV3AheR0+DLL1ui4m6OYCwQ@mail.gmail.com>
 <CAJCQCtSAMR8=QUW8DR5vriHOy-17cpfd94RoDiKZf8nGfKMQ6w@mail.gmail.com>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

thanks for your help.
I did run Testdisk before and it found one partition on the drive. But 
there should be at least one before that one, that was not found.

However, I followed your instructions and it matches to the find of 
testdisk:

-------------
1f510040  5f 42 48 52 66 53 5f 4d  7e 7a 56 01 00 00 00 00  
|_BHRfS_M~zV.....|
23500040  5f 42 48 52 66 53 5f 4d  7e 7a 56 01 00 00 00 00  
|_BHRfS_M~zV.....|

  0x1f510040
-    0x10040
= 0x1f500000
=  525336576
/512
=    1026048

gdisk -l /dev/sda
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: MBR only
  BSD: not present
  APM: not present
  GPT: present

Found valid MBR and GPT. Which do you want to use?
1 - MBR
2 - GPT
3 - Create blank GPT

Your answer: 1
Disk /dev/sda: 234441648 sectors, 111.8 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 49D09617-2C48-42D3-B2CD-9A1B72BC6C07
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 234441614
Partitions will be aligned on 2048-sector boundaries
Total free space is 1026925 sectors (501.4 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1         1026048       234440703   111.3 GiB   8300  Linux filesystem

btrfs-show-super /dev/sda1
dev_item.total_bytes    119508303872
-------


So, I have two problems now:
a) recover the partition before this one
b) get this one mounted

I understand that a) is off topic in this group, so let's focus on b. 
Having said that, I'd be greatful for hints also on a)

when trying to mount (o ro, recovery) this disk, I get:
[36904.547011] BTRFS info (device sda1): disk space caching is enabled
[36904.547898] BTRFS error (device sda1): bad tree block start 0 
20987904
[36904.549864] BTRFS error (device sda1): bad tree block start 0 
20987904
[36904.551632] BTRFS: failed to read chunk root on sda1
[36904.568589] BTRFS: open_ctree failed

Thus, I tried to follow this tutorial:
http://ram.kossboss.com/btrfs-restoring-a-corrupt-filesystem-from-another-tree-location/
but unfortunately the options of btrfs restore have apparently changed. 
(invalid option -F)

I am using Kernel 4.6 and btrfs-tools 4.4

I ran
btrfs rescue super-recover -v /dev/sda1
All Devices:
        Device: id = 1, name = /dev/sda1

Before Recovering:
        [All good supers]:
                device name = /dev/sda1
                superblock bytenr = 65536

                device name = /dev/sda1
                superblock bytenr = 67108864

        [All bad supers]:

All supers are valid, no need to recover



What would be the next step?

Regards,
Hendrik



------ Originalnachricht ------
Von: "Chris Murphy" <lists@colorremedies.com>
An:
Cc: "Hendrik Friedel" <hendrik@friedels.name>; "Btrfs BTRFS" 
<linux-btrfs@vger.kernel.org>
Gesendet: 24.07.2016 03:49:28
Betreff: Re: Chances to recover with bad partition table?

>On Sat, Jul 23, 2016 at 7:46 PM, Chris Murphy <lists@colorremedies.com> 
>wrote:
>
>>  Something like this:
>>  [root@f24s ~]# dd if=/dev/sda | hexdump -C | egrep '5f 42 48 52 66 53 
>>5f'
>>  00110040  5f 42 48 52 66 53 5f 4d  8d 4f 04 00 00 00 00 00  
>>|_BHRfS_M.O......|
>
>Ha so originally I was planning on putting in the dd portion a count
>limit, like count=20480 for a 10MiB search from the start of the
>drive. You could just do
>
># hexdump -C /dev/sda | egrep '5f 42 48 52 66 53 5f'
>
>And then control-C to cancel it once the first super shows up.
>
>
>--
>Chris Murphy


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

