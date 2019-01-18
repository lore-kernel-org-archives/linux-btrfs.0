Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC85C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 06:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDDBF2086D
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 06:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hw4gkWns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfARGNj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 01:13:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfARGNj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 01:13:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0I63cYn097396;
        Fri, 18 Jan 2019 06:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wPX4JDLM83jQmM1kiuLpUyC89HqZUEggeUlUh/VQHxk=;
 b=hw4gkWnsr3lmVSTZdCfWHTeB2XrLBOtF+0kHZkWIARcdi5MLOQ4HYmn+FLCI63UY3pYy
 ynXoI/1Aqinpqu0jkdJsl+zQ5gJD2FzgarDe2wsUeVLRiDPQYKshDJ28BLO5CTsq/0JR
 2kUkObJMtGQi9mS8LuDoF68mLyEjqWdrEhDQq67MpstyCbXDKa9CDh6+QLeKIa/LyDir
 ICTvx5YPSzWBKWtqVCbmLT1rgEz0Oi1pzFvYFe6pnRmxg/J7S+dibLFo4cai47D/Kant
 Y2ZaQssnB/laJJv4BCai7zFuR5glzL0VxqEoAFk+gA+mFS6+ISmUGUHPSDossJvNnK3f rA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pybkcurwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jan 2019 06:13:35 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0I6DTN3020218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jan 2019 06:13:30 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0I6DTka026648;
        Fri, 18 Jan 2019 06:13:29 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 22:13:29 -0800
Subject: Re: [PATCH 6/6] btrfs: refactor btrfs_find_device() return error code
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-7-git-send-email-anand.jain@oracle.com>
 <20190117154922.GU2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <8e14c714-d869-f8a8-9832-610313d2254b@oracle.com>
Date:   Fri, 18 Jan 2019 14:13:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190117154922.GU2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9139 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=978
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901180046
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/17/2019 11:49 PM, David Sterba wrote:
> On Thu, Jan 17, 2019 at 11:32:33PM +0800, Anand Jain wrote:
>> Refactor btrfs_find_device() to return standard error code.
> 
> Do you intend to add more error codes?

  No actually.

  code like this ...
     if (PTR_ERR(device) == -ENOENT)
  can be
     if (IS_ERR(device))


> A NULL is valid in case it's
> clear that it always means 'device not found'.
> 

  Oh. I am not too particular, I am ok to drop this patch.

  The thought process was.. having btrfs_find_device() to return standard
  err code made code at @@ -2404,8 +2404,6 @@; @@ -2419,13 +2417,9 @@;
  simpler.
  And as ioctls already return -ENODEV (though it might not be correct
  one), so if btrfs_find_device() could return -ENODEV (instead of
  -ENOENT) then there are few more places where code can be just ..
     if (IS_ERR(device))
	return PTR_ERR(device);

  What do you think?

Thanks, Anand
