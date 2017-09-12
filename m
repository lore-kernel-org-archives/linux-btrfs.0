Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:56198 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdILSoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 14:44:04 -0400
Date: Tue, 12 Sep 2017 20:43:59 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912184359.hovirdaj55isvwwg@angband.pl>
References: <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 01:36:48PM -0400, Austin S. Hemmelgarn wrote:
> On 2017-09-12 13:21, Adam Borowski wrote:
> > There's fallocate -d, but that for some reason touches mtime which makes
> > rsync go again.  This can be handled manually but is still not nice.

> It touches mtime because it updates the block allocations, which in turn
> touch ctime, which on most (possibly all, not sure though) POSIX systems
> implies an mtime update.  It's essentially the same as truncate updating the
> mtime when you extend the file, the only difference is that the
> FALLOCATE_PUNCH_HOLES ioctl doesn't change the file size.

Yeah, the underlying ioctl does modify the file, it's merely fallocate -d
calling it on regions that are already zero.  The ioctl doesn't know that,
so fallocate would have to restore the mtime by itself.

There's also another problem: such a check + ioctl are racey.  Unlike defrag
or FILE_EXTENT_SAME, you can't thus use it on a file that's in use (or could
suddenly become in use).  Fixing this would need kernel support, either as
FILE_EXTENT_SAME with /dev/zero or as a new mode of fallocate.

For now, though, I wonder -- should we send fine folks at util-linux a patch
to make fallocate -d restore mtime, either always or on an option?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
