Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41662 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1Kc0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 06:32:26 -0400
Date: Mon, 28 Aug 2017 12:32:22 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: shally verma <shallyvermacavium@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: status of inline deduplication in btrfs
Message-ID: <20170828103222.bvdsjpzloo4yubzb@angband.pl>
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
 <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
 <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
 <pan$e34b7$dc9b9508$835301e3$9a80c4d6@cox.net>
 <20170826161524.xz5xylimnqfucdte@angband.pl>
 <CAP9W88geH+nqhjb=qRkU2WSfXG0x9dz-O_6QC-zfdc31UQ3-CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAP9W88geH+nqhjb=qRkU2WSfXG0x9dz-O_6QC-zfdc31UQ3-CA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 28, 2017 at 12:49:10PM +0530, shally verma wrote:
> Am bit confused over here, is your description based on offline-dedupe
> here Or its with inline deduplication?

It doesn't matter _how_ you get to excessive reflinking, the resulting
slowdown is the same.

By the way, you can try "bees", it does nearline-dedupe which is for
practical purposes as good as fully online, and unlike the latter, has no
way to damage your data in case of bugs (mistaken userland dedupe can at
most make the kernel pointlessly read and compare data).

I haven't tried it myself, but what it does is dedupe using FILE_EXTENT_SAME
asynchronously right after a write gets put into the page cache, which in
most cases is quick enough to avoid writeout.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
