From: Chris Mason <chris.mason@oracle.com>
Subject: Re: brtfs ssd mode texted on phoronix
Date: Fri, 29 May 2009 13:47:33 -0400
Message-ID: <20090529174733.GC3828@think>
References: <f058a9c30905290946s32a9a41ds6b693e22c3fb0243@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30905290946s32a9a41ds6b693e22c3fb0243@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 29, 2009 at 05:46:27PM +0100, Miguel F Mascarenhas Sousa Filipe wrote:
> Hi there,
> 
> The phoronix guy tested btrfs in Fedora 11 + rawhide in SSD mode and
> normal mode in a bunch of tests from the phoronix-test-suite.
> 
> http://www.phoronix.com/scan.php?page=article&item=btrfs_ssd_mode&num=1
> 
> The drive was a: OCZ Vertex SATA 2.0 SSD
> The drive is supposedly not that bad, of course is worse than the
> intel X-25 MLC one, but much more consumer level and afordable.
> 
> these are mostly sintetic tests but I think are worth the look.
> 
> SSD mode had worse results almost consistently.
> 

Thanks for sending this along.  I just posted to the forum that 2.6.30
should be faster with -o ssd.

-chris

