Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53265 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751456AbdDROBj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:01:39 -0400
Date: Tue, 18 Apr 2017 16:01:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 5/7] btrfs: use q which is already obtained from
 bdev_get_queue
Message-ID: <20170418140135.GU4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170406032253.14631-1-anand.jain@oracle.com>
 <20170406032253.14631-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406032253.14631-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 11:22:51AM +0800, Anand Jain wrote:
> We have already assigned q from bdev_get_queue() so use it.
> And rearrange the code for better view.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.com>

JFYI, this patch has been added to 4.12
