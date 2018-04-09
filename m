Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbeDIOla (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:41:30 -0400
Date: Mon, 9 Apr 2018 16:39:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Do not add extra slash if given path end
 with it
Message-ID: <20180409143900.GU8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522314679-762-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522314679-762-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 05:11:19PM +0800, Gu Jinxiang wrote:
> When use a given path end with a slash like below,
> the output of path will have double slash.
> 
> Do not add extra slash if there is already one in the given
> path.
> 
> $ btrfs filesystem du ./test/
> output:
> Total   Exclusive  Set shared  Filename
> 0.00B       0.00B           -  /home/gujx/device/tmp/test//foo
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Applied, thanks.

I was wondering if we should remove all trailing slashes, but I think
that the chance of that happening often is too low. The tab completion
will append only a single tab and that's about the case I'd care.
