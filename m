Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1CCC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F1C214C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ztVa7jZe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2F1C214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeJKAYw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 20:24:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeJKAYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 20:24:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AGxGx1177800;
        Wed, 10 Oct 2018 17:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=W5d3ruRngOKAEDrVioxZHHjC7XsdaVVoiWbipRuyIxs=;
 b=ztVa7jZeFZeScoOyN2qg/bdGBtaCF2aCjilPK+ZEvOJuEjPDSzwU2YC/Vg9PKDfWISxo
 Qga7JootwVne6dl1vfsulGc35Wl0qRIlJGb40cWEnX1Bucf+2g2CMRFKSlWX0D7F7PCK
 kOdXc4yUWN3KJwYOy/KekJrBnL5ZgEV2LOCQrkYcz5zuBu0BT6vXSRUzXKSL/3JQYcyc
 H8wfuQ4mGAOG/D++53yMg3NmkBLT7CIpfZuMt+GbwEvoIhjbJ3Nrf/Y21tpRvOL1tPrA
 tASZBKUlhwNrMJe9aGBmkuQp4MJfvo1KiPpj2Wal0KLjukltLA0hdwBiI1w1XOWtv71+ Ig== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mxmftwhve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 17:01:41 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9AH1dFK012037
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 17:01:40 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9AH1dN2024650;
        Wed, 10 Oct 2018 17:01:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 17:01:39 +0000
Date:   Wed, 10 Oct 2018 10:01:37 -0700
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
Subject: Re: [PATCH 06/25] vfs: strengthen checking of file range inputs to
 generic_remap_checks
Message-ID: <20181010170137.GA24824@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913028015.32295.15993665528948323051.stgit@magnolia>
 <CAOQ4uxjZ1JuT3Ga1kTDF9boeYF5pafDmsnzWxVNPWcTpESchgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZ1JuT3Ga1kTDF9boeYF5pafDmsnzWxVNPWcTpESchgw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100163
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 08:23:27AM +0300, Amir Goldstein wrote:
> On Wed, Oct 10, 2018 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > File range remapping, if allowed to run past the destination file's EOF,
> > is an optimization on a regular file write.  Regular file writes that
> > extend the file length are subject to various constraints which are not
> > checked by range cloning.
> >
> > This is a correctness problem because we're never allowed to touch
> > ranges that the page cache can't support (s_maxbytes); we're not
> > supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
> > set; and we must obey resource limits (RLIMIT_FSIZE).
> >
> > Therefore, add these checks to the new generic_remap_checks function so
> > that we curtail unexpected behavior.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mm/filemap.c |   39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 14041a8468ba..59056bd9c58a 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2974,6 +2974,27 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
> >  }
> >  EXPORT_SYMBOL(generic_write_checks);
> >
> > +static int
> > +generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
> > +{
> > +       struct inode *inode = file->f_mapping->host;
> > +
> > +       /* Don't exceed the LFS limits. */
> > +       if (unlikely(pos + *count > MAX_NON_LFS &&
> > +                               !(file->f_flags & O_LARGEFILE))) {
> > +               if (pos >= MAX_NON_LFS)
> > +                       return -EFBIG;
> > +               *count = min(*count, MAX_NON_LFS - (uint64_t)pos);
> > +       }
> > +
> > +       /* Don't operate on ranges the page cache doesn't support. */
> > +       if (unlikely(pos >= inode->i_sb->s_maxbytes))
> > +               return -EFBIG;
> > +
> > +       *count = min(*count, inode->i_sb->s_maxbytes - (uint64_t)pos);
> > +       return 0;
> > +}
> > +
> 
> Sorry. I haven't explained myself properly last time.
> What I meant is that it hurts my eyes to see generic_write_checks() and
> generic_remap_check_limits() which from the line of (limit != RLIM_INFINITY)
> are exactly the same thing. Yes, generic_remap_check_limits() uses
> iov_iter_truncate(), but that's a minor semantic change - it can be easily
> resolved by creating a dummy iter in generic_remap_checks() instead of
> passing int *count.

Making a fake kiocb and iterator seem like a terribly fragile idea.

How about I make the common helper take a pos and *count, and
generic_write_checks can translate that into iov_iter_truncate?

> You could say that this is nit picking, but the very reason this patch
> set exists
> it because clone/dedup implementation did not use the same range checks
> of write to begin with, so it just seems wrong to diverge them at this point.
> 
> So to be clear, I suggest that generic_write_checks() should use your
> generic_remap_check_limits() helper.
> If you disagree and others can live with this minor duplication, fine by me.

Nah, I think I misunderstood you the first time, sorry about that.

--D

> Thanks,
> Amir.
