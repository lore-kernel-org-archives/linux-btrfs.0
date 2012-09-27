Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50558 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2I0NQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 09:16:25 -0400
Date: Thu, 27 Sep 2012 09:16:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH] Btrfs: fix wrong calculation of the available space when
 reserving the space
Message-ID: <20120927131622.GE2328@localhost.localdomain>
References: <506417BB.5050408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <506417BB.5050408@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 27, 2012 at 03:09:15AM -0600, Miao Xie wrote:
> According to the comment, we can overcommit the space up to 1/2 of the total
> disk space, or we just can overcommit up to 1/8. But the code was written
> reversedly. Fix it.
> 

Sorry the comment is wrong, I was actually just looking at this the other day
:).  Basically we want non-flushers to be able to overcommit more to give those
guys more of a chance of being able to make an allocation, but we want flushers
to not be able to overcommit too much since they are allowed to make more
headroom, so the logic is right, the comment is wrong.  Thanks,

Josef
