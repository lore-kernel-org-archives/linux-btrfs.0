Return-Path: <SRS0=42cL=CM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE885C433E2
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8216720767
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KNVnLQVO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgICKOg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 06:14:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgICKOf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Sep 2020 06:14:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 083AELwW030315;
        Thu, 3 Sep 2020 10:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BraqwKg40niWoK8kUXTd02hT9Hm7MQFfWHR/xeriMNM=;
 b=KNVnLQVORtkPttyhvOst1L6pZSok80STErfZUJj/J/OVCQ4F2KuvbCVInQt5FZN5Zz9K
 5+oHsPbVJU6pB22rIPmqOErDR/RjhDV21Qjj5AgsHcUQRL+yf8XHCcesU8JsMVZ1Hs6L
 ta11LwXmdq4Wie/YwoxuacC3olDw2AYqSk1T0NZt6FWreplNW7qF5kZSpKPKZvwXhxhg
 c8D5onfPvxjxddpIAsrYDtekepD8gVM+FH3K8qC1g9fcduWLxX9Fk7Y6UFb2lxvhqjGA
 PMrZVQUE4qOR26iFCIxYeb0bf3Sk8Ak4GDpXikTROOb+AvMUpVhV5a5olVUhPX3SlHHP 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eymft8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 10:14:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 083ABGPc176782;
        Thu, 3 Sep 2020 10:14:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380krh1yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 10:14:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 083AEUA7025016;
        Thu, 3 Sep 2020 10:14:30 GMT
Received: from [192.168.1.102] (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Sep 2020 03:14:30 -0700
Subject: Re: [PATCH 01/15] btrfs: add btrfs_sysfs_add_device helper
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1599091832.git.anand.jain@oracle.com>
 <5f8aa8a03a1712adba0023fc1efa18623571c588.1599091832.git.anand.jain@oracle.com>
 <25dcceb5-631f-3fde-1326-024d0ff02ba8@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <0594abe5-8c38-0f5a-8004-2f425fdee493@oracle.com>
Date:   Thu, 3 Sep 2020 18:14:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <25dcceb5-631f-3fde-1326-024d0ff02ba8@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030094
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



>> -	return error;
>> +int btrfs_sysfs_add_devices_dir(struct btrfs_fs_devices *fs_devices,
>> +				struct btrfs_device *one_device)
>> +{
>> +	int ret;
> 
> That variable can be defined inside the list_for_each-entry as it's
> being used only in that context.

  Patch 6 uses ret in seed list loop. So its ok.

Thanks, Anand

