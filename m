Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37784 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751984AbdJELHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 07:07:47 -0400
Received: by mail-io0-f193.google.com with SMTP id m201so3954243iom.4
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Oct 2017 04:07:47 -0700 (PDT)
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
To: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
 <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bd328a02-8823-a3a4-35ff-a9b890f00679@gmail.com>
Date: Thu, 5 Oct 2017 07:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-04 16:11, Liu Bo wrote:
> On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> Write and flush errors are critical errors, upon which the device fd
>> must be closed and marked as failed.
>>
> 
> Can we defer the job of closing device to umount?
> 
> We can go mark the device failed and skip it while doing read/write,
> and umount can do the cleanup work.
> 
> That way we don't need a dedicated thread looping around to detect a
> rare situation.
If BTRFS doesn't close the device, then it's 100% guaranteed if it 
reconnects that it will show up under a different device node.  It would 
also mean that the device node stays visible when there is in fact no 
device connected to it, which is a pain from a monitoring perspective.
