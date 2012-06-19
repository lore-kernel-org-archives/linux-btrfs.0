Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41421 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2FSNIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 09:08:47 -0400
Date: Tue, 19 Jun 2012 09:08:44 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <josef@redhat.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: fix old data problem caused by aio vs dio
Message-ID: <20120619130844.GE21559@shiny>
References: <4FE07313.2040104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE07313.2040104@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2012 at 06:39:47AM -0600, Miao Xie wrote:
> The 209th case of xfstests failed because of the race between aio and dio. The
> detail reason is following:
> 	Task1		Task2			Btrfs-worker
> 			invalidate pages
> 	read pages
> 			do direct io
> 			invalidate pages*
> 						finish ordered io
> 	read data from
> 	pages
> 
> * This step failed because the kernel found the ordered extent object that
> covered the pages and thought the pages were still under busy. And then Task1
> read the old data from those pages.
> 
> And beside that, I think all the operations including metadata update and
> bit cleanup of extent state should complete before the dio ends.
> 

Thanks for tracking this one down.  I'd really like to keep Josef's
change because it makes a very big difference for latencies.  The read
operation needs to wait until the ordered IO is completely finished.

-chris
