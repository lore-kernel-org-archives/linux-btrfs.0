Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EACC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 00:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56F5520882
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 00:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jQrZm3SI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfDCAmQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 20:42:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDCAmP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 20:42:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x330dcNW172632;
        Wed, 3 Apr 2019 00:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oH5s7maxrLm8xnpjG2yNdeF0nSQVm2V2a8COMMJfZQw=;
 b=jQrZm3SIrH4xD3ZsRYaSj54us5IfcyVXmxUT9dHhHQovYg5slG7ZMzrJuFxEFYP+3POp
 l1Eoox6rgfpVFvjRH+gLONY13K4KsVnnE9vRq+O8xucOUDXgeHDYlGhM2n0aJQq1I5XA
 ZoXKDnL9S8pE8xakPKrVQVdWGFpGc+v7yA1yuNmd94psC5sJiUcqg+E+KGl+3yTHPs8R
 NNlQE07wJG/h2MNPwt9IuehOZ5UW5jjznh7GoLF0O5TMFtUmoF6MnW8once+mHmizZgq
 E0je9I0vP5eI7iCuho8F8+kVT10tm7OfrKp9lYxlTNscV7EGV1YmrJIgPCIXd73NJVjQ aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2rj0dnn2uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 00:42:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x330fJBZ183703;
        Wed, 3 Apr 2019 00:42:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rm9mhrqj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 00:42:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x330g54C002424;
        Wed, 3 Apr 2019 00:42:06 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 17:42:04 -0700
Subject: Re: [PATCH 3/4 RESEND] btrfs: open code btrfs_set_prop in
 inherit_prop
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-5-anand.jain@oracle.com>
 <8fedbab1-6fec-92cb-25b2-c9b9ff264103@suse.com>
 <20190402232447.GK29086@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     Nikolay Borisov <nborisov@suse.com>
Message-ID: <1e788d95-c423-c863-e4d0-758848d25bc5@oracle.com>
Date:   Wed, 3 Apr 2019 08:42:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190402232447.GK29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=977
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030001
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904030001
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/4/19 7:24 AM, David Sterba wrote:
> On Tue, Apr 02, 2019 at 04:35:12PM +0300, Nikolay Borisov wrote:
>>> @@ -367,20 +367,35 @@ static int inherit_props(struct btrfs_trans_handle *trans,
>>>   		if (!value)
>>>   			continue;
>>>   
>>> +		/* may be removed */
>>
>> This comment brings no value. Either explain *why* it can be removed or
>> remove it altogether.
> 
> Comment replaced by
> 
>                   /*
>                    * This is not strictly necessary as the property should be
>                    * valid, but in case it isn't, don't propagate it futher.
>                    */
> 
> I'd keep it the because that's what the direct opencoding transformation would
> do. If we want to remove it, then the reasoning should be provided.

   Agreed with the reasoning.

Thanks, Anand
