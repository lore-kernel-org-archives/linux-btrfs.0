From: David Brown <david@westcontrol.com>
Subject: Content based storage
Date: Tue, 16 Mar 2010 10:21:43 +0100
Message-ID: <hnnijd$jol$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was wondering if there has been any thought or progress in 
content-based storage for btrfs beyond the suggestion in the "Project 
ideas" wiki page?

The basic idea, as I understand it, is that a longer data extent 
checksum is used (long enough to make collisions unrealistic), and merge 
data extents with the same checksums.  The result is that "cp foo bar" 
will have pretty much the same effect as "cp --reflink foo bar" - the 
two copies will share COW data extents - as long as they remain the 
same, they will share the disk space.  But you can still access each 
file independently, unlike with a traditional hard link.

I can see at least three cases where this could be a big win - I'm sure 
there are more.

Developers often have multiple copies of source code trees as branches, 
snapshots, etc.  For larger projects (I have multiple "buildroot" trees 
for one project) this can take a lot of space.  Content-based storage 
would give the space efficiency of hard links with the independence of 
straight copies.  Using "cp --reflink" would help for the initial 
snapshot or branch, of course, but it could not help after the copy.

On servers using lightweight virtual servers such as OpenVZ, you have 
multiple "root" file systems each with their own copy of "/usr", etc. 
With OpenVZ, all the virtual roots are part of the host's file system 
(i.e., not hidden within virtual disks), so content-based storage could 
merge these, making them very much more efficient.  Because each of 
these virtual roots can be updated independently, it is not possible to 
use "cp --reflink" to keep them merged.

For backup systems, you will often have multiple copies of the same 
files.  A common scheme is to use rsync and "cp -al" to make hard-linked 
(and therefore space-efficient) snapshots of the trees.  But sometimes 
these things get out of synchronisation - perhaps your remote rsync dies 
halfway, and you end up with multiple independent copies of the same 
files.  Content-based storage can then re-merge these files.


I would imagine that content-based storage will sometimes be a 
performance win, sometimes a loss.  It would be a win when merging 
results in better use of the file system cache - OpenVZ virtual serving 
would be an example where you would be using multiple copies of the same 
file at the same time.  For other uses, such as backups, there would be 
no performance gain since you seldom (hopefully!) read the backup files. 
  But in that situation, speed is not a major issue.


mvh.,

David

