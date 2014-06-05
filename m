Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39244 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752117AbaFESNk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 14:13:40 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:65212 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WscAU-001Uwb-F0
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 12:13:38 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Using BTRFS on SSD now ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140605145632.GD14713@merlins.org>
Date: Thu, 5 Jun 2014 12:13:37 -0600
Message-Id: <FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 5, 2014, at 8:56 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> compression: lzo, not zlib (zlib will slow down your SSD)

I've had mixed results, where benchmarking suggests lzo is faster, but then zlib actually feels faster. For sure forced zlib compression can be dreadful, but I kinda expect that and therefore don't use it. These days I'm not using any compression. I think a lot of the benchmarks suggesting one way or the other are just the wrong benchmarks to look at for this sort of thing, as they aren't testing the actual workloads that are typical.



> snapshots:
> http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots
> auto-defrag: not really (read the archives)

Definitely there are some issues, it's probably why its not yet default. So I'd either not use it, or use it with the point of testing it to make it better.


> other options: leave default
> add -o discard to mount options

I disagree. The older the SSD almost certainly the worse its TRIM behavior will be, resulting in hangs possibly long hangs. There's a whole bunch of stuff written on lkml about non-queued TRIM ugliness. I think most users are better off issuing fstrim once a week until queued TRIM devices are in the wild and well tested.

The one case were file system discard is useful is not so much to inform the physical device but the next lower layer logical block device like md raid or LVM thinp so that the right unused blocks are freed up.

> 
> Do not use LVM, it's totally unnecessary and will slow you down. Dmcrypt is
> ok, however add discard to cryptsetup options too:
> root2		 /dev/sda2		/pwd		luks,discard

So again in this case I'd say don't use discard. Or at the very least, test it first. My SSD is reportedly not so bad in this regard, but I find even 2-3 second hang of *all* read/write events when deleting a bunch of files to be abhorrent. Some people report much, much longer delays as the SSD then also does immediate and aggressive GC.

I'd say, what slight additional wear occurs from not using discard, makes the SSD die sooner in order to justify getting a new SSD that maybe (?) doesn't have this problem anymore.

Chris Murphy

