Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504A9C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 10:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ECD0222B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550053313;
	bh=aDvgkIfdvLgaIcwqFnoSi9RzapinOOZPDbEmuQyg1yg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Ss3t+SSAym4Kquz+d7NmJXCUgiFVl8WU+VaY3+SIv/fTc6mmd6KedzRNcAYGVg4HP
	 ZX6KNk945Ybxnz5t/IETsu5jJ1WDzPegiN+ZTb75F4aX6IvbR+By3B36SfKbq2TxSU
	 VBfTpCah+tbOaaGojxwPlEHKQCXArQHd7tezIcG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389079AbfBMKVw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733047AbfBMKVv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 05:21:51 -0500
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CA821920;
        Wed, 13 Feb 2019 10:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550053310;
        bh=aDvgkIfdvLgaIcwqFnoSi9RzapinOOZPDbEmuQyg1yg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OuRZwbn4rmZkwsNHzLRXuLoNVzjBWAT2QOxrgELzE6NO3LebRcXe4t3hKIvYCa4O8
         eUO0vKyKiJEA/B1ZTnNGziwvZx51y1oppn1ypZfGiswMr/ux/c6MemMvHUhCp6L1nB
         95jpx/hH4lDpJqWBey4LcwxUVVEWkVUoI09Cm2Ak=
Received: by mail-ua1-f54.google.com with SMTP id z24so581125ual.8;
        Wed, 13 Feb 2019 02:21:50 -0800 (PST)
X-Gm-Message-State: AHQUAubPc/3/aimDrn8rm4286wlgZU5XZqXq4Za/iDqRjJFHb/l6qcbw
        cJbJzcd3CJF9jXdmqhElPCVEh6oM0wFStEjLRw0=
X-Google-Smtp-Source: AHgI3IYKAd3KynfKNAY1N/ccom4yPmOHBfm/kdwVN+TvmZGr4ppH3MFFXzqeqhe0fy1lLkFwQP1EfD+qIVTjJoGIHbc=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr3109933uao.36.1550053309703;
 Wed, 13 Feb 2019 02:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20181029094340.18154-1-fdmanana@kernel.org> <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
In-Reply-To: <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 13 Feb 2019 10:21:38 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>
Message-ID: <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 13, 2019 at 5:44 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/10/29 =E4=B8=8B=E5=8D=885:43, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Unless the '-s' option is passed to fssum, it should not detect file ho=
les
> > and have their existence influence the computed checksum for a file. Th=
is
> > tool was added to test btrfs' send/receive feature, so that it checks f=
or
> > any metadata and data differences between the original filesystem and t=
he
> > filesystem that receives send streams.
> >
> > For a long time the test btrfs/007, which tests btrfs' send/receive wit=
h
> > fsstress, fails sporadically reporting data differences between files.
> > However the md5sum/sha1sum from the reported files in the original and
> > new filesystems are the same. The reason why fssum fails is because eve=
n
> > in normal mode it still accounts for number of holes that exist in the
> > file and their respective lengths. This is done using the SEEK_DATA mod=
e
> > of lseek. The btrfs send feature does not preserve holes nor prealloc
> > extents (not supported by the current protocol), so whenever a hole or
> > prealloc (unwritten) extent is detected in the source filesystem, it
> > issues a write command full of zeroes, which will translate to a regula=
r
> > (written) extent in the destination filesystem. This is why fssum repor=
ts
> > a different checksum. A prealloc extent also counts as hole when using
> > lseek.
> >
> > For example when passing a seed of 1540592967 to fsstress in btrfs/007,
> > the test fails, as file p0/d0/f7 has a prealloc extent in the original
> > filesystem (in the incr snapshot).
> >
> > Fix this by making fssum just read the hole file and feed its data to t=
he
> > digest calculation function when option '-s' is not given. If we ever g=
et
> > btrfs' send/receive to support holes and fallocate, we can just change
> > the test and pass the '-s' option to all fssum calls.
>
> However this is causing more problem here.
>
> Now since fssum doesn't skip holes, for a super large sparse file, fssum
> will try to fill all the holes with zero and spend tons of CPU time
> calculating the result.

Yes. So will md5sum for example and many other things.

The problem is well known and it's due to the addition of the splice
operation to fsstress:

https://www.spinics.net/lists/fstests/msg11257.html

It was also making other tests slower.
This got fixed recently in the last Sunday's update by:

https://www.spinics.net/lists/fstests/msg11266.html

>
> E.g. when seed =3D 1550703281.
> We will have a PiB level file:
> $ ls /mnt/scratch/base/p0/f3 -alh
> -rw-rw-rw- 1 1441 2774 666P Feb 13 13:39 /mnt/scratch/base/p0/f3
>
> (well, 666, no wonder this will fail)
>
> But it only takes aroud 1M:
> $ du /mnt/scratch/base/p0/f3
> 1044    /mnt/scratch/base/p0/f3
>
> This is even more annoying than test failure.
>
> Can't we just filter out the fallocate/hole punching part in the test
> itself?

No. Removing fallocate and hole punching operations from btrfs/007, or
any other test, limits coverage.
There were bugs in the past uncovered by that test exactly because
fsstress exercises those operations.

Further, that would not prevent creation of sparse files. Operations
like pwrite, dwrite, clone, etc also cause sparse files.

>
> Thanks,
> Qu
>
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  src/fssum.c | 65 +++++------------------------------------------------=
--------
> >  1 file changed, 5 insertions(+), 60 deletions(-)
> >
> > diff --git a/src/fssum.c b/src/fssum.c
> > index 5da39abf..f1da72fb 100644
> > --- a/src/fssum.c
> > +++ b/src/fssum.c
> > @@ -224,71 +224,16 @@ int
> >  sum_file_data_permissive(int fd, sum_t *dst)
> >  {
> >       int ret;
> > -     off_t pos;
> > -     off_t old;
> > -     int i;
> > -     uint64_t zeros =3D 0;
> > -
> > -     pos =3D lseek(fd, 0, SEEK_CUR);
> > -     if (pos =3D=3D (off_t)-1)
> > -             return errno =3D=3D ENXIO ? 0 : -2;
> >
> >       while (1) {
> > -             old =3D pos;
> > -             pos =3D lseek(fd, pos, SEEK_DATA);
> > -             if (pos =3D=3D (off_t)-1) {
> > -                     if (errno =3D=3D ENXIO) {
> > -                             ret =3D 0;
> > -                             pos =3D lseek(fd, 0, SEEK_END);
> > -                             if (pos !=3D (off_t)-1)
> > -                                     zeros +=3D pos - old;
> > -                     } else {
> > -                             ret =3D -2;
> > -                     }
> > -                     break;
> > -             }
> >               ret =3D read(fd, buf, sizeof(buf));
> > -             assert(ret); /* eof found by lseek */
> > -             if (ret <=3D 0)
> > +             if (ret < 0)
> > +                     return -errno;
> > +             sum_add(dst, buf, ret);
> > +             if (ret < sizeof(buf))
> >                       break;
> > -             if (old < pos) /* hole */
> > -                     zeros +=3D pos - old;
> > -             for (i =3D 0; i < ret; ++i) {
> > -                     for (old =3D i; buf[i] =3D=3D 0 && i < ret; ++i)
> > -                             ;
> > -                     if (old < i) /* code like a hole */
> > -                             zeros +=3D i - old;
> > -                     if (i =3D=3D ret)
> > -                             break;
> > -                     if (zeros) {
> > -                             if (verbose >=3D 2)
> > -                                     fprintf(stderr,
> > -                                             "adding %llu zeros to sum=
\n",
> > -                                             (unsigned long long)zeros=
);
> > -                             sum_add_u64(dst, 0);
> > -                             sum_add_u64(dst, zeros);
> > -                             zeros =3D 0;
> > -                     }
> > -                     for (old =3D i; buf[i] !=3D 0 && i < ret; ++i)
> > -                             ;
> > -                     if (verbose >=3D 2)
> > -                             fprintf(stderr, "adding %u non-zeros to s=
um\n",
> > -                                     i - (int)old);
> > -                     sum_add(dst, buf + old, i - old);
> > -             }
> > -             pos +=3D ret;
> >       }
> > -
> > -     if (zeros) {
> > -             if (verbose >=3D 2)
> > -                     fprintf(stderr,
> > -                             "adding %llu zeros to sum (finishing)\n",
> > -                             (unsigned long long)zeros);
> > -             sum_add_u64(dst, 0);
> > -             sum_add_u64(dst, zeros);
> > -     }
> > -
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  int
> >
>
