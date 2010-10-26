From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/6] Btrfs: fix deadlock in btrfs_commit_transaction
Date: Tue, 26 Oct 2010 13:06:15 -0400
Message-ID: <20101026170615.GE13254@think>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
 <4CC67930.4030406@cn.fujitsu.com>
 <Pine.LNX.4.64.1010260931310.7660@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1010260931310.7660@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 26, 2010 at 09:36:26AM -0700, Sage Weil wrote:
> On Tue, 26 Oct 2010, liubo wrote:
> > 
> > Since wake_up() itself provides a implied wmb, and a wq active check, 
> > it is better to drop "if (wq)" in __btrfs_end_transaction().
> 
> I see.  It could also be
> 
>         smb_mb();
>         if (wq)
>                 wake_up();
> 
> but just calling wake_up() unconditionally is simpler, and fewer barriers 
> in the wake_up case.  I'm not attached to the if (wq); I just kept it 
> because it was there already.

wake_up() provides an implied barrier because it takes the lock.  I
usually do the smp_mb() + if (wq) dance when I'm working on a relatively
hot waitqueue.

-chris


