From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: understanding the tree-log
Date: Fri, 04 Nov 2011 13:09:47 +0800
Message-ID: <4EB3739B.4030204@cn.fujitsu.com>
References: <4EB35A2C.8060708@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB35A2C.8060708@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2011 11:21 AM, Phillip Susi wrote:
> Given how a transaction is committed, why is there a tree-log?  When
> modifying the tree, either the super block is still pointing to the
> old tree root, or the new generation has been fully committed, so how
> can there ever be an intermediate state that needs a log to recover?

tree-log is for improving the preformance  of fsync and and O_SYNCs.

Btrfs has an expensive "commit transaction", if we commit a transaction every time we fsync,
the performance is not that good.  Instead of this, we introduce a write-ahead log to make
our fsync faster.

So if you do fsync for your data, it means your data is safely in the log tree,
then if a crash takes place, the data can be recovered from log.

More details are in tree-log.c.

thanks,
liubo
