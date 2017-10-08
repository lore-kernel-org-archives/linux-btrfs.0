Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38722 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdJHPjr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 11:39:47 -0400
Received: by mail-qk0-f195.google.com with SMTP id 17so7950047qkq.5
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Oct 2017 08:39:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171007000837.GD19068@lim.localdomain>
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
 <20171007000837.GD19068@lim.localdomain>
From: Nick Gilmour <nickeforos@gmail.com>
Date: Sun, 8 Oct 2017 17:39:06 +0200
Message-ID: <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
Subject: Re: "BTRFS error (device vda1): couldn't get super buffer head for
 bytenr x"
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply!

For conversion I used this command:
$ vboxmanage internalcommands converttoraw mydisk.vdi mydisk.img

and for resizing this one:
$ qemu-img resize mydisk.img 150G

Is there something I can do to fix this or another way to do the
resizing without getting an error?

Regards,
Nick


On Sat, Oct 7, 2017 at 2:08 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Oct 06, 2017 at 12:25:17PM +0200, Nick Gilmour wrote:
>> Hi all,
>>
>> I have converted .vdi disk (BTRFS) into a .img disk, resized it from
>> 500GB to 150GB and then copied into a ZFS Volume. I've imported the VM
>> into VMM and it started normally but an upgrade failed. I've rebooted
>> and  got only a blue screen something like a BSOD on Windows. I've
>> changed into a terminal and now this error appears constantly:
>>
>>  "BTRFS error (device vda1): couldn't get super buffer head for bytenr x"
>
> The error implies that it failed to read the sectors which contains
> btrfs superblock, given you've shrinked the size, I guess btrfs
> doesn't know that somehow and is trying to issue writes to a >150GB
> position(could be 256G).
>
> You can check that 'bytenr x'.
>
> Which command did you use to resize it?
>
> thanks,
>
> -liubo
>
>>
>> I can stop it shortly with Ctrl-C and enter a command. With startx I
>> can see my desktop in blue  color with some icons in it and nothing
>> more.
>>
>>
>> uname -a
>> Linux VM-Ubuntu 4.4.0-83-generic
>>
>> btrfs --version
>> btrfs-progs v4.4
>>
>> btrfs fi show
>> Label: none uuid: x
>>            Total devices 1 FS bytes used 473.68GiB
>>             devid 1 size 492.00 GiB used 492.00GiB path /dev/sda1
>>
>> Label: 'extra' uuid: y
>>            Total devices 1 FS bytes used 112.00KiB
>>             devid 1 size 100.00 GiB used 2.02GiB path /dev/sdb1
>>
>> btrfs fi df /home
>> Data, single: total=106.40GiB, used=96.42GiB
>> System, DUP: total=8.00MiB, used=48.00KiB
>> Metadata, DUP: total=14.88GiB, used=11.18GiB
>> GlobalReserve, single: total=512.00 MiB, used=0.00B
>>
>> dmesg > dmesg.log
>> compiz: segfault at ... error 4 in libnux-graphics-4.0.so...
>>
>>
>> Any ideas?
>>
>> Regards,
>> Nick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
