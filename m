Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F922C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0FD2084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iQcerEFM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF0FD2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbeJFAmj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:42:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeJFAmj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 20:42:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w95HddmQ099886;
        Fri, 5 Oct 2018 17:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VEqAiqG6+1jL9qOagqEF5f7UV+ws9POBUYOCT9j6FKo=;
 b=iQcerEFMn2yyg028cX11XfYkiiZj6QGaikR4B7oIc/Z1xpnZUrP2ZnCU+Qsbfi/dYnNN
 EwC0vfQgtZjKB0eE/1C21PJZzNXBnf9eDx5hooTCEzBTfCOejH06RrRXjvsC5hRJvOqZ
 KX/+WCxin80CNGgG/vxyWawzY5AJPNttEH3BfV8W+T06PE2Wu2vx1of8wzMWr2I2lBNb
 GKfkI4+QuzmlWZW9cb0O//ZdYMIyDY6C0lHPFUJR2SXE5eSGKdY/HSUIRaX0SdrDYP9Z
 p35s1ZSMjC3BY3/5I6xuVg+J0uIV7892ywTIcnDrB4rFRnZpeYrywdL5Oxx3YiGq95LI kw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mt21rm2jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 17:42:50 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w95HgnJA025555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 17:42:49 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w95HgnMi015210;
        Fri, 5 Oct 2018 17:42:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 17:42:49 +0000
Date:   Fri, 5 Oct 2018 10:42:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 12/15] vfs: implement opportunistic short dedupe
Message-ID: <20181005174247.GX19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870036143.29072.11970142092673351715.stgit@magnolia>
 <CAOQ4uxgqQ9ovr1i5+uGz1hq=fedFGKK7TpPCUvXkYPXhoPji3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqQ9ovr1i5+uGz1hq=fedFGKK7TpPCUvXkYPXhoPji3g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9037 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050174
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 09:40:44AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > For a given dedupe request, the bytes_deduped field in the control
> > structure tells userspace if we managed to deduplicate some, but not all
> > of, the requested regions starting from the file offsets supplied.
> > However, due to sloppy coding, the current dedupe code returns
> > FILE_DEDUPE_RANGE_DIFFERS if any part of the range is different.
> > Fix this so that we can actually support partial request completion.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/read_write.c    |   44 +++++++++++++++++++++++++++++++++++---------
> >  include/linux/fs.h |    2 +-
> >  2 files changed, 36 insertions(+), 10 deletions(-)
> >
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 292d68c2f47c..9be9f261edd2 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1781,13 +1781,11 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
> >          * Check that the extents are the same.
> >          */
> >         if (is_dedupe) {
> > -               bool            is_same = false;
> > -
> >                 ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> > -                               inode_out, pos_out, *len, &is_same);
> > +                               inode_out, pos_out, len);
> >                 if (ret)
> >                         return ret;
> > -               if (!is_same)
> > +               if (*len == 0)
> >                         return -EBADE;
> >         }
> >
> > @@ -1872,13 +1870,30 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
> >         return page;
> >  }
> >
> > +static unsigned int vfs_dedupe_memcmp(const char *s1, const char *s2,
> > +                                     unsigned int cmp_len)
> > +{
> > +       const char *orig_s1 = s1;
> > +       const char *e1 = s1 + cmp_len;
> > +       const char *e2 = s2 + cmp_len;
> > +
> > +       while (s1 < e1 && s2 < e2) {
> > +               if (*s1 != *s2)
> > +                       break;
> > +               s1++;
> > +               s2++;
> > +       }
> > +
> > +       return s1 - orig_s1;
> > +}
> > +
> 
> A few nits:
> 'len' wouldn't have been ambiguous in this context.
> I find the for loop in memcmp more elegant. It is definitely shorter.
> Not sure how differently the variants compile, but decrementing
> count/len seems much more sane then checking 2 conditions that
> always have the same result.

Fair enough; will fix.

--D

> Thanks,
> Amir.
