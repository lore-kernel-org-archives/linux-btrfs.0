Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751484AbdJ3MxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 08:53:02 -0400
Date: Mon, 30 Oct 2017 13:51:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: clean up btrfs_dev_stat_inc() usage
Message-ID: <20171030125111.GQ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020095059.3730-1-anand.jain@oracle.com>
 <20171020174533.7766-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020174533.7766-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 21, 2017 at 01:45:33AM +0800, Anand Jain wrote:
> btrfs_end_bio() is using btrfs_dev_stat_inc() and then
> btrfs_dev_stat_print_on_error() separately instead use
> btrfs_dev_stat_inc_and_print() directly.
> 
> As of now there isn't any bio in btrfs which is - a non-empty write and
> also the REQ_PREFLUSH flag is set. So in actual the condition
>    if (bio->bi_opf & REQ_PREFLUSH)
> is never true in btrfs_end_bio(), and so there won't be any redundant error
> log by using btrfs_dev_stat_inc_and_print() separately one for write and
> another for flush.
> 
> This consolidation will help to add the device critical error handles in the
> function btrfs_dev_stat_inc_and_print() and which can be renamed as needed.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
