Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18177 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab3ECHy7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 03:54:59 -0400
Date: Fri, 3 May 2013 15:54:52 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/2] Online data deduplication
Message-ID: <20130503075451.GC16411@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
 <20130501173729.GJ2580@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130501173729.GJ2580@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> You didn't use an INCOPMAT option for this so you need to deal with a user
> mounting the file system with an older kernel or even forgetting to use mount -o
> dedup.  Otherwise your dedup tree will become out of date and you could corrupt
> peoples data.  So if you aren't going to use an INCOMPAT flag you need to at
> least use a COMPAT flag so we know the option has been used at all and then you
> need to have a mechanism to know if you need to invalidate the hash tree.
> 
> Users are also going to make the mistake of thinking dedup will make their
> workload awesome, and when it doesn't they need a way to turn it off.  If you do
> an INCOMPAT option then you need to have a way to delete the hash tree and unset
> the INCOMPAT flag.  If you do the COMPAT route then you get this for free since
> the user just needs to stop using -o dedup, but you'll probably also want to
> provide a mechanism to delete the tree to free up space.  Thanks,
> 
> Josef

I made a few mistakes on this, yeah I should also provide a dedup disable way
and I'm going to use INCOMPAT.

But forgetting to use mount -o dedup will not get dedup tree to be out of date,
because dedup tree is loaded if we have it, no matter whether using 'mount -o
dedup'.

Thanks for the nice reminder, Josef :)

thanks,
liubo
