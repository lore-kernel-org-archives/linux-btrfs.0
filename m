Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:32992 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3BRPdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 10:33:17 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A705E9A03ED
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 08:33:16 -0700 (MST)
Date: Mon, 18 Feb 2013 10:33:13 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: place ordered operations on a per transaction list
Message-ID: <20130218153034.GA3188@localhost.localdomain>
References: <1360772002-8923-1-git-send-email-jbacik@fusionio.com>
 <51220EE1.6090607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51220EE1.6090607@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 18, 2013 at 04:22:09AM -0700, Miao Xie wrote:
> On wed, 13 Feb 2013 11:13:22 -0500, Josef Bacik wrote:
> > Miao made the ordered operations stuff run async, which introduced a
> > deadlock where we could get somebody (sync) racing in and committing the
> > transaction while a commit was already happening.  The new committer would
> > try and flush ordered operations which would hang waiting for the commit to
> > finish because it is done asynchronously and no longer inherits the callers
> > trans handle.  To fix this we need to make the ordered operations list a per
> > transaction list.  We can get new inodes added to the ordered operation list
> > by truncating them and then having another process writing to them, so this
> > makes it so that anybody trying to add an ordered operation _must_ start a
> > transaction in order to add itself to the list, which will keep new inodes
> > from getting added to the ordered operations list after we start committing.
> > This should fix the deadlock and also keeps us from doing a lot more work
> > than we need to during commit.  Thanks,
> 
> Firstly, thanks to deal with the bug which was introduced by my patch.
> 
> But comparing with this fix method, I prefer the following one because:
> - we won't worry the similar problem if we add more work during commit
>   in the future.
> - it is unnecessary to get a new handle and commit it if the transaction
>   is under the commit.

Mine has the benefit of not making a committing transaction flush more stuff
that it doesn't need to, so I think I'll keep mine as well, but I agree yours is
good for the attach case as well.  So can you send this along properly with a
signed off and such and we can have our cake and eat it too.  Thanks,

Josef
