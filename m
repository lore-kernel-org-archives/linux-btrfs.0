Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35922 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcCTTie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 15:38:34 -0400
Received: by mail-io0-f180.google.com with SMTP id 124so38255969iov.3
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 12:38:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC7HdqmQj_sPxZmEAE3nRcAQWOqg+aySQd06=cJNX=EOgjEhjA@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
	<CAJ5QZU0kDKb3HENM9qZa1ebnJRVXwtwOJ_dR=jgYvUOvMTn5jQ@mail.gmail.com>
	<CAC7HdqmQj_sPxZmEAE3nRcAQWOqg+aySQd06=cJNX=EOgjEhjA@mail.gmail.com>
Date: Sun, 20 Mar 2016 14:38:33 -0500
Message-ID: <CAKZK7uw9gMEd-+skdKEUbNO1JZ0c9D7j4zm0d28n62_11dkd-Q@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
From: Justin Brown <justin.brown@fandingo.org>
To: Ryan Erato <rerato@gmail.com>
Cc: Phantom Guy <no.real.person@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not an expert by any means, but I did a migration like this a few weeks ago.

The most consistent recommendation on this mailing list is to use the
newest kernels and btrfs-progs feasible. I did my migration using
Fedora 24 live media, which at the time was kernel ~4.3. I see your
btrfs-progs is a little old. Maybe the kernel is as well and has a
bug.

I know you tried a bunch of variations, but it would be helpful if you
posted the commands you've tried. Perhaps the most obvious problem
that could be occurring is trying to send a RW subvol, which is
illegal. I can't tell if you made a RO snapshot first, but your
success with ROOT indicates you're aware of this limitation. I'm
guessing that there's some problem with the destination path that
you're providing. The path should be the containing subvol where you
want it to go, not the destination name (i.e. btrfs receive
/var/media/backups/ not btrfs receive /var/media/backups/HOME).

Here's some send/receive commands that I've successfully used
recently. Maybe they'll point you in the right direction:

pull a RO snapshot from a remote system:

cd ~/ksp/backups
ssh 192.168.0.122 "sudo btrfs send
/home/justin/ksp/backups/2016-03-15-17:24" | sudo btrfs receive .
mv 2016-03-15-17:24 ../current

Note how I received into the backups directory and have no control
over the initial subvol name. I mv it to the proper location and name
afterwards.

move a RO snapshot between local file system:

cd /tmp/old-btrfs/
sudo btrfs subvol snap -r home home-snap
cd /tmp/new-btrfs/
sudo btrfs send /tmp/old-btrfs/home-snap | sudo btrfs receive .
sudo btrfs subvol snapshot home-snap home
sudo btrfs subvol delete home-snap

Fedora names it's /home subvol "home."

You *shouldn't* need to mess around with advanced mounting options to
get this to work.

On Sun, Mar 20, 2016 at 11:52 AM, Ryan Erato <rerato@gmail.com> wrote:
> I do plan on physically replacing the current drive with the new one
> and my fstab/boot comands use device. I never could get UUID or labels
> to work, but that's another project.
>
> However, this still leaves me unable to take advantage of btrfs
> features for implementing an incremental backup solution to another
> disk.
> Ryan Erato
> C. 414.630.5295
> rerato@gmail.com
> http://www.linkedin.com/in/ryanerato
>
>
> On Sun, Mar 20, 2016 at 1:55 AM, Phantom Guy <no.real.person@gmail.com> wrote:
>> You tried to hard.
>>
>> Build the new media If you need encryption or meets devices.
>>
>>
>> Then add the new media to the whole filesystem.
>>
>>
>> Then remove the old media from the filesystem.
>>
>>
>> # btrfs device add /dev/sdb1 /mountpoint
>>
>> # btrfs device del /dev/sda1 /mountpoint
>>
>> Then sync the filesystem and wait.
>>
>> Once the old device ID no longer part of the filesystem it's done.
>>
>> When the sync finishes, the /dev/sda1 device is nill.
>>
>> If you've designed your fstsb and boot commands correctly the label or UUID
>> has migrated so as long as you've prepped the disk with grub of whatever
>> then you can move the disks with impunity.
>>
>> You don't even need to be in any sort of maintenance mode.
>>
>>
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
