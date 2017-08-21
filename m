Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753245AbdHUPvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:51:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B1FDACFF
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 15:51:13 +0000 (UTC)
Date: Mon, 21 Aug 2017 17:49:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: pass fs_info to btrfs_del_root instead of
 tree_root
Message-ID: <20170821154949.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170802195453.32471-1-jeffm@suse.com>
 <d03588ec-2449-41ab-fd1a-8fefc5b879fa@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d03588ec-2449-41ab-fd1a-8fefc5b879fa@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 17, 2017 at 10:25:11AM -0400, Jeff Mahoney wrote:
> btrfs_del_roots always uses the tree_root.  Let's pass fs_info instead.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
