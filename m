Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D972EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5E420661
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="13NPIYWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfBTMd6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:33:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfBTMd5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 07:33:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1KCO2PR058765;
        Wed, 20 Feb 2019 12:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=wVYm6XkyT0OOxIk/A0v5XwxJUzwcVyzxzmVr812M/iA=;
 b=13NPIYWFejCKD9JD+3Pigj2Bs4VeqZKkqo4OFPjSxys5dn7A9usSllUVrvPFAvCYYTI8
 2vM/iVpXtBGfJiHoPG9B8goZa1K/6caLq9hDzx7rWi1ypd19UJz7rytnQmQIHADYzx7r
 GycWDm3QSI0RvpXHnIevsJUm41yQQRqazuJTG4//vi6s5n6KVmErHMlypgbK9w72N6Dp
 RvjjOixDTxl1toggq0NRI9j0JAYmOBOk3XLpnxONymY3PkVNgfmcCQIKEo6PHVdzSZ0h
 nVt7/xGmIxP8TjknhsDCuPeZJDx2hHcU28oGjRckUm5w9Puc5xVQVvM5CaebE15P7Nxq TA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qpb5rh4pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 12:33:48 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1KCXlTc007605
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 12:33:47 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1KCXlN5016134;
        Wed, 20 Feb 2019 12:33:47 GMT
Received: from kadam (/197.157.0.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Feb 2019 04:33:46 -0800
Date:   Wed, 20 Feb 2019 15:33:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] btrfs: Remove unnecessary casts in
 btrfs_read_root_item
Message-ID: <20190220123338.GP17104@kadam>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
 <20190220123202.43256-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220123202.43256-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 12:32:02PM +0000, YueHaibing wrote:
> There is a messy cast here:
> 	min_t(int, len, (int)sizeof(*item)));
> 
> min_t() should normally cast to unsigned.  It's not possible for
> "len" to be negative, but if it were then we definitely
> wouldn't want to pass negatives to read_extent_buffer().  Also there
> is an extra cast.
> 
> This patch shouldn't affect runtime, it's just a clean up.
> 
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>

It wasn't really suggested by me...  But I do think it's the right
thing.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

