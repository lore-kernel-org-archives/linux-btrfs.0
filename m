From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: fix return value check of
	btrfs_start_transaction()
Date: Thu, 20 Jan 2011 11:09:59 -0500
Message-ID: <20110120160959.GB6609@dhcp231-156.rdu.redhat.com>
References: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 20, 2011 at 03:19:37PM +0900, Tsutomu Itoh wrote:
> The error check of btrfs_start_transaction() is added, and the mistake
> of the error check on several places is corrected. 
> 

I'd rather we go through and have these things return an error than do a
BUG_ON().  We're moving towards a more stable BTRFS, not one that panics more
often :).  Thanks,

Josef
