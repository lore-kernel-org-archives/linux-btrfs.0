Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:58306 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaLASK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 13:10:58 -0500
Message-ID: <547CAF2E.7070109@pobox.com>
Date: Mon, 01 Dec 2014 10:10:54 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com> <547C0834.7090706@cn.fujitsu.com>
In-Reply-To: <547C0834.7090706@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2014 10:18 PM, Qu Wenruo wrote:
> (advocacy for using SQL internally for btrfsck)

All of these ideas you want to toss a entire SQL front end on are more 
simply handled with simple data structures.

In C++ terms "map<inode,parent>" and/or "map<parent,vector<children>>" 
beats the heck out of including all of SQL and its related indexes and 
type conversions (sqlite, for example, stores integers as doubles, or 
decimal numbers depending on version).

RDBMS _are_ good at representing things, so noticing that a thing _can_ 
be represented with an RDBMS is very common.

But by the time you put two or three indexes on relation->(parent, 
child, name) you've given yourself three or four copies of the core data 
in three or four different places. And those copies are largely 
immutable and randomly distributed and will include the overhead in 
memory for fairly sparse trees.

It's not that it's an unworkable idea.

But it is unnecessarily generic and adds an order of magnitude of 
complexity to your problems.

For instance, if I boot from a CD to run a btrfsck where will the 
database files be written to?

If it is an in-memory table why do I want the overhead of SQL to look up 
something indexed by integer?

If the sparse vectors of integers don't fit in memory why would the SQL 
tables of integers fit "better"?

SQL would be the second slowest possible for representing this data -- 
The slowest would be an XML schema stored as flat text.

So your crazy ides is also a pretty bad one compared to most if not all 
sparse data representations and techniques that come to bear on this 
problem set. All you are really doing is pushing the same work (walking 
a tree to find an integer) into a difficult "spell it out in SQL" space.

Is prepare_sql(curosr,"SELECT parent FROM parantage_tree WHERE child = 
%d"); execute_sql(cursor,child); and its possible error returns actually 
clearer or better than "parent=inheretance.find(child); if 
(parent!=inheretance.end()) {...}" (as it might be written in C++)?

Do you want to know if (keep track of whether) an inode is allocated and 
referenced? There's a sparse bit-vector for that...

Want to be able to get back to an inode's location on disk, a sparse 
array of disk offsets exists (among other options).

Before you can even access the RDBMS you'd have to fill it completely; 
otherwise you wouldn't know if a select returning zero rows was an 
authoritative indication that the datum didn't exist or if it was 
instead an indication that the datum hadn't been populated yet.

THIS IS NOT SARCASM: If you strongly disagree, I suggest you start 
coding. Seriously, don't ask, do... And in a month really check to see 
if your solution is any smaller, faster, easier, or in _any_ _way_ more 
optimal than using native data structures. The attempt will answer the 
question definitively and then we'll all know...
