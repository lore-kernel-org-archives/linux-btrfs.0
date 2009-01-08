From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 12:08:35 -0500
Message-ID: <1231434515.14304.27.camel@think.oraclecorp.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 08:58 -0800, Linus Torvalds wrote:
> 
> Ok, I've gone through -v7, and I'm sure you're all shocked to hear it, but 
> I have no complaints. Except that you dropped all the good commit 
> commentary you had earlier ;)
> 

Seems to get stuck under load.  I've hit it with make -j 50 on ext3 and
with my btrfs benchmarking.  This was against the latest git from about
5 minutes ago.

-chris

BUG: soft lockup - CPU#3 stuck for 61s! [python:3970]
CPU 3:
Modules linked in: netconsole configfs btrfs zlib_deflate loop e1000e 3w_9xxx
Pid: 3970, comm: python Not tainted 2.6.28 #1
RIP: 0010:[<ffffffff8024f4de>]  [<ffffffff8024f4de>] __cmpxchg+0x36/0x3f
RSP: 0018:ffff880148073be8  EFLAGS: 00000217
RAX: 00000000fffffff8 RBX: ffff880148073be8 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8801498efdf0
RBP: ffffffff8020ce0e R08: 00000000007563b7 R09: 0000000000000000
R10: ffff880148073c88 R11: 0000000000000001 R12: ffff880148073c88
R13: 0000000000000001 R14: ffff880148073be8 R15: ffffffff8020ce0e
FS:  00007f5fb455a6e0(0000) GS:ffff88014dd368c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f5fb38181a0 CR3: 00000001483a0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff8024f4b1>] ? __cmpxchg+0x9/0x3f
 [<ffffffff805e0068>] ? __mutex_lock_common+0x3d/0x178
 [<ffffffff805e106c>] ? _spin_lock+0x9/0x1f
 [<ffffffff802af31b>] ? __d_lookup+0x98/0xdb
 [<ffffffff805e01f2>] ? __mutex_lock_slowpath+0x19/0x1b
 [<ffffffff805e025b>] ? mutex_lock+0x23/0x3a
 [<ffffffff802a7f99>] ? do_lookup+0x85/0x162
 [<ffffffff802a993d>] ? __link_path_walk+0x4db/0x620
 [<ffffffff802a9ad5>] ? path_walk+0x53/0x9a
 [<ffffffff802a9c68>] ? do_path_lookup+0x107/0x126
 [<ffffffff802a8f74>] ? getname+0x16b/0x1ad
 [<ffffffff802aa693>] ? user_path_at+0x57/0x98
 [<ffffffff802aa6a5>] ? user_path_at+0x69/0x98
 [<ffffffff802a3773>] ? vfs_stat_fd+0x26/0x53
 [<ffffffff802b46b2>] ? mntput_no_expire+0x2f/0x125
 [<ffffffff802a3963>] ? sys_newstat+0x27/0x41
 [<ffffffff802a7cae>] ? mntput+0x1d/0x1f
 [<ffffffff802a7d3e>] ? path_put+0x22/0x26
 [<ffffffff802a36b7>] ? sys_readlinkat+0x7b/0x89
 [<ffffffff8020c4eb>] ? system_call_fastpath+0x16/0x1b


