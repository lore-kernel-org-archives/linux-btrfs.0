Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37732 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3EENAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 09:00:01 -0400
Received: by mail-ob0-f177.google.com with SMTP id un3so2442836obb.22
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 06:00:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <h1rh5a-1lg.ln1@hurikhan.ath.cx>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
 <h1rh5a-1lg.ln1@hurikhan.ath.cx>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Sun, 5 May 2013 14:59:40 +0200
Message-ID: <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com>
Subject: Re: Creating recursive snapshots for all filesystems
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

On Sun, May 5, 2013 at 1:05 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> schrieb:
>
>> Where I'm hanging right now, is that I can't seem to figure out a
>> "bullet proof" way to find all the subvolumes of the filesystems I
>> might have.
>
> What about this:
>
> # btrfs sub list -a /

How do I know that "/" is a btrfs? How do I know, that there are not
also other btrfs filesystems? :)

> You still need to iterate through the mounted btrfs filesystems if you are
> using more than one:
>
> # btrfs fi show | fgrep uuid
> Label: 'usb-backup'  uuid: 7038c8fa-4293-49e9-b493-a9c46e5663ca
> Label: 'system'  uuid: d2bb232a-2e8f-4951-8bcc-97e237f1b536
>
> Then translate the uuid back to an fspath somehow.

Yep. That's basically what I'm doing ATM.

>
> Another option would be to use blkid:
>
> # blkid -t TYPE=btrfs

Ah, that's cool! Didn't know that blkid had this option.

> Still needs translation back to fspathes. But that could be done with
> grep/head/lsblk trickery...

Hm, I didn't know lsblk until now, but it seems that it doesn't handle
LVM well, does it?

(See http://pastebin.com/fuZ8HHQi for better readable version.)

a@ask-home:~$ blkid -t TYPE=btrfs | grep mapper
/dev/mapper/ssd-Data: LABEL="Data"
UUID="7d2eb10f-aced-4d41-bb7f-7badbf075b6a"
UUID_SUB="582b64f5-edd5-48f2-978e-24df9a839b5b" TYPE="btrfs"

a@ask-home:~$ lsblk
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                         8:0    0 167.7G  0 disk
├─sda1                      8:1    0   100M  0 part
├─sda2                      8:2    0  10.9G  0 part /dell-recovery
├─sda3                      8:3    0  39.1G  0 part /windows
├─sda4                      8:4    0     1K  0 part
├─sda5                      8:5    0   102M  0 part /boot
├─sda6                      8:6    0   8.1G  0 part [SWAP]
├─sda7                      8:7    0  12.2G  0 part
│ ├─ssd-Data (dm-0)       252:0    0    35G  0 lvm
│ └─ssd-UbRoot1304 (dm-1) 252:1    0    10G  0 lvm  /
├─sda8                      8:8    0  12.2G  0 part
│ └─ssd-Data (dm-0)       252:0    0    35G  0 lvm
├─sda9                      8:9    0  12.2G  0 part
│ └─ssd-Data (dm-0)       252:0    0    35G  0 lvm
├─sda10                     8:10   0  12.2G  0 part
│ └─ssd-Data (dm-0)       252:0    0    35G  0 lvm
├─sda11                     8:11   0  11.9G  0 part
├─sda12                     8:12   0  11.9G  0 part /data/Kernel/KernExt4
├─sda13                     8:13   0  11.9G  0 part
├─sda14                     8:14   0  11.9G  0 part /data/Kernel/KernReiserfs
└─sda15                     8:15   0  11.9G  0 part /data/Kernel/KernXfs
sr0                        11:0    1  1024M  0 rom

a@ask-home:~$ lsblk -P|grep Data
NAME="ssd-Data (dm-0)" MAJ:MIN="252:0" RM="0" SIZE="35G" RO="0"
TYPE="lvm" MOUNTPOINT=""
NAME="ssd-Data (dm-0)" MAJ:MIN="252:0" RM="0" SIZE="35G" RO="0"
TYPE="lvm" MOUNTPOINT=""
NAME="ssd-Data (dm-0)" MAJ:MIN="252:0" RM="0" SIZE="35G" RO="0"
TYPE="lvm" MOUNTPOINT=""
NAME="ssd-Data (dm-0)" MAJ:MIN="252:0" RM="0" SIZE="35G" RO="0"
TYPE="lvm" MOUNTPOINT=""


So I guess I'd still need to mount the root volume temporarily
somewhere to do the translation.

ZFS really wipes the floor with btrfs regarding ease of use as far as
that's concerned…

That blkid trick was quite useful, though. Thanks!

Cheers,
Alexander
-- 
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
