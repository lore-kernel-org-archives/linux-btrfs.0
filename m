Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750758AbdDROEO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:04:14 -0400
Date: Tue, 18 Apr 2017 16:04:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 7/7] btrfs: check if the device is flush capable
Message-ID: <20170418140410.GW4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170406032253.14631-1-anand.jain@oracle.com>
 <20170406032253.14631-8-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406032253.14631-8-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 11:22:53AM +0800, Anand Jain wrote:
> The blkdev_issue_flush() will check if the write cache is enabled
> before submitting the flush. This will add a code to fail fast if
> its not.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---

Reviewed-by: David Sterba <dsterba@suse.com>
