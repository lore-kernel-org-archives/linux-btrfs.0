Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60511 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbcITH0X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 03:26:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP id E3E6F274B1D
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 09:26:18 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
        by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wHdKLruAeOZr for <linux-btrfs@vger.kernel.org>;
        Tue, 20 Sep 2016 09:26:17 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 09:26:17 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 20 Sep 2016 16:26:17 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
In-Reply-To: <20160920065827.GO7138@carfax.org.uk>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk>
Message-ID: <3da23453fe11bcdfaf8cc283456456d0@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, according to that - it means 423.13GiB out of total available space, 
423.13GiB, has been allocated.

Is it good? Is it bad? Is it why I'm getting "No space left" issues?

Why has it allocated all available space, if only around 1/3 of space is 
in use, according to other tools (less than 140 GB out of 423 GB is in 
use)?


On other systems, I see that "used" from "btrfs fi show" more or less 
matches the output of "btrfs fi df"; here - everything is allocated.


Tomasz Chmielewski
https://lxadm.com


On 2016-09-20 15:58, Hugo Mills wrote:
> On Tue, Sep 20, 2016 at 03:47:14PM +0900, Tomasz Chmielewski wrote:
>> How to understand the following "btrfs fi show" output?
> 
> This gives a write-up (and worked example) of an answer to your 
> question:
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools
> 
>    If you've got any follow-up questions after reading it, please do
> come back and we can try to improve the FAQ entry. :)
> 
>    Hugo.
> 
>> # btrfs fi show /var/lib/lxd
>> Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
>>         Total devices 2 FS bytes used 136.18GiB
>>         devid    1 size 423.13GiB used 423.13GiB path /dev/sda3
>>         devid    2 size 423.13GiB used 423.13GiB path /dev/sdb3
>> 
>> Why is it "size 423.13GiB used 423.13GiB"? Is it full?
>> 
>> I had "No space left" on this filesystem just yesterday (running
>> kernel 4.7.4). This is btrfs RAID-1 on SSD disks. This filesystem is
>> used for 20-30 LXD containers with different roles (mongo, mysql,
>> postgres databases, webservers etc.), around 150 read-only
>> snapshots, btrfs compression is disabled.
>> 
>> 
>> Both "btrfs fi df" and "df -h" show plenty of space:
>> 
>> # btrfs fi df /var/lib/lxd
>> Data, RAID1: total=417.12GiB, used=131.33GiB
>> System, RAID1: total=8.00MiB, used=80.00KiB
>> Metadata, RAID1: total=6.00GiB, used=4.86GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> 
>> 
>> # df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/sda3       424G  137G  286G  33% /var/lib/lxd
>> 
>> 
>> 
>> Tomasz Chmielewski
>> https://lxadm.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
