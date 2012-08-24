Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55947 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab2HXSmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 14:42:11 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id VWFRZSHbT6ZhwW1x (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 12:42:10 -0600 (MDT)
Date: Fri, 24 Aug 2012 14:42:08 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: turbo charge fsync
Message-ID: <20120824184208.GA22819@shiny>
References: <1345833808-1539-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1345833808-1539-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2012 at 12:43:28PM -0600, Josef Bacik wrote:
> 
>                 Original        Patched
> SATA drive      82KB/s          140KB/s
> Fusion drive    431KB/s         2532KB/s
> 
> So around 2-6 times faster depending on your hardware.  There are a few
> corner cases, for example if you truncate at all we have to do it the old
> way since there is no way to be sure what is in the log is ok.  This
> probably could be done smarter, but if you write-fsync-truncate-write-fsync
> you deserve what you get.  All this work is in RAM of course so if your
> inode gets evicted from cache and you read it in and fsync it we'll do it
> the slow way if we are still in the same transaction that we last modified
> the inode in.

I think I sent Liubo down the wrong path on this one, and Josef and I
banged out some ideas for a different (hopefully less complex) way to
solve the problem.  Josef, these results look fantastic.

-chris
