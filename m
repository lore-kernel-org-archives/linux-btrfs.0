From: Daniel J Blueman <daniel@quora.org>
Subject: block_rsv_check EAGAIN vs ENOSPC...
Date: Tue, 24 Apr 2012 23:50:24 +0800
Message-ID: <CAMVG2stv_CbF=-A=yS40_Q6N5+_fpc2SSJxL3Rga0LQXpc8MSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With 3.4-rc4 under certain workloads, I see btrfs_block_rsv_check
return -ENOSPC.

Since btrfs_block_rsv_check can only return -ENOSPC or 0,
relocation.c:3816 checks for -EAGAIN, which is either redundant or
should be -ENOSPC, which I initially suspected.

Let me know which the behaviour should be and I'll get a patch tested and sent.

Thanks,
  Daniel
-- 
Daniel J Blueman
