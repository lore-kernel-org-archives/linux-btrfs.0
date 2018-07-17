Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729640AbeGQPs4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 11:48:56 -0400
Date: Tue, 17 Jul 2018 17:15:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: cleanup the unused srcroot from
 btrfs_qgroup_inherit
Message-ID: <20180717151542.GB3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180717085822.21670-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180717085822.21670-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 04:58:22PM +0800, Lu Fengqi wrote:
> Since commit 0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info
> convenience variables"), the srcroot is no longer used to get fs_fino.
> In fact, it can be dropped after commit 707e8a071528 ("btrfs: use nodesize
> everywhere, kill leafsize").
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
