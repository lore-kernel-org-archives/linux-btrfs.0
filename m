Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:46036 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdIMMz2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 08:55:28 -0400
Received: by mail-io0-f172.google.com with SMTP id g32so1726145ioj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 05:55:28 -0700 (PDT)
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Timofey Titovets <nefelim4ag@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
Cc: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
 <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
 <20170912200057.3mrgtahlvszkg334@angband.pl>
 <e169336d-db31-276f-1d71-bf897cf10d4b@gmail.com>
 <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
 <CAGqmi74UxBRj6pPJ2aEon-raAq46R=29sef_f_wWWGQY1WpwDA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b925e250-0507-55b8-c6da-47d8a5266c9f@gmail.com>
Date: Wed, 13 Sep 2017 08:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAGqmi74UxBRj6pPJ2aEon-raAq46R=29sef_f_wWWGQY1WpwDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-12 20:52, Timofey Titovets wrote:
> No, no, no, no...
> No new ioctl, no change in fallocate.
> Fisrt: VM can do punch hole, if you use qemu -> qemu know how to do it.
> Windows Guest also know how to do it.
> 
> Different Hypervisor? -> google -> Make issue to support, all
> Linux/Windows/Mac OS support holes in files.
Not everybody who uses sparse files is using virtual machines.
> 
> No new code, no new strange stuff to fix not broken things.
Um, the fallocate PUNCH_HOLE mode _is_ broken.  There's a race condition 
that can trivially cause data loss.
> 
> You want replace zeroes? EXTENT_SAME can do that.
But only on a small number of filesystems, and it requires extra work 
that shouldn't be necessary.
> 
> truncate -s 4M test_hole
> dd if=/dev/zero of=./test_zero bs=4M
> 
> duperemove -vhrd ./test_hole ./test_zero
And performance for this approach is absolute shit compared to fallocate -d.

Actual numbers, using a 4G test file (which is still small for what 
you're talking about) and a 4M hole file:
fallocate -d:		0.19 user, 0.85 system, 1.26 real
duperemove -vhrd:	0.75 user, 137.70 system, 144.80 real

So, for a 4G file, it took duperemove (and the EXTENT_SAME ioctl) 114.92 
times as long to achieve the same net effect.  From a practical 
perspective, this isn't viable for regular usage just because of how 
long it takes.  Most of that overhead is that the EXTENT_SAME ioctl does 
a byte-by-byte comparison of the ranges to make sure they match, but 
that isn't strictly necessary to avoid this race condition.  All that's 
actually needed is determining if there is outstanding I/O on that 
region, and if so, some special handling prior to freezing the region is 
needed.
