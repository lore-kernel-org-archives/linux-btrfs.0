From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: no space left on device
Date: Tue, 08 Feb 2011 19:56:50 +0100
Message-ID: <4D5191F2.5080509@logtenberg.eu>
References: <BfUMgs0i1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BfUMgs0i1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

>> But the next step is to update kernel and btrfs-progs from git.
> 
> Maybe that doesn't help now. I'm working with kernel 2.6.37 and kernel  
> 2.6.38-rc2, and I've got big problems.

I had to install at least 2.6.37 to have a kernel with an advanced
enough balance feature to actually reclaim the free space and report it
correctly too.
Still, I had so much kernel crashes during this balance operation that
even after numerous retries I still hadn't once completed it (on a FS of
merely 300GB). Fortunately Zheng Yan coded a patch, which I applied to
2.6.38-rc2, so that I could finally run - and finish - the balance
operation.
Additionally this version of btrfs is more clever in not wasting the
free space to begin with, hence making future rebalances for reclaiming
free space no longer necessary.

That patch is released on this list on january 26th, called "Fix balance
panic". If you experience the same, you could try applying this patch
too. There is no (pre-built) kernel yet with this patch already applied.

  - Erik.
