Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36146 "EHLO
	mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcHIJuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 05:50:18 -0400
Received: by mail-ua0-f170.google.com with SMTP id 97so11445701uav.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 02:50:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0b6a094b-ccf0-36c4-aafb-12a4e9cd424d@gmail.com>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
 <CAEtw4r2hsCd1+bFNcXn_s5jj-8x6qer+x0gLx8wTgNi1=nAXhw@mail.gmail.com>
 <CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
 <CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
 <CAE8gLhkR4XzNx9tarhzD2LdsCRJ3e+BPcWYpE-qA4jnJsvSrLg@mail.gmail.com>
 <CAPmG0jZj6S6TXe0xLdiJWMto=VX7NM7WhSc5T3MLf=HWvsR7+Q@mail.gmail.com> <0b6a094b-ccf0-36c4-aafb-12a4e9cd424d@gmail.com>
From: MegaBrutal <megabrutal@gmail.com>
Date: Tue, 9 Aug 2016 11:50:15 +0200
Message-ID: <CAE8gLh=N9dP0aj+oHxGosaTNG45rvQpx=U_Mx1KT0a6MWN2o=w@mail.gmail.com>
Subject: Re: "No space left on device" and balance doesn't work
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Henk Slager <eye1tm@gmail.com>, Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-06-03 14:43 GMT+02:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>
> Also, since you're on a new enough kernel, try 'lazytime' in the mount options as well, this defers all on-disk timestamp updates for up to 24 hours or until the inode gets written out anyway, but keeps the updated info in memory.  The only downside to this is that mtimes might not be correct after an unclean shutdown, but most software will have no issues with this.
>

Hi all,

Sorry for reviving this old thread, and probably it's not the best
place to ask about this... but I added the "noatime" option in fstab,
restarted the system, and now I think I should try "lazytime" too (as
I like the idea to have proper atimes with delayed writing to disk).
So now I'd just like to test the "lazytime" mount option without
restart.

I remounted the file system like this:

mount -o remount,lazytime /

But now the FS still has the "noatime" mount option, which I guess
renders "lazytime" ineffective. I thought they are supposed to be
mutually exclusive, so I'm actually surprised that I can have both
mount options at the same time.

Now my mount looks like this:

/dev/mapper/centrevg-rootlv on / type btrfs
(rw,noatime,lazytime,space_cache,subvolid=257,subvol=/@)

I also tried to explicitly add "atime" to negate "noatime" (man mount
says "atime" is the option to disable "noatime"), like this:

mount -o remount,atime,lazytime /

But the "noatime" option still stays. Why? Is it a BTRFS specific
issue, or does it reside in another layer?

By the way, is it valid to mount BTRFS subvolumes with different atime
policies? Then how do child subvolumes behave?
