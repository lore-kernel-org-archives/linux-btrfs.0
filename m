Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34455 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbcCWFmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 01:42:12 -0400
Received: by mail-io0-f176.google.com with SMTP id m184so18178275iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 22:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F21FC5.50209@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
Date: Tue, 22 Mar 2016 23:42:11 -0600
Message-ID: <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Chris Murphy <lists@colorremedies.com>
To: bradtem@gmail.com
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 10:47 PM, Brad Templeton <bradtem@gmail.com> wrote:
> That's rather counter intuitive behaviour.  In most FSs, resizes are
> needed when you do things like change the size of an underlying
> partition, or you weren't using all the partition.  When you add one
> drive with device add, and you then remove another with device delete,
> why and how would the added device know to size itself to the device
> that you are planning to delete?   Ie. I don't see how it could know
> (you add the new drive before even telling it you want to remove the old
> one) and I also can't see a reason it would not use all the drive you
> tell it to add.
>
> In any event, I did a btrfs fi resize 3:max /local on the 6TB as you
> suggest, and have another balance running but it appears like all the
> others to be doing nothing, though of course it will take hours.  Are
> you sure it works that way?  Even before the resize, as you see below,
> it indicates the volume is 6TB with 4TB of unallocated space.  It is
> only the df that says full (and the fact that there is no unallocated
> space on the 3TB and 4TB drives.)


It does work that way and I agree off hand that the lack of
automatically doing a resize to max is counter intuitive. I'd think
the user has implicitly set the size they want by handing over the
device to Btrfs, be it a whole device, partition or LV. There might be
some notes in the mail archive and possibly comments in btrfs-progs
that explains the logic.

        devid    1 size 3.62TiB used 3.62TiB path /dev/sdi2
        devid    2 size 2.73TiB used 2.72TiB path /dev/sdh
        devid    3 size 5.43TiB used 1.42TiB path /dev/sdg

Also note that after a successful balance this will not be evenly
allocated because device sizes aren't even. Simplistically it'll do
something like this: copy 1 chunks on devid3 and copy 2 chunks on
devid1 until the free space on devid1 is equal to free space on
devid2. And then it'll start alternating copy 2 chunks between devid1
and 2, while copy 1 chunks continue to write on devid3. That happens
until free space on all three is equal, and then allocation alternates
among all three to try to maintain approximately equal free space
remaining.

You might find this helpful:
http://carfax.org.uk/btrfs-usage/



-- 
Chris Murphy
