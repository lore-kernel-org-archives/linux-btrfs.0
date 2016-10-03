Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbcJCQUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Oct 2016 12:20:40 -0400
Date: Mon, 3 Oct 2016 18:20:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix a possible umount deadlock
Message-ID: <20161003162037.GB6576@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160922045613.25861-1-anand.jain@oracle.com>
 <b16b4d32-9990-25d3-2973-f2bae1e6fba5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b16b4d32-9990-25d3-2973-f2bae1e6fba5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 12:24:07PM -0400, Jeff Mahoney wrote:
> This isn't necessarily a comment on this code in particular, but what's
> the reason for using call_rcu to defer the freeing instead of
> synchronize_rcu and freeing the device directly via __free_device (if it
> accepted a btrfs_device)?  It's a pattern that's used throughout
> volumes.c and it's old[1].  I'm not sure if it was intentional to defer
> freeing since that was actually a functional change from the code it
> replaced.

It could be unintentional, the patch was supposed to relax the read-only
side, ie. use RCU instead of mutex. Deferred freeing does not seem to be
necessary. The device locking code needs cleanup/refactoring.
