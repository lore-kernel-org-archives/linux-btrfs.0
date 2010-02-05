From: David Miller <davem@davemloft.net>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 05 Feb 2010 12:01:51 -0800 (PST)
Message-ID: <20100205.120151.128582331.davem@davemloft.net>
References: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: lists@nerdbynature.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Christian Kujau <lists@nerdbynature.de>
Date: Fri, 5 Feb 2010 10:36:52 -0800 (PST)

> When writing to a newly created btrfs (vanilla 2.6.33-rc6, sparc64) the 
> following messages are printed:
> 
> [28617.650231] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [28617.745783] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [28654.589492] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [28654.685036] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [28689.595394] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]

Can you rerun your test with the following patch applied?

It will obtain more information for the btrfs developers.

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
+		       regs->u_regs[UREG_RETPC],
+		       (void *) regs->u_regs[UREG_RETPC]);
 	}
 }
 
