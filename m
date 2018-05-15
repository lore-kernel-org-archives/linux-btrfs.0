Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbeEOSLq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 14:11:46 -0400
Date: Tue, 15 May 2018 20:09:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add parent_transid parameter to veirfy_level_key
Message-ID: <20180515180905.GW6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 01:37:37AM +0800, Liu Bo wrote:
> @parent_transid could tell whether the eb's generation has been verified
> by the caller.

Can you please write why you add this change? Like is it an enhancement
or debugging help or someting like that.
