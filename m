Return-Path: <SRS0=TwUB=NV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435A9C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 07:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0086B20825
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 07:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkGH1uHP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0086B20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbeKJRH3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 12:07:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43644 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbeKJRH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 12:07:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA6pofJ095646;
        Sat, 10 Nov 2018 07:23:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5m13PRrlbIYbY2SirD7U6nWVn3N/s3ykibMvtRH9afo=;
 b=BkGH1uHPOSd8lh/teimaHGcTegLuMZJq1QX5P2+Sk4psjlPr47m98rM1tBCMAWqOo5X2
 IXV3ULtX1ws6y1PQdZKUrANj4RWiwtKHy8i3yImDLyHuTJ6Sc4eDoC0RX4z9nmnF43SG
 G0vnx5k3z1UMh/AHy0S/NoJu+GzdBHZixdqAbOMiEMGnvyQUDFpgAD31CmzWvIoRb9M/
 dL13+JEbqVRrvwngidhjicvegW5hk1wpoxFnbibHPlAFaDJogUQU7bTE72bSAEd9kNC/
 p9vG9H6jf2r2PnXv/vOQahJSK0mOmuO4YZF41xqqf+H2Idj6AUrNshi0MH9swk6dZ+4S Uw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nnprtr9qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Nov 2018 07:23:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAA7NOLg026866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Nov 2018 07:23:25 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAA7NNUV005165;
        Sat, 10 Nov 2018 07:23:24 GMT
Received: from [172.20.10.2] (/183.90.37.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Nov 2018 23:23:23 -0800
Subject: Re: [PATCH v15.1 00/13] Btrfs In-band De-duplication
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <14b9135d-c83f-f481-ef84-cfb19b9b34a6@oracle.com>
Date:   Sat, 10 Nov 2018 15:21:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9072 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=846
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811100045
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



De-duplication must also let use cases to enable de-duplication on per 
subvolume level, using the subvolume properties. Similar to compression 
and future-encryption.

Thanks, Anand
