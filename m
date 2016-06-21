Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57855 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbcFUNfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 09:35:52 -0400
Subject: Re: [PATCH v2 2/2] btrfs: wait for bdev put
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <1466504648-2937-1-git-send-email-anand.jain@oracle.com>
CC: <holger@applied-asynchrony.com>, <dsterba@suse.com>,
        <xiaolong.ye@intel.com>
From: Chris Mason <clm@fb.com>
Message-ID: <0eaf435d-f6e3-31c3-24e2-5a8b1df840a8@fb.com>
Date: Tue, 21 Jun 2016 09:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <1466504648-2937-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2016 06:24 AM, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
>
> Further to the commit
>       bc178622d40d87e75abc131007342429c9b03351
>       btrfs: use rcu_barrier() to wait for bdev puts at unmount
>
> This patch implements a method to time wait on the __free_device()
> which actually does the bdev put. This is needed as the user space
> running 'btrfs fi show -d' immediately after the replace and
> unmount, is still reading older information from the device.

Thanks for working on this Anand.  Since it looks like blkdev_put can 
deadlock against us, can we please switch to making sure we fully flush 
the outstanding IO?  It's probably enough to do a sync_blockdev() call 
before we allow the unmount to finish, but we can toss in an 
invalidate_bdev for good measure.

Then we can get rid of the mdelay loop completely, which seems pretty 
error prone to me.

Thanks!

-chris

