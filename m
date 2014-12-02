Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14463 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752544AbaLBBRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 20:17:50 -0500
Message-ID: <547D1339.10404@cn.fujitsu.com>
Date: Tue, 2 Dec 2014 09:17:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com> <547C0834.7090706@cn.fujitsu.com> <547CAF2E.7070109@pobox.com>
In-Reply-To: <547CAF2E.7070109@pobox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Robert White <rwhite@pobox.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年12月02日 02:10
> On 11/30/2014 10:18 PM, Qu Wenruo wrote:
>> (advocacy for using SQL internally for btrfsck)
>
> All of these ideas you want to toss a entire SQL front end on are more 
> simply handled with simple data structures.
>
> In C++ terms "map<inode,parent>" and/or "map<parent,vector<children>>" 
> beats the heck out of including all of SQL and its related indexes and 
> type conversions (sqlite, for example, stores integers as doubles, or 
> decimal numbers depending on version).
>
> RDBMS _are_ good at representing things, so noticing that a thing 
> _can_ be represented with an RDBMS is very common.
>
> But by the time you put two or three indexes on relation->(parent, 
> child, name) you've given yourself three or four copies of the core 
> data in three or four different places. And those copies are largely 
> immutable and randomly distributed and will include the overhead in 
> memory for fairly sparse trees.
>
> It's not that it's an unworkable idea.
>
> But it is unnecessarily generic and adds an order of magnitude of 
> complexity to your problems.
>
> For instance, if I boot from a CD to run a btrfsck where will the 
> database files be written to?
This is easy, memory.
Since only when we judge the fs' metadata is too huge then we will use file.

One of the problem in current inode_record is, btrfsck can only record 
them all in memory,
when metadata of the file system is too big, sysadmin can only add swap 
space or memory
to handle it.

Although it is not a urgent problem, since 1T btrfs fs with about 5G 
metadata will only takes about 500M
checking chunk and extent and even less for checking fs roots.
>
> If it is an in-memory table why do I want the overhead of SQL to look 
> up something indexed by integer?
>
> If the sparse vectors of integers don't fit in memory why would the 
> SQL tables of integers fit "better"?
>
> SQL would be the second slowest possible for representing this data -- 
> The slowest would be an XML schema stored as flat text.
>
> So your crazy ides is also a pretty bad one compared to most if not 
> all sparse data representations and techniques that come to bear on 
> this problem set. All you are really doing is pushing the same work 
> (walking a tree to find an integer) into a difficult "spell it out in 
> SQL" space.
>
> Is prepare_sql(curosr,"SELECT parent FROM parantage_tree WHERE child = 
> %d"); execute_sql(cursor,child); and its possible error returns 
> actually clearer or better than "parent=inheretance.find(child); if 
> (parent!=inheretance.end()) {...}" (as it might be written in C++)?
>
> Do you want to know if (keep track of whether) an inode is allocated 
> and referenced? There's a sparse bit-vector for that...
>
> Want to be able to get back to an inode's location on disk, a sparse 
> array of disk offsets exists (among other options).
>
> Before you can even access the RDBMS you'd have to fill it completely; 
> otherwise you wouldn't know if a select returning zero rows was an 
> authoritative indication that the datum didn't exist or if it was 
> instead an indication that the datum hadn't been populated yet.
>
> THIS IS NOT SARCASM: If you strongly disagree, I suggest you start 
> coding. Seriously, don't ask, do... And in a month really check to see 
> if your solution is any smaller, faster, easier, or in _any_ _way_ 
> more optimal than using native data structures. The attempt will 
> answer the question definitively and then we'll all know...
I know this is a crazy idea and not disagree with your opinion.
But I am also somewhat tired of bringing new structure new searching 
functions or even bring larger change on
the btrfsck record infrastructure when I found that can't provide the 
function when new recovery function is going
to be implemented.

In fact, after I implement the whole corrupted-leaf recovery patchset, I 
may try to implement it as an experimental
try-and-error for cleanup/enhance for the inode_record infrastructure 
and see if there is the huge performance drop
or the lines of code reduced(anyway, just a personal try-and-error, will 
not send them if there is no such interesting
result, and it may be highly possible a disaster as you mentioned)

Thanks,
Qu

