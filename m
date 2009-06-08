From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fdatasync should skip metadata writeout
Date: Mon, 8 Jun 2009 10:01:20 -0400
Message-ID: <20090608140120.GC3899@think>
References: <6.0.0.20.2.20090608133848.0740d758@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090608133848.0740d758@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 08, 2009 at 04:50:47PM +0900, Hisashi Hifumi wrote:
> Hi.
> 
> In btrfs, fdatasync and fsync are identical.
> I think fdatasync should skip committing transaction when 
> inode->i_state is set just I_DIRTY_SYNC and this indicates
> only atime or/and mtime updates.
> Following patch improves fdatasync throughput.
> 
> #sysbench --num-threads=16 --max-requests=10000 --test=fileio 
> --file-block-size=4K --file-total-size=16G --file-test-mode=rndwr 
> --file-fsync-mode=fdatasync run 

Very nice, thank you for the patch.

-chris
