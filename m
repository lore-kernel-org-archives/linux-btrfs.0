Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59883 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932105AbcJFWkP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 18:40:15 -0400
Date: Fri, 7 Oct 2016 09:40:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tim Small <tim@seoss.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Making statfs return qgroup info (for container use case etc.)
Message-ID: <20161006224011.GF9806@dastard>
References: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 02:51:58PM +0100, Tim Small wrote:
> Hello,
> 
> I use btrfs for containers (e.g. full OS style containers using lxc/lxd
> etc. rather than application containers).  btrfs de-duplication and
> send/receive are very useful features for this use-case.
> 
> Each container runs in its own subvolume, and I use quotas to stop one
> container exhausting the disk space of the others.
> 
> df shows the total space + free space for the entire filesystem - which
> is confusing for users within the containers.  Worse - they don't have
> any way of knowing how much quota they actually have left (other than du
> -xs / vs. whatever I've told them).
> 
> It'd be really nice if running e.g. statfs("/home", ...) within a
> container could be made to return the qgroup usage + limit for the path
> (e.g. by passing in an option at mount time - such as qgroup level
> maybe?) , instead of the global filesystem data in f_bfree f_blocks etc.

XFS does this with directory tree quotas. It was implmented 10 years
ago or so, IIRC...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
