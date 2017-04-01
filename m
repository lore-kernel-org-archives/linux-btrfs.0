Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33158 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbdDAIWQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 04:22:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuEIL-0003uW-K8
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 10:22:01 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: backing up a file server with many subvolumes
Date: Sat, 1 Apr 2017 10:21:55 +0200
Message-ID: <20170401102155.218e8d3b@jupiter.sol.kaishome.de>
References: <58D72EC4.9020101@gmail.com>
        <f9290eee-b091-b25c-c10a-74ba18b9f6f4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 27 Mar 2017 07:53:17 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > I'd like to try to back up (duplicate) the file server filesystem
> > containing these snapshot subvolumes for each remote machine.  The
> > problem is that I don't think I can use send/receive to do this.
> > "Btrfs send" requires "read-only" snapshots, and snapshots are not
> > recursive as yet.  I think there are too many subvolumes which
> > change too often to make doing this without recursion practical.
> >
> > Any thoughts would be most appreciated.  
> In general, I would tend to agree with everyone else so far if you
> have to keep your current setup.  Use rsync with the --inplace option
> to send data to a staging location, then snapshot that staging
> location to do the actual backup.
> 
> Now, that said, I could probably give some more specific advice if I
> had a bit more info on how you're actually storing the backups.
> There are three general ways you can do this with BTRFS and
> subvolumes: 1. Send/receive of snapshots from the system being backed
> up. 2. Use some other software to transfer the data into a staging
> location on the backup server, then snapshot that.
> 3. Use some other software to transfer the data, and have it handle 
> snapshots instead of using BTRFS, possibly having it create
> subvolumes instead of directories at the top level for each system.

If you decide for (3), I can recommend borgbackup. It allows variable
block size deduplication across all backup sources, tho to fully get
that potential, your backups can only be done serially not in parallel.
Borgbackup cannot access the same repository with two processes in
parallel, and deduplication is only per repository.

Another recommendation for backups is the 3-2-1 rule:

  * have at least 3 different copies of your data (that means, your
    original data, the backup copy, and another backup copy, separated
    in a way they cannot fail for the same reason)
  * use at least 2 different media (that also means: don't backup
    btrfs to btrfs, and/or use 2 different backup techniques)
  * keep at least 1 external copy (maybe rsync to a remote location)

The 3 copy rule can be deployed by using different physical locations,
different device types, different media, and/or different backup
programs. So it's kind of entangled with the 2 and 1 rule.

-- 
Regards,
Kai

Replies to list-only preferred.

