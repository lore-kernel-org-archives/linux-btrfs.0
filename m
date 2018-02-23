Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50287 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbeBWW6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:58:31 -0500
Date: Fri, 23 Feb 2018 23:56:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: remove assert in
 btrfs_init_dev_replace_tgtdev()
Message-ID: <20180223225612.GQ1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180220145036.9431-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180220145036.9431-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 20, 2018 at 10:50:36PM +0800, Anand Jain wrote:
> In the same function we just ran btrfs_alloc_device() which means the
> btrfs_device::resized_list is sure to be empty and we are protected
> with the btrfs_fs_info::volume_mutex.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
