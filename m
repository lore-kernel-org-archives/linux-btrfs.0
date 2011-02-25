From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Comparing snapshots?
Date: Fri, 25 Feb 2011 21:03:04 +0100
Message-ID: <4D680AF8.5060800@libero.it>
References: <20110225095916.GA7609@suse.de>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110225095916.GA7609@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2011 10:59 AM, Arvin Schnell wrote:
> Hi,
> 
> for a backup program I have to find all differing files
> (including metadata) in two snapshots taken from the same
> subvolume.
> 
> Having looked at the find-new command I thought about this
> process:
> 
> 1. Get the two transids when the two snapshots were created.
> 
> 2. Query modifications to the original subvolume between the two
>    transids.
> 
> Is the general process corrent or have I overseen something?

I suppose that you are thinking to something like:

- record the last trans-id (trans-id1)
- update the file-system
- [...]
- record the last trans-id (trans-id2)
- update the file-system
- [...]
- Backup all the objects which have a trans-id between (trans-id1-trans-id2]

This may lead to miss two kinds of "operations"
1) a file deletion
2) a file changed two times, the first one after the first "snapshot",
and the second one after the second snapshot.

In the first case you would not be able to find any key update between
the two trans-id(s), because they simply doesn't exist.

In the second case the trans-id associated to the object is after trans-id2.

For solving the point two you must change "Query modifications to the
original subvolume" into "Query modifications to the second snapshot".
This means that the second snapshot must exist (it is not sufficient to
know the trans-id)..

For solving the point one, it is needed to
a) track the change not only of the files but also of the directory (if
you remove a file, the timestamp of the directory inode is updated).

b) compare the update directories with the original ones. This means
that the first snapshot must exist (it is not sufficient to know the
trans-id).

I have to point out that for a backup purpose would be sufficient to
track the changed files (and not the deleted ones).

I started to develop a tool to comparing two snapshot. But I stopped
when I discovered that the ioctl BTRFS_IOC_TREE_SEARCH was not robust
enough for that: when I tried to find the changed inode, attribute,
extended attribute... I discovered that the ioctl BTRFS_IOC_TREE_SEARCH
don't work well is some corner case [*].

I even tried to propose a patch to mitigate the problem. But at the time
the develop efforts were (are) oriented to other issues, and the patch
was not merged..

However if you want to start to develop something, I can go deeper in
the problem.


[*] see the thread "Bug in the design of the tree search ioctl API ?",
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07523.html

> AFAIS the btrfs tool does not provide the required
> information/commands. Would it be possible to add those?
> 
> Thanks in advance,
>   Arvin
> 

