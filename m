Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50292 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbFXDYY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 23:24:24 -0400
Date: Tue, 23 Jun 2015 20:24:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: Cao jin <caoj.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Question about "btrfs send/receive"
Message-ID: <20150624032423.GH20517@merlins.org>
References: <5589078B.2090806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5589078B.2090806@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 03:15:23PM +0800, Cao jin wrote:
> Hi all,
>     I am considering implement the btrfs send/receive command in 
> libguestfs(http://libguestfs.org/), and found that incremental send 
> seems pretty complicated. So my questions is:
> 1. What is the most usually usage of btrfs send/receive?
> 2. Does it make sense to implement the simplest form?
>      $ btrfs send -f sent_file subvol

Sure, have a look at this:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
