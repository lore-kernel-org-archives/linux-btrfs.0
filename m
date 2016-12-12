Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751680AbcLLNQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 08:16:33 -0500
Date: Mon, 12 Dec 2016 14:16:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        fdmanana@gmail.com
Subject: Re: [PATCH] Btrfs: fix lockdep warning about log_mutex
Message-ID: <20161212131626.GP12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 01:45:04PM -0800, Liu Bo wrote:
> +		mutex_lock_nested(&BTRFS_I(inode)->log_mutex, 1);

Please also use SINGLE_DEPTH_NESTING here.
