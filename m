From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Thu, 17 Feb 2011 20:09:00 -0500
Message-ID: <1297991261-sup-6831@think>
References: <4D5CB6B8.2060804@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D5CB6B8.2060804@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-02-17 00:48:40 -0500:
> Compare with Ext3/4, the performance of file creation and deletion on btrfs
> is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
> such as inode item, directory name item, directory name index and so on.
> 
> If we can do some delayed b+ tree insertion or deletion, we can improve the
> performance, so we made this patch which implemented delayed directory name
> index insertion/deletion and delayed inode update.

This work is really cool, thanks for doing it.  I'm starting a run on
this tonight and if all goes well I'll review in detail and try to queue
it along with the per-subvolume storage bits for .39.

Thanks!

-chris
