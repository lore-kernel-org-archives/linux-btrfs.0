Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35877 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbcEDT2p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 15:28:45 -0400
Received: by mail-oi0-f68.google.com with SMTP id i2so10362704oib.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 12:28:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b7a2d$25647256$6ea52b4$e3976a4a@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
	<pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
	<f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
	<CAJCQCtQ5q_VUw0rCWWRZBFo=Lhx0ouYeuCDMxDLxcWKowUwbUw@mail.gmail.com>
	<pan$b7a2d$25647256$6ea52b4$e3976a4a@cox.net>
Date: Wed, 4 May 2016 13:28:44 -0600
Message-ID: <CAJCQCtRYsPanTSbtaDHOpm-+upb+=Xqxtk7KNxwndzcEvgF47Q@mail.gmail.com>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2016 at 12:34 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Wed, 04 May 2016 12:07:39 -0600 as excerpted:
>
>> If you think it's worth the hassle, then you have to directly modify the
>> grub.cfg to include an expanded rootflags parameter. Right now
>> grub-mkconfig logic doesn't not include all options in fstab for
>> rootflags.
>
> And...
>
> That might explain why his grub2 behavior didn't match what I expected.
>
> Here, I entirely did away with the high-level grub config machinery like
> grub-mkconfig (to the point I install-mask some of the files so they
> don't get installed and thus can't accidentally be run, by some third
> party configuration script or something, and mess up my direct config)
> and I strictly do direct editing of the actual grub.cfg (and included
> files) in grub's native shell-like script.
>
> I tend to forget that grub has this entire higher level config machinery
> that most people use, but that wasn't configuring grub the way I wanted,
> and that I'd have to learn IN ADDITION to the low-level scripting in
> ordered to get grub to do what I wanted, if I was to continue to use the
> high-level stuff at all.  Problem solved locally by simply deleting and
> masking the high-level stuff so it doesn't install, so I had to learn
> only the low-level script config, but that doesn't help me remember that
> few others will be doing that, and that the high-level stuff even exists.

Well this is a major reason why grubby is still used to modify
grub.cfg on Fedora/CentOS/RHEL rather than obliterate the grub.cfg in
favor of an entirely new one made from scratch using the baked in
logic of grub-mkconfig.

The problem is, grubby is crusty and resists modification itself, so
while its templating of a previous boot entry, parsing it, then making
a new boot entry that uses everything it doesn't understand or care
about in the template, only changing the things that it knows need
changing (pretty much just the path to kernel and initramfs), while
applying sanity tests, it also doesn't understand Btrfs subvolumes. So
right now /boot can't be on a Btrfs subvolume, it has to be at the top
level, as a consequence.

So, booting is hard.


-- 
Chris Murphy
