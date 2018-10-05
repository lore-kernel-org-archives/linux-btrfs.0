Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A58C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EFE2084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3G8BZvSc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96EFE2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbeJFAuD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:50:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbeJFAuD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 20:50:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w95Hnv9H136292;
        Fri, 5 Oct 2018 17:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HIjN92geHfiigtKbV9lwPcbqDrXnzsqMB19G1nbB4Og=;
 b=3G8BZvScImr+M/Lm6YXS3FBJyF7Ofvi6rMsUu2hj8eK7E5aSI3Q9jnvpI6Q/8I5V9X+A
 D3bick5v0ymHMlPAbj5UZGAoXadNezVYo1ifTJ1FOAEbhreqcjN3TUP5YMZKZgm0oVA8
 qKLvaifUifFbhtZCyLSx3V3rfqFO7izGN+Rk+/egTVd+oh47/GIneBL8qK2xuQqQwOdU
 xvj98TTfq1pnn6UNHrF5fiLc961f6RJMpIScWTSOlvKj2T3mCR2tPcLZeTc87LIXm9yh
 /z8EQ6ClnQsr3FAx7NqF2Oh8Mv0V92f6qEzVCCNdQEqYSoRTNht9aUFDXknOTka+xxp5 TQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mt0tuc56k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 17:50:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w95HoAEq017925
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 17:50:11 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w95Ho9wi024968;
        Fri, 5 Oct 2018 17:50:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 17:50:09 +0000
Date:   Fri, 5 Oct 2018 10:50:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
Message-ID: <20181005175008.GY19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870034158.29072.8943691140742142494.stgit@magnolia>
 <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9037 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050176
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 10:07:43AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Pass operational flags to the per-filesystem clone and dedupe
> > implementations.  This enables the vfs to signal when it can deal with
> > short clone and short dedupe operations.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [...]
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1761,7 +1761,7 @@ struct file_operations {
> >                         loff_t, size_t, unsigned int);
> >         s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
> >                                 struct file *file_out, loff_t pos_out,
> > -                               u64 count);
> > +                               u64 count, unsigned int flags);
> >         s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
> >                                  struct file *file_out, loff_t pos_out,
> >                                  u64 count);
> > @@ -1827,9 +1827,15 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
> >                 unsigned long, loff_t *, rwf_t);
> >  extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
> >                                    loff_t, size_t, unsigned int);
> > +/* Caller can handle a shortened operation. */
> > +#define CLONERANGE_SHORT       (1 << 0)
> > +/* End operation at the source file's EOF. */
> > +#define CLONERANGE_EOF         (1 << 1)
> > +/* Operation is actually dedupe, not clone. */
> > +#define CLONERANGE_DEDUPE      (1 << 2)
> 
> That's cool. But you know what's going to be the next step, right?
> Merging the 3 file operation interfaces into a single one.
> copy_file_range() already has the flags arg for future extensions
> and as you wrote somewhere, clone is really an optimized copy.
> ovl_copyfile() already does that internally.
> 
> So the only take away for this patch series, please use constant
> names COPYRANGE_* and also explicitly define:
> 
> /* Operation is actually clone, not copy. */
> #define COPYRANGE_CLONE      (1 << 2)
> /* Operation is actually dedupe, not copy. */
> #define COPYRANGE_DEDUPE      (1 << 3)

Yeah, I was too tired to try to throw that one on top of the flaming
garbage pile.  But I guess since I have a bunch more work to do to the
previous patch I might as well do that...

--D

> 
> Thanks,
> Amir.
