Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1768C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E2DC2086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:51:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+J0KYic"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E2DC2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeJJXNv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 19:13:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbeJJXNv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 19:13:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AFnWOZ076577;
        Wed, 10 Oct 2018 15:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=oXCSEOUplon1SC9IBIFIMA5GCtN3NC5TOH9CszYcAZ8=;
 b=O+J0KYicJo7eeaqynfXCYwqqCOcj8CbEQU+2o2UUvAFuo4pUZeDjgWQXlJKJl27PJSD1
 9ur8/sTA7SB0iykrCal1qY2tTc8LA073awhO5zXBBU5unhg/o4qsOHNZl487vyP1AbKF
 mEivmty2QW+ixmcDn1q3Nur9EKKw32x0sYNs/eqH2kXUmNjTRSkj2j6jVk0C71XZAGAX
 D5za/CnS5gxsoPxecw77ugPAVjlq10KAg8ecdl+wrtNkDwVQa4xjafRYgYwFeVFDtgoF
 2PVyAmShpv8U8OeCFoIlHQ5C2wIesbO7Q0hGGhbKUKdQ1mgIwK/ODzikjuS//wDSNyOk 6g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mxnpr4wkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 15:51:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9AFowIC009803
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 15:50:59 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9AFovgf031316;
        Wed, 10 Oct 2018 15:50:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 15:50:57 +0000
Date:   Wed, 10 Oct 2018 08:50:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
Message-ID: <20181010155055.GS28243@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913040858.32295.9474188640729118153.stgit@magnolia>
 <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=923
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100154
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:47:00AM +0300, Amir Goldstein wrote:
> On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Change the remap_file_range functions to take a number of bytes to
> > operate upon and return the number of bytes they operated on.  This is a
> > requirement for allowing fs implementations to return short clone/dedupe
> > results to the user, which will enable us to obey resource limits in a
> > graceful manner.
> >
> > A subsequent patch will enable copy_file_range to signal to the
> > ->clone_file_range implementation that it can handle a short length,
> > which will be returned in the function's return value.  Neither clone
> > ioctl can take advantage of this, alas.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [...]
> > @@ -141,8 +142,8 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> >         }
> >
> >         /* Try to use clone_file_range to clone up within the same fs */
> > -       error = do_clone_file_range(old_file, 0, new_file, 0, len);
> > -       if (!error)
> > +       cloned = do_clone_file_range(old_file, 0, new_file, 0, len);
> > +       if (cloned == len)
> >                 goto out;
> >         /* Couldn't clone, so now we try to copy the data */
> >         error = 0;
> 
> This error = 0 not needed anymore, but not a big deal...

Fixed.

> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 693bd0620a81..c8c890c22898 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -434,14 +434,14 @@ enum ovl_copyop {
> >         OVL_DEDUPE,
> >  };
> >
> > -static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
> > +static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
> >                             struct file *file_out, loff_t pos_out,
> > -                           u64 len, unsigned int flags, enum ovl_copyop op)
> > +                           loff_t len, unsigned int flags, enum ovl_copyop op)
> >  {
> >         struct inode *inode_out = file_inode(file_out);
> >         struct fd real_in, real_out;
> >         const struct cred *old_cred;
> > -       ssize_t ret;
> > +       loff_t ret;
> >
> >         ret = ovl_real_fdget(file_out, &real_out);
> >         if (ret)
> > @@ -489,9 +489,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
> >                             OVL_COPY);
> >  }
> >
> > -static int ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> > -                               struct file *file_out, loff_t pos_out,
> > -                               u64 len, unsigned int flags)
> > +static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> > +                                  struct file *file_out, loff_t pos_out,
> > +                                  loff_t len, unsigned int flags)
> >  {
> >         enum ovl_copyop op;
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 917934770b08..f43b0620afd4 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1589,10 +1589,13 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> >          * more efficient if both clone and copy are supported (e.g. NFS).
> >          */
> >         if (file_in->f_op->remap_file_range) {
> > -               ret = file_in->f_op->remap_file_range(file_in, pos_in,
> > -                               file_out, pos_out, len, 0);
> > -               if (ret == 0) {
> > -                       ret = len;
> > +               s64 cloned;
> 
> loff_t?

Fixed.

> > +
> > +               cloned = file_in->f_op->remap_file_range(file_in, pos_in,
> > +                               file_out, pos_out,
> > +                               min_t(loff_t, MAX_RW_COUNT, len), 0);
> > +               if (cloned >= 0) {
> > +                       ret = cloned;
> >                         goto done;
> >                 }
> >         }
> 
> Commit message wasn't clear enough on the behavior of copy_file_range()
> before and after the patch IMO. Maybe it would be better to pospone this
> semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
> in this patch?

There shouldn't be any behavior change here -- all implementations
return a negative error code or the length that was passed in.  I'll
clarify that in the commit message.

--D

> Thanks,
> Amir.
