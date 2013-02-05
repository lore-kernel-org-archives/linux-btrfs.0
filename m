Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:52066 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3BEAEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 19:04:43 -0500
Date: Mon, 4 Feb 2013 16:04:43 -0800 (PST)
From: Sage Weil <sage@inktank.com>
To: Josef Bacik <jbacik@fusionio.com>
cc: Mike Lowe <j.michael.lowe@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Subject: Re: corrupted file size on inline extent conversion?
In-Reply-To: <20130130190940.GJ3660@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1302041602350.14733@cobra.newdream.net>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net> <20130129145429.GD3660@localhost.localdomain> <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com> <20130130182213.GI3660@localhost.localdomain> <949A937F-7E0F-47E9-B63F-EC58E3B6370C@gmail.com>
 <20130130190940.GJ3660@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Jan 2013, Josef Bacik wrote:
> On Wed, Jan 30, 2013 at 11:30:49AM -0700, Mike Lowe wrote:
> > I've been running rsync against a rbd device backed by btrfs filesystems that are about 11% full for about 45 minutes before I checked and noticed the printk message.  That was the first go with the patch.  Seems like I was able to get by without any problems until the btrfs filesystems got some use and filled up a little bit.
> > 
> 
> Ok since you are seeing the message I'll go ahead and post the patch and 
> get it moving along, let me know if you still see the problem.  Thanks,

Awesome.  Mike still hasn't seen a reocurrence, so it's looking like the 
patch is good.

Thanks so much!
sage
