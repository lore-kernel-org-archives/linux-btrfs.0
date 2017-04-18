Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53493 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753486AbdDRODP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:03:15 -0400
Date: Tue, 18 Apr 2017 16:03:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 6/7] btrfs: delete unused member nobarriers
Message-ID: <20170418140311.GV4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170406032253.14631-1-anand.jain@oracle.com>
 <20170406032253.14631-7-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406032253.14631-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 11:22:52AM +0800, Anand Jain wrote:
> The last consumer of nobarriers is removed by the commit [1] and sync
> won't fail with EOPNOTSUPP anymore. Thus, now when write cache is write
> through it just return success without actually transpiring such a
> request to the block device/lun.
> 
> [1]
> commit b25de9d6da49b1a8760a89672283128aa8c78345
> block: remove BIO_EOPNOTSUPP
> 
> And, as the device/lun write cache state may change dynamically saving
> such as state won't help either. So deleting the member nobarriers.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
