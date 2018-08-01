Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388930AbeHAOwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 10:52:42 -0400
Date: Wed, 1 Aug 2018 15:06:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: replace: Reset on-disk dev stats value after
 replace
Message-ID: <20180801130653.GF3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1533020736.git.misono.tomohiro@jp.fujitsu.com>
 <e913d7ad-24b0-d361-9841-e15882b521fc@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e913d7ad-24b0-d361-9841-e15882b521fc@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2018 at 04:20:21PM +0900, Misono Tomohiro wrote:
> on-disk devs stats value is updated in btrfs_run_dev_stats(),
> which is called during commit transaction, if device->dev_stats_ccnt
> is not zero.
> 
> Since current replace operation does not touch dev_stats_ccnt,
> on-disk dev stats value is not updated. Therefore "btrfs device stats"
> may return old device's value after umount/mount
> (Example: See "btrfs ins dump-t -t DEV $DEV" after btrfs/100 finish).

In such cases it's good to have a snippet of the output, so it's
possible to match the output and check if we see the same thing.

Otherwise looks ok, thanks.
