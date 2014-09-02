Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27276 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbaIBAKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Sep 2014 20:10:48 -0400
Date: Tue, 2 Sep 2014 10:08:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nikolai Grigoriev <ngrigoriev@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ext4 vs btrfs performance on SSD array
Message-ID: <20140902000822.GA20473@dastard>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 26, 2014 at 07:39:08PM -0400, Nikolai Grigoriev wrote:
> Hi,
> 
> This is not exactly a problem - I am trying to understand why BTRFS
> demonstrates significantly higher throughput in my environment.
> 
> I am observing something that I cannot explain. I am trying to come up
> with a good filesystem configuration using HP P420i controller and
> SSDs (Intel S3500). Out of curiosity I have tried BTRFS (still
> unstable so I can't really expect to be able to use it) and noticed
> that the read speed is about 150% of ext4 - while write speed is
> comparable.
...
> When I read, I observe different picture:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> (ext4 - reading)
> sdb               0.00     0.00 4782.00    0.00   597.75     0.00 256.00     1.57    0.33   0.18  84.10
> (btrfs - reading)
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdc             207.00     0.00 1794.00    0.00   886.40     0.00 1011.90    10.59    5.90   0.56 100.00
> (xfs - reading)
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdd               0.00     0.00 4623.00    0.00   577.88     0.00 256.00     1.71    0.37   0.21  97.00

Pretty obvious difference: avgrq-sz. btrfs is doing 512k IOs, ext4
and XFS are doing is doing 128k IOs because that's the default block
device readahead size.  'blockdev --setra 1024 /dev/sdd' before
mounting the filesystem will probably fix it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
