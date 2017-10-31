Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751393AbdJaOVX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:21:23 -0400
Subject: Re: [PATCH v2 1/2] btrfs: match btrfs_device->mode same as it used
 for open
To: Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20171020103325.9595-1-anand.jain@oracle.com>
 <20171020140715.3110-1-anand.jain@oracle.com>
 <20171030143938.GW3521@twin.jikos.cz>
 <0ae0edc8-2557-b3ba-9157-b5ecdf37d31c@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fb901ef0-d4ee-66e8-c8ba-2736d856a5ca@suse.com>
Date: Tue, 31 Oct 2017 16:21:21 +0200
MIME-Version: 1.0
In-Reply-To: <0ae0edc8-2557-b3ba-9157-b5ecdf37d31c@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.10.2017 04:11, Anand Jain wrote:
> 
> 
> On 10/30/2017 10:39 PM, David Sterba wrote:
>> On Fri, Oct 20, 2017 at 10:07:15PM +0800, Anand Jain wrote:
>>> We aren't setting the FMODE_WRITE when initializing btrfs_device
>>> structure and when calling blkdev_put, however we are setting it
>>> only when calling blkdev_get_by_path().
>>
>> But this still does not say why this is a problem worth fixing. Nikolay
>> asked for it, and I would do the same, but why do we even have to ask
>> for that?
> 
>  Here its just a cleanup of miss match of open mode and close modes.>  And there isn't any problem that I noticed.

Even if that's the case, please state that explicitly in your changelog
and also put "No functional changes" if you expect it to not introduce
any change in behavior.


> 
> Thanks, Anand
> 
> 
>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
