From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] btrfs: fix deadlock when doing reservation
Date: Wed, 15 Jun 2011 09:44:02 -0400
Message-ID: <4DF8B722.2090704@redhat.com>
References: <4DF88DCF.2030502@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF88DCF.2030502@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2011 06:47 AM, Miao Xie wrote:
> The following deadlock may happen when doing reservation for metadata:
> 
> Task0				Flush thread		Task1
> start_transaction()
>   shrink_delalloc()
>     writeback_inodes_sb_nr()
>       wait for flush thread
>       end.
> 				btrfs_writepages()
> 				  cow_file_range()
> 							btrfs_commit_transaction
> 							  wait num_writer == 1
> 							  (wait Task0 end
> 							   transaction)
> 				  start_transaction()
> 				    wait trans commit
> 				    end
> 
> Task0 -> Flush thread -> Task1 -> Task0
> 
> Fix the above deadlock by doing reservation before the trans handle has
> been joined into the transaction.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

I've already taken care of this in

[PATCH 1/2] Btrfs: do transaction space reservation before joining the
transaction

Thanks,

Josef
