Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258E2C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EF620738
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XWmwqdjo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgFWOAG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 10:00:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732687AbgFWOAE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 10:00:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NDwTU6180675;
        Tue, 23 Jun 2020 14:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dI1hKG7O40l4biJgJNO9CKAbLI17+GCndE9Ij920JL0=;
 b=XWmwqdjo8+kW7thJZALE4or65XQmL4GQz8bW6gjrwthvulQgsMg9KC9+UYDRGLa74vxt
 hgSi4SUPVcT0P2qrukQu7fgYDnEnFMaCrmYpU6uJuft1CRGo3dKmqa+fGfIgnIcxJMbi
 DafaEv7PT6p1TDkqbBG0/QScXJIzv3AKsyOnxX/031yEODQk5V/bjwsglw7hxr3gQWWJ
 B14cZEXuNujvuDdPNyG8phn+iFr4zMVo5suE2vTQ7lnaMK+QBZ9jlQ4IQO2IbIBM99/M
 iWtpcmJEmKlEcVPjXtS7xjROfZY2X0i9EzGs5CG7UfXPQSV3WEUUEJtwwPrlG4x+xjWH Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uk3c00be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 14:00:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NDdC4K124792;
        Tue, 23 Jun 2020 13:58:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31svcwt1vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 13:58:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05NDvvM8015351;
        Tue, 23 Jun 2020 13:57:58 GMT
Received: from [192.168.1.102] (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 13:57:57 +0000
Subject: Re: [PATCH] btrfs: use free_root_extent_buffer to free root
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org
References: <20200623084007.34215-1-johannes.thumshirn@wdc.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <e1039ebc-3b33-4c5e-d700-a6d5b663d896@oracle.com>
Date:   Tue, 23 Jun 2020 21:57:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623084007.34215-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good.
Reviewed-by: Anand Jain <annad.jain@oracle.com>
