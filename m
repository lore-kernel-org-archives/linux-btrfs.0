Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dalmat.net ([88.183.56.135]:44886 "EHLO athena.dalmat.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3HZVn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 17:43:26 -0400
Received: from [192.168.0.23] (nyx.dalmat.net [192.168.0.23])
	by athena.dalmat.net (Postfix) with ESMTP id DD9223FCDC
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 23:43:22 +0200 (CEST)
Message-ID: <521BCBFA.8040506@dalmat.net>
Date: Mon, 26 Aug 2013 23:43:22 +0200
From: Matthieu Dalstein <matthieu.dalstein@dalmat.net>
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Ability to free space on a full btrfs filesystem
References: <521A2F78.908@dalmat.net> <502292E7-02F9-4398-905B-BA58D186CA7E@colorremedies.com>
In-Reply-To: <502292E7-02F9-4398-905B-BA58D186CA7E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I don't know if removing a snapshot will necessarily help but it may be worth a try and see if these numbers change enough to allow file deletion.

Actually the snapshots could not be removed due to the unsufficient 
remaining space.


> Another way out of this that's worked for some people in the past is to btrfs device add another disk to the volume. Maybe just 1GB of USB stick space is enough so that it can allocate another metadata chunk. But I'd give it as much of the fastest storage you have: can be any disk partition, or LV. But I've also done it with a USB stick partition.
>
> After it's added, see if you can do a balance, which should free most of those 141GB of data chunks. And then you can btrfs device delete the recently added device, which will move whatever data/metadata chunks are on it, back to the primary device for the volume.

Thanks for the tip. I would have expected another less intrusive 
recovery but this one worked well. I did not fully rebalance the fs 
(could have lasted days!) but with the d/m usage balance parameters I 
managed to get back to a good state.

I guess this means I should find ways to avoid full fs unless there is a 
plan to recover gracefully from such situations.

Thanks
-- 
Matthieu
