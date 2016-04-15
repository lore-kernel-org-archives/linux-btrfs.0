Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:56459 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbcDOJRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 05:17:41 -0400
Subject: Re: Help ! "btrfs check" looping recursive
References: <570FCBBD.2010500@petaramesh.org>
 <pan$9e5b6$4adde6c7$caa17ba5$f91d4445@cox.net>
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Message-ID: <5710B0A9.1030800@petaramesh.org>
Date: Fri, 15 Apr 2016 11:13:13 +0200
MIME-Version: 1.0
In-Reply-To: <pan$9e5b6$4adde6c7$caa17ba5$f91d4445@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Thanks for your reply Duncan !

Le 15/04/2016 02:24, Duncan wrote :
> Swâmi Petaramesh posted on Thu, 14 Apr 2016 18:56:29 +0200 as excerpted:
> 
>> It seems that i have a "btrfs check" process that’s stuck in an infinite
>> recursive loop…

> Given the prompt above, you're running from parted-magic, but that 
> doesn't tell us the btrfs-progs or kernel versions unless we look it up.

True, I forgot to specify this.

This FS is from a machine that currently runs : 4.5.0-1-ARCH

As I had a couple of "dead" files (KDE session files in
~/.config/session) that showed "????" for all their attributes and
couldn’t be accessed nor deleted, I ran "btrfs check" from a reasonably
recent live Parted Magic, which has :

- Kernel : 4.3.2
- BTRFS tools : 4.1.2

> So kernel and btrfs-progs version?  Also, btrfs filesystem show output 
> might be useful.

Taken from the currently running machine (as I in the end choosed to
abort the "btrfs check" using ^C) :

# btrfs fi sh
Label: 'LINUX'  uuid: 13c87f57-3a85-4daf-a4bf-ba777407c169
        Total devices 1 FS bytes used 268.07GiB
        devid    1 size 334.50GiB used 294.54GiB path /dev/mapper/VGZ-LINUX


# btrfs fi df /
Data, single: total=289.46GiB, used=264.17GiB
System, DUP: total=32.00MiB, used=56.00KiB
Metadata, single: total=5.01GiB, used=3.90GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi us /
Overall:
    Device size:                 334.50GiB
    Device allocated:            294.54GiB
    Device unallocated:           39.96GiB
    Device missing:                  0.00B
    Used:                        268.07GiB
    Free (estimated):             65.26GiB      (min: 45.28GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)





Data,single: Size:289.46GiB, Used:264.17GiB


   /dev/mapper/VGZ-LINUX         289.46GiB





Metadata,single: Size:5.01GiB, Used:3.90GiB


   /dev/mapper/VGZ-LINUX           5.01GiB

System,DUP: Size:32.00MiB, Used:56.00KiB
   /dev/mapper/VGZ-LINUX          64.00MiB

Unallocated:
   /dev/mapper/VGZ-LINUX          39.96GiB


# df -h /
Sys. de fichiers      Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/VGZ-LINUX   335G    269G   66G  81% /

> Btrfs-progs version in particular, since the recursive nature of this 
> loop is very obviously a bug.


I hope I gave all the necessary information now.

TIA and best regards.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E
