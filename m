From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Mon, 30 Apr 2012 19:12:55 +0100
Message-ID: <CAMU1PDhukD76UDQ9fUbcsZKW7gsw0vBQC7LjvT8Ocme+G_xpzw@mail.gmail.com>
References: <4F98B447.30102@ennit.de>
	<CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
	<201204290813.48417.Martin@lichtvoll.de>
	<4295276.7uL8mlRAJE@bursa01>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4295276.7uL8mlRAJE@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On 30 April 2012 18:10, Hubert Kario <hka@qbs.com.pl> wrote:
> On Sunday 29 of April 2012 08:13:48 Martin Steigerwald wrote:
>> Am Donnerstag, 26. April 2012 schrieb Bart Noordervliet:
>> > On Thu, Apr 26, 2012 at 11:06, Thomas Rohwer <trohwer@ennit.de> wr=
ote:
>> > >> As for the two filesystems shown in btrfs fi show... I have no =
clue
>> > >> what that is about. Did you maybe make a mistake to create a bt=
rfs
>> > >> filesystem on the whole disk at first?
>> > >
>> > > That is possible. But afterwards I certainly repartioned the dev=
ice
>> > > and created a btrfs filesystem on /dev/sda1. Maybe this info is =
only
>> > > in the partition table? I understand that I should avoid mountin=
g
>> > > /dev/sda in this situation.
>> >
>> > Well I think there is a btrfs superblock still present from the
>> > full-disk filesystem. Due to the offset of the first partition fro=
m
>> > the start of the disk, this superblock was not overwritten when yo=
u
>> > created the filesystem inside the partition. But they very much
>> > overlap and the full-disk superblock will probably eventually be
>> > overwritten by elements from the partition filesystem. How you wou=
ld
>> > go about erasing the stale superblock and whether it is safe to do=
 so
>> > I can't say though.
>>
>> There is the command wipefs. Whether its safe to use here I do not k=
now. I
>> wouldn=C2=B4t try without a backup.
>
> Sorry, but I'm unable to find it. Is it a `btrfs` tool option or is i=
t a
> standalone application (in similar form as is the `btrfs-zero-log`)?

Google is your friend.  wipefs is part of util-linux from 2.17, circa J=
an-2010.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
