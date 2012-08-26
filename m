Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:43175 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab2HZVNy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Aug 2012 17:13:54 -0400
Date: Sun, 26 Aug 2012 17:13:49 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: pass lockdep rwsem metadata to async commit
 transaction
Message-ID: <20120826211349.GA2305@localhost.localdomain>
References: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net>
 <alpine.DEB.2.00.1208241545040.26910@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1208241545040.26910@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2012 at 04:47:56PM -0600, Sage Weil wrote:
> Sadly, now I hit another one:
>

Oh haha you need to set current->journal_info to the trans you have before you
call commit_transaction in do_async_commit.  Thanks,

Josef 
