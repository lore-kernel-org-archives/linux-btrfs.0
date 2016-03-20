Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38408 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbcCTQw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 12:52:26 -0400
Received: by mail-wm0-f49.google.com with SMTP id l68so96084061wml.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 09:52:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ5QZU0kDKb3HENM9qZa1ebnJRVXwtwOJ_dR=jgYvUOvMTn5jQ@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
 <CAJ5QZU0kDKb3HENM9qZa1ebnJRVXwtwOJ_dR=jgYvUOvMTn5jQ@mail.gmail.com>
From: Ryan Erato <rerato@gmail.com>
Date: Sun, 20 Mar 2016 09:52:05 -0700
Message-ID: <CAC7HdqmQj_sPxZmEAE3nRcAQWOqg+aySQd06=cJNX=EOgjEhjA@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
To: Phantom Guy <no.real.person@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I do plan on physically replacing the current drive with the new one
and my fstab/boot comands use device. I never could get UUID or labels
to work, but that's another project.

However, this still leaves me unable to take advantage of btrfs
features for implementing an incremental backup solution to another
disk.
Ryan Erato
C. 414.630.5295
rerato@gmail.com
http://www.linkedin.com/in/ryanerato


On Sun, Mar 20, 2016 at 1:55 AM, Phantom Guy <no.real.person@gmail.com> wrote:
> You tried to hard.
>
> Build the new media If you need encryption or meets devices.
>
>
> Then add the new media to the whole filesystem.
>
>
> Then remove the old media from the filesystem.
>
>
> # btrfs device add /dev/sdb1 /mountpoint
>
> # btrfs device del /dev/sda1 /mountpoint
>
> Then sync the filesystem and wait.
>
> Once the old device ID no longer part of the filesystem it's done.
>
> When the sync finishes, the /dev/sda1 device is nill.
>
> If you've designed your fstsb and boot commands correctly the label or UUID
> has migrated so as long as you've prepped the disk with grub of whatever
> then you can move the disks with impunity.
>
> You don't even need to be in any sort of maintenance mode.
>
>
>>
>
