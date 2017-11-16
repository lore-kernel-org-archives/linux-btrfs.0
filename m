Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19779 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932999AbdKPEIm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 23:08:42 -0500
Subject: Re: [PATCH 0/4] factor __btrfs_open_devices()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171109154526.23181-1-anand.jain@oracle.com>
 <20171115170355.GW28899@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b036a131-4557-840e-d2f6-0dcc266646db@oracle.com>
Date: Thu, 16 Nov 2017 12:08:57 +0800
MIME-Version: 1.0
In-Reply-To: <20171115170355.GW28899@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/16/2017 01:03 AM, David Sterba wrote:
> On Thu, Nov 09, 2017 at 11:45:22PM +0800, Anand Jain wrote:
>> This is in preparation to help bring the missing device back to the
>> alloc list dynamically. As of now if we run 'btrfs dev scan </dev/missing>'
>> on a mounted FS, nothing happens, there is no code which handles this
>> condition. So the idea is to fix it by running through the device open
>> process for the reappeared missing device.
>>
>> So this patch separates device open steps into a separate function so that
>> it can be called for a device, instead of for all the devices in the
>> dev_list. As this function is in the critical mount section, and to show
>> the src code changes as clearly as possible, I have created 4 no-functional
>> changes patches, which can be merged together if needed.
> 
> The splitting is fine, I've only merged 2 and 4 to one, but otherwise
> it's clear from each patch if there are no functional changes. 1,3,2+4
> added to next, thanks.

Thanks indeed. (git-diff showed changes which didn't make sense,
I had to split, merge is fine).

Thanks, Anand
