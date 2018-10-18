Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AC1ECDE42
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FDD208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GRQF+0ls"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37FDD208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbeJRMql (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 08:46:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbeJRMql (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 08:46:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9I4jmVs026539;
        Thu, 18 Oct 2018 04:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=vXgftaptkWsB9URK9bj1aD+RBRBJzW9Ox3DYlQ/Kzhc=;
 b=GRQF+0lsXNZBkEp2ZlJdpPp2P876onQagwJL/o+XFZjHIPVUtihN0XCCcOj3yv/9v16y
 6VCwhvEdl12u3bno1qzItHLiwc7uaZ6kQzcn21ODpioTEpJP9gfw4/Cle/AwP6eawnfT
 4V3tcnMJgAb+hNAyDPlaA1EGAL4mcAp9M/P+ZVbzclkiI60xfZ2xTrVwfu0nwHMlUBv4
 +n7BoAmY4YQr2WXgmqBFtuweB4od3iUyCHXtPkROdPL+hrFFMRQNvb8+pCn8hPkSn8Bo
 swrFNM0jrBlxsN+TSeAmpAbcPgWVc14QXntqi0x7CNGptVe9AspaIyvOlA3I2ljr0Eay YA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n38nqc5vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 04:47:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9I4lMjF018852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 04:47:22 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9I4lMUL009448;
        Thu, 18 Oct 2018 04:47:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 21:47:21 -0700
Date:   Wed, 17 Oct 2018 21:47:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Al Viro <viro@ZenIV.linux.org.uk>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 09/29] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181018044718.GT28243@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981631706.5568.6473120432728396978.stgit@magnolia>
 <20181018004826.GB12386@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018004826.GB12386@ZenIV.linux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=904
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810180045
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 01:48:26AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 03:45:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Combine the clone_file_range and dedupe_file_range operations into a
> > single remap_file_range file operation dispatch since they're
> > fundamentally the same operation.  The differences between the two can
> > be made in the prep functions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  Documentation/filesystems/vfs.txt |   13 +++++------
> >  fs/btrfs/ctree.h                  |    8 ++-----
> >  fs/btrfs/file.c                   |    3 +-
> >  fs/btrfs/ioctl.c                  |   45 +++++++++++++++++++------------------
> >  fs/cifs/cifsfs.c                  |   22 +++++++++++-------
> >  fs/nfs/nfs4file.c                 |   10 ++++++--
> >  fs/ocfs2/file.c                   |   24 +++++++-------------
> >  fs/overlayfs/file.c               |   30 ++++++++++++++-----------
> >  fs/read_write.c                   |   18 +++++++--------
> >  fs/xfs/xfs_file.c                 |   23 ++++++-------------
> >  include/linux/fs.h                |   20 +++++++++++++---
> >  11 files changed, 110 insertions(+), 106 deletions(-)
> > 
> > 
> > diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> > index a6c6a8af48a2..bb3183334ab9 100644
> > --- a/Documentation/filesystems/vfs.txt
> > +++ b/Documentation/filesystems/vfs.txt
> > @@ -883,8 +883,9 @@ struct file_operations {
> >  	unsigned (*mmap_capabilities)(struct file *);
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> >  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> >  };
> 
> Documentation/filesystems/porting part, please.  And document remap_flags.

Ok, will do.

> > +#define REMAP_FILE_DEDUP		(1 << 0)
> > +
> > +/*
> > + * These flags should be taken care of by the implementation (possibly using
> > + * vfs helpers) but can be ignored by the implementation.
> > + */
> > +#define REMAP_FILE_ADVISORY		(0)
> 
> ???

Sorry if this wasn't clear.  How about this?

/*
 * These flags signal that the caller is ok with altering various aspects of
 * the behavior of the remap operation.  The changes must be made by the
 * implementation; the vfs remap helper functions can take advantage of them.
 * Flags in this category exist to preserve the quirky behavior of the hoisted
 * btrfs clone/dedupe ioctls.
 */


--D
