From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: worse than expected compression ratios with -o compress
Date: Sat, 16 Jan 2010 11:16:50 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I have a mysql database which consists of hundreds of millions, if not 
billions of Usenet newsgroup headers.  This data should be highly 
compressable, so I put the mysql data directory on a btrfs filesystem 
mounted with the compress option:
/dev/sdi on /var/news/mysql type btrfs (rw,noatime,compress,noacl)

However, I'm not seeing the kind of compression ratios that I would expect 
with this type of data.  FYI, all my tests are using Linux 2.6.32.3. 
Here's my current disk usage:
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi              302G  122G  181G  41% /var/news/mysql

and here's the actual size of all files:
delta-9 mysql # pwd
/var/news/mysql
delta-9 mysql # du -h --max-depth=1
747K    ./mysql
0       ./test
125G    ./urd
125G    .
delta-9 mysql #

As you can see, I am only shaving off 3 gigs out of 125 gigs worth of what 
should be very compressable data.  The compressed data ends up being 
around 98% the size of the original data.

To contrast, rzip can compress a database dump of this data to around 7% 
of its original size.  This is an older database dump, which is why it is 
smaller.  Before:
-rw------- 1 root root  69G 2010-01-15 14:55 mysqlurdbackup.2010-01-15
and after:
-rw------- 1 root root 5.2G 2010-01-16 05:34 mysqlurdbackup.2010-01-15.rz

Of course it took 15 hours to compress the data, and btrfs wouldn't be 
able to use rzip for compression anyway.

However, I still would expect to see better compression ratios than 98% on 
such data.  Are there plans to implement a better compression algorithm? 
Alternatively, is there a way to tune btrfs compression to achieve better 
ratios?

thanks,
Jim Faulkner
Please CC my e-mail address on any replies.
