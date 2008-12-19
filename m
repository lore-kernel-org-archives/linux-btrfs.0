From: Sage Weil <sage@newdream.net>
Subject: inode data not getting included in commits?
Date: Thu, 18 Dec 2008 16:22:45 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0812181536060.10446@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris-

I noticed some data and metadata getting out of sync on disk, despite 
wrapping my writes with btrfs transactions.  After digging into it a bit, 
it appears to be a larger problem with inode size/data getting written 
during a regular commit.

I have a test program append a few bytes at a time to a few different 
files, in a loop.  I let it run until I see a btrfs transaction commit 
(via a printk at the bottom of btrfs_commit_transaction).  Then 'reboot -f 
-n'.  After remounting, all files exist but are 0 bytes, and debug-tree 
shows a bunch of empty files.  I would expect to see either the sizes when 
the commit happend (a few hundred KB in my case), or no files at all; 
there was actually no point in time when any of the files were 0 bytes.

Similarly, if I do the same but wait for a few commits to happen, after 
remount the file sizes reflect the size from around the next-to-last 
commit, not the last commit.

This is probably more information than you need, but my original test was 
a bit more complicated, with weirder results.  Append to each file, then 
write it's size to an xattr on another file.  Wrap both operations in a 
transaction.  Start it up, run 'sync', then reboot -f -n.  When I remount 
the size and xattr are out of sync by exactly one iteration: the xattr 
reflects the size that resulted from _two_ writes back, not the 
immediately preceeding write.  If anything I would expect to see a larger 
actual size than xattr value (for example if the start/end transaction 
ioctls weren't working)...

sage



#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	while (1) {
		int r, fd, pos, i = rand() % 10;
		char a[20];
		
		sprintf(a, "%d.log", i);
		fd = open(a, O_CREAT|O_APPEND|O_WRONLY, 0600);
		r = write(fd, "foobarfoo\n", 10);
		pos = lseek(fd, 0, SEEK_CUR);
		printf("write %s = %d, size = %d\n", a, r, pos);
		close(fd);
	}
}

