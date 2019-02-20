Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DFEC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 05:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98532147A
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 05:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AxmdwJZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfBTF7W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 00:59:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57486 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfBTF7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 00:59:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1K5sIaC129828;
        Wed, 20 Feb 2019 05:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=tBTbh1I7Q6ylkvAv/4yzta1F99KS0lfuIFkAnPJhw44=;
 b=AxmdwJZjD7KZfifcgKdOnIzYA9AFZKqMOPO5lwC7gZA25IDTUhMxEGM8rCpkCKsYGrAN
 m+JAOhQMIr7o+GSk/ZAgM0emXtxmxp8a1INIy+Vv/MIzEfds258i07DLRu44i3SDfo9U
 9vMoQcAHMSeLJdOBhybpm+eLeSHlon33RWZmwa99Xfda2jyXJEwV5l1AGI5KWZC0+KW5
 vtURs5mK0nM63L/4h5K99GKGx+3UXO1fX2E6XIMbnVPMNMz+14vb1RSoiYlNsAAYZzEB
 Z6L4AzrQW7o3nGr7uZFB8KwGE1SVSXUX+fMOf15Qx2AFMBFqdbmvMahlU7t+CDBQxPrr mw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qp81e7jxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 05:59:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1K5x5Qh018623
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 05:59:05 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1K5x3jd026136;
        Wed, 20 Feb 2019 05:59:04 GMT
Received: from kadam (/197.157.0.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Feb 2019 21:59:03 -0800
Date:   Wed, 20 Feb 2019 08:58:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Fix type conversion in btrfs_read_root_item
Message-ID: <20190220055621.GM17104@kadam>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220030840.188854-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200042
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 03:08:40AM +0000, YueHaibing wrote:
> btrfs_item_size_nr return value is u32, convert it to int may result
> in truncation.Also read_extent_buffer expect a unsigned param, so
> min_t should use type u32 to compare.
> 
> Fixes: 8ea05e3a4262 ("Btrfs: introduce subvol uuids and times")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/btrfs/root-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 02d1a57af78b..893d12fbfda0 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -21,12 +21,12 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
>  				struct btrfs_root_item *item)
>  {
>  	uuid_le uuid;
> -	int len;
> +	u32 len;
>  	int need_reset = 0;
>  
>  	len = btrfs_item_size_nr(eb, slot);
>  	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
> -			min_t(int, len, (int)sizeof(*item)));
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Yeah, min_t() should normally cast to unsigned and the extra cast is
silly.

> +			   min_t(u32, len, sizeof(*item)));

regards,
dan carpenter

