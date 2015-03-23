Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [85.19.192.2] ([85.19.192.2]:33391 "EHLO mail.itpas.no"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbbCWNEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 09:04:54 -0400
Message-ID: <55100C94.2060709@itpas.no>
Date: Mon, 23 Mar 2015 13:52:36 +0100
From: =?UTF-8?B?VG9yYmrDuHJuIFNrYWdlc3RhZA==?= <torbjorn@itpas.no>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
References: <550FEC73.9010507@skagestad.org> <1427113963.5707.0@mail.thefacebook.com>
In-Reply-To: <1427113963.5707.0@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23. mars 2015 13:32, Chris Mason wrote:
>
>
> On Mon, Mar 23, 2015 at 6:35 AM, Torbjørn <lists@skagestad.org> wrote:
>> Hi,
>>
>> After upgrading to 4.0.0-rc5 from 4.0.0-rc4 I see "Object already 
>> exists" after reboot.
>> The fs is forced read only.
>> The error does not disappear after additional reboots.
>>
>> mount|grep sda1
>> /dev/sda1 on / type btrfs (rw,noatime,compress=lzo,space_cache,subvol=@)
>> /dev/sda1 on /home type btrfs 
>> (rw,noatime,compress=lzo,space_cache,subvol=@home)
>> /dev/sda1 on /mnt/volumes type btrfs 
>> (rw,noatime,compress=lzo,space_cache)
>>
>> Label: 'root'  uuid: 6a681300-faef-4195-a1b3-6699c7a5aa5e
>>     Total devices 2 FS bytes used 66.87GiB
>>     devid    1 size 298.09GiB used 124.03GiB path /dev/sda1
>>     devid    2 size 298.09GiB used 124.03GiB path /dev/sdd1
>>
>> btrfs-progs v3.19
>>
>> Any additional info I can provide? Tests you want me to run?
>
> Are you seeing this consistently with every boot?
>
> If so, can you please revert this one:
>
> commit ea526d18990018f224e5734748975bea1824545f
> Author: Josef Bacik <jbacik@fb.com>
> Date:   Fri Mar 13 16:40:45 2015 -0400
>
>    Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
>
> Anything special about your workload
>
> -chris
>
I see it consistently with every reboot.
The fs is the root of a server. The fs itself has no special workload 
except being root.

I will try to boot with 4.0.0-rc4 as soon as I get physical access, and 
also revert ea526d18990018f224e5734748975bea1824545f.

Thanks.

--
Torbjørn
