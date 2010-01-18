From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: worse than expected compression ratios with -o compress
Date: Mon, 18 Jan 2010 09:46:42 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001180906050.14760@alumni-linux.ccs.neu.edu>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu> <20100117143422.GA18448@cumulus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100117143422.GA18448@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>


On Sun, 17 Jan 2010, Sander wrote:

> A fair comparison would be to compress the actual database files.

You are absolutely right.  I've run some more tests, this time against the 
database files themselves.

This time there are 73 GB worth of database files:
delta-9 mysql # du -h
747K    ./mysql
0       ./test
73G     ./urd
73G     .

btrfs compresses this to 70 GB:
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi              187G   70G  117G  38% /var/news/mysql

which is 96% compression ratio.  I then tried compressing /var/news/mysql 
with some popular compressors.

zip -5, zip -9, and gzip all ended up producing archives that are roughly 
11 GB:
delta-9 btrfs-mysql-test-jim # ls -lh btrfs-mysql-test.gz 
btrfs-mysql-test-9.zip btrfs-mysql-test-5.zip
-rw-r--r-- 1 jim jim 11G 2010-01-18 01:50 btrfs-mysql-test-5.zip
-rw-r--r-- 1 jim jim 11G 2010-01-18 06:56 btrfs-mysql-test-9.zip
-rw-r--r-- 1 jim jim 11G 2010-01-18 02:17 btrfs-mysql-test.gz
delta-9 btrfs-mysql-test-jim #

This is a 15% compression ratio.

bzip2 produced an 8 GB archive, which is an 11% compression ratio:
-rw-r--r-- 1 jim jim 8.0G 2010-01-18 09:08 btrfs-mysql-test.bz2

7z produced a 6.1 GB archive, which is an 8% compression ratio:
-rw-r--r-- 1 jim jim 6.1G 2010-01-18 07:36 btrfs-mysql-test.7z

Finally, all of these are just command line compressors, I wanted to get a 
test in with actual disk compression software.  I haven't had a DOS box 
running doublespace since I was rather young, so I plugged an extra drive 
into a Windows Vista machine, formatted it with NTFS, and enabled 
compression via the drive properties menu.  I then copied the mysql data 
directory onto the compressed NTFS drive:
http://www.ccs.neu.edu/home/jfaulkne/ntfscompression1.jpg

The end result was 72.4 GB of data using 29.5 GB of disk space:
http://www.ccs.neu.edu/home/jfaulkne/ntfscompression2.jpg

This is a 41% compression ratio.

So, in summary, the compression ratios are:
btrfs: 96%
zip/gzip: 15%
bzip2: 11%
7z: 8%
NTFS: 41%

I think most would agree that btrfs is doing a rather poor job of 
compressing my data, even compared to gzip and NTFS compression. 
Thoughts?
