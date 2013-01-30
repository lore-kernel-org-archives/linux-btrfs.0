Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48185 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3A3TJn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 14:09:43 -0500
Date: Wed, 30 Jan 2013 14:09:40 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Mike Lowe <j.michael.lowe@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>, Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Subject: Re: corrupted file size on inline extent conversion?
Message-ID: <20130130190940.GJ3660@localhost.localdomain>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net>
 <20130129145429.GD3660@localhost.localdomain>
 <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com>
 <20130130182213.GI3660@localhost.localdomain>
 <949A937F-7E0F-47E9-B63F-EC58E3B6370C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <949A937F-7E0F-47E9-B63F-EC58E3B6370C@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 11:30:49AM -0700, Mike Lowe wrote:
> I've been running rsync against a rbd device backed by btrfs filesystems that are about 11% full for about 45 minutes before I checked and noticed the printk message.  That was the first go with the patch.  Seems like I was able to get by without any problems until the btrfs filesystems got some use and filled up a little bit.
> 

Ok since you are seeing the message I'll go ahead and post the patch and get it
moving along, let me know if you still see the problem.  Thanks,

Josef
