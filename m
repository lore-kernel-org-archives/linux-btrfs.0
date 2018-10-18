Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09120C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 05:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA10021473
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 05:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1h9bgnqg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA10021473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbeJRNDC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 09:03:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeJRNDB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 09:03:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9I53law033466;
        Thu, 18 Oct 2018 05:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=mpxG2duM7u1a6SnGJr5spt/2AqtqPqyhhAV70h8CMGc=;
 b=1h9bgnqg0x3HhFWonbBXlbR0e1/PJgSpryglEDaoX/d9mGDqxQOrHU9oVxELeY5XPOlJ
 K+SFBBx9ADKVHvQcoel0P+UP6+gLBRH8hkR2UpqIKm3+qWLxoLvnenDQbahhg2C6mOiq
 LcvQst54L8WpOtHIeenEtFfYYiAm8yEQfJ7LEZrVfpyi6qiA5hxFW16KcyHc91YCIUYe
 XMIsqpf/sYTt6GM1a8eO1fWS8ZhmKrsedzg95xJCVDm1mYngzpMsrP1CcviCi+2gHNim
 qZ+MUogsVyNa3JpIUo45r4jf9UbZ7IK26X65dJJQ2QS5pM7RL/NLHRa2nd5hKOdnk+Xo +A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2n384uceep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 05:03:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9I53coR021557
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 05:03:38 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9I53aLr013700;
        Thu, 18 Oct 2018 05:03:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 22:03:36 -0700
Date:   Wed, 17 Oct 2018 22:03:34 -0700
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
Message-ID: <20181018050334.GU28243@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981631706.5568.6473120432728396978.stgit@magnolia>
 <20181018004826.GB12386@ZenIV.linux.org.uk>
 <20181018044718.GT28243@magnolia>
 <20181018045429.GF32577@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018045429.GF32577@ZenIV.linux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=722
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810180048
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 05:54:29AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 09:47:18PM -0700, Darrick J. Wong wrote:
> 
> > > > +#define REMAP_FILE_DEDUP		(1 << 0)
> > > > +
> > > > +/*
> > > > + * These flags should be taken care of by the implementation (possibly using
> > > > + * vfs helpers) but can be ignored by the implementation.
> > > > + */
> > > > +#define REMAP_FILE_ADVISORY		(0)
> > > 
> > > ???
> > 
> > Sorry if this wasn't clear.  How about this?
> > 
> > /*
> >  * These flags signal that the caller is ok with altering various aspects of
> >  * the behavior of the remap operation.  The changes must be made by the
> >  * implementation; the vfs remap helper functions can take advantage of them.
> >  * Flags in this category exist to preserve the quirky behavior of the hoisted
> >  * btrfs clone/dedupe ioctls.
> >  */
> 
> Something like "currently we have no such flags, but some will appear
> in subsequent commits", removed once such flags do appear, perhaps?

Done.

--D
