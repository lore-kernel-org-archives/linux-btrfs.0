Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:46788 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbaLAEEC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 23:04:02 -0500
Message-ID: <547BE8A5.7050900@pobox.com>
Date: Sun, 30 Nov 2014 20:03:49 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com>
In-Reply-To: <547BCB43.5020505@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2014 05:58 PM, Qu Wenruo wrote:
> ("why not use SQL to..." suggestion)

SQL, as in Structured Query Language, is _terrible_ for recursion. It 
expresses all of its elements in terms of set theory and really can only 
implement union and intersection of flat sets.

Several companies offer extensions to SQL in their implementations to 
help with this lack of recursion such as "prior" in Oracle's PSQL, but 
they are all stateful beyond reason.

Several companies, including microsoft, have proposed and partially 
implemented "a relational database as a file system" paradigm and then 
crashed into the fact that dealing with the parent of the parent of 
something is different than dealing with the parent of the parent of the 
parent of something.

There is a humours-but-true saying: "If you have a problme, and you 
decide to solve it with (regex or xml or uml or sql etc) you now have 
two problems."

Writing the SQL to walk the tree is harder than allocating the memory as 
a vector, filling it with the data, and then walking the pointers.

Your suggestion is the first step on the road to The Inner Platform 
Effect™. You have a specialized database (parent, inode, name) and now 
you want to put a generic database engine over the specialized database 
so that you an re-implement the specialized database with generic 
primitives.

http://en.wikipedia.org/wiki/Inner-platform_effect

Things need to be only as generic as they need to be, and no more 
generic than that.

Replacing a pointer to a record with a pointer to a cursor's result 
table that will give you the name of the next result to query is not a 
win. Even as you spell it out you can see that it is _not_ a reduction 
in memory or processing.

And the "easy SQL lines" stop being that easy when "name" stops being 
unique.

(I've been down this road before. Not with file systems but with 
"managed objects" in a network management system. Nodes, Parent nodes, 
etc. Just referring to distributed things like networks switches instead 
of file system inodes. ... It doesn't end well. 8-) )

