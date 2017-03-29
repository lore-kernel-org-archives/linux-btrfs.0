Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29407 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754941AbdC2Jzr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 05:55:47 -0400
Subject: Re: [PATCH 2/4] btrfs: Communicate back ENOMEM when it occurs
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-3-anand.jain@oracle.com>
 <20170328153842.GA4781@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <77251288-c6e6-cdd7-1a60-3cf3d46ee4d0@oracle.com>
Date: Wed, 29 Mar 2017 18:00:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170328153842.GA4781@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/28/2017 11:38 PM, David Sterba wrote:
> On Mon, Mar 13, 2017 at 03:42:12PM +0800, Anand Jain wrote:
>> The only error that write dev flush (send) will fail is due
>> to the ENOMEM then, as its not a device specific error and
>> rather a system wide issue, we should rather stop further
>> iterations and perpetuate the -ENOMEM error to the caller.
>
> I think we should try harder, as flushing is a critical operation and a
> simple yet unlikely memory allocation failure should not stop it.
>
> The device::flush_bio is being allocated each time we start flush and
> freed afterwards. This seems unnecessary. The proper fix IMO is to
> preallocate the bio at the time the device is added to the list. The bio
> lifetime is same as the device'.


  I agree. Also as we are using an empty bio with
  the REQ_PREFLUSH flag we have the opportunity to use
  blkdev_issue_flush() instead. And bio is in fact
  does the prealloc part.
  Will use blkdev_issue_flush() and submit the patch
  again.

Thanks, Anand

