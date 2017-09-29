Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41080 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752113AbdI2Rkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:40:40 -0400
Date: Fri, 29 Sep 2017 19:39:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] btrfs: undo writable when sprouting fails
Message-ID: <20170929173904.GT31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170928065111.10224-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170928065111.10224-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 02:51:09PM +0800, Anand Jain wrote:
> When new device is being added to seed FS, seed FS is marked writable,
> but when we fail to bring in the new device, we missed to undo the
> writable part. This patch fixes it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Thanks, 1-3 added to the queue.
