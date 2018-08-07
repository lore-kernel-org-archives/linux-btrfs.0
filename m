Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbeHHBqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2018 21:46:22 -0400
Subject: Re: [PATCH RESEND v8] Add cli and ioctl to forget scanned device(s)
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180806010949.26915-1-anand.jain@oracle.com>
 <20180807175138.GR3218@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <aaea23f4-e76c-3301-5047-c3d3d9f097e9@oracle.com>
Date: Wed, 8 Aug 2018 07:33:08 +0800
MIME-Version: 1.0
In-Reply-To: <20180807175138.GR3218@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/08/2018 01:51 AM, David Sterba wrote:
> On Mon, Aug 06, 2018 at 09:09:47AM +0800, Anand Jain wrote:
>> Adds cli and ioctl to forget a scanned device or forget all stale
>> devices in the kernel.
> 
> Please provide more details about your idea of the usecase, ie. how
> excactly and when the command is supposed to be used.

  Much of this details are in the kernel change log so I didn't add
  here, wonder if you miss that?

> I vaguely recollect that we've discussed the commandline interface but
> don't remember the result. Nevertheless, I think that the 'forget'
> command should be an option of 'device scan'.

  Right. Its here[1]. As I mentioned it had typo ?

  [1]
   https://patchwork.kernel.org/patch/10092511/

>    btrfs device scan --forget /dev/sda

  This syntax is is not in line with our other cli.
  Like: btrfs device add; btrfs device delete;

> Next I'm not sure the freeing all stale devices is a good idea.

   Its not a bad idea though. You suggested it here [1] (above).

< Should
> it be more fine grained?

  The current proposed cli is also fine grained.
     btrfs device forget [device-path]
  Where it checks and releases only [device-path]

> Suppose there are several multi-device
> filesystems on the host and some of them not mounted. The devices have
> been scanned eg. via udev and the filesystems are ready to be mounted.
> Calling 'forget all' will now prevent mount without another 'device
> scan'.

   Right. So if users intention is to mount then he should not call
   btrfs device forget. (with or without any device path).

> What if a particular filesystem needs to forget the scanned devices, or
> just one filesystem:device.

  The current cli in this patch supports this..
     btrfs device forget [device-path]

  So user can forget a device.

> And there's the question how to specify the devices, it can be by device
> path or uuid or maybe device id.

  The forget part is synonym to its 'btrfs device scan [device-path]'.

  The stale devices can be of any type. As of now there is no way user
  can know their stale devices. Only way they can clean them all is
  by running
    btrfs device forget <-- without any option so cleans all unmounted
   device.

  So providing the fsid/uuid option is of no use.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
