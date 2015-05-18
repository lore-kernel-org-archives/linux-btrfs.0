Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [77.88.71.232] ([77.88.71.232]:50644 "EHLO zimbra.karlsbakk.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbbERJW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:22:26 -0400
Date: Mon, 18 May 2015 11:22:08 +0200 (CEST)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net> <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
Subject: Re: Btrfs and integration with GNU ++
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> For btrfs to be accepted as a primary filesystem in major distros, I'd
>> think it should integrate with existing tools.
> 
> Well, fortunately or unfortunately, btrfs is already being accepted as a
> primary fs in major distros.

Interesting - which ones is it that's doing this?

>> Currently, df seems to show good data, while du doesn't.
> 
> There has been some work put into what df returns to make it so, while
> similar work to du has not yet been released, and in fact only quite
> recently (within the last month) has been proposed on the list.
> 
> Maturity of the filesystem, again...

hehe

>> Lastly - I just did a small test on a 6 drive RAID-6, turned on
>> compression and started cat /proc/zero > testfile - let this run until
>> the filesize was 500GB and stopped it. Made some other test files and a
>> copy of these with --reflink=auto just for kicks. rm test* and waited.
>> While waiting, did a 'echo b > /proc/sysrq-trigger' and fsck started on
>> bootup and took a minute or so to complete. Since the filesystem is
>> rather small (6x8GB VDEVs on top of ZFS with SSD caching, kvm as
>> hypervisor), I wonder how long this fsck job would take if it were on a
>> system with, say, 6 4TB drives. RHEL/CentOS7 just moved to XFS to allow
>> for system crashes without this hour-long fsck job, and I somewhat doubt
>> that btrfs will be the chosen one if it requires the same amount of time
>> as of ext4.
> 
> As Qu mentions, on-mount fsck is not needed on btrfs, as assuming no bugs
> (filesystem maturity, again), due to btrfs' COW nature, commits are
> atomic and the filesystem is self-consistent at every commit.  Commits
> occur every 30 seconds by default (it's a mount option), and there's only
> a very limited journal of fsynced transactions kept since the last
> commit, to be sure they are recoverable even when the filesystem crashes
> between commits, that automatically replays on mount.  So no on-mount fsck
> needed.

I didn't run it. Some part of the Jessie startup did, and 1 minute for just 6x8GB (not TB) seems a lot…

roy
