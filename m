Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eagle.jhcloos.com ([207.210.242.212]:52297 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KOXor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 18:44:47 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Likely mem leak in 3.7
Date: Thu, 15 Nov 2012 18:26:37 -0500
Message-ID: <m3r4nuwipl.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Starting with 3.7 rc1, my workstation seems to loose ram.

Up until (and including) 3.6, used-(buffers+cached) was roughly the same
as sum(rss) (taking shared into account).  Now there is an approx 6G gap.

When the box first starts, it is clearly less swappy than with <= 3.6; I
can't tell whether that is related.  The reduced swappiness persists.

It seems to get worse when I update packages (it runs Gentoo).  The
portage tree and overlays are on btrfs filesystems.  As is /var/log
(with compression, except for the distfiles fs).  The compilations
themselves are done in a tmpfs.  I CCed l-b because of that apparent
correlation.

My postgress db is on xfs (tested faster) and has a 3G shared segment,
but that recovers when the pg process is stopped; neither of those seem
to be implicated.

There are also several ext4 partitions, including / and /home.

Cgroups are configured, and openrc does put everything it starts into
its own directory under /sys/fs/cgroup/openrc.  But top(1) shows all
of the processes, and its idea of free mem does change with pg's use
of its shared segment.  So it doesn't *look* like the ram is hiding
in some cgroup.

The kernel does not log anything relevant to this.

Slabinfo gives some odd output.  It seems to think there are negative
quantities of some slabs:

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
:at-0000016               5632      16    90.1K 18446744073709551363/0/275  256 0   0 100 *a
:t-0000048                3386      48   249.8K 18446744073709551558/22/119   85 0  36  65 *
:t-0000120                1022     120   167.9K 18446744073709551604/14/53   34 0  34  73 *
blkdev_requests            182     376   122.8K 18446744073709551604/7/27   21 1  46  55 
ext4_io_end                348    1128   393.2K 18446744073709551588/0/40   29 3   0  99 a

The largest entries it reports are:

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
ext4_inode_cache         38448     864   106.1M    3201/566/39   37 3  17  31 a
:at-0000104             316429     104    36.5M   8840/3257/92   39 0  36  89 *a
btrfs_inode              13271     984    35.7M      1078/0/14   33 3   0  36 a
radix_tree_node          43785     560    34.7M   2075/1800/45   28 2  84  70 a
dentry                   64281     192    14.3M   3439/1185/55   21 0  33  86 a
proc_inode_cache         15695     608    12.1M     693/166/51   26 2  22  78 a
inode_cache              10730     544     6.0M       349/0/21   29 2   0  96 a
task_struct                628    5896     4.3M      123/23/10    5 3  17  84 

The total Space is much smaller than the missing ram.

The only other difference I see is that one process has left behind
several score zombies.  It is structured as a parent with several
worker kids, but the kids stay zombie even when the parent process
is stopped and restarted.  wchan shows that they are stuck in exit.
Their normal rss isn't enough to account for the missing ram, even
if it isn't reclaimed.  (Not to mention, ram != brains. :)

I haven't tried bisecting because of the time it takes to confirm the
problem (several hours of uptime).  I've only compiled (each of) the
rc tags, so v3.6 is that last known good and v3.7-rc1 is the first
known bad.

If there is anything that I missed, please let me know!

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
