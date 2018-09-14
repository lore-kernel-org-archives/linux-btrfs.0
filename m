Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbeINVUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:20:23 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45177AE25
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:05:14 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:05:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/2] btrfs: Enhance btrfs_trim_fs function to handle
 error better
Message-ID: <20180914160513.GQ5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180907061624.20604-1-wqu@suse.com>
 <20180907061624.20604-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180907061624.20604-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 02:16:23PM +0800, Qu Wenruo wrote:
> +	if (bg_failed)
> +		btrfs_warn(fs_info, "failed to trim %llu block group(s)",
> +			   bg_failed);

> +	if (dev_failed)
> +		btrfs_warn(fs_info, "failed to trim %llu device(s)",
> +			   dev_failed);

Minor update, I've added bg_ret and dev_ret to the messages as this will
end up in the logs and could be useful for later analysis.
