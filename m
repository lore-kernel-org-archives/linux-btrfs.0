Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4522BC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 014982150B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TZ60exmy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 014982150B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbeJJWgI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 18:36:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJWgI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 18:36:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AEwxYN081590;
        Wed, 10 Oct 2018 15:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=AJhx/GoZjFHQVQNvjPrZCOFKnhJAJBopb44cn7a6bqc=;
 b=TZ60exmysscwwdeQQSyrTBNLDT16kP0EPEA3NElxOCr+UMlP0ZMaZ0+Nghn6PV3Xw5sL
 Jba1coYZ25tpHYPzFCBrSZFATpmuE6srRlcR6MiHjX1xk5Sg9vssQTNIYuwiyHVl1DI0
 HKY0MAxy1ugsmHkq5oZROqYfBB38wE7Vp79xn6rPWKEI7F/1C18ykTArncK21ntx24GY
 7tDBPrQBaSDIoY9tXVROaDFYNBsSId4cGWnX9Bmwp78s4qfG7ByroFGZczIj8Ye0OpXV
 ue2wTtywga6atZ9spgfMCqGhsJlz7SxLQmA0bkbl+hv1j1NYDHHiP0BgZLsN1tRPzPRF Hw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0q4sjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 15:13:25 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9AFDOff031904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 15:13:24 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9AFDNIl008492;
        Wed, 10 Oct 2018 15:13:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 15:13:22 +0000
Date:   Wed, 10 Oct 2018 08:13:21 -0700
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
Subject: Re: [PATCH 08/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181010151321.GR28243@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913029885.32295.7399525233513945673.stgit@magnolia>
 <CAOQ4uxj_wftoGvub9n_6X3Qc64LKxs+8TB-opUiq59sGQ=YoKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj_wftoGvub9n_6X3Qc64LKxs+8TB-opUiq59sGQ=YoKw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=887
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100149
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 08:54:44AM +0300, Amir Goldstein wrote:
> On Wed, Oct 10, 2018 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Combine the clone_file_range and dedupe_file_range operations into a
> > single remap_file_range file operation dispatch since they're
> > fundamentally the same operation.  The differences between the two can
> > be made in the prep functions.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I like this. Nits below.
> 
> [...]
> 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index d60b6caf09e8..e22b294fa25b 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3627,26 +3627,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >         return ret;
> >  }
> >
> > -int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
> > -                           struct file *dst_file, loff_t dst_loff,
> > -                           u64 olen)
> > -{
> > -       struct inode *src = file_inode(src_file);
> > -       struct inode *dst = file_inode(dst_file);
> > -       u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> > -
> > -       if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
> > -               /*
> > -                * Btrfs does not support blocksize < page_size. As a
> > -                * result, btrfs_cmp_data() won't correctly handle
> > -                * this situation without an update.
> > -                */
> > -               return -EINVAL;
> > -       }
> > -
> > -       return btrfs_extent_same(src, src_loff, olen, dst, dst_loff);
> > -}
> > -
> >  static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
> >                                      struct inode *inode,
> >                                      u64 endoff,
> > @@ -4348,9 +4328,27 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
> >         return ret;
> >  }
> >
> > -int btrfs_clone_file_range(struct file *src_file, loff_t off,
> > -               struct file *dst_file, loff_t destoff, u64 len)
> > +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> > +               struct file *dst_file, loff_t destoff, u64 len,
> > +               unsigned int flags)
> >  {
> > +       if (flags & RFR_IDENTICAL_DATA) {
> > +               struct inode *src = file_inode(src_file);
> > +               struct inode *dst = file_inode(dst_file);
> > +               u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> > +
> > +               if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
> > +                       /*
> > +                        * Btrfs does not support blocksize < page_size. As a
> > +                        * result, btrfs_cmp_data() won't correctly handle
> > +                        * this situation without an update.
> > +                        */
> > +                       return -EINVAL;
> > +               }
> > +
> > +               return btrfs_extent_same(src, off, len, dst, destoff);
> > +       }
> > +
> 
> Seems weird that you would do that instead of:
> 
> +    if (flags & ~RFR_IDENTICAL_DATA)
> +        return -EINVAL;
> +    if (flags & RFR_IDENTICAL_DATA)
> +        return btrfs_dedupe_file_range(src, off, dst, destoff, len);

Hmm.  The flags validation thing is kind of a mess here.  There should be a:

#define RFR_VALID_FLAGS	(RFR_IDENTICAL_DATA | /* add other RFR flags */)

And all these functions should also gate on:

if (remap_flags & ~RFR_VALID_FLAGS) {
	WARN_ON(...);
	return -EINVAL;
}

Though FWIW the btrfs implementation actually will support all three
flags, so the particular structure of these checks here are correct if
you add in my self-criticism above.

> 
> >         return btrfs_clone_files(dst_file, src_file, off, len, destoff);
> >  }
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 7065426b3280..bf971fd7cab2 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -975,8 +975,9 @@ const struct inode_operations cifs_symlink_inode_ops = {
> >         .listxattr = cifs_listxattr,
> >  };
> >
> > -static int cifs_clone_file_range(struct file *src_file, loff_t off,
> > -               struct file *dst_file, loff_t destoff, u64 len)
> > +static int cifs_remap_file_range(struct file *src_file, loff_t off,
> > +               struct file *dst_file, loff_t destoff, u64 len,
> > +               unsigned int flags)
> >  {
> >         struct inode *src_inode = file_inode(src_file);
> >         struct inode *target_inode = file_inode(dst_file);
> > @@ -986,6 +987,9 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
> >         unsigned int xid;
> >         int rc;
> >
> > +       if (flags & RFR_IDENTICAL_DATA)
> > +               return -EOPNOTSUPP;
> > +
> 
> I think everyone would be better off with:
> +       if (flags)
> +               return -EINVAL;
> 
> This way you won't need to change all filesystem implementations
> every time that you add a new RFR flag.
> Lucky for us, dedup already return -EINVAL if (!f_op->dedupe_file_range)
> (and not -EOPNOTSUPP).

Ugh, right, I forgot about that, um, quirk of the interface. :(

> [...]
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 986313da0c88..693bd0620a81 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -489,26 +489,28 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
> >                             OVL_COPY);
> >  }
> >
> > -static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
> > -                               struct file *file_out, loff_t pos_out, u64 len)
> > +static int ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> > +                               struct file *file_out, loff_t pos_out,
> > +                               u64 len, unsigned int flags)
> >  {
> > -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > -                           OVL_CLONE);
> > -}
> > +       enum ovl_copyop op;
> > +
> > +       if (flags & RFR_IDENTICAL_DATA)
> > +               op = OVL_DEDUPE;
> > +       else
> > +               op = OVL_CLONE;
> >
> > -static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> > -                                struct file *file_out, loff_t pos_out, u64 len)
> > -{
> >         /*
> >          * Don't copy up because of a dedupe request, this wouldn't make sense
> >          * most of the time (data would be duplicated instead of deduplicated).
> >          */
> > -       if (!ovl_inode_upper(file_inode(file_in)) ||
> > -           !ovl_inode_upper(file_inode(file_out)))
> > +       if (op == OVL_DEDUPE &&
> > +           (!ovl_inode_upper(file_inode(file_in)) ||
> > +            !ovl_inode_upper(file_inode(file_out))))
> >                 return -EPERM;
> >
> >         return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > -                           OVL_DEDUPE);
> > +                           op);
> >  }
> >
> 
> Apart from the generic check invalid flags comment - ACK on ovl part.

Thanks for the review!  Is that an official Acked-by to add to the
commit message, or an informal ACK?

--D

> Thanks,
> Amir.
