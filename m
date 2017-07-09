Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41201 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdGILjH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 07:39:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dUAYF-0004La-3B
        for linux-btrfs@vger.kernel.org; Sun, 09 Jul 2017 13:38:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can I drop/reset files with corrupted data if they are in a read
 only snapshot?
Date: Sun, 9 Jul 2017 11:38:51 +0000 (UTC)
Message-ID: <pan$de201$b4e6d9dd$ac883479$6ac66e5b@cox.net>
References: <20170709053228.donh2nh75idlzfck@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 08 Jul 2017 22:32:28 -0700 as excerpted:

> Second, ok, after a 24H scrub (yes, it's long and slow), I know which
> filenames have issues. Problem is that they are inside a read only btrfs
> snapshot. I cannot delete this snapshot because if I do so, I will
> destroy a btrfs send/receive relationship that will take 2 + 1 day to
> recreate (2 filesystems both have 2 files to delete each).
> How can I force delete the file anyway, or reset the checksum and accept
> that the file is corrupted, but not care?
> (I've deleted it and the next btrfs send/receive will free the blocks
> anyway)

At your own risk you can try using btrfs property to set the ro snapshot 
to rw.  Then you can delete the corrupted files and reset the snapshot 
back to ro.

Of course you'll need to do the same thing on both the send and receive 
side in ordered to keep the two reference snapshots in sync.

However, because my use-case doesn't involve send/receive, I've not been 
able to personally verify that the above procedure doesn't screw up an 
incremental send/receive job using that modified snapshot as a 
reference.  There has been one report on the list of someone who did the 
property toggle thing at my cautious suggestion and he said it didn't 
screw up the send/receive reference for him, but one case of working is 
not enough for me to be comfortable saying it's known to work just fine, 
thus the at your own risk caveat.

(Trying a send both to you and to list this time...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

