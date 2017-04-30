Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:38208
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937870AbdD3VjY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 17:39:24 -0400
From: Zach Aller <ZAller@iteris.com>
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix these btrfs errors
Date: Sun, 30 Apr 2017 21:39:21 +0000
Message-ID: <D52BC352.4869A%zaller@iteris.com>
References: <D52BBC8E.48696%zaller@iteris.com>
 <CAJCQCtTi+uOSrTvPMp+C22UdCwCNwtQWaZH4Lbr3vd_EBY_t4w@mail.gmail.com>
In-Reply-To: <CAJCQCtTi+uOSrTvPMp+C22UdCwCNwtQWaZH4Lbr3vd_EBY_t4w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is a recent filesystem the data was written with kernel 4.10, today I
upgraded to 4.11rc8 to see if it helped anything which it did not.

On 4/30/17, 4:35 PM, "chris@colorremedies.com on behalf of Chris Murphy"
<chris@colorremedies.com on behalf of lists@colorremedies.com> wrote:

>On Sun, Apr 30, 2017 at 3:08 PM, Zach Aller <ZAller@iteris.com> wrote:
>
>> uname -a
>> Linux server 4.11.0-041100rc8-generic #201704232131 SMP Mon Apr 24
>> 01:32:55 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> ./btrfs --version
>> btrfs-progs v4.10
>>
>> ./btrfs fi show
>> Label: none  uuid: bdd89c26-038d-49fd-b895-52b8deb989cc
>>         Total devices 1 FS bytes used 17.04TiB
>>         devid    1 size 21.83TiB used 17.28TiB path /dev/sda
>
>
>How old is the file system? Is this a recent problem with just
>4.11rc8? Is most of the 17TB written with a particular kernel version,
>which?
>
>
>>
>> Here is a dmesg snippet
>>
>>
>> [    3.633295] BTRFS: device fsid bdd89c26-038d-49fd-b895-52b8deb989cc
>> devid 1 transid 72387 /dev/sda
>> [   12.907658] BTRFS info (device sda): disk space caching is enabled
>> [   12.907659] BTRFS info (device sda): has skinny extents
>> [   13.129140] BTRFS info (device sda): bdev /dev/sda errs: wr 0, rd 0,
>> flush 0, corrupt 217, gen 19
>> [20956.415076] BTRFS info (device sda): The free space cache file
>> (9804365955072) is invalid. skip it
>> [36292.358558] BTRFS warning (device sda): checksum error at logical
>> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level
>>0)
>> in tree 7
>> [36292.358563] BTRFS warning (device sda): checksum error at logical
>> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level
>>0)
>> in tree 7
>> [36292.358569] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
>> flush 0, corrupt 218, gen 19
>> [36292.364717] BTRFS error (device sda): unable to fixup (regular) error
>> at logical 5614914584576 on dev /dev/sda
>
>
>Both copies of metadata are failing checksum, so it can't be fixed. It
>suggests there's a hardware problem (memory or storage), or maybe a
>new bug.
>
>Have there been any crashes while writing to the file system?
>What is the storage stack configuration? 22TB for a single block
>device means it's built up from something else.
>
>I'd dig around for any non-btrfs storage stack related errors in the
>meantime, maybe a dev will have some idea what's going on from the
>call traces, I'm not sure what they mean.
>
>-- 
>Chris Murphy

