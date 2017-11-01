Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44053 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932679AbdKAMP1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 08:15:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e9rvO-0003SC-3J
        for linux-btrfs@vger.kernel.org; Wed, 01 Nov 2017 13:15:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Several questions regarding btrfs
Date: Wed, 1 Nov 2017 12:15:02 +0000 (UTC)
Message-ID: <pan$8b220$9c430bf3$f61d549b$3a5859fa@cox.net>
References: <1509467017.1662.37.camel@gmail.com>
        <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
        <1509480384.1662.84.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ST posted on Tue, 31 Oct 2017 22:06:24 +0200 as excerpted:

> Also another questions in this regard - I tried to "set-default" and
> then reboot and it worked nice - I landed indeed in the snapshot, not
> top-level volume. However /etc/fstab didn't change and actually showed
> that top-level volume should have been mounted instead. It seems that
> "set-default" has higher precedence than fstab...
> 1. is it true?
> 2. how do they actually interact?
> 3. such a discrepancy disturbs me, so how should I tune fstab to reflect
> the change? Or maybe I should not?

For most distros, for root, the /etc/fstab entry is a dummy of sorts.  
The kernel must have the information for root before it can read
/etc/fstab, and it's usually either fed to the kernel on the kernel 
commandline (via root=, rootfstype= and rootflags=) or configured in the 
initr*, tho those may be indirectly sourced from /etc/fstab via scripts 
that set them up, and there's a kernel default that applies without a 
configured commandline, that distros may setup for their own defaults.

The /etc/fstab entry may be used when remounting root writable, as it's 
normally mounted read-only first and only remounted writable later, but 
some distros may either do that without reading the fstab entry as well, 
or be configured to leave root mounted read-only (as I've configured my 
system here, on gentoo).


So presumably whatever's actually being used by your kernel to find the 
root to mount, the commandline, the initr*, or the configured kernel 
defaults, doesn't have a specific subvolume option and (for btrfs), is 
simply depending on the btrfs default subvolume being pointed at the 
right subvolume.  As such, configuring btrfs to point at a different 
subvolume "just works", since it's just using the filesystem default 
subvolume in the first place.

Which should work fine as long as whatever configured default subvolume 
ends up having a valid root configuration.  I'd thus be most worried 
about testing that you can point it at whatever you are using as a backup 
and/or emergency boot and maintenance image, and successfully boot from 
that, should the default subvolume get screwed up and become unbootable 
for whatever reason.  Of course that'll require being able to either know 
where the kernel is getting its root information in ordered to change it, 
or at minimum, being able to successfully override it with a higher 
priority config, when necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

