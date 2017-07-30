Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:37983 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdG3Bj1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 21:39:27 -0400
Received: by mail-lf0-f45.google.com with SMTP id y15so102550042lfd.5
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 18:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$6c020$e98b46d2$7e8ca956$7078db6d@cox.net>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
 <20170726160717.GA32451@localhost.localdomain> <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
 <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net> <CANznX5GNuSXRNq7Zo7pghi4AM=jh_C9yGLd-zdi7P88xRE5Tqw@mail.gmail.com>
 <pan$6c020$e98b46d2$7e8ca956$7078db6d@cox.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sun, 30 Jul 2017 03:39:10 +0200
Message-ID: <CANznX5E9nONAbOA-RQWgdL2G7wgwkP73mUDL2d5v2AB9n3inqw@mail.gmail.com>
Subject: Re: write corruption due to bio cloning on raid5/6
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reply to the TL;DR part, so TL;DR marker again...

Well, I live on the other extreme now. I want as few filesystems as
possible and viable (it's obviously impossible to have a real backup
within the same fs and/or device and with the current
size/performance/price differences between HDD and SSD, it's evident
to separate the "small and fast" from the "big and slow" storage but
other than that...). I always believed (even before I got a real grasp
on these things and could explain my view or argue about this)
"subvolumes" (in a general sense but let's use this word here) should
reside below filesystems (and be totally optional) and filesystems
should spread over a whole disk or(md- or hardware) RAID volume
(forget the MSDOS partitions) and even these ZFS/Brtfs style
subvolumes should be used sparingly (only when you really have a good
enough reason to create a subvolume, although it doesn't matter nearly
as much with subvolumes than it does with partitions).

I remember the days when I thought it's important to create separate
partitions for different kinds of data (10+ years ago when I was aware
I didn't have the experience to deviate from common general
teachings). I remember all the pain of randomly running out of space
on any and all filesystems and eventually mixing the various kinds of
data on every theoretically-segregated filesystems (wherever I found
free space), causing a nightmare of broken sorting system (like a
library after a tornado) and then all the horror of my first russian
rulett like experiences of resizing partitions and filesystem to make
the segregation decent again. And I saw much worse on other peoples's
machines. At one point, I decided to create as few partitions as
possible (and I really like the idea of zero partitions, I don't miss
MSDOS).
I still get shivers if I need to resize a filesystems due to the
memories of those early tragic experiences when I never won the
lottery on the "trial and error" runs but lost filesystems with both
hands and learned what wild-spread silent corruption is and how you
can refresh your backups with corrupted copies...). Let's not take me
back to those early days, please. I don't want to live in a cave
anymore. Thank you modern filesystems (and their authors). :)

And on that note... Assuming I had interference problems, it was
caused by my human mistake/negligence. I can always make similar or
bigger human mistakes, independent of disk-level segregation. (For
example, no amount of partitions will save any data if I accidentally
wipe the entire drive with DD, or if I have it security-locked by the
controller and loose the passwords, etc...)
