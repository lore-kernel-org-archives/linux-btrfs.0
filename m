From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Date: Mon, 25 Jan 2010 10:17:26 -0500
Message-ID: <20100125151726.GA331@think>
References: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
 <20100114193708.GD23810@think>
 <201001232123.58602.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753197Ab0AYPR4@vger.kernel.org>
In-Reply-To: <201001232123.58602.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2010 at 09:23:56PM +0100, Johannes Hirte wrote:
> Am Donnerstag 14 Januar 2010 20:37:08 schrieb Chris Mason:
> > On Thu, Jan 07, 2010 at 10:29:32PM +0100, Johannes Hirte wrote:
> > > One of my btrfs filesystems gives the following bug message on access:
> > > 
> > > Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
> > > Jan  6 23:08:12 datengrab kernel: kernel BUG at
> > > include/linux/spinlock.h:376! Jan  6 23:08:12 datengrab kernel: invalid
> > > opcode: 0000 [#1] SMP
> > > Jan  6 23:08:12 datengrab kernel: last sysfs file:
> > > /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> > > Jan  6 23:08:12 datengrab kernel: CPU 1
> > > Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not
> > > tainted 2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron,
> > > S2875/To Be Filled
> > > By O.E.M.
> > > Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>] 
> > > [<ffffffff8118f7ea>] btrfs_assert_tree_locked+0x16/0x1c
> > 
> > Well, we really should have this tree block locked, but
> > btrfs_mark_extent_written is doing some special things.  Is the trace
> > always the same?
> 
> Sorry for the long delay. Yes the trace was always the same. I can't test 
> patches, since I'm not working on the corrupted FS anymore. The bug only 
> occurred on the corrupted filesystem. But as I've seen, Yan Zheng has tracked 
> it down (commit 6c7d54ac87f338c479d9729e8392eca3f76e11e1). 
> 
> I still suspect that the FS corruption was caused by this bug. It didn't 
> happened again. If so, I'll report.

Right, we should have it fixed now, thanks for the report.

-chris
