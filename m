Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42032 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaJVHOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 03:14:17 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id ECBD93C1D16
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 09:14:14 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 5 =?UTF-8?Q?=5Fthousand=5F=20snapshots=3F=20even=20=31=36=30?=  =?UTF-8?Q?=3F=20=28was=3A=20device=20balance=20times=29?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 22 Oct 2014 09:14:14 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> But 5000 snapshots?
> 
> Why?  Are you *TRYING* to test btrfs until it breaks, or TRYING to
> demonstrate a balance taking an entire year?

Remember a given btrfs filesystem is not necessarily a backup 
destination for data from one source.

It can be, say, 30 or 60 daily snapshots, plus several monthly, for each 
data source * number of data sources.

So while it probably will make a difference (5000 snapshots from one 
source, vs 5000 snapshots made from many sources) for balance times, I 
wouldn't call a large number of snapshots that unusual.

-- 
Tomasz Chmielewski
http://www.sslrack.com

