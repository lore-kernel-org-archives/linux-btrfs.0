Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9D2C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616CC20870
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hLjThU3G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 616CC20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbeJKGiN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 02:38:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbeJKGiL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 02:38:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AMxIf4107133;
        Wed, 10 Oct 2018 23:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2q0RMSZCctyYnNETRwNzadxCii8i23iwSD8hokafvUU=;
 b=hLjThU3G75U5tFWjOd5ZdTA3QrRqQD0vPqJU2TDBDSL9Jfrcs4bGl86/gLkMS2Vju+B8
 pgTMpzNQaml7H7VSdn3OPgsoLqNUjfg3cnoxaCQzPNfq/CJlIae/3EE/nMPkWe/S8W23
 BAxth6YnLKbFwDpDyAy3C0zJgzoGlWFY2VU8uuniBVtIsD/gGX9xrueN7dJPV9SdONti
 CTAiq/Jr+KYRUH8J158Ajw1xBkUoIHzev2Ti/7+hsOQAnoTLa06khCuSwDVMX/0HbLOc
 SyDQoUaGqpNSwF3xuJS8xf1EydeNsN/LyobQD1XR3hrg2F3lgYH8IZnDp4Bvndu0OPRa ag== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0q758b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 23:13:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9ANDf3V005961
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 23:13:41 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9ANDfIp020298;
        Wed, 10 Oct 2018 23:13:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 23:13:41 +0000
Date:   Wed, 10 Oct 2018 16:13:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 05/25] vfs: check file ranges before cloning files
Message-ID: <20181010231339.GA6701@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913027326.32295.7601238218404639876.stgit@magnolia>
 <20181010230639.GN6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010230639.GN6311@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100213
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 10:06:39AM +1100, Dave Chinner wrote:
> On Tue, Oct 09, 2018 at 05:11:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the file range checks from vfs_clone_file_prep into a separate
> > generic_remap_checks function so that all the checks are collected in a
> > central location.  This forms the basis for adding more checks from
> > generic_write_checks that will make cloning's input checking more
> > consistent with write input checking.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> ....
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1717,12 +1717,12 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
> >   * Returns: 0 for "nothing to clone", 1 for "something to clone", or
> >   * the usual negative error code.
> >   */
> > -int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
> > -			       struct inode *inode_out, loff_t pos_out,
> > -			       u64 *len, bool is_dedupe)
> > +int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
> > +			struct file *file_out, loff_t pos_out,
> > +			u64 *len, bool is_dedupe)
> >  {
> > -	loff_t bs = inode_out->i_sb->s_blocksize;
> > -	loff_t blen;
> > +	struct inode *inode_in = file_inode(file_in);
> > +	struct inode *inode_out = file_inode(file_out);
> >  	loff_t isize;
> >  	bool same_inode = (inode_in == inode_out);
> >  	int ret;
> > @@ -1740,10 +1740,7 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
> >  	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> >  		return -EINVAL;
> >  
> > -	/* Are we going all the way to the end? */
> >  	isize = i_size_read(inode_in);
> > -	if (isize == 0)
> > -		return 0;
> 
> This looks like a change of behaviour. Instead of skipping zero
> legnth source files and returning success, this will now return
> -EINVAL as other checks fail? That needs to be documented in the
> commit message if it's intentional and a valid change to make...

Meh, I'll make another patch.  btrfs has never had this behavior.

$ ls /mnt/a
-rw-r--r-- 1 root root 0 Oct 10 16:10 /mnt/a
$ xfs_io -f -c 'reflink /mnt/a 1000000 0 4096' /mnt/b
XFS_IOC_CLONE_RANGE: Invalid argument

So it's a bug in the vfs prep functions.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
