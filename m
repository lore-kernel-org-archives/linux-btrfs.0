Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52860 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751692AbaLYDL0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 22:11:26 -0500
Date: Wed, 24 Dec 2014 21:15:45 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141225031545.GB5864@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com>
 <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com>
 <20141221225315.GA19479@pyropus.ca> <549827C3.6060009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549827C3.6060009@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> This actually sounds kind of like the issues I have sometimes on my
> laptop using btrfs on an SSD, I've mostly resolved them by tuning IO
> scheduler parameters, as the default IO scheduler (the supposedly
> Completely Fair Queue, which was obviously named by a mathematician
> who had never actually run the algorithm) has some pretty brain-dead
> default settings.  The other thing I would suggest looking into
> regarding the variability is tuning the kernel's write-caching
> settings

Ok, that's something I will examine.  I knew CFQ is completely wrong for SSD
use, but I thought it was still one of the better schedulers for spinning
disks.  Apparently that may not be the case.

Thanks,

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
