Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36289 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbEMLaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 07:30:24 -0400
Received: by igbpi8 with SMTP id pi8so135745103igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 04:30:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150513111131.GR18480@carfax.org.uk>
References: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
	<55532EA4.2080907@skagestad.org>
	<20150513111131.GR18480@carfax.org.uk>
Date: Wed, 13 May 2015 12:30:23 +0100
Message-ID: <CAL3q7H71A1mgLvPGqhuQp7mD+pxpR7JXdaz3dk3kRE4idYJTWg@mail.gmail.com>
Subject: Re: Failed RAID0=> RAID1 Conversion
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>,
        David Alcorn <nroclaed@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 12:11 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, May 13, 2015 at 12:59:48PM +0200, Torbjørn wrote:
>> On 13. mai 2015 12:47, David Alcorn wrote:
>> >I run Debian Jessie with a kernel upgrade to 4.0.0 from the Debian
>> >experimental repository.  My BTRFS-Tools remain at 3.17.-1  I wanted
>> >to convert a RAID0 array on /dev/sdb3 and /dev sdc3  from RAID0  to
>> >RAID1 so I ran the commands:
>> >
>> >     mount /dev/sdb3 /mnt
>> >     btrfs device add -f /dev/sdc3 /mnt
>> >     btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt
>> >
>> >All appeared well with output similar to "395 of 395 chunks converted"
>> >but I think nothing happened.  The array contains a subvolume @export
>> >with size (per "du -sh @export") of  442G.  The pertinent output from
>> >"btrfs filesystem show" reports:
>> >
>> >     Label: none  uuid: 647eb0f8-7732-40bc-a4a4-0d1b31a8ae16
>> >             Total devices 2 FS bytes used 443.05GiB
>> >             devid    1 size 1.36TiB used 223.03GiB path /dev/sdb3
>> >             devid    2 size 1.36TiB used 223.03GiB path /dev/sdc3
>> >
>> >My array remains RAID0 if I understand the above output correctly.
>> >This output persist through a reboot and no data was lost.  Where did
>> >I err?
>>
>> For info about raid levels, use "btrfs filesystem df <mount point>"
>> It should give you something like this:
>> Data, RAID1: total=12.97GiB, used=12.28GiB
>> System, RAID1: total=32.00MiB, used=16.00KiB
>> Metadata, RAID1: total=1.00GiB, used=334.53MiB
>> GlobalReserve, single: total=112.00MiB, used=0.00B
>
>    If this still says RAID0, then you've probably hit a known (and
> since fixed) bug that stops restripe operations from working:

As far as I can see, it hasn't been fixed as of 4.1-rc3 yet, nor any
patch to fix it was posted to this list yet (other than Omar's revert
patch).

>
> http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg43313.html
>
>    Hugo.
>
> --
> Hugo Mills             | You can play with your friends' privates, but you
> hugo@... carfax.org.uk | can't play with your friends' childrens' privates.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                       C++ coding rule



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
