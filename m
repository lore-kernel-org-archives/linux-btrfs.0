Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462F4ECDE42
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0E42145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XAhoAeko"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A0E42145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbeJRMgp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 08:36:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeJRMgp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 08:36:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9I4XdVG160654;
        Thu, 18 Oct 2018 04:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=rkcslAM0NOFz2hUL43+pBrc7T9nx1xmjZfKtAisDuUg=;
 b=XAhoAekoM+4kzq6ih2/FS0Yei9sJRIB09w2e/JRyjPLJ8fiQYfPzTJpdjSezVHlyACMx
 Nwvu4SVHAzllT0VpZQ2rUvAfja48fJnU/mCnQUk1L9V81fj9PW3B1+Yhpu/AqDZbVreM
 zIJx60e1crd/w/hLKjkpyt+5QmKyCT8Pl53Irk45wBY1W687QXrCoVd50/BG6GaofpeZ
 LWK/NZH1GkzAu3j1NP8yA5ke5u7cgMAJ1DO5pPhVlacFvi9DDlwHmqoh+sBHte4T1Y+N
 uRhzqIiV/hXa48EmjOaPNLsQf19fKjEDjHI/5zXp19zQYeitnjK8jrpbVXorD5FyvvXJ Wg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39brm1xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 04:37:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9I4bTv0022132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 04:37:29 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9I4bSnh007108;
        Thu, 18 Oct 2018 04:37:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 21:37:28 -0700
Date:   Wed, 17 Oct 2018 21:37:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Al Viro <viro@ZenIV.linux.org.uk>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 04/29] vfs: strengthen checking of file range inputs to
 generic_remap_checks
Message-ID: <20181018043724.GS28243@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981628292.5568.2466587869276881561.stgit@magnolia>
 <20181018004156.GA12386@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018004156.GA12386@ZenIV.linux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=995
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810180043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 01:41:56AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 03:44:43PM -0700, Darrick J. Wong wrote:
> > +static int generic_access_check_limits(struct file *file, loff_t pos,
> > +				       loff_t *count)
> > +{
> > +	struct inode *inode = file->f_mapping->host;
> > +
> > +	/* Don't exceed the LFS limits. */
> > +	if (unlikely(pos + *count > MAX_NON_LFS &&
> > +				!(file->f_flags & O_LARGEFILE))) {
> > +		if (pos >= MAX_NON_LFS)
> > +			return -EFBIG;
> > +		*count = min(*count, (loff_t)MAX_NON_LFS - pos);
> 
> 	Can that can be different from MAX_NON_LFS - pos?
> 
> > +	}
> > +
> > +	/*
> > +	 * Don't operate on ranges the page cache doesn't support.
> > +	 *
> > +	 * If we have written data it becomes a short write.  If we have
> > +	 * exceeded without writing data we send a signal and return EFBIG.
> > +	 * Linus frestrict idea will clean these up nicely..
> > +	 */
> > +	if (unlikely(pos >= inode->i_sb->s_maxbytes))
> > +		return -EFBIG;
> > +
> > +	*count = min(*count, inode->i_sb->s_maxbytes - pos);
> > +	return 0;
> > +}
> 
> Anyway, I would rather do this here:
> 
> 	struct inode *inode = file->f_mapping->host;
> 	loff_t max_size = inode->i_sb->s_maxbytes;
> 
> 	if (!(file->f_flags & O_LARGEFILE))
> 		max_size = MAX_NON_LFS;
> 
> 	if (unlikely(pos >= max_size))
> 		return -EFBIG;
> 	*count = min(*count, max_size - pos);
> 	return 0;

Sounds much better to me. :)

--D
