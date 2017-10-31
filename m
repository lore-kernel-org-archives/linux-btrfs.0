Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27022 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752919AbdJaCLp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 22:11:45 -0400
Subject: Re: [PATCH v2 1/2] btrfs: match btrfs_device->mode same as it used
 for open
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171020103325.9595-1-anand.jain@oracle.com>
 <20171020140715.3110-1-anand.jain@oracle.com>
 <20171030143938.GW3521@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0ae0edc8-2557-b3ba-9157-b5ecdf37d31c@oracle.com>
Date: Tue, 31 Oct 2017 10:11:45 +0800
MIME-Version: 1.0
In-Reply-To: <20171030143938.GW3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/30/2017 10:39 PM, David Sterba wrote:
> On Fri, Oct 20, 2017 at 10:07:15PM +0800, Anand Jain wrote:
>> We aren't setting the FMODE_WRITE when initializing btrfs_device
>> structure and when calling blkdev_put, however we are setting it
>> only when calling blkdev_get_by_path().
> 
> But this still does not say why this is a problem worth fixing. Nikolay
> asked for it, and I would do the same, but why do we even have to ask
> for that?

  Here its just a cleanup of miss match of open mode and close modes.
  And there isn't any problem that I noticed.

Thanks, Anand


> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
