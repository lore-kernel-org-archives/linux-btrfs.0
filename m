Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39033 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdESCXk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 22:23:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dBXZk-00042R-Ce
        for linux-btrfs@vger.kernel.org; Fri, 19 May 2017 04:23:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't remount a BTRFS partition read write after a drive failure
Date: Fri, 19 May 2017 02:23:26 +0000 (UTC)
Message-ID: <pan$ca9bb$47dac8b6$6d24a133$f405d287@cox.net>
References: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
        <CAMG9ccz555xia-FpqGsoy-uzYXcyYwG6H0EC18O2AC9yLUuBpg@mail.gmail.com>
        <d76bbe8f-af4a-36a0-2eb0-45384a8fee79@chicoree.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sylvain Leroux posted on Thu, 18 May 2017 09:22:55 +0200 as excerpted:

> Thank you Chris, Ivan, for your answers.

> Here we are in a very special use case. But I think we would see a
> similar behavior if some drive case or cable was dying, the
> administrator replaced it, but was unable to remount rw the drive after
> having fixed the problem. Or did I missed something?

What you seem to have missed is my earlier reply, saying, effectively...

Known issue.  Btrfs currently doesn't really have a concept of devices 
coming and going while it's mounted.  If a device disappears, btrfs will 
continue to try to write to it until there are enough errors to kick it 
into read-only mode.  Even then, it continues to be part of the 
filesystem.

So when the kernel kicks the device and it reappears as another device, 
btrfs is still tracking the first, now non-existent device, for that 
filesystem (which is tracked by UUID, so it will be considered the same 
filesystem even when appearing as a different device, because the UUID is 
the same), and will attempt to add the second device to it (which is 
logical because unlike most filesystems, btrfs can actually /be/ multi-
device).

But the filesystem properties still say only one device, so btrfs knows 
there's /something/ wrong and won't mount the filesystem at its new 
device location except read-only, to prevent further damage due to the 
confusion.

There's patches in the pipeline to give btrfs this dynamic appearing and 
disappearing devices sense that it currently lacks, but they're in a 
patch-set (the btrfs global hot-spare feature patch set, which obviously 
requires btrfs knowing when a device is gone and needs replaced by the 
hot-spare) that has been held up waiting for a different patch set, that 
itself hasn't been integrated yet.

So try again in a few kernel cycles...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

