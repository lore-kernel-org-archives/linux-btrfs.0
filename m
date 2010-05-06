From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs/direct-IO: fix a bug of btrfs_dio_read
Date: Wed, 5 May 2010 22:11:36 -0400
Message-ID: <20100506021136.GB5672@localhost.localdomain>
References: <4BE2257A.7030005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	jim owens <owens6336@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BE2257A.7030005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 06, 2010 at 10:12:10AM +0800, liubo wrote:
> As I mentioned in the bug-report, when the file size is 
> not n * BUFFERSIZE, this file cannot be read correctly 
> and the system will crash or hang up.
> 
> After investigation, I fount that data_len should be 
> checked before lock_extent, in order to prevent the 
> situation that when it comes to the file end, 
> diocb->lockstart changes to lockend+1, then lock_extent
>  will cause system's crash or hang.
> 
> So move the data_len's check ahead.
> 

Please read my previous email, DIO has been refactored, this code isn't going to
be used anymore.  Thanks,

Josef
