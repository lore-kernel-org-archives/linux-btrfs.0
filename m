Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756667AbcIVPhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 11:37:36 -0400
Date: Thu, 22 Sep 2016 17:35:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs: fix a possible umount deadlock
Message-ID: <20160922153534.GR16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160922045613.25861-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160922045613.25861-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 12:56:13PM +0800, Anand Jain wrote:
> btrfs_show_devname() is using the device_list_mutex, sometimes
> a call to blkdev_put() leads vfs calling into this func. So
> call blkdev_put() outside of device_list_mutex, as of now.
> 
[...]
> 
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
