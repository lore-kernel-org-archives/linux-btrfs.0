Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29149C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 16:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D67A020659
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 16:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dk3Em1QA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D67A020659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbeJKXcR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 19:32:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbeJKXcQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:32:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9BFxAo9100720;
        Thu, 11 Oct 2018 16:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=UNOLSjYqkVe+iaK4h9HeIx0OgqIqodALHs3I5jmieeY=;
 b=Dk3Em1QA+kWKjrwz2SR0l2Fp7W+PfbA1+Cs7h5k32HR3GI9WDK529/XURp19uTQuqYSV
 6IvP2WljlTx6U6b+CRStzPOmlk6DYj6FAQF3thmFdjTHg3WPQCAu5/aXkZ+jDIECmM98
 w/RHcsvjnGZUr7n30BF+twmQiEGIE/goReAQgEfrLMsPGtdTWnKyqgCMnQyeLJJtRP2X
 4TllP0npbesR2T+SkgaftJzC6leINUD8YNngi6gte5o97GIFONaQo1fHf5HiKlN8zmen
 ammAU+yQ+ctM94qnFz3XRuOQMmmHK2HiQhaZI0qY7q8LP1aIS7SxS73r/9N6rFbOv0lZ nw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mxmfu5frq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 16:04:20 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9BG4Dmf031845
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 16:04:14 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9BG4Dsa007105;
        Thu, 11 Oct 2018 16:04:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 16:04:13 +0000
Date:   Thu, 11 Oct 2018 09:04:11 -0700
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
Subject: Re: [PATCH 17/25] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181011160411.GA28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923126628.5546.3484461137192547927.stgit@magnolia>
 <CAOQ4uxgbTf0Po3stK4YZWqYPWTmwfqsSLGwV4p4be6gBrdLP+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgbTf0Po3stK4YZWqYPWTmwfqsSLGwV4p4be6gBrdLP+g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110154
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 08:15:42AM +0300, Amir Goldstein wrote:
> On Thu, Oct 11, 2018 at 7:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Plumb in a remap flag that enables the filesystem remap handler to
> > shorten remapping requests for callers that can handle it.  Now
> > copy_file_range can report partial success (in case we run up against
> > alignment problems, resource limits, etc.).
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/read_write.c    |   15 +++++++++------
> >  include/linux/fs.h |    7 +++++--
> >  mm/filemap.c       |   16 ++++++++++++----
> >  3 files changed, 26 insertions(+), 12 deletions(-)
> >
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 6ec908f9a69b..3713893b7e38 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1593,7 +1593,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> >
> >                 cloned = file_in->f_op->remap_file_range(file_in, pos_in,
> >                                 file_out, pos_out,
> > -                               min_t(loff_t, MAX_RW_COUNT, len), 0);
> > +                               min_t(loff_t, MAX_RW_COUNT, len),
> > +                               RFR_CAN_SHORTEN);
> >                 if (cloned > 0) {
> >                         ret = cloned;
> >                         goto done;
> > @@ -1804,16 +1805,18 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> >                  * If the user is attempting to remap a partial EOF block and
> >                  * it's inside the destination EOF then reject it.
> >                  *
> > -                * We don't support shortening requests, so we can only reject
> > -                * them.
> > +                * If possible, shorten the request instead of rejecting it.
> >                  */
> >                 if (is_dedupe)
> >                         ret = -EBADE;
> >                 else if (pos_out + *len < i_size_read(inode_out))
> >                         ret = -EINVAL;
> >
> > -               if (ret)
> > -                       return ret;
> > +               if (ret) {
> > +                       if (!(remap_flags & RFR_CAN_SHORTEN))
> > +                               return ret;
> > +                       *len &= ~blkmask;
> > +               }
> >         }
> >
> >         return 1;
> > @@ -2112,7 +2115,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
> >
> >                 deduped = vfs_dedupe_file_range_one(file, off, dst_file,
> >                                                     info->dest_offset, len,
> > -                                                   0);
> > +                                                   RFR_CAN_SHORTEN);
> 
> You did not update WARN_ON_ONCE in vfs_dedupe_file_range_one()
> to allow this flag and did not mention dedupe in commit message.
> Was that change intentional in this patch?
> 
> After RFR_SHORT_DEDUPE patch the end result in fine.

Heh, oops, sorry about that.  I'll reissue the patch with the two
corrections.

--D

> Thanks,
> Amir.
