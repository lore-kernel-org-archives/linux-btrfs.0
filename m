Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41506 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3CKGtm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 02:49:42 -0400
Date: Mon, 11 Mar 2013 14:47:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Roman Mamedov <rm@romanrm.ru>
Cc: Michael Johnson - MJ <mj@revmj.com>, linux-btrfs@vger.kernel.org
Subject: Re: snapshot deletion / unmount slowness
Message-ID: <20130311064749.GA28468@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
 <20130311121143.5cfa69d8@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130311121143.5cfa69d8@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 12:11:43PM +0600, Roman Mamedov wrote:
> On Sun, 10 Mar 2013 22:31:08 -0700
> Michael Johnson - MJ <mj@revmj.com> wrote:
> 
> > What I now suspect is going on is that while deleting the snapshots
> > was quick, that probably kicks of a background thread which actually
> > does the heavy lifting.
> 
> Exactly that, the snapshot deletion only "syncs" on unmount, there is no
> other way to ensure it is complete.
> 
> If you have some patience and let it unmount properly and then remount it, you
> may find that you have gained much more free space, due to all the snapshots
> being actually deleted and the space they were occupying freed only just now.

A recent commit(commit fa6ac8765c48a06dfed914e8c8c3a903f9d313a0
Btrfs: fix cleaner thread not working with inode cache option)
may improve the situation.

You may want to try it.

thanks,
liubo
