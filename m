Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbeHGSQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 14:16:27 -0400
Date: Tue, 7 Aug 2018 18:01:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Remove root parameter from
 btrfs_insert_dir_item
Message-ID: <20180807160123.GL3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-6-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180804131057.9967-6-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 09:10:57PM +0800, Lu Fengqi wrote:
> All callers pass the root tree of dir, we can push that down to the
> function itself.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
