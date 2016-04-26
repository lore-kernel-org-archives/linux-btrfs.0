Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33847 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcDZCG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 22:06:29 -0400
Date: Tue, 26 Apr 2016 03:40:35 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Josef Bacik <jbacik@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160426014035.GA11882@angband.pl>
References: <20160324225411.GA1612@codemonkey.org.uk>
 <20160325082526.GA314@x4>
 <56F93A1B.2060701@fb.com>
 <20160328141446.GB308@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160328141446.GB308@x4>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 04:14:46PM +0200, Markus Trippelsdorf wrote:
> On 2016.03.28 at 10:05 -0400, Josef Bacik wrote:
> > >Mar 24 10:37:27 x4 kernel: WARNING: CPU: 3 PID: 11838 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x22b/0x2a0
> > 
> > I saw this running some xfstests on our internal kernels but haven't been
> > able to reproduce it on my latest enospc work (which is obviously perfect).
> > What were you doing when you tripped this?  I'd like to see if I actually
> > did fix it or if I still need to run it down.  Thanks,
> 
> I cannot really tell. Looking at the backtrace, both Dave and I were
> running rm. 
> This warning happened just once on my machine, so the issue is obviously
> very hard to trigger.

On the other hand, it seems to be triggering really often (on the order of
~10 mins of light use) on my box.  I understandably ran away from 4.6-rc to
stable kernels (no one likes to risk data loss), but even in that little
time it triggered 328 times (over ~20ish boots).

Despite all of these WARNs, there's no data loss yet on the disk in
question, and the filesystem appears consistent.

Call stacks show a variety of callers of btrfs_destroy_inode, originating
from do_unlinkat, SyS_rename, btrfs_ioctl_snap_destroy, shrink_zone, or
task_work_run, direct callers being:

do_unlinkat

__dentry_kill
dput

__dentry_kill
shrink_dentry_list

dispose_list
prune_icache_sb


Just tried 4.6-rc5, it's still there.

Any way I could help debug this?

-- 
A tit a day keeps the vet away.
