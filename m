Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbeAaC2N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 21:28:13 -0500
Subject: Re: [PATCH v2 1/2] btrfs: fix device order consistency
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180122224937.3458-1-anand.jain@oracle.com>
 <20180122224937.3458-2-anand.jain@oracle.com>
 <20180130142040.GJ19355@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <38c3627c-0a73-1604-b938-44a066b55c02@oracle.com>
Date: Wed, 31 Jan 2018 10:29:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180130142040.GJ19355@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>   
>> +static int device_sort(void *priv, struct list_head *a, struct list_head *b)
> 
> I'll rename that to devid_cmp as it's the comparator and not really a
> sorting function.

  Ok. I will make that change in v3.

Thanks,
Anand
