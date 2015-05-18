Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55901 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbbERGlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 02:41:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YuEjj-0008BH-VT
	for linux-btrfs@vger.kernel.org; Mon, 18 May 2015 08:41:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 08:41:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 08:41:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs and integration with GNU ++
Date: Mon, 18 May 2015 06:41:09 +0000 (UTC)
Message-ID: <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roy Sigurd Karlsbakk posted on Sun, 17 May 2015 21:33:27 +0200 as
excerpted:

> Hi all
> 
> First of all, thanks for the good work. I first started looking into
> btrfs some six years back, and things are a lot better now. I just
> wonder about a few things…
> 
> For btrfs to be accepted as a primary filesystem in major distros, I'd
> think it should integrate with existing tools.

Well, fortunately or unfortunately, btrfs is already being accepted as a 
primary fs in major distros.

That despite the fact that it isn't entirely mature yet, and the 
sysadmin's law about backups (if you don't have a backup, by definition 
you value your time and hassle saved in not making it over your data, 
despite any claims to the contrary; if it isn't current, you value the 
time and hassle of keeping current backups more than the loss of the data 
between the time of the backup and now, and a would-be backup isn't a 
backup until it is tested workable/restorable from the tools you'd have 
if the filesystem(s) it's backing up failed) applies double to btrfs 
because it is /not/ fully mature yet.  Yet major distros are making it 
the default without warning people about this, and for people such as 
ordinary desktop users that may not be aware of such cardinal sysadmin's 
rules.

> Currently, df seems to show good data, while du doesn't.

There has been some work put into what df returns to make it so, while 
similar work to du has not yet been released, and in fact only quite 
recently (within the last month) has been proposed on the list.

Maturity of the filesystem, again...

> I've been working with ZFS for some
> time, and there du will show data on disk and du --apparent-size will
> show how much apparently is on disk according to file sizes. I beleive
> this only acconuts for compression (not dedup, which I don't use), but
> still it's neat. Also, lsblk works well with md, showing which md device
> each device belongs to, while in btrfs land, it only shows the device
> from /proc/mounts that appear to be mounted. Again, mount should IMHO
> show btrfs information and not just the some device in the btrfs
> filesystem.
> 
> Lastly - I just did a small test on a 6 drive RAID-6, turned on
> compression and started cat /proc/zero > testfile - let this run until
> the filesize was 500GB and stopped it. Made some other test files and a
> copy of these with --reflink=auto just for kicks. rm test* and waited.
> While waiting, did a 'echo b > /proc/sysrq-trigger' and fsck started on
> bootup and took a minute or so to complete. Since the filesystem is
> rather small (6x8GB VDEVs on top of ZFS with SSD caching, kvm as
> hypervisor), I wonder how long this fsck job would take if it were on a
> system with, say, 6 4TB drives. RHEL/CentOS7 just moved to XFS to allow
> for system crashes without this hour-long fsck job, and I somewhat doubt
> that btrfs will be the chosen one if it requires the same amount of time
> as of ext4.

As Qu mentions, on-mount fsck is not needed on btrfs, as assuming no bugs 
(filesystem maturity, again), due to btrfs' COW nature, commits are 
atomic and the filesystem is self-consistent at every commit.  Commits 
occur every 30 seconds by default (it's a mount option), and there's only 
a very limited journal of fsynced transactions kept since the last 
commit, to be sure they are recoverable even when the filesystem crashes 
between commits, that automatically replays on mount.  So no on-mount fsck 
needed.

In fact, btrfs-tools has shipped with a "null" fsck.btrfs for some time 
now.  It's shell code and thus can be easily examined.  All it does for 
the usual fsck -a is return without error, and if you're not running a 
current version, print a complaint that it doesn't need run at all.  Some 
distro btrfs-tools packages don't even ship it at all.

Even if you have the full btrfs check run at startup, it's normally read-
only and won't fix a thing, unless it's given the --repair option or some 
even stronger fixup option.


So if on-boot fsck took a minute to run on a btrfs, it wasn't because 
anything close to current fsck.btrfs takes that long to run on its own, 
it was either something the distro is doing on its own that's completely 
contrary to recommendations, or it was other things happening in 
parallel, delaying what is after all a simple shell script that does 
nothing but return without error and that should run effectively 
instantly, in human terms anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

