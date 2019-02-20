Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656E9C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 06:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5E02147A
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 06:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B7WEwee9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfBTGKi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:10:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfBTGKh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 01:10:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1K63scO131169;
        Wed, 20 Feb 2019 06:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=YLZUhGdnIjuDG0jFto/b9BMW22OHCoPMpwtQcqPeyp4=;
 b=B7WEwee9sJS4sdoY/urGMldaPwydADxhtwnmCYemZ+fXH32QxCzyYQZ7oIIfJFYzgRfI
 8UYigkwwhHzuSlfSfbyqhnaVWYNk51fbhQZp7gGMFX37r3ffurRf5jzXmnEXSUhXN77C
 LAG/Iaa3GBF293MRky5gp9Cfq0M1lxISBeVO3heey7bC81UyJjCKUlj8lxI8jtRsDBGa
 5uxFhCMkQr8UXY227Fg/PGA9DO32QHYEL9j8GTPULoV7I1+okwK89k6VlI4nkYYYduFe
 9mWaslCjmZKJNxy2ms2Iw7l1JJKtYN7os1HhYm/vQzR2Nr7i8whgZLbv0qGXVtYsX/EZ 3A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qp9xtyfh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 06:10:28 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1K6AMr4012565
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 06:10:23 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1K6AMHa009275;
        Wed, 20 Feb 2019 06:10:22 GMT
Received: from kadam (/197.157.0.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Feb 2019 22:10:21 -0800
Date:   Wed, 20 Feb 2019 09:10:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Fix type conversion in btrfs_read_root_item
Message-ID: <20190220061009.GN17104@kadam>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
 <20190220055621.GM17104@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220055621.GM17104@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 08:58:43AM +0300, Dan Carpenter wrote:
> On Wed, Feb 20, 2019 at 03:08:40AM +0000, YueHaibing wrote:
> > btrfs_item_size_nr return value is u32, convert it to int may result
> > in truncation.Also read_extent_buffer expect a unsigned param, so
> > min_t should use type u32 to compare.
> > 
> > Fixes: 8ea05e3a4262 ("Btrfs: introduce subvol uuids and times")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  fs/btrfs/root-tree.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> > index 02d1a57af78b..893d12fbfda0 100644
> > --- a/fs/btrfs/root-tree.c
> > +++ b/fs/btrfs/root-tree.c
> > @@ -21,12 +21,12 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
> >  				struct btrfs_root_item *item)
> >  {
> >  	uuid_le uuid;
> > -	int len;
> > +	u32 len;
> >  	int need_reset = 0;
> >  
> >  	len = btrfs_item_size_nr(eb, slot);
> >  	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
> > -			min_t(int, len, (int)sizeof(*item)));
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Yeah, min_t() should normally cast to unsigned and the extra cast is
> silly.
> 

Btw, I shouldn't have had to dig through the patch to find the *real*
reason you wrote it.  A better description would have said:

    There is a messy cast here:

	min_t(int, len, (int)sizeof(*item)));

    min_t() should normally cast to unsigned.  It's not possible for
    "len" to be negative, but if it were then then we definitely
    wouldn't want to pass negatives to read_extent_buffer().  Also there
    is an extra cast.

    This patch shouldn't affect runtime, it's just a clean up.

regards,
dan carpenter

