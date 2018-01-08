Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755038AbeAHSZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 13:25:25 -0500
Date: Mon, 8 Jan 2018 19:23:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: qgroup: move btrfs_show_qgroups's error
 handler to __qgroup_search
Message-ID: <20180108182317.GG13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113053316.14573-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171113053316.14573-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 13, 2017 at 01:33:15PM +0800, Lu Fengqi wrote:
> We have to process the return value of BTRFS_IOC_TREE_SEARCH ioctl in
> advance, so that we can distinguish between the two case where quota
> is not enabled (ioctl return -ENOENT) and either parent qgroup or child
> qgroup does not exist (update_qgroup_relation return -ENOENT). Besides
> this, any error in this routine has been reported, so we don't need to
> report again in cmd_qgroup_show.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

1 and 2 applied, thanks.
