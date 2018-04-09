Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751549AbeDIOUO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:14 -0400
Date: Mon, 9 Apr 2018 16:17:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Let function find_device to be consistent
 with kernel
Message-ID: <20180409141743.GQ8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522639812-28309-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522639812-28309-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2018 at 11:30:12AM +0800, Gu Jinxiang wrote:
> Make find_device to be consistent with kernel according
> 35c70103a528 ("btrfs: refactor find_device helper")
> 
> And, modify the compare condition from both devid and uuid to
> devid or devid and uuid according
> 8f18cf13396c ("Btrfs: Make the resizer work based on shrinking and growing devices")
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Applied, thanks.
