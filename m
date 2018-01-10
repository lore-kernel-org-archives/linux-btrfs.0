Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753811AbeAJBhl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 20:37:41 -0500
Subject: Re: [PATCH 5/5] btrfs: move uuid_mutex closer to exclusivity
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-6-anand.jain@oracle.com>
 <20180109161520.vtv4zzljrxtv7cuw@destiny>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d8c27adf-ad10-c25f-893d-76043ed20cd7@oracle.com>
Date: Wed, 10 Jan 2018 09:38:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180109161520.vtv4zzljrxtv7cuw@destiny>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/10/2018 12:15 AM, Josef Bacik wrote:
> On Tue, Jan 09, 2018 at 10:46:25PM +0800, Anand Jain wrote:
>> move uuid_mutex with in device_list_add().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> This isn't going to work, there's a bunch of places we return errors so this
> just deadlocks the box.  Leave it like it is, it's not hurting anybody leaving
> it like this.  Thanks,

  Err. My mistake. Can't believe how did I miss it.
  Pls ignore this patch.
  Thanks for the review.

- Anand

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
