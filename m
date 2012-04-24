From: Josef Bacik <josef@redhat.com>
Subject: Re: block_rsv_check EAGAIN vs ENOSPC...
Date: Tue, 24 Apr 2012 11:54:02 -0400
Message-ID: <20120424155402.GF3326@localhost.localdomain>
References: <CAMVG2stv_CbF=-A=yS40_Q6N5+_fpc2SSJxL3Rga0LQXpc8MSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2stv_CbF=-A=yS40_Q6N5+_fpc2SSJxL3Rga0LQXpc8MSA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 11:50:24PM +0800, Daniel J Blueman wrote:
> With 3.4-rc4 under certain workloads, I see btrfs_block_rsv_check
> return -ENOSPC.
> 
> Since btrfs_block_rsv_check can only return -ENOSPC or 0,
> relocation.c:3816 checks for -EAGAIN, which is either redundant or
> should be -ENOSPC, which I initially suspected.
> 
> Let me know which the behaviour should be and I'll get a patch tested and sent.
> 

Yup you are right, thanks,

Josef
