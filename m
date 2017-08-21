Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53639 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751738AbdHUOzD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 10:55:03 -0400
Date: Mon, 21 Aug 2017 16:53:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 5/7] Btrfs: remove BUG() in add_data_reference
Message-ID: <20170821145339.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-6-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-6-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:22PM -0600, Liu Bo wrote:
> Now that we have a helper to report invalid value of extent inline ref
> type, we need to quit gracefully instead of throwing out a kernel panic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
