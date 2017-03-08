Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20615 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbdCHTnb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 14:43:31 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v28Iba3k023247
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 8 Mar 2017 18:37:36 GMT
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Adam Borowski <kilobyte@angband.pl>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
 <20170308064720.o5j24elapzjc5loz@angband.pl>
 <40bfe74e-ff6c-9efe-9dcb-381855654b40@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, demfloro@demfloro.ru
Message-ID: <dd463cff-a439-4a86-8f84-6f3e544c5317@oracle.com>
Date: Thu, 9 Mar 2017 02:40:51 +0800
MIME-Version: 1.0
In-Reply-To: <40bfe74e-ff6c-9efe-9dcb-381855654b40@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> Looks like I found an unrelated bug, though, that messed with my testing.
>> And it looks like a nasty one: once "btrfs dev scan" sees a disk, it
>> stores
>> its device and will then happily use it without verification even if it's
>> been pulled out and replaced by something else.  Lemme investigate that
>> later today.

   A missing device scanned after the FS mount - would just appear
   as being used by the FS tree, but actually its not. BTRFS does
   not handle the online reappear of the device that is the device
   which is not found at the mount/open-ctree won't be part of
   the alloc_dev_list, yet.

HTH
Anand

> It would be nice if you can send detailed info to mail list.
>
> AFAIK, btrfs will check its superblock for devid and device UUID, to
> ensure that's the device we're using.
