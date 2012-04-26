From: Bart Noordervliet <bart@noordervliet.net>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 12:04:21 +0200
Message-ID: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
References: <4F98B447.30102@ennit.de> <CAGy7UtgsWOmvG16oFTRutFTu5bwq4kT+CQTicqPuYa45YhqUSA@mail.gmail.com>
 <4F991027.6000903@ennit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Thomas Rohwer <trohwer@ennit.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F991027.6000903@ennit.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 11:06, Thomas Rohwer <trohwer@ennit.de> wrote:
>> As for the two filesystems shown in btrfs fi show... I have no clue
>> what that is about. Did you maybe make a mistake to create a btrfs
>> filesystem on the whole disk at first?
>
> That is possible. But afterwards I certainly repartioned the device and
> created a btrfs filesystem on /dev/sda1. Maybe this info is only in
> the partition table? I understand that I should avoid mounting /dev/sda
> in this situation.

Well I think there is a btrfs superblock still present from the
full-disk filesystem. Due to the offset of the first partition from
the start of the disk, this superblock was not overwritten when you
created the filesystem inside the partition. But they very much
overlap and the full-disk superblock will probably eventually be
overwritten by elements from the partition filesystem. How you would
go about erasing the stale superblock and whether it is safe to do so
I can't say though.
