Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB3FC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25584214C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mths8z8z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25584214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbeJKAt7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 20:49:59 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35701 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbeJKAt7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 20:49:59 -0400
Received: by mail-yb1-f195.google.com with SMTP id o63-v6so2532303yba.2;
        Wed, 10 Oct 2018 10:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ACoMz9KCkR8XWvMMwmLPERIkdz0G9Eat74iA4USgrag=;
        b=mths8z8znezdmtvMmgf8de8Ep9ejeQwOCK0aySmX71vZhHHbkOWWkyhiSIOaX+Exxt
         dGMs4JEYPhuqsvgMj79mLlIW/nIDi5dNa6mNIx1jmm7YOYDAeBFD7VBzl/ZblO31v6Up
         foDAX2XiFV1iKqARUcPmPEzxScqyRP8vcun9Msw6j4rBSr3tYhlsMUc5j1zsL0PGKORv
         q70qRgD5YNcjUGKb63ETWX/Kiw9mEMFkak4q1ot9DoX+r1BYgTpNoqvCqF2sl3gSMbok
         9qnsr0bJSENgT/DcCPZQp98VgLRNs4uTKi6p0AohNoMAQVIhkCEP60cmwlU1Qmy2a6QD
         0aQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ACoMz9KCkR8XWvMMwmLPERIkdz0G9Eat74iA4USgrag=;
        b=Pq8lyUFBOIKXIbeSlcrqQ5n4bZxxRhgOhxgNGhPWSi+9JoVjhWODsl6F5VOU0SIxkq
         bSOI1b0TnNVWJ9vomsKwo/JkyGIfKGtaRo89awkRhU6An7+Zx/py+8M9Zp8VtNzRrcAi
         6bgOBnCaMRlbyMccB0GikgahXHdD3NRBnQvL7SWIlHn7JaPJysV3d2eoZ3+xaqIXTFJo
         Lxz3LEd6ayP4yyBZfsKEPW+KQHzQsrV+BhXM+MzUghEvC05MtQbIn2FHK4m8FU11of66
         VPnDp0tIBq1yxfvVoF68Vsz40bhR5e8wftXj4QBhHl0N8fIweUq5RyHPNOslnpZRtIcm
         OlQQ==
X-Gm-Message-State: ABuFfohlLiidb7QNtAkMgp9BwR4PT1/AGHvy6FkxFS1NSy2Dr1eJyLES
        bA2rp/xS5w+VvPy7TMgOGE370gG7D2aL7N45pbc=
X-Google-Smtp-Source: ACcGV62GMxhHS/y/vL+55zorM0fnrYueracpCP1tRdTy6kj/hIQ35y6/3zz51aDvo5UPli5AJrDjgrYiC2zLrifJcgw=
X-Received: by 2002:a25:1a85:: with SMTP id a127-v6mr19895999yba.507.1539192410204;
 Wed, 10 Oct 2018 10:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913028015.32295.15993665528948323051.stgit@magnolia> <CAOQ4uxjZ1JuT3Ga1kTDF9boeYF5pafDmsnzWxVNPWcTpESchgw@mail.gmail.com>
 <20181010170137.GA24824@magnolia>
In-Reply-To: <20181010170137.GA24824@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 20:26:38 +0300
Message-ID: <CAOQ4uxi9ZU3La7RcaeVR_L7CXf2A-FeF1PnS_-PSO9idyf3BKg@mail.gmail.com>
Subject: Re: [PATCH 06/25] vfs: strengthen checking of file range inputs to generic_remap_checks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 8:01 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 08:23:27AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > File range remapping, if allowed to run past the destination file's EOF,
> > > is an optimization on a regular file write.  Regular file writes that
> > > extend the file length are subject to various constraints which are not
> > > checked by range cloning.
> > >
> > > This is a correctness problem because we're never allowed to touch
> > > ranges that the page cache can't support (s_maxbytes); we're not
> > > supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
> > > set; and we must obey resource limits (RLIMIT_FSIZE).
> > >
> > > Therefore, add these checks to the new generic_remap_checks function so
> > > that we curtail unexpected behavior.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  mm/filemap.c |   39 +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 39 insertions(+)
> > >
> > >
> > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > index 14041a8468ba..59056bd9c58a 100644
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -2974,6 +2974,27 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
> > >  }
> > >  EXPORT_SYMBOL(generic_write_checks);
> > >
> > > +static int
> > > +generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
> > > +{
> > > +       struct inode *inode = file->f_mapping->host;
> > > +
> > > +       /* Don't exceed the LFS limits. */
> > > +       if (unlikely(pos + *count > MAX_NON_LFS &&
> > > +                               !(file->f_flags & O_LARGEFILE))) {
> > > +               if (pos >= MAX_NON_LFS)
> > > +                       return -EFBIG;
> > > +               *count = min(*count, MAX_NON_LFS - (uint64_t)pos);
> > > +       }
> > > +
> > > +       /* Don't operate on ranges the page cache doesn't support. */
> > > +       if (unlikely(pos >= inode->i_sb->s_maxbytes))
> > > +               return -EFBIG;
> > > +
> > > +       *count = min(*count, inode->i_sb->s_maxbytes - (uint64_t)pos);
> > > +       return 0;
> > > +}
> > > +
> >
> > Sorry. I haven't explained myself properly last time.
> > What I meant is that it hurts my eyes to see generic_write_checks() and
> > generic_remap_check_limits() which from the line of (limit != RLIM_INFINITY)
> > are exactly the same thing. Yes, generic_remap_check_limits() uses
> > iov_iter_truncate(), but that's a minor semantic change - it can be easily
> > resolved by creating a dummy iter in generic_remap_checks() instead of
> > passing int *count.
>
> Making a fake kiocb and iterator seem like a terribly fragile idea.
>
> How about I make the common helper take a pos and *count, and
> generic_write_checks can translate that into iov_iter_truncate?
>

Seems good to me.

Thanks,
Amir.
