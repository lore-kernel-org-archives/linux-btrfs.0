From: Alex <alex@bpmit.com>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 12:19:54 +0000 (UTC)
Message-ID: <loom.20120317T131420-684@post.gmane.org>
References: <C52pxfli1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen <Hullen <at> t-online.de> writes:

> 

> 
> Where is the problem, how can I use the full space?
> 
> Viele Gruesse!
> Helmut

Effectively it's missing the trigger to rebalance when the 'primary' device
starts to get full, or just to randomly spread the data between the devices.

Isn't this going to be a problem for anyone restoring from a backup? Lots of
data heading to btrfs without a pause.

Helmut, can you tell everyone which version of the kernel & patches you're
running pls.



