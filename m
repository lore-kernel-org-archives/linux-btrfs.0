Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705E4ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226A5214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dd/9J+Ix"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 226A5214C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbeJRAhb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 20:37:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbeJRAhb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 20:37:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HGYHT4084141;
        Wed, 17 Oct 2018 16:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=H0+2Z1L+JeFBtTVLQEkymIrGtN49e2rRZ+iWcwfNMD4=;
 b=Dd/9J+IxDEIJbzCi4XhSwmHQezax+lAXpj5WhSNkSIsYdR5pFsK3pwmcet5DrNbssgE1
 WjEqoUDJCWYT1Yr2qCIvr+74w7+IENLPSRFu5X6hLb0cANVHIOL84IKqk1FWwbBKPFjK
 mKbprGhIG4DxQjXsoHBo89M+3BRYdKNHJkClWPnZCQmSoYuPU1MsSqe4awTuGEOIpgKZ
 JzzucWsQm4smpXZyVlXVBo7auUznqwdEJ90VtPWS23P73X+AdPvI0eOt9tJGsEfzZzgo
 gNSnfLB8M2o1Y7OmyNoUMr2MQyTmwkWU5W/3PO4bZF5oYGnob9U5NLwM44ibbWEjs50c /Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39brg2ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 16:40:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9HGef8Z013703
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 16:40:41 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9HGefOe011020;
        Wed, 17 Oct 2018 16:40:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 09:40:40 -0700
Date:   Wed, 17 Oct 2018 09:40:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 25/26] xfs: support returning partial reflink results
Message-ID: <20181017164039.GP28243@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966005536.3607.787445581785795364.stgit@magnolia>
 <20181017084002.GI16896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017084002.GI16896@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170140
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 01:40:02AM -0700, Christoph Hellwig wrote:
> > @@ -1415,11 +1419,17 @@ xfs_reflink_remap_range(
> >  
> >  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> >  
> > +	if (len == 0) {
> > +		ret = 0;
> > +		goto out_unlock;
> > +	}
> > +
> 
> As pointed out last time this check is superflous, right above we have
> this check:
> 
> 	if (ret < 0 || len == 0)
> 		return ret;

Oops, sorry I missed that, will fix now.

> >  	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> > -			pos_out + len);
> > +			&remappedfsb, pos_out + len);
> > +	remapped_bytes = min_t(loff_t, len, XFS_FSB_TO_B(mp, remappedfsb));
> 
> I still think returning the bytes from the function would be saner,
> but maybe that's just me.

Hmmm, this call site is getting messy; I'll tack on another patch to
clean that up too.

--D
