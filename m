Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F40CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 05:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1EF2075B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 05:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oB8QL0mf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfCEF7b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:59:31 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37274 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfCEF7a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2019 00:59:30 -0500
Received: by mail-yw1-f65.google.com with SMTP id k14so6083097ywe.4;
        Mon, 04 Mar 2019 21:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kfLxd+4Be2DzjSq3hwmTOY8I4PrBSron/pPkBseKTQ=;
        b=oB8QL0mfH9Xhi+1niH2m81xsDGlaANTvl84m+dTLUWrHHj7LMaCisB7YPtdzf6h0hd
         ux2rrdhMH9D30MzZqUZMe3gFIkWWx2Ff5vUvgSsY4V8XMwKJPuOX490ltHPW3T+uBAlX
         kfkZ/HFAqZ1G/TwJ9nHY8EY56FgedMQzs/U8Ik5QfG4bxi9hBxwoZtZmD/UuLGpQrMfO
         XyfMen+NQmbI+1gfbL2LmGOdbijjYEaTvDICFCxPXsJc3LcKOJNyZjpl/PETMdDZ1rpB
         6eP8EtK2ZF+Jyt3QsdgMF3afcp23aLKqax0LLCYkKUVbuE/H20jPCCZaPJ/4r4eYGBeF
         exjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kfLxd+4Be2DzjSq3hwmTOY8I4PrBSron/pPkBseKTQ=;
        b=Mo51xs3pG/WSKuMBzzaPo3nZDPNC/t1bjuKfBPUAVsMaSGa7PJoPP3+DoeglYKCAFO
         wC7Gss9sslmtYtVKra7QbLtx4sIkuZMSutDrilvF8/zOrn6gEz6iyjvnwSwu8hvWihjR
         5kZVW1brPNNIvxaCvU7hsXIW4J+gCBQdsLx8JWyLrlGRr7jVNgxqWV+vm5bv+FRCYg8+
         Qn7MYsoh9eKDyVpipaJI3hV1CyN3B1QWunIQ5xztMOlOZ/6eY1dnVn8K0XxjkDO5Dynm
         fzHKhznVPchmGempSaOTYEX6MWDAft00LCwDMMwXwUJaLfTouanaJZ46yLvgwQYp7AQs
         HLgw==
X-Gm-Message-State: APjAAAU2ssvSdAtj2H6K/NOf+G0ymGPDLHuLcCAj606iID91dxFDtssg
        /WfzbHlXKppM93v4QVLI0YkWo6CCl4o3t5UvwuDJge/c
X-Google-Smtp-Source: APXvYqzG9brK59QYitpi5LXLgFc6CN1mz2W6zmJl/V7YYcyweewVO6ottJriAWDIDpVlZEwca9yQnD/04WdJEgV9t1o=
X-Received: by 2002:a81:2ed6:: with SMTP id u205mr17278199ywu.176.1551765569358;
 Mon, 04 Mar 2019 21:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com>
 <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com> <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com>
In-Reply-To: <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 Mar 2019 07:59:18 +0200
Message-ID: <CAOQ4uxg_D0r2L=6zg4yxN1AfzkK8aHkWwOQPKEaKt8Z7WtVf2w@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 5, 2019 at 12:31 AM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Mon, Mar 4, 2019 at 5:59 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Mar 4, 2019 at 5:23 PM Filipe Manana <fdmanana@kernel.org> wrote:
> > >
> > > On Mon, Mar 4, 2019 at 3:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > > > >
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > Test that if we truncate a file to reduce its size, rename it and then
> > > > > fsync it, after a power failure the file has a correct size and name.
> > > > >
> > > >
> > > > I am not sure that ext4/xfs semantics guaranty anything about
> > > > persisting file name after fsync of file?...
> > > >
> > > > > This test is motivated by a bug found in btrfs, which is fixed by a
> > > > > patch for the linux kernel titled:
> > > > >
> > > > >   "Btrfs: fix incorrect file size after shrinking truncate and fsync"
> > > >
> > > > At least the title of this patch says nothing about persisting the
> > > > name.
> > >
> > > Because the bug in btrfs is not about persisting the name, it's about
> > > persisting the correct inode size.
> > >
> >
> > OK. Still AFAIK, ext4/xfs don't guaranty that the name bar will exist
> > after power failure unless the parent dir was fsynced.
> > If you fsync the parent dir instead of the file after rename, it will
> > make the test correct for ext4/xfs (and POSIX for that matter).
>
> I'm not so sure about that. Couldn't find anything explicit anywhere about that.

man fsync(2):
"       Calling  fsync() does not necessarily ensure that the entry in
the directory
        containing the file has also reached disk.  For that an
explicit fsync() on a file
        descriptor for the directory is also needed."

> There are other tests that do similar assumptions, either after
> renames or after adding a new
> hard link (fsyncing just the file being enough to guarantee the new
> hard link exits after a power
> failure, without the need to fsync the parent directory). I don't
> recall ever having had such comment before,

Because I missed it in review...

> even for much more complex cases involving renames
> such as [1] for example.
>
> [1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=e2d866668a98af4cd47cd6913418e410cd80aa93
>
> In this case both old and new names are in the same parent directory,
> but if they were in different directories, and
> requiring the user/application to fsync both directories, it could be
> dangerous, if the old parent dir is fsync'ed and
> a power failure happened before fsync'ing the new parent (requiring
> the user/application to know about this
> and fsync the new parent before the old parent dir also seems very
> demanding), leading to a potential file loss
> after replaying the log/journal (there were such cases in btrfs before).
>

This is not a problem for ext4/xfs.
fsync(newdir) guarantees persisting new filename
metadata ordering implies that olddir changes (and file nlink)
also persist.

To meet requirement of both btrfs and ext4/xfs in that case
your test may fsync both file AND newdir, as long as this
still allows your test to catch the bug?

> > Will that test modification still catch the btrfs bug (pre fix)?
>
> Yes, it will still trigger the btrfs bug.
>
> Well, I don't mind doing such change, but I would like to hear other
> opinions too, perhaps Dave could shed some light on this?
> Even old reiserfs and f2fs (both on posix and strict fsync modes)
> currently pass this test.
>

As I wrote to Dave, if file is not "metadata dirty" before rename,
then whether or not rename dirties to file for fsync is a filesystem
specific implementation detail that is not in any standard.

Since filesystems tend to try to optimize out unneeded journal
commits, so the observation about what filesystems do today
empirically is not a sufficiently strong argument.

Again, if your test can afford to do fsync of file and parent dir
it is best to be on the safe side (please audit other similar tests
that you know about). If your test cannot afford to fsync parent
dir, then at least a fat comment about this issue is worth about
the expected (but not guaranteed) effects of fsync of file.

Thanks,
Amir.
