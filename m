Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48287C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0364820989
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wm4yN5+M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0364820989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbeJOXgK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 19:36:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeJOXgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 19:36:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9FFnI6Q128793;
        Mon, 15 Oct 2018 15:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=QwS5ismKBooVnYNXzV3+7Mdz3K4327PCusBWjXxgDe0=;
 b=Wm4yN5+MBglZD74mE4gK8BrS4bNN03ksaABNqKMrXG/AlDWL8VcgF7zKV8R1CXbv++WH
 8cHvnJcVAc3rdYD4BbyTMDJoZ2WQrdfBqk/D73HGCJ5f9oDEZ/ady5I455ydV9PnBZM+
 wS4k6R1dYr35XAFojiAR/4zvRhvXPI/uhrvbCv2qWMVD++RtXc084NKykBB32wY6F9kp
 2yhDSnCcipxL95tqfisUp4D9CHWESqjgElInVguxMs2HmCEbxA4IG7uCr9l0on1bovQg
 Ux3qJ5NJATvFlvilUS1byKBTagen923izyqoEm0c8XPOjin59cvQotxEb3AK/7c2xka/ 8w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2n38npuas6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 15:50:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9FFo2AZ010405
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 15:50:02 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9FFo1AA004736;
        Mon, 15 Oct 2018 15:50:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 08:50:00 -0700
Date:   Mon, 15 Oct 2018 08:49:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@redhat.com,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 24/25] xfs: support returning partial reflink results
Message-ID: <20181015154959.GI28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938931226.8361.7365948775364411156.stgit@magnolia>
 <20181014173546.GI30673@infradead.org>
 <20181014230536.GY6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014230536.GY6311@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=994
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810150141
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 10:05:36AM +1100, Dave Chinner wrote:
> On Sun, Oct 14, 2018 at 10:35:46AM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 12, 2018 at 05:08:32PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Back when the XFS reflink code only supported clone_file_range, we were
> > > only able to return zero or negative error codes to userspace.  However,
> > > now that copy_file_range (which returns bytes copied) can use XFS'
> > > clone_file_range, we have the opportunity to return partial results.
> > > For example, if userspace sends a 1GB clone request and we run out of
> > > space halfway through, we at least can tell userspace that we completed
> > > 512M of that request like a regular write.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_file.c    |    5 +----
> > >  fs/xfs/xfs_reflink.c |   20 +++++++++++++++-----
> > >  fs/xfs/xfs_reflink.h |    2 +-
> > >  3 files changed, 17 insertions(+), 10 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index bc9e94bcb7a3..b2b15b8dc4a1 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -928,14 +928,11 @@ xfs_file_remap_range(
> > >  	loff_t		len,
> > >  	unsigned int	remap_flags)
> > >  {
> > > -	int		ret;
> > > -
> > >  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> > >  		return -EINVAL;
> > >  
> > > -	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > > +	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > >  			len, remap_flags);
> > 
> > Is there any reason not to merge xfs_file_remap_range and
> > xfs_reflink_remap_range at this point?
> 
> Yeah, that seems like a good idea to me - pulling all the
> vfs/generic code interactions back up into xfs_file.c would match
> how the rest of the file operations are layered w.r.t. external and
> internal XFS code...

Yeah, ditto ocfs2.  I'll look into throwing a few more refactors onto
the end of this series... 8-D

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
