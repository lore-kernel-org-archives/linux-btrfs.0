Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CD9C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EBC2145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vINpq3uL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87EBC2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbeKPQs1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 11:48:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeKPQs1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 11:48:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAG6XYsc098091;
        Fri, 16 Nov 2018 06:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vG9G6KV7+ZmlkiIzkDPl31HHGsviCMm2W/mJViLp6uU=;
 b=vINpq3uLJ8Z0ozhAUCXVwEPjVY77ByM8G1nZcThVnpSp+93JF2+vF2gymg0ytQBD8wO6
 VudDEY3GdkOiprH6gEOz2BkpZPS4g7eCXJix8uziFJWgaeSs4nBT3M9AZ98D0z0QDt2m
 nfEH5whXA5bnN3huqxAh7t+K+H7dU8U4jgGDGXTYF13rnO9tzzi3Kydm8cZ93efb1NUZ
 3Pb20cjb0MxbC23di97qzzEExXintd/v2YiVMnA9ND4yozkwkZGLpstwg5c1MeDdBlTn
 qn2mub3lAoRUg1o2izS/PXjx9/2g7wtbVDbK1QhpxHIa+9fdQBfP+WvsuOd2awI/RCwC XA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nr7csdhkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 06:37:19 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAG6bJAx024035
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 06:37:19 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAG6bIWs014196;
        Fri, 16 Nov 2018 06:37:19 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Nov 2018 22:37:18 -0800
Subject: Re: [PATCH 4/9] btrfs: fix UAF due to race between replace start and
 cancel
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-5-git-send-email-anand.jain@oracle.com>
 <20181113172448.GF24115@twin.jikos.cz>
 <e1e32e53-3860-1d74-c2ed-1b4dbdb57404@oracle.com>
 <20181115140021.GQ24115@twin.jikos.cz> <20181115152543.GR24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <f3b9d25c-98ed-61fc-3642-697d86a39d9b@oracle.com>
Date:   Fri, 16 Nov 2018 14:37:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181115152543.GR24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160058
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/15/2018 11:25 PM, David Sterba wrote:
> On Thu, Nov 15, 2018 at 03:00:21PM +0100, David Sterba wrote:
>> On Wed, Nov 14, 2018 at 09:28:34AM +0800, Anand Jain wrote:
>>>>>    	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>>>>>    	return result;
>>>>
>>>> There's a compiler warning:
>>>>
>>>> fs/btrfs/dev-replace.c: In function ‘btrfs_dev_replace_cancel’:
>>>> fs/btrfs/dev-replace.c:865:9: warning: ‘result’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>>>     return result;
>>>>            ^~~~~~
>>>
>>>> I haven't looked closer though it looks valid.
>>>
>>> int result; is assigned within switch(), so there isn't actual problem.
>>
>> The warning is there because switch (dev_replace->replace_state) does
>> not have a default: case that would catch the values outside of what's
>> defined by the enum. So in that case result would have undefined value.
>>
>>> But will initialize the result to -EINVAL to quite the compiler.
>>> Sending v3.
>>
>> I don't see any change in the followup version.
>> https://patchwork.kernel.org/patch/10681939/

  Looks like I didn't run git commit --amend, now pulled your changes
  from misc-next.

> I've added
> 
> 	default:
> 		result = -EINVAL;
> 
> to the end of the switch.

  Ok. misc-next looks good to me.

Thanks, Anand

