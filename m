Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE2FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30E62184E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 22:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553812611;
	bh=G4d4DlffAz+cGkFqOoRxIqkglutIDKi5M+COmuzNA/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SHNPbRyFTQr5QxI/84OCz4puxWusKJKTZ/4rzexhC859kLBDzTWELxdFlbJM7szlb
	 g8gBYz0yPdeMjCfa3uwnyi+S2+0fy3wkwdCDLw3OBOrUiffinei53Eqqnzbga6w3UF
	 Gm5U+j39AIRL9Z96S3/0e5X5EH3rH91ClE45ZD30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfC1Wgu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 18:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbfC1Wgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 18:36:50 -0400
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B2E2184E;
        Thu, 28 Mar 2019 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553812609;
        bh=G4d4DlffAz+cGkFqOoRxIqkglutIDKi5M+COmuzNA/k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c2s1x4v/wXTdPKhKp66hQu9xnxFpf/AzHFUGBUhd6XAdDU0hOOiIexGMhWeMk70UW
         HcizlL94YtoMjYYBEmkUyhneUVMaq+TbXTjk8cNXYMuretQB9np4v+yDg4lOdh2s+2
         g9y1iLN1OggshBHtdEH1LCMrY6VbmxYLISOxu8eE=
Received: by mail-vs1-f47.google.com with SMTP id w13so193094vsc.4;
        Thu, 28 Mar 2019 15:36:49 -0700 (PDT)
X-Gm-Message-State: APjAAAVrVfO4xwEqfC709sgPfozJJmVtMrLo51PXAt8dl91sYnuJT5EN
        RBuhzsbZAJwszWO1RvXG5YYXulU+cc/vhRj8Ft4=
X-Google-Smtp-Source: APXvYqwodmuElNdN+ebq1z3TLlL7nWPZ216xZfw+WOUwxt33zTRli2YhYtlWn5hJ4+XnvhZWiv+wMeGJKwnD7MZu3dg=
X-Received: by 2002:a67:d098:: with SMTP id s24mr27000961vsi.95.1553812608665;
 Thu, 28 Mar 2019 15:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190328185404.28879-1-fdmanana@kernel.org> <20190328214839.GM26298@dastard>
In-Reply-To: <20190328214839.GM26298@dastard>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 28 Mar 2019 22:36:37 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6uHcsEvBCTaBaTeCPhsQ2XHDRqVu7tVa-bPc9iHP6pNw@mail.gmail.com>
Message-ID: <CAL3q7H6uHcsEvBCTaBaTeCPhsQ2XHDRqVu7tVa-bPc9iHP6pNw@mail.gmail.com>
Subject: Re: [PATCH 2/7] fsstress: add operation for setting xattrs on files
 and directories
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 9:48 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Mar 28, 2019 at 06:54:04PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Currently fsstress does not exercise creating, reading or deleting xattrs
> > on files or directories. This change adds support for setting xattrs on
> > files and directories, using only the xattr user namespace (the other
> > namespaces are not general purpose and are used for security, capabilities,
> > ACLs, etc). This adds a counter for each file entry structure that keeps
> > track of the number of xattrs set for the file entry, and each new xattr
> > has a name that includes the counter's value (example: "user.x4").
> > Values for the xattrs have at most 100 bytes, which is much more than
> > the maximum size supported for all major filesystems.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  ltp/fsstress.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 141 insertions(+), 9 deletions(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index cc4f520e..03e40eb6 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -27,6 +27,7 @@
> >  io_context_t io_ctx;
> >  #endif
> >  #include <sys/syscall.h>
> > +#include <sys/xattr.h>
> >
> >  #ifndef FS_IOC_GETFLAGS
> >  #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
> > @@ -85,6 +86,7 @@ typedef enum {
> >       OP_RESVSP,
> >       OP_RMDIR,
> >       OP_SETATTR,
> > +     OP_SETXATTR,
> >       OP_SPLICE,
> >       OP_STAT,
> >       OP_SYMLINK,
> > @@ -110,6 +112,7 @@ typedef struct opdesc {
> >  typedef struct fent {
> >       int     id;
> >       int     parent;
> > +     int     xattr_counter;
> >  } fent_t;
> >
> >  typedef struct flist {
> > @@ -195,6 +198,7 @@ void      rename_f(int, long);
> >  void resvsp_f(int, long);
> >  void rmdir_f(int, long);
> >  void setattr_f(int, long);
> > +void setxattr_f(int, long);
> >  void splice_f(int, long);
> >  void stat_f(int, long);
> >  void symlink_f(int, long);
> > @@ -246,6 +250,7 @@ opdesc_t  ops[] = {
> >       { OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
> >       { OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
> >       { OP_SETATTR, "setattr", setattr_f, 0, 1 },
> > +     { OP_SETXATTR, "setxattr", setxattr_f, 4, 1 },
>
> Ok, now that I see this, the penny drops - you can't do this as
> it changes the CLI interface in a way that will make existing
> scripts do something entirely different to what they used to do.
>
> i.e. "-f setxattr=n" is used to specify the frequency of this
> specific operation. It used to control the project ID setting, now
> with this change it controls extended attribute frequency. There are
> some tests that actually use "-f setxattr=n" (and who knows how many
> custom test scripts using fsstress built from fstests), so I don't
> think we should be renaming existing operations to something else
> and then reusing the name for a new type of operation like this....

Any idea for a good name? (Not too long, or too similar like setextattr)


>
> I certainly agree with the idea of adding extended attributes to
> fsstress, just not this way...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
