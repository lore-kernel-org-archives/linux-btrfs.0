Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60913 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaJMTud (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 15:50:33 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so9510120wgh.9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 12:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543B372F.10509@oracle.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
	<543B372F.10509@oracle.com>
Date: Mon, 13 Oct 2014 12:50:31 -0700
Message-ID: <CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com>
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Suman C <schakrava@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had progs 3.12 and updated to the latest from git(3.16). With this
update, btrfs fi show reports there is a missing device immediately
after i pull it out. Thanks!

I am using virtualbox to test this. So, I am detaching the drive like so:

vboxmanage storageattach <vm> --storagectl <controller> --port <port>
--device <device> --medium none

Next I am going to try and test a more realistic scenario where a
harddrive is not pulled out, but is damaged.

Can/does btrfs mark a filesystem(say, 2 drive raid1) degraded or
unhealthy automatically when one drive is damaged badly enough that it
cannot be written to or read from reliably?

Suman

On Sun, Oct 12, 2014 at 7:21 PM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
> Suman,
>
>> To simulate the failure, I detached one of the drives from the system.
>> After that, I see no sign of a problem except for these errors:
>
>  Are you physically pulling out the device ? I wonder if lsblk or blkid
>  shows the error ? reporting device missing logic is in the progs (so
>  have that latest) and it works provided user script such as blkid/lsblk
>  also reports the problem. OR for soft-detach tests you could use
>  devmgt at http://github.com/anajain/devmgt
>
>  Also I am trying to get the device management framework for the btrfs
>  with a more better device management and reporting.
>
> Thanks,  Anand
>
>
>
> On 10/13/14 07:50, Suman C wrote:
>>
>> Hi,
>>
>> I am testing some disk failure scenarios in a 2 drive raid1 mirror.
>> They are 4GB each, virtual SATA drives inside virtualbox.
>>
>> To simulate the failure, I detached one of the drives from the system.
>> After that, I see no sign of a problem except for these errors:
>>
>> Oct 12 15:37:14 rock-dev kernel: btrfs: bdev /dev/sdb errs: wr 0, rd
>> 0, flush 1, corrupt 0, gen 0
>> Oct 12 15:37:14 rock-dev kernel: lost page write due to I/O error on
>> /dev/sdb
>>
>> /dev/sdb is gone from the system, but btrfs fi show still lists it.
>>
>> Label: raid1pool  uuid: 4e5d8b43-1d34-4672-8057-99c51649b7c6
>>      Total devices 2 FS bytes used 1.46GiB
>>      devid    1 size 4.00GiB used 2.45GiB path /dev/sdb
>>      devid    2 size 4.00GiB used 2.43GiB path /dev/sdc
>>
>> I am able to read and write just fine, but do see the above errors in
>> dmesg.
>>
>> What is the best way to find out that one of the drives has gone bad?
>>
>> Suman
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
