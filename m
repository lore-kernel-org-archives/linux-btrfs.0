Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E98C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 09:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E2B206DD
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 09:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551777984;
	bh=jCn80l57Y/F/7O5ublg3Lgktuvbxz8AZ0LNDN6MmH/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=VhGq3nIBQk9F4l9cEvlJkjRG97agR5NAky08kEV3sA6clJARRoDsQLM43LcMym5XV
	 AIAvV9iK0RHaPSh75mVYtlkb2N/mcVwXMlTmkRPDBqaMmh8b+Kw2rTZdfvlTY94+3K
	 KG2llgEysNBMrMP8FzbsmsYTfngzFGccrBSr023M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfCEJ0X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbfCEJ0V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 04:26:21 -0500
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA932082C;
        Tue,  5 Mar 2019 09:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551777980;
        bh=jCn80l57Y/F/7O5ublg3Lgktuvbxz8AZ0LNDN6MmH/g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T4ZqOVmwP/TShQnb/4t+MASxOB8JnxXipwZakkjHWot60gW5MT6k+X70yIehdRm6o
         3N3rS5FvIOi6swmp04xnPEvGegleFiqNExXKu9Wi/2V7iCa7hcal3pWu/5fSowRVln
         Ei6ovWZURRidFBwCG/z1Y5YusezDPZgpvzxuaWRo=
Received: by mail-ua1-f45.google.com with SMTP id f88so7134652uaf.2;
        Tue, 05 Mar 2019 01:26:20 -0800 (PST)
X-Gm-Message-State: APjAAAWAqbeXXJfhcLq50GjaEMIOqPpcv4n2TJHS9cV0ryW6X0Q9Vl56
        XvhP1ESqNuncZvxwJiWE4JLfK7SqsXo66bV49jw=
X-Google-Smtp-Source: APXvYqweEHgjN8hupC8iBBcN6dygxfLTEdwGFeXdj6h9I7ySCpb6a/waopJ8JsXDJNkdK22+WI0J64dRtI1lv6KpTB0=
X-Received: by 2002:ab0:4741:: with SMTP id i1mr658108uac.36.1551777979865;
 Tue, 05 Mar 2019 01:26:19 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com>
 <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com>
 <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com> <CAOQ4uxg_D0r2L=6zg4yxN1AfzkK8aHkWwOQPKEaKt8Z7WtVf2w@mail.gmail.com>
In-Reply-To: <CAOQ4uxg_D0r2L=6zg4yxN1AfzkK8aHkWwOQPKEaKt8Z7WtVf2w@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 5 Mar 2019 09:26:08 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7F8tuczjCXCUOewuJu3CKLq+MgYv-B2mbLA8qep7+xyA@mail.gmail.com>
Message-ID: <CAL3q7H7F8tuczjCXCUOewuJu3CKLq+MgYv-B2mbLA8qep7+xyA@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 5, 2019 at 5:59 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Mar 5, 2019 at 12:31 AM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > On Mon, Mar 4, 2019 at 5:59 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Mar 4, 2019 at 5:23 PM Filipe Manana <fdmanana@kernel.org> wrote:
> > > >
> > > > On Mon, Mar 4, 2019 at 3:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > > > > >
> > > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > > >
> > > > > > Test that if we truncate a file to reduce its size, rename it and then
> > > > > > fsync it, after a power failure the file has a correct size and name.
> > > > > >
> > > > >
> > > > > I am not sure that ext4/xfs semantics guaranty anything about
> > > > > persisting file name after fsync of file?...
> > > > >
> > > > > > This test is motivated by a bug found in btrfs, which is fixed by a
> > > > > > patch for the linux kernel titled:
> > > > > >
> > > > > >   "Btrfs: fix incorrect file size after shrinking truncate and fsync"
> > > > >
> > > > > At least the title of this patch says nothing about persisting the
> > > > > name.
> > > >
> > > > Because the bug in btrfs is not about persisting the name, it's about
> > > > persisting the correct inode size.
> > > >
> > >
> > > OK. Still AFAIK, ext4/xfs don't guaranty that the name bar will exist
> > > after power failure unless the parent dir was fsynced.
> > > If you fsync the parent dir instead of the file after rename, it will
> > > make the test correct for ext4/xfs (and POSIX for that matter).
> >
> > I'm not so sure about that. Couldn't find anything explicit anywhere about that.
>
> man fsync(2):
> "       Calling  fsync() does not necessarily ensure that the entry in
> the directory
>         containing the file has also reached disk.  For that an
> explicit fsync() on a file
>         descriptor for the directory is also needed."
>
> > There are other tests that do similar assumptions, either after
> > renames or after adding a new
> > hard link (fsyncing just the file being enough to guarantee the new
> > hard link exits after a power
> > failure, without the need to fsync the parent directory). I don't
> > recall ever having had such comment before,
>
> Because I missed it in review...
>
> > even for much more complex cases involving renames
> > such as [1] for example.
> >
> > [1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=e2d866668a98af4cd47cd6913418e410cd80aa93
> >
> > In this case both old and new names are in the same parent directory,
> > but if they were in different directories, and
> > requiring the user/application to fsync both directories, it could be
> > dangerous, if the old parent dir is fsync'ed and
> > a power failure happened before fsync'ing the new parent (requiring
> > the user/application to know about this
> > and fsync the new parent before the old parent dir also seems very
> > demanding), leading to a potential file loss
> > after replaying the log/journal (there were such cases in btrfs before).
> >
>
> This is not a problem for ext4/xfs.
> fsync(newdir) guarantees persisting new filename
> metadata ordering implies that olddir changes (and file nlink)
> also persist.
>
> To meet requirement of both btrfs and ext4/xfs in that case
> your test may fsync both file AND newdir, as long as this
> still allows your test to catch the bug?
>
> > > Will that test modification still catch the btrfs bug (pre fix)?
> >
> > Yes, it will still trigger the btrfs bug.
> >
> > Well, I don't mind doing such change, but I would like to hear other
> > opinions too, perhaps Dave could shed some light on this?
> > Even old reiserfs and f2fs (both on posix and strict fsync modes)
> > currently pass this test.
> >
>
> As I wrote to Dave, if file is not "metadata dirty" before rename,
> then whether or not rename dirties to file for fsync is a filesystem
> specific implementation detail that is not in any standard.
>
> Since filesystems tend to try to optimize out unneeded journal
> commits, so the observation about what filesystems do today
> empirically is not a sufficiently strong argument.

Even if the strictly ordered metadata guarantees Dave explained so
many time before is not formally defined anywhere,
I think it's a behavior that shouldn't change, as not only it makes
sense, but applications might be relying on it and therefore
useful to make sure no regressions happen. If such tests should be
shared (and run only filesystems known to support
the strictly ordered metadata) or require something special, is
another question.

>
> Again, if your test can afford to do fsync of file and parent dir
> it is best to be on the safe side (please audit other similar tests
> that you know about). If your test cannot afford to fsync parent
> dir, then at least a fat comment about this issue is worth about
> the expected (but not guaranteed) effects of fsync of file.

I'm sending a v2 with the fsync against the parent directory, despite
not being needed for any fs I could
run the tests against, because it's a generic test.

Thanks.

>
> Thanks,
> Amir.
