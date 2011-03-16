From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Wed, 16 Mar 2011 13:49:36 -0400
Message-ID: <1300297740-sup-2597@think>
References: <20110310000355.f225f0d0.kitayama@cl.bb4u.ne.jp> <4D786DF2.7000104@cn.fujitsu.com> <20110316184850.f25551a6.kitayama@cl.bb4u.ne.jp> <4D80C81F.60507@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D80C81F.60507@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-03-16 10:24:31 -0400:
> On Wed, 16 Mar 2011 18:48:50 +0900, Itaru Kitayama wrote:
> > Hi Miao,
> > 
> > The V4 still hangs. Does the new function, btrfs_update_inode_nodelayed() you introduced to the V4
> > need take care of a delayed node (commit delayed items of the inode and set the delayed note to NULL)?
> 
> I think there no delayed item because we commit all the delayed items when we start committing
> transaction.
> 
> > 
> > Below is my experimental patch on top of V4 trying to avoid taking trans_mutex in btrfs_remove_delayed_node(), 
> > but still hangs. Could you take a look at it? Thanks.
> 
> It is so strange I can not reproduce it on my machine. But by reviewing the code, I think some inodes
> may be updated when committing the transaction, it makes the filesystem hang.

Maybe this is related to the free space cache?  Is one of you using
mount -o space_cache?

-chris
