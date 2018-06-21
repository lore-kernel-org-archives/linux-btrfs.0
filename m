Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933187AbeFUR1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 13:27:32 -0400
Date: Thu, 21 Jun 2018 19:24:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [v2] btrfs: use monotonic time for transaction
 handling
Message-ID: <20180621172440.GT24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180621160420.139575-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180621160420.139575-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 21, 2018 at 06:04:05PM +0200, Arnd Bergmann wrote:
> The transaction times were changed to ktime_get_real_seconds to avoid
> the y2038 overflow, but they still have a minor problem when they go
> backwards or jump due to settimeofday() or leap seconds.
> 
> This changes the transaction handling to instead use ktime_get_seconds(),
> which returns a CLOCK_MONOTONIC timestamp that has neither of those
> problems.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: Rebased on top of an earlier patch by Allen Pais, which
>     also obsoleted the original patch 2/3

1 and 2 added to patch queue, thanks.
