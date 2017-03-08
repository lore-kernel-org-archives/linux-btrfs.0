Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48326 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdCHS2y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 13:28:54 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        kilobyte@angband.pl, demfloro@demfloro.ru
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
Message-ID: <22a333f7-27e7-2491-88c2-cae0ac2c32fa@oracle.com>
Date: Thu, 9 Mar 2017 02:31:55 +0800
MIME-Version: 1.0
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in btrfs_device,
>   but use a new structure extra_rw_degrade_errors, to record error when
>   sending down/waiting device.

Suggested local variables because, v2 had theoretical bug as assessed 
before. The actual fix (while the variables continue to be at struct 
device) may not be in the scope of this patch, as the btrfs as such 
would not handle the intermittent device disappear/reappear as of now. 
So though I believe in the long term the barrier failure should be part 
of per device dev_stat rather, but at the moment to keep the original 
design as it is in the scope of this patch a local stack variable will 
suffice.

Hope this clarifies better.

Thanks, Anand
