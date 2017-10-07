Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21013 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdJGAMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 20:12:38 -0400
Date: Fri, 6 Oct 2017 17:08:37 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nick Gilmour <nickeforos@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "BTRFS error (device vda1): couldn't get super buffer head for
 bytenr x"
Message-ID: <20171007000837.GD19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 12:25:17PM +0200, Nick Gilmour wrote:
> Hi all,
> 
> I have converted .vdi disk (BTRFS) into a .img disk, resized it from
> 500GB to 150GB and then copied into a ZFS Volume. I've imported the VM
> into VMM and it started normally but an upgrade failed. I've rebooted
> and  got only a blue screen something like a BSOD on Windows. I've
> changed into a terminal and now this error appears constantly:
> 
>  "BTRFS error (device vda1): couldn't get super buffer head for bytenr x"

The error implies that it failed to read the sectors which contains
btrfs superblock, given you've shrinked the size, I guess btrfs
doesn't know that somehow and is trying to issue writes to a >150GB
position(could be 256G).

You can check that 'bytenr x'.

Which command did you use to resize it?

thanks,

-liubo

> 
> I can stop it shortly with Ctrl-C and enter a command. With startx I
> can see my desktop in blue  color with some icons in it and nothing
> more.
> 
> 
> uname -a
> Linux VM-Ubuntu 4.4.0-83-generic
> 
> btrfs --version
> btrfs-progs v4.4
> 
> btrfs fi show
> Label: none uuid: x
>            Total devices 1 FS bytes used 473.68GiB
>             devid 1 size 492.00 GiB used 492.00GiB path /dev/sda1
> 
> Label: 'extra' uuid: y
>            Total devices 1 FS bytes used 112.00KiB
>             devid 1 size 100.00 GiB used 2.02GiB path /dev/sdb1
> 
> btrfs fi df /home
> Data, single: total=106.40GiB, used=96.42GiB
> System, DUP: total=8.00MiB, used=48.00KiB
> Metadata, DUP: total=14.88GiB, used=11.18GiB
> GlobalReserve, single: total=512.00 MiB, used=0.00B
> 
> dmesg > dmesg.log
> compiz: segfault at ... error 4 in libnux-graphics-4.0.so...
> 
> 
> Any ideas?
> 
> Regards,
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
