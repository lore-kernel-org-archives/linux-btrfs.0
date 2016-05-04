Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbcEDMlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 08:41:24 -0400
Date: Wed, 4 May 2016 14:41:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-progs: fix incorrect flag check
Message-ID: <20160504124106.GS29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212800-26837-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462212800-26837-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 11:13:20AM -0700, Liu Bo wrote:
> The flag OPEN_CTREE_RECOVER_SUPER is set when it's going to recover
> any bad superblock copy, the current code doesn't match that.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied, thanks.
