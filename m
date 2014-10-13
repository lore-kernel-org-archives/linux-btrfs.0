Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38917 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJMXSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 19:18:09 -0400
Received: by mail-vc0-f178.google.com with SMTP id hq12so6761408vcb.9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 16:18:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
	<CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
Date: Mon, 13 Oct 2014 19:18:08 -0400
Message-ID: <CAGfcS_=QaPPNLYKePnhpaDuXqW3uqc4Y4nWjj5ca_ixCuU+uXA@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: john terragon <jterragon@gmail.com>
Cc: David Arendt <admin@prnet.org>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 5:22 PM, john terragon <jterragon@gmail.com> wrote:
> I'm using "compress=no" so compression doesn't seem to be related, at
> least in my case. Just read-only snapshots on 3.17 (although I haven't
> tried 3.16).

I was using lzo compression, and hence my comment about turning it off
before going back to 3.16 (not realizing that 3.16 has subsequently
been fixed).

Ironically enough I discovered this as I was about to migrate my ext4
backup drive into my btrfs raid1.  Maybe I'll go ahead and wait on
that and have an rsync backup of the filesystem handy (minus
snapshots) just in case.  :)

I'd switch to 3.16, but it sounds like there is no way to remove the
snapshots at the moment, and I can live for a while without the
ability to create new ones.

interestingly enough it doesn't look like ALL snapshots are affected.
I checked and some of the snapshots I made last weekend while doing
system updates look accessible.  They are significantly smaller, and
the subvolumes they were made from are also fairly new - though I have
no idea if that is related.

The subvolumes do show up in btrfs su list.  They cannot be examined
using btrfs su show.

It would be VERY nice to have a way of cleaning this up without
blowing away the entire filesystem...

--
Rich
