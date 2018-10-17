Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D103ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139C52156B
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iMOCs8SO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 139C52156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbeJRAci (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 20:32:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeJRAci (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 20:32:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HGYDgB129942;
        Wed, 17 Oct 2018 16:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/t05Z3x5uWRjbecu03yZ2Bf0k2cH5K3gOwgB3+gR+PA=;
 b=iMOCs8SO4zruv/fNOzsYoHJ2U8qGmlgJYVWW71fSFWpAiTjs9nCaPhScQpMs3B2JaeXz
 8PnqBZ9qkraS6tbLEJwGgarHIbKQ9mIfnYcjDdj8qhfdjy7wjYrD7Q/OR0vonuJ2vi8d
 t/h6yueyk/6yCy8ypnxStQt4hAqdVzkZFn3C01i3JYoRk2ha8RmYRZ/NJ6rCSl9IM5Rg
 u9lbMZCD1sVWclyf4hKylqAv392XjyrFLN9FljTVHXl2GCBLpWYVRpM6zcTDpcA05JYz
 N/pDKYX5dlfwCiLTqj6uyRTkODE+Lz0EbuIog3H6pOPEsyvZJ/QzZ1t2rCoPWIBPkY89 zg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384u8b1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 16:35:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9HGZdxn020428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 16:35:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9HGZd7L031444;
        Wed, 17 Oct 2018 16:35:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 09:35:39 -0700
Date:   Wed, 17 Oct 2018 09:35:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 17/26] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181017163537.GO28243@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965999426.3607.3221368918901209000.stgit@magnolia>
 <20181017083652.GF16896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017083652.GF16896@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=938
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170140
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 01:36:52AM -0700, Christoph Hellwig wrote:
> >  /* Update inode timestamps and remove security privileges when remapping. */
> > @@ -2023,7 +2034,8 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
> >  {
> >  	loff_t ret;
> >  
> > -	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP));
> > +	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
> > +				     REMAP_FILE_CAN_SHORTEN));
> 
> I guess this is where you could actually use REMAP_FILE_VALID_FLAGS..
> 
> >  /* REMAP_FILE flags taken care of by the vfs. */
> > -#define REMAP_FILE_ADVISORY		(0)
> > +#define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
> 
> And btw, they are not 'taken care of by the VFS', they need to be
> taken care of by the fs (possibly using helpers) to take affect,
> but they can be safely ignored.

Ok, I'll update the comment.

> > +		if (!IS_ALIGNED(count, bs)) {
> > +			if (remap_flags & REMAP_FILE_CAN_SHORTEN)
> > +				count = ALIGN_DOWN(count, bs);
> > +			else
> > +				return -EINVAL;
> 
> 			if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
> 				return -EINVAL;
> 			count = ALIGN_DOWN(count, bs);

Seeing as we return EINVAL on shortened count and !CAN_SHORTEN below
this, I think this can be simplified further:

	if (pos_in + count == size_in) {
		bcount = ALIGN(size_in, bs) - pos_in;
	} else {
		if (!IS_ALIGNED(count, bs))
			count = ALIGN_DOWN(count, bs);
		bcount = count;
	}

--D
