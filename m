Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27279 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbcCOWTs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 18:19:48 -0400
Subject: Re: Incompat features: raid56 ... when creating a RAID6?
To: Andreas Grosse <andig.listen@aol.com>
References: <16570443.SxVegaKaET@andilaptop>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <56E88A7C.1010801@oracle.com>
Date: Wed, 16 Mar 2016 06:19:40 +0800
MIME-Version: 1.0
In-Reply-To: <16570443.SxVegaKaET@andilaptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/16/2016 05:42 AM, Andreas Grosse wrote:
> Hello everyone!
>
> I just wanted to create a RAID6 and got the following output:
>
>> # mkfs.btrfs -d raid6 -m raid6 -L slowPool /dev/sd[cdefgh]
>> btrfs-progs v4.4.1
>> See http://btrfs.wiki.kernel.org for more information.
>>
>> Label:              slowPool
>> UUID:               85ddf6a7-51f1-4cc0-b6cd-d472277b0e86
>> Node size:          16384
>> Sector size:        4096
>> Filesystem size:    27.29TiB
>>
>> Block group profiles:
>>    Data:             RAID6             4.01GiB
>>    Metadata:         RAID6             4.01GiB
>>    System:           RAID6            14.50MiB
>>
>> SSD detected:       no
>> Incompat features:  extref, raid56, skinny-metadata
>> Number of devices:  6
>>
>> Devices:
>>     ID        SIZE  PATH
>>
>>      1     4.55TiB  /dev/sdc
>>      2     4.55TiB  /dev/sdd
>>      3     4.55TiB  /dev/sde
>>      4     4.55TiB  /dev/sdf
>>      5     4.55TiB  /dev/sdg
>>      6     4.55TiB  /dev/sdh
>
> And then the line saying "Incompat features: ... raid56" came to my eyes.
> Reading the corresponding manpage, it says:
>> raid56
>>      extended format for RAID5/6, also enabled if raid5 or raid6 block groups
>>      are selected
>
> So why is raid56 marked as incompatible if I just created a file system with
> multiple disks using the RAID6 profile? Have I misunderstood something there?
> I am confused. Can somebody here lighten this up?

  Those messages are indeed confusing. It just indicates the
  FS may fail to mount on certain older kernels. Not necessarily
  the kernel in the system on which you ran btrfs-progs. Sorry
  that it not very obvious at the moment, but there are patches
  to make this part better.

  To check features that your running kernel supports you could use
   ls /sys/fs/btrfs/features

  But note: Some of the names used by sys/fs/..features don't
  exactly match with the names used by btrfs-progs: incompatible..
  (a bug, which is also fixed in the patch).

Thanks, Anand


> (If important: Gentoo Linux with kernel 4.5.0, btrfs-progs v4.4.1)
>
> AndiN‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Þº{.nÇ+‰·¥Š{±nÚß²)í…æèw*jg¬±¨¶‰šŽŠÝ¢j/êäz¹Þ–Šà2ŠÞ™¨è­Ú&¢)ß¡«a¶Úþø®G«éh®æj:+v‰¨Šwè†Ù¥
>
