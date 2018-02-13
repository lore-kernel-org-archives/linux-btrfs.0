Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934765AbeBMQbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 11:31:11 -0500
Date: Tue, 13 Feb 2018 17:28:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: declare max_inline as u32
Message-ID: <20180213162855.GX3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213094950.9412-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213094950.9412-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 05:49:49PM +0800, Anand Jain wrote:
> As of now btrfs_fs_info::max_line is u64, which can't be
> larger than btrfs_fs_info::sectorsize which is defined as
> u32, so make btrfs_fs_info::max_line u32,
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
