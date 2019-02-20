Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935F4C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 01:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6336621738
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 01:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0DoZIadz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfBTBVP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 20:21:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfBTBVO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 20:21:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1K1K8Q2132247;
        Wed, 20 Feb 2019 01:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fuMqYQpMg6lyCNfDukH0/FLqIzSfMoZ3XKuTwD+dsXs=;
 b=0DoZIadzmd96WjfhQSHhtwvI08+6rDMEXQqyLRJBIY/QVKZwtK6odOGCmeqvKERq8mRk
 OMCmnV9PVbJ03/Crot2ihiwo5A2HbfLWeXce/WBraWMGdLaqYSyZOWru/g5jo6jGGSKz
 n5X49/jQ/kWHmr7+5UsFx1OnHIecM/nkrptRfK2GXkVvfok0JhAXq7ih/uP/S8Sc8Dnd
 fDuKwnSPYlXmTOAN82RJWNaHs0A1Yxpef8w7XAgqyn1tf/DfD7YkXsJohSzRZDRQzVLj
 aJa5oIfrv4fxvtT282/ZCyvto0MlBeQZgY0xuW9++AKNUYT4FBazq/Qx2wo2+7Af0RRq Wg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qp9xtxqub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 01:21:06 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1K1L5Ge026842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 01:21:05 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1K1L3gk011206;
        Wed, 20 Feb 2019 01:21:04 GMT
Received: from [172.20.10.2] (/157.45.42.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Feb 2019 17:21:03 -0800
Subject: Re: [PATCH] btrfs: drop the lock on error in
 btrfs_dev_replace_cancel()
To:     dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>
References: <20190211183209.GA13934@kadam>
 <20190219190451.GU9874@twin.jikos.cz>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <f53fc8af-ad77-116c-5d4a-cbb1e28cb974@oracle.com>
Date:   Wed, 20 Feb 2019 09:20:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190219190451.GU9874@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200007
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/20/19 3:04 AM, David Sterba wrote:
> On Mon, Feb 11, 2019 at 09:32:10PM +0300, Dan Carpenter wrote:
>> We should drop the lock on this error path.  This is from static
>> analysis and I don't know if it's possible to hit this error path in
>> real life.
> 
> Yes the lock needs to be released, it's there to protect access to the
> dev_replace members and is not supposed to be left locked. The value of
> state that's being switched would need to be artifically changed to an
> invalid value so the default: branch is taken.
> 
> It's been introduced by d189dd70e25561817325 in 5.0-rc1 so it counts as
> a regression but I don't think it's urgent enough to be sent to a late
> rc. It'll go through the stable tree channel. Thanks.
> 

oops I missed this email. Thanks Dan and David.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
