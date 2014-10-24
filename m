Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbaJXRAp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 13:00:45 -0400
Date: Fri, 24 Oct 2014 13:00:29 -0400
From: Dave Jones <davej@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs: WARN_ON(data_sinfo->bytes_may_use < bytes);
Message-ID: <20141024170029.GA15926@redhat.com>
References: <20141023010731.GA27796@redhat.com>
 <20141023012236.GA28429@redhat.com>
 <20141024155245.GA14709@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141024155245.GA14709@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 24, 2014 at 11:52:47PM +0800, Liu Bo wrote:
 
 > > I also see this WARN_ON being hit from the sync path..
 > > 
 > > WARNING: CPU: 2 PID: 11166 at fs/btrfs/extent-tree.c:3799 btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]()
 > > CPU: 2 PID: 11166 Comm: trinity-c61 Tainted: G        W      3.18.0-rc1+ #74
 > >  0000000000000009 00000000aee2e4e2 ffff8801b0dfbcc8 ffffffff8d86cc97
 > >  0000000000000000 0000000000000000 ffff8801b0dfbd08 ffffffff8d07f301
 > >  ffff88023f328000 ffff88023953d668 0000000000040000 ffff880239358548
 > > Call Trace:
 > >  [<ffffffff8d86cc97>] dump_stack+0x4f/0x7c
 > >  [<ffffffff8d07f301>] warn_slowpath_common+0x81/0xa0
 > >  [<ffffffff8d07f41a>] warn_slowpath_null+0x1a/0x20
 > >  [<ffffffffc0253831>] btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]
 > >  [<ffffffffc025ca63>] btrfs_write_dirty_block_groups+0x6f3/0x740 [btrfs]
 > >  [<ffffffffc02f7a41>] commit_cowonly_roots+0x17a/0x234 [btrfs]
 > >  [<ffffffffc026e60b>] btrfs_commit_transaction+0x45b/0xc10 [btrfs]
 > >  [<ffffffffc023a09b>] btrfs_sync_fs+0x8b/0x270 [btrfs]
 > >  [<ffffffff8d266ad0>] ? do_fsync+0x80/0x80
 > >  [<ffffffff8d266af0>] sync_fs_one_sb+0x20/0x30
 > >  [<ffffffff8d22f2f2>] iterate_supers+0xb2/0x110
 > >  [<ffffffff8d266c24>] sys_sync+0x64/0xb0
 > >  [<ffffffff8d877d49>] tracesys_phase2+0xd4/0xd9
 > > 
 > > After rebooting, and restarting the fuzzer, it happened again very quickly.
 > 
 > Could you please show us the trinity options you're using?
 > 
 > I also see this WARNing from other reports, but still try to reproduce..

That one was nothing special, just -q -l off.
I've not been able to reproduce it in the last two days though.

	Dave

