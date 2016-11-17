Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.230]:38292 "EHLO
        dnvrco-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750714AbcKQWIX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 17:08:23 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.aresgate.net (smtpd) with ESMTP id 91EF493CAD8
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 14:01:16 -0800 (PST)
Received: from smtp.aresgate.net ([127.0.0.1])
        by localhost (smtp.aresgate.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id LAlOj-Z_PsKZ for <linux-btrfs@vger.kernel.org>;
        Thu, 17 Nov 2016 14:01:15 -0800 (PST)
Received: from gypsyops.denof.sin (cpe-76-172-86-115.socal.res.rr.com [76.172.86.115])
        by smtp.aresgate.net (smtpd) with ESMTPSA id 6C53E93CAD0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 14:01:15 -0800 (PST)
Date: Thu, 17 Nov 2016 14:01:11 -0800
From: Vladi Gergov <vladi@aresgate.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs raid1 degraded needs chunk root rebuild
Message-ID: <20161117220111.GA13765@gypsyops.denof.sin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any ideas if currently I can still recover data from this volume? I have
tried the new btrfs tools with btrfs rescue chunk-recover without much
success. Any ideas if i can recover any of the data?

----- Forwarded message from Chris Mason <chris.mason@oracle.com> -----

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs raid1 degraded does not mount or fsck
To: Vladi Gergov <vgergov@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Nov 2010 16:50:58 -0500
User-Agent: Sup/git

Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:
> >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> Password:
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> [  684.595150] btrfs: allowing degraded mounts
> [  684.595594] btrfs: failed to read chunk root on sdb
> [  684.604110] btrfs: open_ctree failed
>
> >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.

Ok, I dug through this and found the bug responsible for your
unmountable FS.  When we're mounted in degraded mode, and we don't have
enough drives available to do raid1,10, we're can use the wrong raid
level for new allocations.

I'm fixing the kernel side so this doesn't happen anymore, but I'll need
to rebuild the chunk tree (and probably a few others) off your good disk to
fix things.

I've got it reproduced here though, so I'll make an fsck that can scan
for the correct trees and fix it for you.

Since you're basically going to be my first external fsck customer, is
there anyway you can do a raw device based backup of the blocks?  This
way if I do mess things up we can repeat the experiment.

-chris

!DSPAM:4ce2fd55191821234852255!



----- End forwarded message -----

-- 

,-| Vladi
`-| Gergov
