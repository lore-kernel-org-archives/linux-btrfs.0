From: Guido Winkelmann <guido-btrfs@thisisnotatest.de>
Subject: Repairing corrupted filesystems
Date: Thu, 10 May 2012 15:55:34 +0200
Message-ID: <27281960.kxhTVsFkdY@pc10>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got three servers here with corrupted btrfs filesystems. These servers 
were/are part of a ceph cluster that was physically moved a few months ago. 
The servers may have been incorrectly powered off without a proper shutdown 
during the move, but that's hard to find out now. (It wasn't me who actually 
moved them). The servers had 2 independent btrfs filesystems each (one per 
physical disk). 

Out of the six total filesystems, 5 can now no longer be mounted. When trying 
to, I get the following messages in dmesg:

device fsid cc5ec5e4-ba19-4ce9-aecc-17e1682a63aa devid 1 transid 551383 
/dev/sdb5
parent transid verify failed on 49468260352 wanted 24312 found 511537
parent transid verify failed on 49468260352 wanted 24312 found 511537
parent transid verify failed on 49468260352 wanted 24312 found 511537
parent transid verify failed on 49468260352 wanted 24312 found 511537
btrfs: open_ctree failed

In #btrfs on IRC, someone suggested I try mounting with -o recovery, but that 
did not change anything.

The last time the servers had the filesystems mounted, they were running with 
Kernel 3.1.1, but I have since upgraded to 3.3.5. The filesystems were 
originally created with the fairly old userspace tools that were shipped with 
CentOS 6.

I have tried running btrfsck from 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git (checked 
out yesterday), but that didn't change anything.
I also tried btrfs-recover from the same repository. That did work, however 
some mails from the ceph mailing list, like this one:
http://article.gmane.org/gmane.comp.file-systems.ceph.devel/6219
would suggest that just recovering the files from the filesystem would not do 
the trick, and I really need to actually recover the actual filesystem.

Is there something left I can do about this?

Luckily, I did not yet have any important data on the ceph cluster of which I 
did not have other copies, however I'd really like to know whether btrfs can 
recover from this situation at all. Frankly, 5 out of 6 filesystems not 
surviving an unclean shutdown looks like a rather discouraging statistic. In 
fact, this the first time I have actually witnessed /any/ filesystem actually 
die from an unclean shutdown... (Yeah, I know, anecdotes != data, but 
still...)

Regards,
	Guido
