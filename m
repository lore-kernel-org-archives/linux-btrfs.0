Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50812 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdECVTr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 17:19:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d61gR-00022V-MT
        for linux-btrfs@vger.kernel.org; Wed, 03 May 2017 23:19:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can I see what device was used to mount btrfs?
Date: Wed, 3 May 2017 21:19:31 +0000 (UTC)
Message-ID: <pan$8ae23$5a262cb7$97dabdcd$19e38885@cox.net>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
        <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
        <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
        <20170502184923.jdpfx3pwkl5avdph@angband.pl>
        <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
        <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
        <cdf96959-94e8-4932-465f-ea5c72187892@inwind.it>
        <CAJCQCtQwCohHJBKihg5fMC2Wc6+jz=Zc-a5MAOBaV4Pt-YzN6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 03 May 2017 12:43:36 -0600 as excerpted:

> If I understand the bug report correctly, the user specifies mounting by
> label which then systemd is converting into /dev/dm-0 (because it's a
> two LUKS devices Btrfs volume).
> 
> Why not convert the fstab mount by label request, into a /dev/by-uuid/
> path; and then systemd calls mount with -u,--uuid mount option rather
> than the block device? I'd think this is better no matter what the file
> system is, but certainly with Btrfs and possibly ZFS. That makes the
> device discovery problem not systemd's problem to hassle with.

You're forgetting one thing:  mount doesn't handle either label or uuid 
(or similar partlabel/partuid/etc) mounting on its own -- it interprets 
all of these as the appropriate /dev/disk/by-* symlink references, 
dereferences those to the canonical device name, and actually mounts 
using that.

See the mount (8) manpage, relatively near the top under "Indicating the 
device", the relevant quote being "The mount (8) command internally uses 
udev symlinks, so the use of symlinks in /etc/fstab has no advantage over 
[LABEL=, UUID=, etc] tags."

And of course it's systemd's udev component that sets up those /dev/disk/
by-* symlinks in the first place.

So converting mount-by-label requests to mount-by-uuid requests gets you 
exactly nowhere, as underneath the covers they're both using the the same 
level udev-generated /dev/disk/by-* symlinks to get the canonical device 
name, so not only do you fail to get rid of the systemd/udev involvement, 
you fail to even reduce abstraction to a lower level.

Not to mention that newer systemd is apparently using its own mount-
alternative now, and doesn't actually call the traditional mount binary 
any more, at least for supported filesystem types.  I'm not qualified to 
argue the case for or against that, but it's apparently happening now, 
and regardless of where one stands on the merits, it's certainly 
inserting systemd even farther into the mount process for relatively 
complex and fuller-featured filesystems such as btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

