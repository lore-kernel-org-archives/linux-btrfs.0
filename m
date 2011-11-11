From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/6] Btrfs: Abstract similar code for
 btrfs_block_rsv_add{, _noflush}()
Date: Thu, 10 Nov 2011 19:12:49 -0500
Message-ID: <20111111001249.GA4435@shiny>
References: <4EBB6F07.6000009@cn.fujitsu.com>
 <4EBB7DBC.8060701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBB7DBC.8060701@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2011 at 03:31:08PM +0800, Miao Xie wrote:
> The mail of PATCH 0 was always rejected, so I try to send it as the
> reply of PATCH 1.
> ====================
> Title: [PATCH 0/6] Random fix of the space relocation
> 
> This patchset fixes 5 bugs of the space relocation, one fixes the problem
> that we forgot to reserve space for writing out i-node cache, one fixes
> that the path is not released, this problem may cause the deadlock.
> one fixes the no-cow problem, this problem will break the meta-data.
> one fixes the deadlock that caused by the race between the relocation
> and the snapshot creation, the last one fixes BUG_ON() which is triggered
> by the orphan back-ref nodes.
> 
> NOTE: This patchset is based on the danger branch.

Thanks!  For future patches, please use the for-linus branch instead.
danger still has the subtransid code, which we need to fix

-chris
