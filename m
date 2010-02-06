From: David Miller <davem@davemloft.net>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 05 Feb 2010 21:32:20 -0800 (PST)
Message-ID: <20100205.213220.147487541.davem@davemloft.net>
References: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de>
	<20100205.120151.128582331.davem@davemloft.net>
	<alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: lists@nerdbynature.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Christian Kujau <lists@nerdbynature.de>
Date: Fri, 5 Feb 2010 21:13:00 -0800 (PST)

> On Fri, 5 Feb 2010 at 12:01, David Miller wrote:
>> Can you rerun your test with the following patch applied?
>> It will obtain more information for the btrfs developers.
> 
> Thanks, David! Here it is:
> 
> [ 1861.965178] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [ 1862.060546] Caller [100a6044:crc32c+0x44/0x80 [libcrc32c]]
> [ 1862.126652] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [ 1862.221928] Caller [100a6044:crc32c+0x44/0x80 [libcrc32c]]
> 
> It's always libcrc32c and the numbers stay the same too. Full dmesg here:
> http://nerdbynature.de/bits/2.6.33-rc6/btrfs/

My debugging patch didn't work correctly.

Can you try using this one instead?

Thanks!

diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 378ca82..cbde2ea 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -283,6 +283,9 @@ static void log_unaligned(struct pt_regs *regs)
 		count++;
 		printk("Kernel unaligned access at TPC[%lx] %pS\n",
 		       regs->tpc, (void *) regs->tpc);
+		printk("Caller [%lx:%pS]\n",
+		       regs->tnpc,
+		       (void *) regs->tnpc);
 	}
 }
 
