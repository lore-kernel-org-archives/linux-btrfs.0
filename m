Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53056 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753932AbdIDSmf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 14:42:35 -0400
Date: Mon, 4 Sep 2017 20:42:29 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: \o/ compsize
Message-ID: <20170904184229.cjarg6p7tbgy7gka@angband.pl>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
 <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 07:07:25PM +0300, Timofey Titovets wrote:
> 2017-09-04 18:11 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
> > Here's an utility to measure used compression type + ratio on a set of files
> > or directories: https://github.com/kilobyte/compsize
> >
> > It should be of great help for users, and also if you:
> > * muck with compression levels
> > * add new compression types
> > * add heurestics that could err on withholding compression too much
> 
> Packaged to AUR:
> https://aur.archlinux.org/packages/compsize-git/

Cool!  I'd wait until people say the code is sane (I don't really know these
ioctls) but if you want to make poor AUR folks our beta testers, that's ok.

However, one issue: I did not set a license; your packaging says GPL3. 
It would be better to have something compatible with btrfs-progs which are
GPL2-only.  What about GPL2-or-higher?

After adding some related info (like wasted space in pinned extents, reuse
of extents), it'd be nice to have this tool inside btrfs-progs, either as a
part of "fi du" or another command.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
