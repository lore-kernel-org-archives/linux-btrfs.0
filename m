From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: Interpreting Output of "btrfs fi show"
Date: 26 Apr 2012 13:11:00 +0200
Message-ID: <C7$h9m5PCXB@helmut.hullen.de>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Bart,

Du meintest am 26.04.12:

>>> As for the two filesystems shown in btrfs fi show... I have no clue
>>> what that is about. Did you maybe make a mistake to create a btrfs
>>> filesystem on the whole disk at first?

>> That is possible. But afterwards I certainly repartioned the device
>> and created a btrfs filesystem on /dev/sda1. Maybe this info is only
>> in the partition table? I understand that I should avoid mounting
>> /dev/sda in this situation.

> Well I think there is a btrfs superblock still present from the
> full-disk filesystem. Due to the offset of the first partition from
> the start of the disk, this superblock was not overwritten when you
> created the filesystem inside the partition.

Sounds familiar ...

I now use to delete about the first 10 MByte of the target disk via "dd  
if=/dev/zero"

Viele Gruesse!
Helmut
