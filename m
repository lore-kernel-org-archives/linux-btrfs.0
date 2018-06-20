Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeFTNpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 09:45:12 -0400
Date: Wed, 20 Jun 2018 15:42:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>, fdmanana@gmail.com
Subject: Re: [PATCH 1/4] btrfs: always wait on ordered extents at fsync time
Message-ID: <20180620134221.GX24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523155836.4622-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523155836.4622-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 11:58:33AM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> There's a priority inversion that exists currently with btrfs fsync.  In
> some cases we will collect outstanding ordered extents onto a list and
> only wait on them at the very last second.  However this "very last
> second" falls inside of a transaction handle, so if we are in a lower
> priority cgroup we can end up holding the transaction open for longer
> than needed, so if a high priority cgroup is also trying to fsync()
> it'll see latency.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

1-4 added to misc-next, with Filipe's reviewed-by from the first
iteration.
