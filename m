From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: understanding the tree-log
Date: Fri, 04 Nov 2011 09:35:00 -0400
Message-ID: <4EB3EA04.3000903@cfl.rr.com>
References: <4EB35A2C.8060708@cfl.rr.com> <4EB3739B.4030204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB3739B.4030204@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/4/2011 1:09 AM, Liu Bo wrote:
> Btrfs has an expensive "commit transaction", if we commit a transaction every time we fsync,
> the performance is not that good.  Instead of this, we introduce a write-ahead log to make
> our fsync faster.
>
> So if you do fsync for your data, it means your data is safely in the log tree,
> then if a crash takes place, the data can be recovered from log.

How can you write to the log tree without a full commit?  The tree of 
tree roots has to point to the root node of the log tree, so when you 
write out the log tree, that needs updated too, which requires a full 
commit doesn't it?

