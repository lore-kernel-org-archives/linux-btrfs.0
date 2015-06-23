Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbbFWOwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 10:52:49 -0400
Date: Tue, 23 Jun 2015 16:52:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Robbie Ko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 7/7] Btrfs: incremental send, avoid the overhead of
 allocating an orphan_dir_info object unnecessarily
Message-ID: <20150623145247.GF6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
 <1435055991-10109-8-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435055991-10109-8-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 06:39:51PM +0800, Robbie Ko wrote:
> Avoid the overhead of allocating an orphan_dir_info object unnecessarily.
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
