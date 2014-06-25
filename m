Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47622 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaFYHee (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 03:34:34 -0400
Date: Wed, 25 Jun 2014 15:34:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash when mounting raid5 btrfs with missing
 disks
Message-ID: <20140625073423.GB3642@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1403595556-32753-1-git-send-email-bo.li.liu@oracle.com>
 <53AA794D.2090407@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53AA794D.2090407@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru,

On Wed, Jun 25, 2014 at 04:25:01PM +0900, Satoru Takeuchi wrote:
> Hi Liu,
> 
> (2014/06/24 16:39), Liu Bo wrote:
> > The reproducer is
> > 
> > $ mkfs.btrfs D1 D2 D3 -mraid5
> > $ mkfs.ext4 D2 && mkfs.ext4 D3
> > $ mount D1 /btrfs -odegraded
> 
> Tested-by: Satoru Takeuchi<takeuchi_satoru@jp.fujitsu.com>
> 
> Here is the result of the last mount.
> 
> ===
> ...
> mount: wrong fs type, bad option, bad superblock on /dev/vdb1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> ===
> 
> It "correctly" failed :-)

Thanks for testing it :)

thanks,
-liubo

> 
> Thanks,
> Satoru
> 
> > 
> > -------------------
> > 
> > [   87.672992] ------------[ cut here ]------------
> > [   87.673845] kernel BUG at fs/btrfs/raid56.c:1828!
> > ...
> > [   87.673845] RIP: 0010:[<ffffffff813efc7e>]  [<ffffffff813efc7e>] __raid_recover_end_io+0x4ae/0x4d0
> > ...
> > [   87.673845] Call Trace:
> > [   87.673845]  [<ffffffff8116bbc6>] ? mempool_free+0x36/0xa0
> > [   87.673845]  [<ffffffff813f0255>] raid_recover_end_io+0x75/0xa0
> > [   87.673845]  [<ffffffff81447c5b>] bio_endio+0x5b/0xa0
> > [   87.673845]  [<ffffffff81447cb2>] bio_endio_nodec+0x12/0x20
> > [   87.673845]  [<ffffffff81374621>] end_workqueue_fn+0x41/0x50
> > [   87.673845]  [<ffffffff813ad2aa>] normal_work_helper+0xca/0x2c0
> > [   87.673845]  [<ffffffff8108ba2b>] process_one_work+0x1eb/0x530
> > [   87.673845]  [<ffffffff8108b9c9>] ? process_one_work+0x189/0x530
> > [   87.673845]  [<ffffffff8108c15b>] worker_thread+0x11b/0x4f0
> > [   87.673845]  [<ffffffff8108c040>] ? rescuer_thread+0x290/0x290
> > [   87.673845]  [<ffffffff810939c4>] kthread+0xe4/0x100
> > [   87.673845]  [<ffffffff810938e0>] ? kthread_create_on_node+0x220/0x220
> > [   87.673845]  [<ffffffff817e7c7c>] ret_from_fork+0x7c/0xb0
> > [   87.673845]  [<ffffffff810938e0>] ? kthread_create_on_node+0x220/0x220
> > 
> > -------------------
> > 
> > It's because that we miscalculate @rbio->bbio->error so that it doesn't
> > reach maximum of tolerable errors while it should have.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >   fs/btrfs/raid56.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index 4055291..4a88f07 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -1956,9 +1956,10 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
> >   	 * pages are going to be uptodate.
> >   	 */
> >   	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
> > -		if (rbio->faila == stripe ||
> > -		    rbio->failb == stripe)
> > +		if (rbio->faila == stripe || rbio->failb == stripe) {
> > +			atomic_inc(&rbio->bbio->error);
> >   			continue;
> > +		}
> >   
> >   		for (pagenr = 0; pagenr < nr_pages; pagenr++) {
> >   			struct page *p;
> > 
> 
