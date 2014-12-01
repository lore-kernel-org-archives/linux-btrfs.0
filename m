Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30643 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbaLAB65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 20:58:57 -0500
Message-ID: <547BCB43.5020505@cn.fujitsu.com>
Date: Mon, 1 Dec 2014 09:58:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BACKGROUND]
I'm trying to implement the function to repair missing inode item.
Under that case, inode type must be salvaged(although it can be fallback to
FILE).

One case should be, if there is any dir_item/index or inode_ref refers the
inode as parent, the type of that inode must be DIR.

However, currently btrfsck implement (inode_record only records backref), we
are unable to search the inode_backref whose parent is given inode number.

[FIRST IMPLEMENT DESIGN]
My first thought is to implement an generic inode-relation structure,
recording parent ino, child ino, name and namelen, and restore the structure
in a rbtree, not in the child/parent's list.

But I soon recognize that this is a perfect use case for relational 
database,
as 'ino' as the primary key for INODE table,
('parent_ino', 'child_ino', 'name') as the primary key for INODE_REF table.

[CRAZY IDEA]
So why not using SQL to implement the btrfsck inode-record things?

With such crazy idea, it will be much much easier to do any iteration from a
given ino, and with the already mature RDB implement, like sqlite3, we can
save hundreds of lines of codes implementing the rb-tree or list.

[PROS]
1. Easy to maintain
    Now we don't need to maintain the rbtree searching or list 
iteration, but
    easy SQL lines and its wrapper.

2. Easy to extend
    If we need to record something more, like extents and its relation to
    inode, we only need to create 2 tables and several SQL and wrappers.

3. Reduced memory usage for HUGE fs.
    When metadata grows to several TB or even more, current rb-tree based
    implement may run short of memory since they are all stored in memory.
    But if use SQL, RDBMS like sqlite3 can restore things in either 
memory or
    disk, which may hugely reduce the memory usage for huge btrfs.

    If not use existing RDBMS, we need to implement complicated memory 
control
    system to manage memory in userland.

[CONS]
1. Heavy implement
    SQL hide the rb-tree or B+ tree implement but costs more memory(if not
    compressed) and CPU cycles, which will be slower than the simple rb-tree
    implement even using lightweight RDBMS like sqlite3.

2. Heavy dependency
    If use it, btrfs-progs will include RDBMS as the make and runtime
    dependency.
    Such low level progs depend on high level programs like sqlite3 may 
be very
    strange.

3. A lot of rework on existing codes.
    Even SQL is easier to maintain and extend, if we use it, we still 
need to
    reimplement several hundreds or even thousands lines of code to 
implement
    it, not to mention the regression tests.

4. Copyright
    Will it cause any copyright problem if using non-GPL RDBMS like 
sqlite3 in
    GPLv2 btrfs-progs?

[NEED FEEDBACK]
Any feedback or discussion on the crazy idea is welcomed, since this may 
needs
a lot of work, it definitely needs a lot review on the idea before it 
comes to
codes.

Thanks,
Qu

