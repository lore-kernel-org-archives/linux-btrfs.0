Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22195 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CKPFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 11:05:06 -0400
Date: Mon, 11 Mar 2013 23:03:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org, Roman Mamedov <rm@romanrm.ru>,
        Michael Johnson - MJ <mj@revmj.com>
Subject: Re: snapshot deletion / unmount slowness
Message-ID: <20130311150313.GE28468@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
 <20130311121143.5cfa69d8@natsu>
 <20130311064749.GA28468@liubo.jp.oracle.com>
 <513DAFDF.2040805@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <513DAFDF.2040805@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:20:15AM +0100, Swâmi Petaramesh wrote:
> Le 11/03/2013 07:47, Liu Bo a écrit :
> > A recent commit(commit fa6ac8765c48a06dfed914e8c8c3a903f9d313a0
> > Btrfs: fix cleaner thread not working with inode cache option)
> > may improve the situation.
> 
> Hi Liu,
> 
> I have never seen this issue with btrfs-cleaner not working, when I
> delete snapshots it typically kicks in a few seconds later and works
> "until done".
> 

The 'not working' is a little confused, sorry.

It means that cleaner thread does not do its work in time.  When we delete a
snapshot/subvolume, we a)invalidate all of inodes that belong to it and then
b)add it to a list for cleaner thread to do the real work if the last inode is
destroyed from memory.

What the commit tries to fix is that the inode cache inode will remain in
memory so that keeps the snapshot/subvolume from adding to the cleanup list.
And this'd result in the situation that our space is not freed as we wish.

So back to the thread, if you notice that even cleaner thread does not help you
get free space after you've delete the snapshot/subvolume, there should be some
inodes of snapshot/subvolume remaining in memory.

> Does the bug you mention affect only specific kernel versions ?

After we have inode cache.

> 
> AFAIK I use inode_cache (it's not in my fstab but I mounted my FSes
> using it manually, and I believe it's a "persistent" option ? - I may
> possibly be wrong...)

It's only working when you mount with it, it helps you reuse inode id.

thanks,
liubo
