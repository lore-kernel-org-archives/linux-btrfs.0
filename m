From: Sander <sander@humilis.net>
Subject: Re: worse than expected compression ratios with -o compress
Date: Sun, 17 Jan 2010 15:34:22 +0100
Message-ID: <20100117143422.GA18448@cumulus>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jim,

Jim Faulkner wrote (ao):
> To contrast, rzip can compress a database dump of this data to
> around 7% of its original size.  This is an older database dump,
> which is why it is smaller.  Before:
> -rw------- 1 root root  69G 2010-01-15 14:55 mysqlurdbackup.2010-01-15
> and after:
> -rw------- 1 root root 5.2G 2010-01-16 05:34 mysqlurdbackup.2010-01-15.rz
> 
> Of course it took 15 hours to compress the data, and btrfs wouldn't
> be able to use rzip for compression anyway.

The difference between a life MySQL database and a dump of that database
is that the dump is text, while the database files are binary.

A fair comparison would be to compress the actual database files.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
