Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:48106 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdJIL6z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 07:58:55 -0400
Received: by mail-it0-f42.google.com with SMTP id p138so13347250itp.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Oct 2017 04:58:55 -0700 (PDT)
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
To: bo.li.liu@oracle.com
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
 <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <bd328a02-8823-a3a4-35ff-a9b890f00679@gmail.com>
 <20171006233357.GB19068@lim.localdomain>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c4f262c-2843-0876-8914-761b371f9371@gmail.com>
Date: Mon, 9 Oct 2017 07:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <20171006233357.GB19068@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-06 19:33, Liu Bo wrote:
> On Thu, Oct 05, 2017 at 07:07:44AM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-10-04 16:11, Liu Bo wrote:
>>> On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
>>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>>
>>>> Write and flush errors are critical errors, upon which the device fd
>>>> must be closed and marked as failed.
>>>>
>>>
>>> Can we defer the job of closing device to umount?
>>>
>>> We can go mark the device failed and skip it while doing read/write,
>>> and umount can do the cleanup work.
>>>
>>> That way we don't need a dedicated thread looping around to detect a
>>> rare situation.
>> If BTRFS doesn't close the device, then it's 100% guaranteed if it
>> reconnects that it will show up under a different device node.  It would
>> also mean that the device node stays visible when there is in fact no device
>> connected to it, which is a pain from a monitoring perspective.
> 
> I see, you're assuming that these errors are due to disconnection of
> disks, it could be bad sectors (although almost impossible from
> enterprise hard disks) or some other errors across the stack.
And we need to handle any of these cases.  If BTRFS is going to claim 
handling of device failures, it needs to handle all types of device 
failure it reasonably can without making assumptions about what type of 
failure occurred.
> 
> I do agree that cleanup needs to be done if disk got disconnected, but
> not doing cleanup here, a udev rule is needed to handle such an event.
And why exactly does it need to involve userspace beyond notifying that 
something bad happened?  We know the failure happened, why should we 
tell userspace about it and require userspace to tell us to handle it? 
It's not like this is a performance critical path since it won't happen 
very often, and the primary concern is data safety, not performance, so 
why exactly do we need to push something that isn't a policy decision 
(and arguably isn't a decision, if we're not using a device, we 
shouldn't be holding it open, period) out to userspace?

Looking at it a bit differently though, every time I've seen any write 
or flush errors, either the connection to the device was unstable, or 
the storage device was failing, and neither case is something that 
should require userspace to make a decision about how to handle things.

To be entirely honest though, from a system administrator's perspective, 
I would actually expect a device getting disconnected (or otherwise 
disappearing off the bus) to end up in a 'Missing' state, not a 'Failed' 
state.  I see no reason to treat it any differently than if it 
disappeared before the volume was mounted, other than the requirement to 
actually handle it.  That type of handling _will_ require userspace 
involvement (because I seriously doubt there will ever be proper 
notification from the block layer to holders that a device is gone), but 
that's also largely orthogonal to this patch set (there's no reason that 
we need to handle write or flush errors the same way).
