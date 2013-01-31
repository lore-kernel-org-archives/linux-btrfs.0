Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3AaCmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 21:42:10 -0500
Message-ID: <5109DA29.9060601@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 10:42:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting shared
 block reference
References: <50232A19.2010704@cn.fujitsu.com> <20120809180405.GC32103@shiny> <5024E4B7.20600@cn.fujitsu.com> <20120810115628.GE32103@shiny> <CAOcd+r0+K_hpCPYwdJzT_yyPg_1d+6YKiAU4+zvGKM3UjR1hAg@mail.gmail.com>
In-Reply-To: <CAOcd+r0+K_hpCPYwdJzT_yyPg_1d+6YKiAU4+zvGKM3UjR1hAg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Jan 2013 20:23:22 +0200, Alex Lyakas wrote:
> Hi Miao,
> I was following this thread in the past, but I did not understand it
> fully, maybe you can explain?
> 
>>>>>  # mkfs.btrfs <partition>
>>>>>  # mount <partition> <mnt>
>>>>>  # cd <mnt>
>>>>>  # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
>>>>>  # for ((i=0; i<4; i++))
>>>>>  > do
>>>>>  > mkdir $i
>>>>>  > for ((j=0; j<200; j++))
>>>>>  > do
>>>>>  > btrfs sub snap . $i/$j
>>>>>  > done &
>>>>>  > done
>>>>
>>>> snapshot creation has a critical section.  Once we copy a given root to
>>>> its snapshot, we're not allowed to change it until the transaction
>>>> is fully committed.
> 
> Is the limitation that if we are creating a snap B of root A, and
> placing the root of B somewhere into the tree of A, then we can do
> this only once per transaction? Does this limitation still exist or
> your fix fixes it?

The limitation is the snapshoted subvolume can not be changed until the transaction
is committed. That is we can not insert anything(including the root of B and the
directory item/index of B) into the tree of A after snap B is created.

This limitation was fixed.

> Also, according to your reproducer, each "btrfs sub snap" will
> start/join a transaction, but then it will call
> btrfs_commit_transaction() and not btrfs_commit_transaction_async(),
> so it will wait until the transaction commits. So how it may happen
> that you create more than one snap in the same transaction with your
> reproducer?

run several tasks, and each task create snapshots repeatedly in its own
directory.
(If we create snapshots in the same directory, the i_mutex of the directory
 will make the process serialized)

> The reason I am asking, is that I want to try to write code that
> creates several snaps in one transaction and only then commits. Should
> this be possible or there is some limitation, like I mentioned above?

As far as I know, it is possible, there is no limitation now.

Thanks
Miao
