From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: worse than expected compression ratios with -o compress
Date: Thu, 21 Jan 2010 13:16:31 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu> <20100118141240.GA10710@localhost.localdomain> <20100118212951.GC4065@think> <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu> <20100120163011.GE3001@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100120163011.GE3001@think>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 20 Jan 2010, Chris Mason wrote:

> Please let me know if this improves your ratios

It most certainly does!  It also greatly reduced the time required to copy 
the data to my (not very fast) disk.  All my testing was done on 2.6.32.4. 
The line numbers in your patch were a little off for 2.6.32.4, but I did 
manage to apply it cleanly.  Here's the results of my testing:

First let's see the results with plain old mount -o compress:
delta-9 ~ # mkfs.btrfs /dev/sdi

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdi
         nodesize 4096 leafsize 4096 sectorsize 4096 size 186.31GB
Btrfs Btrfs v0.19
delta-9 ~ # mount -o noacl,compress,noatime /dev/sdi /var/news/mysql
delta-9 ~ # time cp -a /nfs/media/tmp/btrfs-mysql-test /var/news/mysql

real    57m6.983s
user    0m0.807s
sys     1m28.494s
delta-9 ~ # cd /var/news/mysql
delta-9 mysql # du -h --max-depth=1
73G     ./btrfs-mysql-test
73G     .
delta-9 mysql # df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi              187G   67G  120G  36% /var/news/mysql

So, with plain mount -o compress, it took 57 minutes to copy the data to 
my btrfs disk, and it achieved a 92% compression ratio.

Now let's test with mount -o compress-force.  First I'll create a new 
btrfs filesystem so we're getting a fresh start:

delta-9 ~ # mkbtrfs /dev/sdi

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdi
         nodesize 4096 leafsize 4096 sectorsize 4096 size 186.31GB
Btrfs Btrfs v0.19
delta-9 ~ # mount -o noatime,noacl,compress-force /dev/sdi /var/news/mysql
delta-9 ~ # time cp -a /nfs/media/tmp/btrfs-mysql-test /var/news/mysql/

real    14m45.742s
user    0m0.547s
sys     1m30.551s
delta-9 ~ # df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi              187G   14G  173G   8% /var/news/mysql
delta-9 ~ # cd /var/news/mysql
delta-9 mysql # du -h --max-depth=1
73G     ./btrfs-mysql-test
73G     .
delta-9 mysql #

Wow!  So not only did mount -o compress-force achieve a 19% compression 
ratio, using 53 GB less disk space than mount -o compress, it managed to 
copy the data in only 15 minutes, compared to 57 minutes with mount -o 
compress.

The disk in question is an old IDE disk in a cheap external USB 2.0 
enclosure, which is probably not exactly the type of storage that btrfs is 
being developed for.  Nevertheless, it is nice to see such a huge 
improvement in the time required to copy the data around.

I'd be very happy to see the -o compress-force option in the mainline 
kernel someday!
