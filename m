Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:37529 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3KENmI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 08:42:08 -0500
Received: from [63.245.179.205] (helo=minerva.lan.complete.org)
	by glockenspiel.complete.org with esmtps
	(with TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(TLS peer CN christoph.complete.org, certificate verified)
	(Exim 4.72)
	id 1VdgtT-0002dW-Hy
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 07:42:07 -0600
Received: from localhost ([127.0.0.1])
	by minerva.lan.complete.org with esmtp (Exim 4.80)
	(envelope-from <jgoerzen@complete.org>)
	id 1VdgtP-0008Fg-7F
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 07:42:03 -0600
Message-ID: <5278F5AA.60108@complete.org>
Date: Tue, 05 Nov 2013 07:42:02 -0600
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: umount waiting for 12 hours and still running
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

More than 12 hours ago, I tried to umount a btrfs filesystem. Something
involving btrfs-cleaner and btrfs-transacti is still running, but I
don't know what.

I have noticed excessively long umount times before, and it is a
significant concern for me.

A bit of background:

The filesystem in question involves two 2TB USB hard drives.  It is 49%
full.  Data is RAID0, metadata is RAID1.  The files stored on it are for
BackupPC, meaning there are many, many directories and hardlinks.  I
would estimate 30 million inodes in use and many of them have dozens of
hardlinks to them.  These disks used to be formatted with ext4.  I used
the e2fs dump to back them up, created a fresh btrfs filesystem, and
used restore to load the data onto it.

Now then.  btrfs seemed to be extremely slow creating hard links. Slow
to the tune of taking hours longer than ext4 to do the same task, and
often triggering kernel task hung for more than 120 seconds warnings.  I
thought perhaps converting metadata to raid0 would help.  So I started a
btrfs balance start -mconver=raid0 on it.  According to btrfs fi df, it
churned through the first 900MB out of 26GB of metadata in quick order,
but then the amount of RAID0 metadata bounced up and down between about
950MB and 1019MB -- always just shy of 1GB.  There was an active rsync
job to the disk during this time.  With no apparent progress even after
hours, I tried to cancel the balance.  My cancel command did not return
even after waiting hours.  Finally I rebooted and mounted the FS with
the option to not restart the balance, then it canceled in a few
minutes.  dstat showed all was quiet on the disk.  So I thought I would
unmount it, remount it normally, and start the convert again.

And it is from that unmount that it has been sitting.  According to
dstat, it reads about 360K per second, every so often writing out about
25MB per second.  And it's been doing this for 12 hours.

It seems I have encountered numerous problems here:

   * I/O Starvation on link(2) and perhaps also unlink(2)
   * btrfs convert having a lack of progress after many hours
   * btrfs convert stop not stopping anything
   * umount taking hours

The umount is still pending, so if there is any debugging I can do,
please let me know.

Kernel 3.10 from Debian wheezy backports on i386.

Thanks,

John
