Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rafiki-balancer.wellbehavedsoftware.com ([78.46.156.93]:47857
	"EHLO mail.wellbehavedsoftware.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaI0Pr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 11:47:29 -0400
Received: from [10.109.132.7] (81.184.233.196.dyn.user.ono.com [81.184.233.196])
	by mail.wellbehavedsoftware.com (Postfix) with ESMTPSA id E1233186AF
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 15:39:07 +0000 (UTC)
Message-ID: <5426DA1B.9010503@pharaoh.uk>
Date: Sat, 27 Sep 2014 17:39:07 +0200
From: James Pharaoh <james@pharaoh.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS backup questions
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to build a backup solution for a highly virtualized server 
environment, based on BTRFS. I have a lot of questions which I can't 
find the answers to, and have included some of the most important ones here.

1. Simultaneous snapshots

I would really like to snapshot multiple subvolumes at the same time, so 
I can get a consistent view of my system. It seems like BTRFS should be 
able to provide this, given its data model, but I can't see any way to 
do so. Can anyone suggest how I can do this, or confirm that it is not 
possible and perhaps enlighten me as to why?

2. Duplicating NOCOW files

This is obviously possible, since it takes place when you make a 
snapshot. So why can't I create a clone of a snapshot of a NOCOW file? I 
am hoping the answer to this is that it is possible but not implemented 
yet...

I also have a question about the implementation of this. It would make 
sense, to me, to fragment the snapshot instead of the file itself. This 
is especially true in my case, where I am taking a snapshot which I am 
going to discard later.

Can someone confirm what happens in this case? Basically I want to know 
if access to the original file will continue to be performant after lots 
of snpshots have been taken.

3. Peformance penalty of fragmentation on SSD systems with lots of memory

I see a lot of discussion of the performance issues running databases, 
and similar, on top of BTRFS without NOCOW. I suspect that this is not a 
huge issue if using SSD, and with a lot of memory, since things will 
generally be in memory anyway.

Can anyone confirm if this is true? Obviously it makes sense to use a 
database's native replication if possible but I am trying to come up 
with a general purpose hosting platform and so I am very interested in 
the performance when this kind of optimization hasn't taken place.

4. Generations and tree structures

I am planning to use lots more clever tricks which I think should be 
available in BTRFS, but I can't see much documentation. Can anyone point 
out any good examples or documentation of how to access the tree 
structures directly. I'm particularly interested in finding changed 
files and portions of files using the generations and the tree search.

Even better, would anyone be able to help me with this?

5. Project

I've looked around for existing projects, but can't find anything apart 
from some basic scripts. Please let me know if there are any good 
projects I should be aware of.

In the mean time, I've created my own project in Haskell and shared on 
github.

https://github.com/wellbehavedsoftware/wbs-backup

Some of the goals here are:

- Take advantage of deduplication, both in the running system and in the 
backups

- Work seamlessly and efficiently with a large number of snapshots.

- Efficiently take backups at a high frequency and send them to a remote 
system

- Backups should serve for disaster recovery, for undoing mistakes, and 
for tracking changes

- Provide a means to verify the backup via a completely indepdent code 
path, and to do so efficiently.

I am developing this for a direct business need, but I think this kind 
of functionality should be open source, and that it will be more useful 
to me with community support. If anyone is interested in participating, 
or even just using it, please let me know.

Thanks to everyone who has worked on BTRFS so far ;-)

James
