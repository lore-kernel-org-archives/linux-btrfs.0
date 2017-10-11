Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757205AbdJKRzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:55:50 -0400
Date: Wed, 11 Oct 2017 19:54:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: free btrfs_device in place
Message-ID: <20171011175404.GZ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010215103.20828-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 03:51:03PM -0600, Liu Bo wrote:
> It's pointless to defer it to a kthread helper as we're not under any
> special context.

I agree the doubly deferred freeing is pointless. It's a weird mix of
RCU and workques and understanding all the interactions turned out to be
hard, last time I tried.

The RCU stuff needs the rcu_barriers, and the callback can be served
from any process context. While the workqueus have their dedicated
kthreads.

Calling free_device() is quick, it just adds the work to the queue and
returns. This makes __btrfs_close_devices/btrfs_rm_device/... and all
other callers fast, at the cost that there must be some explicit barrier
or waiting done when we want to make sure all the device resources have
been freed.

I can't say the quick return is wrong, but it makes the device lifetime
hard to understand. The device freeing callback (__free_device) is
lightweight, but also calls "rcu_free" for the device name.

I have WIP patches to clean up the rcu and locking around devices and
actually document the rules, but with unreviewed pile in the mailinglist
I can't tell when this is going to land. If you want to simplify at
least the device freeing, please go on, and explain in the changelog
that it's not going to break anything. The hand-wavy sentence is not
what I'd expect :)
