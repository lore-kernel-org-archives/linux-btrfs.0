Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35586 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbCaIki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 04:40:38 -0400
Received: by ierf6 with SMTP id f6so10127277ier.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 01:40:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
References: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
Date: Tue, 31 Mar 2015 09:40:36 +0100
Message-ID: <CAL3q7H5ujYoDoo66OY5HAgpQF-i5CyyinMphHVwZmt=ieAKURg@mail.gmail.com>
Subject: Re: Btrfs Send/Receive "utime" error And "WARN_ON Cannot allocate memory"
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 4:06 AM, Robbie Ko <robbieko@synology.com> wrote:
> Hi,
>
> I have  testing btrfs send/receive recently.
>
> I got an error "send ioctl failed with -12: Cannot allocate memory" on
> send side.
> WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.
>
> I got an error "utime failed: No such file or directory" on receive side.
> The followings are simple reproduced steps and related information.
>
> I have applied the following patch in the url :
> https://patchwork.kernel.org/patch/6113581/.
> However, it did not fix the problem.
>
> Is there any  idea about what this might be or how to fix it?
>
> Steps to reproduce:
>
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount /dev/sdc /mnt2
>
> $ mkdir -p /mnt/data
> $ mkdir -p /mnt/data/n1/n2
> $ mkdir -p /mnt/data/n4
> $ mkdir -p /mnt/data/t6/t7
> $ mkdir -p /mnt/data/t5
> $ mkdir -p /mnt/data/t7
> $ mkdir -p /mnt/data/n4/t2
> $ mkdir -p /mnt/data/t4
> $ mkdir -p /mnt/data/t3
> $ mv /mnt/data/t7 /mnt/data/n4/t2
> $ mv /mnt/data/t4 /mnt/data/n4/t2/t7
> $ mv /mnt/data/t5 /mnt/data/n4/t2/t7/t4
> $ mv /mnt/data/t6 /mnt/data/n4/t2/t7/t4/t5
> $ mv /mnt/data/n1/n2 /mnt/data/n4/t2/t7/t4/t5/t6
> $ mv /mnt/data/n1 /mnt/data/n4/t2/t7/t4/t5/t6
> $ mv /mnt/data/n4/t2/t7/t4/t5/t6/t7 /mnt/data/n4/t2/t7/t4/t5/t6/n2
> $ mv /mnt/data/t3 /mnt/data/n4/t2/t7/t4/t5/t6/n2/t7
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
>
> $ mv /mnt/data/n4/t2/t7/t4/t5/t6/n1 /mnt/data/n4
> $ mv /mnt/data/n4/t2 /mnt/data/n4/n1
> $ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6/n2 /mnt/data/n4/n1/t2
> $ mv /mnt/data/n4/n1/t2/n2/t7/t3 /mnt/data/n4/n1/t2
> $ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6 /mnt/data/n4/n1/t2
> $ mv /mnt/data/n4/n1/t2/t7/t4 /mnt/data/n4/n1/t2/t6
> $ mv /mnt/data/n4/n1/t2/t7 /mnt/data/n4/n1/t2/t3
> $ mv /mnt/data/n4/n1/t2/n2/t7 /mnt/data/n4/n1/t2
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
>
>   $ btrfs send /mnt/snap1 | btrfs receive /mnt2
>   $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive /mnt2
> ERROR: send ioctl failed with -12: Cannot allocate memory
> ERROR: utimes data/n4/t2/t7/t4/t5/t6/n2 failed. No such file or directory.


Hi,

May I ask if these reproducers come from a real application/workload
or are they generated through some fuzz tester (like fsstress)?
It would be easier, and save time, if you mention how to get such
reproducers instead of sending the same e-mail over and over again but
with different reproducers.

I'll take a look at it soon.

thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
