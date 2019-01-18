Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157F2C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 06:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79BA2086D
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 06:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WlQ0pDzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfARGNd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 01:13:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfARGNc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 01:13:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0I64Hts048922;
        Fri, 18 Jan 2019 06:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xAek1fp3LokeLrJ8wEdy/KTIffLDU+t3/il0Kt/8rWs=;
 b=WlQ0pDzoOaaNHmvs53WUKfyOkbsfxv+wq3U8pabKALXEYNFbP/ljtiui6FpxXj1GeOsi
 srbTWRrzfZBHJVWCqcfTdCizkln8mMn4utWkQ0iZ4pO62c3Bn/8w6VR8s2XytS4dWbl7
 sa3cSUJMMF+/urrdhKoeUT4t7EnGp9gGKndAzvUAcKsxPk9tI+jYIX2XPIY5XA5xCLDY
 MxAzmBi995d7P5msDKBw1f8b//312r5OHHLEiyceIumCDFRo0NI61vYwJr8Dqbruwqk7
 x1Jt5/Ti5UCmC/W7lv/sJAo/jvjxd26ciYLF9lGlxjkKZUr6EZ3BIiYjD12XUV9PZv6o YA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pybjp3rtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jan 2019 06:13:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0I6DQgK014098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jan 2019 06:13:27 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0I6DQTo029337;
        Fri, 18 Jan 2019 06:13:26 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 22:13:26 -0800
Subject: Re: [PATCH 3/6] btrfs: rename btrfs_find_device_by_path()
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-4-git-send-email-anand.jain@oracle.com>
 <20190117155421.GW2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <30537913-7f91-9bea-81ce-c9e40b467412@oracle.com>
Date:   Fri, 18 Jan 2019 14:13:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190117155421.GW2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9139 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=925
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901180046
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/17/2019 11:54 PM, David Sterba wrote:
> On Thu, Jan 17, 2019 at 11:32:30PM +0800, Anand Jain wrote:
>> btrfs_find_device_by_path() is a helper function, drop the btrfs prefix
>> and the suffix _path is too generic, in fact as it reads superblock to
>> find the btrfs_device, so rename it to find_device_by_superblock()
> 
> The function takes a path so it's search by path, as the name says, I
> don't think that needs to change.

  Sorry I didn't mention about my motivation to rename..
  find device by matching the device_path (without reading its
  superblock) is done by btrfs_free_stale_devices() and its helper
  device_path_matched() in the patch [1] which is in next-dev.

  [1]
  btrfs: refactor btrfs_free_stale_devices() to get return value

  So a reader can think why not use btrfs_find_device_by_path() here,
  unless fn is read to find out it matches the device by taking
  the devid from the superblock.

  Its not a big deal though.. I am ok to keep this as it is.. or... more
  below..

> And even this is a helper, the
> btrfs_ prefix is useful in case there's something stuck inside the
> block layer functions that get called later so it's obvious on the
> stack.

  Makes sense.

  Or.
  I think its a good idea to collapse this relatively small function into
  its only parent, btrfs_find_device_by_devspec().

Thanks.
