Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42040 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdJNAeI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 20:34:08 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9E0Y7lc002459
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9E0Y7Vm004750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:07 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9E0Y7P9029356
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:07 GMT
Subject: Re: [PATCH] btrfs: fix false EIO for missing device
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20171013134218.19048-1-anand.jain@oracle.com>
 <20171013180111.GB1553@lim.localdomain>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9baaa634-8d83-f7f4-cbad-04df9f1c2820@oracle.com>
Date: Sat, 14 Oct 2017 08:33:55 +0800
MIME-Version: 1.0
In-Reply-To: <20171013180111.GB1553@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> -		bio->bi_status = BLK_STS_IOERR;
>> +		if (atomic_read(&bbio->error) > bbio->max_errors)
>> +			bio->bi_status = BLK_STS_IOERR;
>> +		else
>> +			bio->bi_status = 0;
> 
> Thanks for the fix, I'd prefer BLK_STS_OK rather than 0.
> 
> With that,
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

  Thanks for the review will fix it.

-Anand

> -liubo
