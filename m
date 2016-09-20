Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35085 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbcITH22 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 03:28:28 -0400
Received: by mail-lf0-f52.google.com with SMTP id l131so5791380lfl.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 00:28:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk> <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 20 Sep 2016 09:28:25 +0200
Message-ID: <CAEtw4r0X0G-Whsfa+JHR36Z4_Mujvtc-GT5TE-w9zpEC3d2PfA@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* If this NOT solve the "No space left" issues you must remove old snapshots.

2016-09-20 9:27 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> Data, RAID1: total=417.12GiB, used=131.33GiB
>
> You have 417(total)-131(used) blocks wo are only partial filled.
> You should balance your file-system.
>
> At first you need some free space. You could remove some files / old
> snapshots etc. or you add a empty USB-Stick with min. 4 GB to your
> BTRFS-Pool (after balancing complete you can remove the stick from the
> pool).
>
> But at first you should try to free emty data and meta data blocks:
>
> btrfs balance start -musage=0 /mnt
> btrfs balance start -dusage=0 /mnt
>
> Then you an run a full balance or a partial balance:
>
> #a partial balance with reorganize data blocks less then 50% filled
> btrfs balance start -dusage=50 /mnt
>
> #or a full balance
> btrfs balance start /mnt
>
> Because of a possible bug you should disable all snapshot scripts
> (like cron-jobs) during the balance.
>
> If this solve the "No space left" issues you must remove old snapshots.
>
> 2016-09-20 8:58 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>> On Tue, Sep 20, 2016 at 03:47:14PM +0900, Tomasz Chmielewski wrote:
>>> How to understand the following "btrfs fi show" output?
>>
>> This gives a write-up (and worked example) of an answer to your question:
>>
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools
>>
>>    If you've got any follow-up questions after reading it, please do
>> come back and we can try to improve the FAQ entry. :)
>>
>>    Hugo.
>>
>>> # btrfs fi show /var/lib/lxd
>>> Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
>>>         Total devices 2 FS bytes used 136.18GiB
>>>         devid    1 size 423.13GiB used 423.13GiB path /dev/sda3
>>>         devid    2 size 423.13GiB used 423.13GiB path /dev/sdb3
>>>
>>> Why is it "size 423.13GiB used 423.13GiB"? Is it full?
>>>
>>> I had "No space left" on this filesystem just yesterday (running
>>> kernel 4.7.4). This is btrfs RAID-1 on SSD disks. This filesystem is
>>> used for 20-30 LXD containers with different roles (mongo, mysql,
>>> postgres databases, webservers etc.), around 150 read-only
>>> snapshots, btrfs compression is disabled.
>>>
>>>
>>> Both "btrfs fi df" and "df -h" show plenty of space:
>>>
>>> # btrfs fi df /var/lib/lxd
>>> Data, RAID1: total=417.12GiB, used=131.33GiB
>>> System, RAID1: total=8.00MiB, used=80.00KiB
>>> Metadata, RAID1: total=6.00GiB, used=4.86GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>>
>>> # df -h
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/sda3       424G  137G  286G  33% /var/lib/lxd
>>>
>>>
>>>
>>> Tomasz Chmielewski
>>> https://lxadm.com
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> Hugo Mills             | I can resist everything except temptation.
>> hugo@... carfax.org.uk |
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |
