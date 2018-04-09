Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49777 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751998AbeDIOXz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:23:55 -0400
Date: Mon, 9 Apr 2018 16:21:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Remove duplicate value-get for
 data_extents_scrubbed
Message-ID: <20180409142124.GR8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522663877-1547-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522663877-1547-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2018 at 06:11:17PM +0800, Gu Jinxiang wrote:
> Get data_extents_scrubbed value for twice, since there is only
> one data_extents_scrubbed in struct btrfs_scrub_progress, remove
> the duplicate one.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Applied, thanks.
