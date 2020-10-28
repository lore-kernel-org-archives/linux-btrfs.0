Return-Path: <SRS0=hfn9=ED=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0494DC56201
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9985D246CD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TESpJ4K5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgJ1VyK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:54:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgJ1VyI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Oct 2020 17:54:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S8P7mI106340;
        Wed, 28 Oct 2020 08:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DshjwVmYgG3RJTI20RdVygoq5BuGaCOAk7RVuAE3G/Q=;
 b=TESpJ4K5zFevI983/TDO0IjSpjrIFN9IBC/kXB2NbNuiOoY56b4tVN91uHQGbUmliE0Y
 p7tnESmQPms7gEM5AIAFrZCa5aaMJBpCueEpHudVVk32hp3zVhYEpB+BBF9pmBOeudvh
 q94OKdfAS4Cxmj81aSctnUlRUKlXe4J+zFi3Fed6XaPcVn0xlbvWRpaLAA8z6kEOEjrM
 8ucYr0HzkhIsVtOsRq53hnBmauCGHtizrJxXyjJvnr3CYhN/OiSAFwU1TAAYmETJ+DDo
 Dh7T1BxuPF+P0SwjNAndlmUocibm96A/7Zcehl3RE3JaqAOSgvBFhU0kqXs2Flrq0UDr 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kwy15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 08:29:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S8PKmW031538;
        Wed, 28 Oct 2020 08:27:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6wy1xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 08:27:01 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09S8R0Ix031492;
        Wed, 28 Oct 2020 08:27:00 GMT
Received: from [192.168.1.102] (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 01:27:00 -0700
Subject: Re: [PATCH RFC 1/7] block: export part_stat_read_all
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <cover.1603751876.git.anand.jain@oracle.com>
 <047fe87c52b64caf1bd09eee4b1ca5130062a885.1603751876.git.anand.jain@oracle.com>
 <5c772e21-a401-1198-29d0-7ce0278b1544@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <551a851b-fbaf-3173-09a5-8cbd92b2e7a2@oracle.com>
Date:   Wed, 28 Oct 2020 16:26:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5c772e21-a401-1198-29d0-7ce0278b1544@toxicpanda.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280056
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 28/10/20 2:09 am, Josef Bacik wrote:
> On 10/26/20 7:55 PM, Anand Jain wrote:
>> For mirrored raid profiles such as raid1, raid1c3, raid1c4, and raid10,
>> currently, btrfs use the PID method to determine which one of the
>> mirrored devices to use to read the block. However, the PID method is
>> not the best choice if the devices are heterogeneous in terms of type,
>> speed, and size, as we may end up reading from the slower device.
>>
>> Export the function part_stat_read_all() so that the btrfs can determine
>> the device with the least average wait time to use.
>>
>> Cc: linux-block@vger.kernel.org
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> You don't need this, it can be accomplished with part_stat_read, or any 
> variety of the helpers in part_stat.h.  Thanks,

Oh. I have missed #define part_stat_read. It works for now.
We don't have to export part_stat_read_all() as in this patch.

Sorry for the noise.

Thanks, Anand

> 
> Josef

