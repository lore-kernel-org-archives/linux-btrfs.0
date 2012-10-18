Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58670 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2JRN2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 09:28:54 -0400
Date: Thu, 18 Oct 2012 09:28:50 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Marguerite Su <i@marguerite.su>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: initramfs take a long time to load[135s]
Message-ID: <20121018132850.GA22010@shiny>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 18, 2012 at 05:29:50AM -0600, Marguerite Su wrote:
> Hi, all,
> 
> I ran into a situation that no useful information can be found over
> the internet...
> 
> I'm using 3.6.2 + btrfs git compiled using dkms, and I have a 300GB
> btrfs /home and 50GB btrfs /:

Usually when btrfs is slow to mount, or slow right after a mount it is
because we're regenerating the free space cache.  This is slow enough
that you should be able to see the free space cache threads active even
after the initial boot is done.

The good news is that you should be able to just let them finish
generating the cache and then the problem should go away.

If it isn't the free space cache, it'll be a fragmentation problem.  The
easiest way to tell the difference is to get a few sysrq-w snapshots
during the boot.

-chris
