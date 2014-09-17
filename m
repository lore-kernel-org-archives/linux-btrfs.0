Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42389 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaIQEmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 00:42:00 -0400
Message-ID: <54191108.1060703@oracle.com>
Date: Wed, 17 Sep 2014 12:41:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: lists@xunil.at
CC: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <54171E51.2020709@codethink.co.uk> <54172018.1050300@oracle.com> <5417250B.9030105@oracle.com> <5418A6B9.6090003@xunil.at> <5418B15C.1070907@oracle.com>
In-Reply-To: <5418B15C.1070907@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks Sam for the logs.

  In your config  btrfs Kernel still knows the device as /dev/root.
  not /dev/sda. looks like during boot up the device is /dev/root
  and after boot up its /dev/sda. so is the problem all about. some
  logs below to support that.

  Unfortunately at my end I am not able to reproduce this on a virtual
  box. I guess it would need a real bios. If you have any of that info
  that will help.

  when progs can't find the device in user space it would print missing.
  That was introduced in patch 206efb60cbe3049e0d44c6da3c1909aeee18f813.

  But the point to note is  - though the actual device is same, its path
  during boot up and after boot up are different in some standalone
  systems.

  scsi inquiry serial number provides an unique device id. But in btrfs
  we are depend on our SB. which can copied across devices. OR there
  might some un-wiped stale SB on the device. We need some new mechanism
  to handle this.


 From your system, /proc/self/mounts (the device path here
comes from the btrfs kernel, )
------
/dev/root / btrfs ...
::
/dev/root /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
-------

per mount cli
-----
/dev/sda2 on / type btrfs ...
::
/dev/sda2 on /home type btrfs ...
------

fstab
-----
UUID=..b31df	/	btrfs defaults,noatime,compress=lzo,subvolid=258
::
UUID=..b31df	/home	btrfs defaults,noatime,compress=lzo,subvolid=285
-------




Anand


On 17/09/2014 05:53, Anand Jain wrote:
>
>
> Stefan,
>
>   Can you pls send me the output for
>
>     cat /etc/fstab  | egrep btrfs
>     cat /proc/self/mounts | egrep btrfs
>     mount | egrep btrfs
>
> Thanks, Anand
>
>
>
> On 17/09/2014 05:08, Stefan G. Weichinger wrote:
>> Am 15.09.2014 um 19:42 schrieb Anand Jain:
>>
>>> Sam,
>>>
>>>    In the above context, Can you pls share the btrfs fi show output ?
>>
>>
>> unsure if it helps:
>>
>> I applied the patch as well, running gentoo on latest git-sources here.
>>
>> My "btrfs fi show" misses my SSD now:
>>
>> # btrfs fi show
>> Label: 'btrfs_evo'  uuid: ea95dbd1-ef4e-48a4-9732-54e6c80b31df
>>     Total devices 1 FS bytes used 80.91GiB
>>     *** Some devices missing
>>
>> .. although all the btrfs-subvols on /dev/sda2 are mounted correctly and
>> everything works fine so far.
>>
>> Stefan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
