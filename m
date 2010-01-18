From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: worse than expected compression ratios with -o compress
Date: Mon, 18 Jan 2010 11:06:23 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001181054280.18418@alumni-linux.ccs.neu.edu>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu> <20100117143422.GA18448@cumulus> <alpine.DEB.2.00.1001180906050.14760@alumni-linux.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1001180906050.14760@alumni-linux.ccs.neu.edu>
List-ID: <linux-btrfs.vger.kernel.org>


On Mon, 18 Jan 2010, Jim Faulkner wrote:

> So, in summary, the compression ratios are:
> btrfs: 96%
> zip/gzip: 15%
> bzip2: 11%
> 7z: 8%
> NTFS: 41%

One minor follow up.  I used "mysql < mysqldump.sql" to initially populate 
the database on the btrfs filesystem.  I thought that this may affect the 
compression ratio, since mysql probably keeps changing the same blocks as 
the sql import progresses.  Compare this to the NTFS test, in which I 
simply copied the populated database files onto the filesystem.

So, I created a new btrfs filesystem, mounted it with the compress option, 
and simply copied my database files onto the filesystem, just like I did 
on the NTFS test.  This did make a small difference:
delta-9 mysql # du -h
0       ./btrfs-mysql-test/test
73G     ./btrfs-mysql-test/urd
743K    ./btrfs-mysql-test/mysql
73G     ./btrfs-mysql-test
73G     .

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi              187G   67G  120G  36% /var/news/mysql

This shaved another 3 GB off of the disk usage, so btrfs has now achieved 
a 91% compression ratio.

This is still rather poor compared to the 41% compression ratio achieved 
by NTFS.  Surely btrfs should be better at compressing this data.
