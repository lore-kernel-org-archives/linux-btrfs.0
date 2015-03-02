Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:40731 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbbCBQD4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Mar 2015 11:03:56 -0500
Received: by labgd6 with SMTP id gd6so31325203lab.7
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Mar 2015 08:03:54 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJiZgco09Busd5DkXrqo4hL7u_t=g0NkN+54Q8eu0jgY7j8nEQ@mail.gmail.com>
References: <CAJiZgco09Busd5DkXrqo4hL7u_t=g0NkN+54Q8eu0jgY7j8nEQ@mail.gmail.com>
Date: Mon, 2 Mar 2015 16:03:54 +0000
Message-ID: <CAL3q7H6vVzv5caoaLuy1m=v-rVEHfGrmGaB4vXbz=zfe76L37w@mail.gmail.com>
Subject: Re: Btrfs Send/Receive "no such file or directory" bug
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 2, 2015 at 12:22 PM, Robbie Ko <robbieko@synology.com> wrote:
> Hi,
>
> I have been testing btrfs send/receive recently.
> I got an error "rename failed: no such file or directory" on receive side.
> The followings are simple reproduced steps and related information,
> Is there any  idea about what this might be or how to fix it?
>
> uanme -a
> Linux ubuntu 4.0.0-rc1-custom #2 SMP Fri Feb 27 22:20:12 CST 2015
> x86_64 x86_64 x86_64 GNU/Linux
> btrfs --version
> Btrfs v3.14.1
>
>  Steps to reproduce:
>
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
>
>   $ mkdir -p /mnt/data/n1/n2/p1/p2
>   $ mkdir /mnt/data/n4
>   $ mkdir -p /mnt/data/p1/p2
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
>
>   $ mv /mnt/data/p1/p2 /mnt/data
>   $ mv /mnt/data/n1/n2/p1/p2 /mnt/data/p1
>   $ mv /mnt/data/p2 /mnt/data/n1/n2/p1
>   $ mv /mnt/data/n1/n2 /mnt/data/p1
>   $ mv /mnt/data/p1 /mnt/data/n4
>   $ mv /mnt/data/n4/p1/n2/p1 /mnt/data
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
>
>   $ btrfs send /mnt/snap1 -f /tmp/1.send
>   $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/2.send
>
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount /dev/sdc /mnt2
>   $ btrfs receive /mnt2 -f /tmp/1.send
>   $ btrfs receive /mnt2 -f /tmp/2.send
>   ERROR: rename data/p1/p2 -> data/n4/p1/p2 failed. no such file or directory

Thanks for reporting this with an example.
I'll take a look at it.

>
>   Thanks.
>
>   Robbie Ko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
