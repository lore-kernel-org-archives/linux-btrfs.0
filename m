Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F050C65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B0B20834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DnEjQJmH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55B0B20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbeJFAgB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:36:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35336 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeJFAgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 20:36:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w95HTc0n091706;
        Fri, 5 Oct 2018 17:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=QN7xSUyR+BLWUI6DDg31r/Lm2/fpOqMUqDXU3WX40Q8=;
 b=DnEjQJmH3NSOBgyc2010djkQlsRnt79Tj9JalnQDiArp1uwR9s9G9m8R/OdzIGfjFFKc
 iMwtZHy23NLA7N/EHiY9v/l4o6IOOvWH2NN7nfDInBbdYFxH6No8+/HaaTF3CewDyax1
 VcBxif70n9pGAMlhtOJq35g7rnLlLBXAW3UUmrKzjIne8lZMwXnMV12Ja3QYNB9fv129
 yEkm7u8uaMqi6quWbh+l5Pc6PzNk/MivJ1FzQTjgrZusRq7XDgHkmRTXmIthKKPB8UEn
 SRe3P+CqMkX84QfNhmE3Uxh/VHgjRxGS7u4xPtMEoH/8egpnufU1VDhoBUWMVnHcklA8 aw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mt21rm1pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 17:36:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w95HaCrG007712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 17:36:12 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w95HaBfd030511;
        Fri, 5 Oct 2018 17:36:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 10:36:10 -0700
Date:   Fri, 5 Oct 2018 10:36:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 06/15] vfs: strengthen checking of file range inputs to
 clone/dedupe range
Message-ID: <20181005173607.GW19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870031519.29072.18289185889660082318.stgit@magnolia>
 <CAOQ4uxiVPvNPxTNZ-njeyte6yk3jo3tjNKv78kS9NqA_Xzxc6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiVPvNPxTNZ-njeyte6yk3jo3tjNKv78kS9NqA_Xzxc6g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9037 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050173
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 09:10:12AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Clone range is an optimization on a regular file write.  File writes
> > that extend the file length are subject to various constraints which are
> > not checked by clonerange.  This is a correctness problem, because we're
> > never allowed to touch ranges that the page cache can't support
> > (s_maxbytes); we're not supposed to deal with large offsets
> > (MAX_NON_LFS) if O_LARGEFILE isn't set; and we must obey resource limits
> > (RLIMIT_FSIZE).
> >
> > Therefore, add these checks to the new generic_clone_checks function so
> > that we curtail unexpected behavior.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mm/filemap.c |   31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 68ec91d05c7b..f74391721234 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3015,6 +3015,37 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
> >                 return -EINVAL;
> >         count = min(count, size_in - (uint64_t)pos_in);
> >
> > +       /* Don't exceed RLMIT_FSIZE in the file we're writing into. */
> > +       if (limit != RLIM_INFINITY) {
> > +               if (pos_out >= limit) {
> > +                       send_sig(SIGXFSZ, current, 0);
> > +                       return -EFBIG;
> > +               }
> > +               count = min(count, limit - (uint64_t)pos_out);
> > +       }
> > +
> > +       /* Don't exceed the LFS limits. */
> > +       if (unlikely(pos_out + count > MAX_NON_LFS &&
> > +                               !(file_out->f_flags & O_LARGEFILE))) {
> > +               if (pos_out >= MAX_NON_LFS)
> > +                       return -EFBIG;
> > +               count = min(count, MAX_NON_LFS - (uint64_t)pos_out);
> > +       }
> > +       if (unlikely(pos_in + count > MAX_NON_LFS &&
> > +                               !(file_in->f_flags & O_LARGEFILE))) {
> > +               if (pos_in >= MAX_NON_LFS)
> > +                       return -EFBIG;
> > +               count = min(count, MAX_NON_LFS - (uint64_t)pos_in);
> > +       }
> > +
> > +       /* Don't operate on ranges the page cache doesn't support. */
> > +       if (unlikely(pos_out >= inode_out->i_sb->s_maxbytes ||
> > +                    pos_in >= inode_in->i_sb->s_maxbytes))
> > +               return -EFBIG;
> > +
> 
> Forget my standards, this doesn't abide by your own standards ;-)
> Please factor out generic_write_checks() and use it instead of
> duplicating the code. The in/out variant doesn't justify not calling
> the helper twice IMO.

Factor generic_write_checks and generic_clone_checks how?  They operate
on very different parameter types.

Or were you suggeseting refactoring just the "Dont' exceed LFS limits"
and "Don't operate on ranges the page cache..." sections of
generic_clone_checks to reduce copy paste?  That I'll do.

--D

> 
> Thanks,
> Amir.
