Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49314 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbaLAGSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 01:18:50 -0500
Message-ID: <547C0834.7090706@cn.fujitsu.com>
Date: Mon, 1 Dec 2014 14:18:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com>
In-Reply-To: <547BE8A5.7050900@pobox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Robert White <rwhite@pobox.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年12月01日 12:03
> On 11/30/2014 05:58 PM, Qu Wenruo wrote:
>> ("why not use SQL to..." suggestion)
>
> SQL, as in Structured Query Language, is _terrible_ for recursion. It 
> expresses all of its elements in terms of set theory and really can 
> only implement union and intersection of flat sets.
>
> Several companies offer extensions to SQL in their implementations to 
> help with this lack of recursion such as "prior" in Oracle's PSQL, but 
> they are all stateful beyond reason.
>
> Several companies, including microsoft, have proposed and partially 
> implemented "a relational database as a file system" paradigm and then 
> crashed into the fact that dealing with the parent of the parent of 
> something is different than dealing with the parent of the parent of 
> the parent of something.
>
> There is a humours-but-true saying: "If you have a problme, and you 
> decide to solve it with (regex or xml or uml or sql etc) you now have 
> two problems."
Wait, regex and uml and xml is OK, but never heard sql is one of them...
>
> Writing the SQL to walk the tree is harder than allocating the memory 
> as a vector, filling it with the data, and then walking the pointers.
In fact, such INODE and INODE_REF table is not (completely nor mainly) 
used to walk the tree,
it is mainly used to search for:
1. is there any inode_ref refers to a given ino as parent.

This will not even be a problem when the fs is *OK*, since do a simple 
btrfs_search_slot()
with key( objectied = ino, type = BTRFS_DIR_INDEX/ITEM_KEY, offset = 0) 
will do it.

However when it comes to corrupted leaf, the whole INODE_ITEM with its 
DIR_INDEX/ITEM are gone
with the leaf, so the old search way is not usable and btrfs-progs will 
relay on other mechanism
to determine that.
And unfortunately, there is no such mechanism.


2. is there any dir_index/dir_item refers to a given ino as child.
Current inode_record works fine for this object.

So when the crazy idea disappear and sane ideas come back, it will 
probably be rb-tree based
(parent, ino, name, namelen) entries to record parent-child relation
(currently it is a list_head only records backref inside the inode_record).

And another rb-tree based (ino) entries (same as current inode_record 
structure).
>
> Your suggestion is the first step on the road to The Inner Platform 
> Effect™. You have a specialized database (parent, inode, name) and now 
> you want to put a generic database engine over the specialized 
> database so that you an re-implement the specialized database with 
> generic primitives.
>
> http://en.wikipedia.org/wiki/Inner-platform_effect
>
> Things need to be only as generic as they need to be, and no more 
> generic than that.
>
> Replacing a pointer to a record with a pointer to a cursor's result 
> table that will give you the name of the next result to query is not a 
> win. Even as you spell it out you can see that it is _not_ a reduction 
> in memory or processing.
>
> And the "easy SQL lines" stop being that easy when "name" stops being 
> unique.
Name is still unique when parent ino is given, so the INODE_REF tables' 
primary key is not
name but the (parent, ino, name) combine.

But the inner platform effect still seems valid for my crazy idea.
Anyway, the crazy idea comes to me when I see the RDB like feature in 
the inode_record structure,
-and I just want to save sometime coding the new (parent, ino, name, 
namelen) rb-tree-.
>
> (I've been down this road before. Not with file systems but with 
> "managed objects" in a network management system. Nodes, Parent nodes, 
> etc. Just referring to distributed things like networks switches 
> instead of file system inodes. ... It doesn't end well. 8-) )
>
The RDB idea must come to you just like me, wanting to write less codes, 
right?
So it seems the end may be the same. :-(

Thanks,
Qu
