Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31218 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdKGCdX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 21:33:23 -0500
Subject: Re: [PATCH v2] btrfs: cleanup btrfs_async_submit_limit to return the
 final limit value
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171031125946.26844-1-anand.jain@oracle.com>
 <20171102060353.7103-1-anand.jain@oracle.com>
 <20171106153831.GL28789@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b42c69ba-be5b-9a49-d269-aafcfa4b3fd8@oracle.com>
Date: Tue, 7 Nov 2017 10:22:05 +0800
MIME-Version: 1.0
In-Reply-To: <20171106153831.GL28789@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> 1. If the pdflush issue is fixed, we should go back to bdi congestion method,
>> as block layer is more appropriate and accurate to tell when the device is
>> congested. Device q depth 256 is very generic.
>> 2. Consider RAID1 devices at different speed (SSD and iscsi LUN) not too sure
>> if this approach would lead to the FS layer IO performance  throttle at the
>> speed of the lowest ? wonder how to reliably test it.
> 
> The referenced commits are from 2008, there have been many changes in
> the queue flushing etc, so we might need to revisit the current
> behaviour completely. Using the congestion API is desired, but we also
> need to keep the IO behaviour (or make it better of course). In such
> case I'd suggest small steps so we can possibly catch the regressions.

  Ok. Will try. Its still confusing to me.

Thanks, Anand

