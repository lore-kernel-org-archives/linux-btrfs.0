Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932515AbeE2J2G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 05:28:06 -0400
Date: Tue, 29 May 2018 11:25:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] UUID tree fs_info cleanup
Message-ID: <20180529092517.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2018 at 03:01:52PM +0800, Lu Fengqi wrote:
> Just remove the redundant fs_info argument from uuid_tree functions
> because these functions have already taken transaction which has a
> reference to the fs_info.

Thanks. I've also renamed the function btrfs_uuid_tree_rem to
btrfs_uuid_tree_remove.
