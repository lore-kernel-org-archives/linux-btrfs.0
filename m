Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45417 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3ALHsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 02:48:21 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so3278252iej.32
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 23:48:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E3B2C3E3-7A06-4C19-AA66-5AFC3FC7D2C3@colorremedies.com>
References: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com>
	<CAE5mzvjGwnrYJUQJ97xuCm__hAE18cfLx8r5_NutFkA6dzONcQ@mail.gmail.com>
	<E3B2C3E3-7A06-4C19-AA66-5AFC3FC7D2C3@colorremedies.com>
Date: Sat, 12 Jan 2013 01:48:21 -0600
Message-ID: <CAE5mzvgnEq6qFyJfujPLzG5wFRToYFWwFa-HpsCaotkz+kN5Zw@mail.gmail.com>
Subject: Re: obscure out of space, df and fi df are way off
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> [root@localhost tmp]# df
>>> Filesystem                 1K-blocks    Used Available Use% Mounted on
>>> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage
>>> /dev/sda1                     495844   31509    438735   7% /mnt/sysimage/boot
>>> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage/home
>>>
>>> So there's 1.5M of free space left according to conventional df. However:
>>>
>>> [root@localhost tmp]# btrfs fi show
>>> Label: 'fedora_f18v'  uuid: 0c9b2b62-5ec1-4610-ab2f-9f00c909428a
>>>        Total devices 1 FS bytes used 2.87GB
>>>        devid    1 size 3.57GB used 3.57GB path /dev/sda3
>>>
>>> [root@localhost tmp]# btrfs fi df /mnt/sysimage
>>> Data: total=2.69GB, used=2.69GB
>>> System, DUP: total=8.00MB, used=4.00KB
>>> System: total=4.00MB, used=0.00
>>> Metadata, DUP: total=438.94MB, used=183.36MB
>>> Metadata: total=8.00MB, used=0.00

> So if I assume 2.7GiB for data, and add up the left side of fi df I get 3224MB rounded up, which is neither 3.57GB or 3.57GiB. I'm missing 346MB at least. That is what I should have said from the outset.

2.69 + (438.94 / 1000 *2) + (8.0 / 1000 / 1000 *2) + (4.0 / 1000 /
1000) + (8.0 / 1000 / 1000 *2)
3.567916

Looks like 3.57GB to me :p

> So is the Metadta DUP Total 438.94MB allocated value actually twice that, but only 438.94MB is displayed because that's what's available (since the metadata is duplicated)?

The capacity of the metadata group is 438.94; the actual size on disk
is twice that.

>> Note that the -M option to mkfs.btrfs is intended for this use-case:
>> filesystems where the size of a block allocation is large compared to
>> the size of the filesystem.  It should let you squeeze out most of the
>> rest of that 400MB (200MB, DUP).
>
> Is there a simple rule of thumb an installer could use to know when to use -M? I know mkfs.btrfs will do this for smaller filesystems than this. I'm thinking this is a testing edge case that a desktop installer shouldn't be concerned about, but rather should just gracefully fail from, or better yet, insist on a larger install destination than this in particular when Btrfs.

I tend to go with "any filesystem smaller than 32GB", but a more
accurate rule is probably along the lines of "any filesystem that you
expect to normally run within half a gb of full".
