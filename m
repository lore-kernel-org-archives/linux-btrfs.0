Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37534 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaJRXMu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 19:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <5441EEA1.7080807@oracle.com>
References: <CAMhgxDMxRNviq5iayuziqUiQXGzSP5cZV2qxnch-3wWLZvwNAA@mail.gmail.com>
 <daf1096c58d3dd54392809f7d3f89e4d@sonic.net> <5441EEA1.7080807@oracle.com>
From: "Vincent." <fensoft@gmail.com>
Date: Sun, 19 Oct 2014 01:12:09 +0200
Message-ID: <CAMhgxDO21Arh+4+uLBAhqSZ36q_4fkhHR=1vcx64jsXYNacBtA@mail.gmail.com>
Subject: Re: raid10 drive replacement
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Suman Chakravartula <suman@rockstor.com>, linux-btrfs@vger.kernel.org,
        linux-btrfs-owner@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i've upgraded to kernel 3.17.0 to update btrfs.ko and it's still not
mountable in -odegraded (-odegraded,ro works) with this error:
[  361.828752] BTRFS info (device xvde): allowing degraded mounts
[  361.984823] BTRFS: bdev (null) errs: wr 15211054, rd 3038899, flush
0, corrupt 0, gen 0
[  374.253555] BTRFS: too many missing devices, writeable mount is not allowed
[  374.332474] BTRFS: open_ctree failed

and, yes, data + metadata are raid10
--
Vincent


On Sat, Oct 18, 2014 at 6:37 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
> somethings aren't matching well. the issue is..
> ----
> [ 6219.703606] Btrfs: too many missing devices, writeable mount is not
> allowed
> ----
> But per Vincent only xvdc is missing in a raid10 (both data and metadata are
> raid10 ?)
>
>
> Anand
>
>
>
> On 10/18/14 10:02, Suman Chakravartula wrote:
>>
>>
>> On 2014-10-17 18:47, Vincent. wrote:
>>>
>>> Hi !
>>>
>>> I have a faulty drive in my raid10 and want it to be replaced.
>>> Working drive are xvd[bef] and replacement drive is xvdc.
>>>
>> This is something I ran into the other day. Key difference is that I was
>> running 3.17.1 kernel and 3.16 btrfs-progs
>>
>>> When I mount my drive in RW:
>>> #mount -odegraded /dev/xvdb /tank
>>> #dmesg -c
>>> [ 6207.294513] btrfs: device fsid 728ef4d8-928c-435c-b707-f71c459e1520
>>> devid 1 transid 551398 /dev/xvdb
>>> [ 6207.327357] btrfs: allowing degraded mounts
>>> [ 6207.477041] btrfs: bdev (null) errs: wr 15211054, rd 3038899, flush
>>> 0, corrupt 0, gen 0
>>> [ 6219.703606] Btrfs: too many missing devices, writeable mount is not
>>> allowed
>>> [ 6219.785929] btrfs: open_ctree failed
>>>
>>
>> In my case, I was able to rw mount. May be update btrfs-progs and retry?
>>
>>> When I mount my drive in RO:
>>> #mount -odegraded,ro /dev/xvdb /tank
>>> #btrfs filesystem show
>>> Label: none  uuid: 728ef4d8-928c-435c-b707-f71c459e1520
>>> Total devices 4 FS bytes used 4.70TiB
>>> devid    1 size 2.73TiB used 2.73TiB path /dev/xvdb
>>> devid    2 size 2.73TiB used 2.73TiB path
>>> devid    3 size 2.73TiB used 2.73TiB path /dev/xvde
>>> devid    4 size 2.73TiB used 2.73TiB path /dev/xvdf
>>>
>>> Btrfs v3.12
>>>
>>> Of course, because my mount is in RO, i can't add device and do a
>>> balance:
>>> #btrfs device add /dev/xvdc /tank
>>> ERROR: error adding the device '/dev/xvdc' - Read-only file system
>>>
>>> Neither a "replace without disk":
>>> #btrfs replace start -Br 2 /dev/xvdc /tank
>>> ERROR: ioctl(DEV_REPLACE_START) failed on "/tank": Read-only file
>>> system, no error
>>>
>> Because my mount was rw, replace worked.
>>
>>> FYI I'm on ubuntu 14.04 with btrfs 3.12
>>>
>>> Any idea ?
>>> Thanks !
>>> --
>>> fensoft
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
