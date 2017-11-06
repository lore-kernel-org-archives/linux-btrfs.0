Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50585 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754455AbdKFXpA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 18:45:00 -0500
Subject: Re: [PATCH 3/7] btrfs: use i_size_read() instead of open code
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-4-anand.jain@oracle.com>
 <20171106165215.GQ28789@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d16fbeb8-bfb7-58da-4ae0-6dde21a74762@oracle.com>
Date: Tue, 7 Nov 2017 07:44:59 +0800
MIME-Version: 1.0
In-Reply-To: <20171106165215.GQ28789@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/07/2017 12:52 AM, David Sterba wrote:
> On Mon, Nov 06, 2017 at 04:36:14PM +0800, Anand Jain wrote:
>> As i_size_read() takes care of 32bit smp or preempt cases as well.
> 
> Can bdev->bd_inode->i_size change so that we need to use the
> i_size_read()? My answer is 'no'.

  Hm. Right I was looking at it only from the theoretical point of view.

  And I presume you mean to say disk resize at the block layer is not
  really a practically achievable concern.

Thanks, Anand
