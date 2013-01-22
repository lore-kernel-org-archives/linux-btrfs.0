Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3AVO0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 09:26:17 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id D8D0BA4E0C
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 15:26:15 +0100 (CET)
Date: Tue, 22 Jan 2013 15:26:15 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 -rc4
Message-ID: <20130122142615.GD28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130104125059.GE20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130104125059.GE20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 04, 2013 at 01:50:59PM +0100, David Sterba wrote:
> I've noticed a few csum mismatch messages, and a few failed xfstests:

They're still there, we're on rc4, so I started looking for potential
patches to revert, but tonight the test reproduced csums with these
patches removed:

 Btrfs: do not call file_update_time in aio_write
 Btrfs: only unlock and relock if we have to
 Btrfs: use tokens where we can in the tree log
 Btrfs: only clear dirty on the buffer if it is marked as dirty
 Btrfs: log changed inodes based on the extent map tree
 Btrfs: do not mark ems as prealloc if we are writing to them
 Btrfs: keep track of the extents original block length
 Btrfs: inline csums if we're fsyncing
 Btrfs: don't bother copying if we're only logging the inode
 Btrfs: only log the inode item if we can get away with it

whole branch (test-next-csum in my git repo), was created by rebasing
btrfs-next/for-chris on top of linus/master commit
9a9284153d965a57edc7162a8e57c14c97f3a935.

The patches were selected semi-randomly and some of them are just
dependencies that made merging easier.

> 113:
> - it hung last evening and is still in that state, no disk or cpu activity,
>   there were only the tests running
> - no process is in D state, no btrfs kernel thread is active
> - the only interesting process is
> 
>   PID TTY      STAT   TIME COMMAND
> 15585 pts/0    Sl+    0:01 /root/xfstests/ltp/aio-stress -t 20 -s 10  -O -S -I	\
> 	1000 /mnt/a1/aiostress.15188.4 /mnt/a1/aiostress.15188.4.20		\
> 	/mnt/a1/aiostress.15188.4.19 /mnt/a1/aiostress.15188.4.18		\
> [<ffffffff810af447>] futex_wait_queue_me+0xc7/0x100
> [<ffffffff810affa1>] futex_wait+0x191/0x280
> [<ffffffff810b1cb6>] do_futex+0xd6/0xbd0
> [<ffffffff810b282b>] sys_futex+0x7b/0x180
> [<ffffffff8195fe99>] system_call_fastpath+0x16/0x1b

also reproduced, this happens like every 3rd run of the whole test.


david
