Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A85C04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 09:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F054B205F4
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 09:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p+w4iggH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F054B205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbeJPRrc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 13:47:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbeJPRrb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 13:47:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G9miZo116089;
        Tue, 16 Oct 2018 09:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=DgFsR/497IKvJizRAlXtBAqnBSkA+f19eEJ/K+a4Y+A=;
 b=p+w4iggHllmW2ZwoaE7FgwUBOlfsBTw36opjBh8JJGhW9W2YL/1M/AfMvMYazVcVtzcc
 j2MHMrAc8OP+D89xkVKjpSaxO4uKUDevSY+Fu5/6jQDsuUgglTPr6q7qN4CsxN+WPPju
 LrYbCBkTH082g7iMIoy6Q8zeph1oN2ip1BXjymmP1hYkricIcSqnz3+pmju0FwW9h+2X
 X6ghm3FMCSaQqBWHicoXYeYfGHc2RJl1UcZKLhzUB84ugx86HEZVmC2Ao6XTQ6+tkXiL
 /3CSPQD0kKDWKoO1N4DKcO/bdLTfUbuWkbv96aa73GopZy623aiINeW1+9g9ILn26gM3 pg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39br7esy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 09:57:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G9vi8Y013832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 09:57:44 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G9vhhD031072;
        Tue, 16 Oct 2018 09:57:43 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Oct 2018 02:57:43 -0700
Subject: Re: BTRFS bad block management. Does it exist?
To:     waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <2287c62d-6dbb-3b30-1134-d754e42941ab@oracle.com>
Date:   Tue, 16 Oct 2018 17:57:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160086
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org




On 10/14/2018 07:08 PM, waxhead wrote:
> In case BTRFS fails to WRITE to a disk. What happens?

> Does the bad area get mapped out somehow?

There was a proposed patch, its not convincing because the disks does 
the bad block relocation part transparently to the host and if disk runs 
out of reserved list then probably its time to replace the disk as in my 
experience the disk would have failed for other non-media error before 
it runs out of the reserved list and where in this case the host 
performed relocation won't help. Further more being at the file-system 
level you won't be able to accurately determine whether the block write 
has failed for the bad media error and not because of the reason of 
target circuitry fault.

> Does it try again until it 
> succeed or

> until it "times out" or reach a threshold counter?

Block IO timeout and retry are the properties of the block layer 
depending on the type of error it should.

SD module already does retry of 5 counts (when failfast is not set), it 
should be tune-able. And I think there was a patch for that in the ML.

We had few discussion on the retry part in the past. [1]
[1]
https://www.spinics.net/lists/linux-btrfs/msg70240.html
https://www.spinics.net/lists/linux-btrfs/msg71779.html


> Does it eventually try to write to a different disk (in case of using 
> the raid1/10 profile?)

When there is mirror copy it does not go into the RO mode, and it leaves 
write hole(s) patchy across any transaction as we don't fail the disk at 
the first failed transaction. That means if a disk is at nth transaction 
per the super-block, its not guaranteed that all previous transactions 
have made it to the disk successfully in case of mirror-ed configs. I 
consider this as a bug. And there is a danger that it may read the junk 
data, which is hard but not impossible to hit due to our un-reasonable 
(there is a patch in the ML to address that as well) hard-coded 
pid-based read-mirror policy.

I sent a patch to fail the disk when first write fails so that we know 
the last good integrity of the FS based on the transaction id. That was 
a long time back I still believe its important patch. There wasn't 
enough comments I guess for it go into the next step.

The current solution is to replace the offending disk _without_ reading 
from it, to have a good recovery from the failed disk. As data centers 
can't relay on admin initiated manual recovery, there is also a patch to 
do this stuff automatically using the auto-replace feature, patches are 
in the ML. Again there wasn't enough comments I guess for it go into the 
next step.

Thanks, Anand
