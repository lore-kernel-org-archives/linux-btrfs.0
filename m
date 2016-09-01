Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35775 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756138AbcIAVDL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:03:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bfXxb-0002Tw-SD
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 21:47:39 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: [OT] Re: Balancing subvolume on a specific device
Date: Thu, 1 Sep 2016 21:45:19 +0200
Message-ID: <20160901214519.79d27445@jupiter.sol.kaishome.de>
References: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
        <20160819171734.GJ20440@carfax.org.uk>
        <pan$dbf6f$52e9f6f3$42f8cce4$2ebbbbc6@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 20 Aug 2016 06:30:11 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> There's at least three other options to try to get what you mention, 
> however.  FWIW, I'm a gentooer and thus build everything from sources 
> here, and use ccache myself.  What I do is put all my build stuff,
> the gentoo git and assorted overlay git trees, ccache, kernel
> sources, the binpkg cache, etc, all on a separate "build" btrfs on
> normal partitions, / not/ a subvolume.  That way it can go wherever I
> want, and it, along with the main system (/) and /home, but /not/ my
> media partition (all of which are fully independent filesystems on
> their own partitions, most of them btrfs raid1 on a parallel set of
> partitions on a pair of ssds), on ssd. Works great. =:^)

Off topic: Is ccache really that helpful? I dumped it a few years ago
after getting some build errors and/or packaging bugs with it (software
that would just segfault when built with ccache), and in the end it
didn't give a serious speed boost anyways after comparing the genlop
results. What would help a whole lot more would be to cache this really
really inefficient configure tool of hell which often runs much longer
than the build phase of the whole source itself.

I now moved to building inside tmpfs (/var/tmp/portage mounted as 32GB
tmpfs with x-systemd.automount), added around 30GB of swap space just
in case. I'm running on 16GB of RAM and found around half of my RAM
almost always sits there doing nothing. Even building chromium and
libreoffice at the same time shows no problems with this setup. Plus,
it's a whole lot faster than building on the native fs (even if I'm
using bcache). And I'm building more relaxed since my SSD is wearing
slower - Gentoo emerge can put a lot of burden on the storage.

-- 
Regards,
Kai

Replies to list-only preferred.

