Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47826 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622Ab3BZPwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 10:52:54 -0500
Date: Tue, 26 Feb 2013 07:52:53 -0800
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, jbacik@fusionio.com
Subject: Re: WARNING: at fs/btrfs/inode.c:2165 btrfs_orphan_commit_root+0xcb/0xdf()
Message-ID: <20130226155253.GA22367@merlins.org>
References: <20130225025546.GC14143@merlins.org> <20130226070200.GA3949@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226070200.GA3949@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 03:02:01PM +0800, Liu Bo wrote:
> On Sun, Feb 24, 2013 at 06:55:46PM -0800, Marc MERLIN wrote:
> > Is this useful to anyone?
> > 
> 
> Hi Marc,
> 
> Thanks for the report, of course they're useful.
 
Thanks. I wasn't sure since I haven't seen the real problem of crashes
during mount due to unexpected state in replay logs being improved over the
last 4 kernel versions, and I wasn't sure if they are being worked on.

> Could you please also show us your workloads and it'd be better to know how to
> reproduce this?

Sure thing.

Workload is a simple laptop, where something tyipcally dies during writes
and I get a full system hang because linux is unable to flush its disk
queues, so in the end I power cycle.
Details here:
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg391505.html

As mentioned in my other mail, I do run on top of dmcrypt since I can't have
an unencrypted laptop, and ecryptfs is way too slow while not supporting
encryption of long filenames.

The next question is: are your write requests getting there in the order
they should. My crashes and your BUG() that get triggered indicate that
maybe not.

Currently, I have:
gandalfthegreat:~# cat /sys/block/sda/queue/scheduler 
noop [deadline] cfq 

That could be a problem I guess, so I'll change it to noop, just in case.

My boot is like this:
/vmlinuz-3.7.8-amd64-preempt-20130222 root=/dev/mapper/cryptroot ro rootflags=subvol=root cryptopts=source=/dev/sda4,keyscript=/sbin/cryptgetpw,discard

btrfs is mounted like so:
LABEL=btrfs_pool1 /   btrfs subvol=root,defaults,compress=lzo,discard,nossd,space_cache,noatime

Is there anything else I can give?
(I'll answer on the other thread with the fsimage)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
