Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58302 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3CLSB3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 14:01:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8681B9A04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 12:01:29 -0600 (MDT)
Date: Tue, 12 Mar 2013 14:01:24 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130312180124.GB12725@shiny.masoncoding.com>
References: <20130312170312.GO7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130312170312.GO7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 11:03:12AM -0600, David Sterba wrote:
> Hi,
> 
> while testing the userspace scrub updates, I've found lots of parent
> transid verify failures (see below) that are likely unrelated to the
> userspace patches.
> 
> The filesystem was freshly created with raid10/raid10 profiles on 4x10G
> partitions (sda5...8) and there was
> 
> fs_mark -D 5000 -S0 -n 100000 -s 0 -L 200 -d /mnt/a1/scratch/0
> (16x -d ...)
> 
> running when I started scrub on /dev/sda5, ran status a few times and
> then ran scrub cancel.
> 
> Cancel hung
> 
> kernel is 3.9-rc2 + chris/for-linus + btrfs-next/master
> 

Please go back to just 3.9-rc2 and see if you can trigger it.  Josef put
his skinny extents into btrfs-next/master, which is pretty exciting but
may be related to these failures.

I'm unable to reproduce here so far.

-chris
