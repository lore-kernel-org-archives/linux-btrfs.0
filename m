From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for
 using uninitialized variable
Date: Sun, 12 Sep 2010 13:36:21 +0300
Message-ID: <AANLkTimU2k6=GPgMsabqpv+uwTVWtSoOoUmwOBbSAT4K@mail.gmail.com>
References: <1284129724.23418.27.camel@ubuntu1004pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, josef@redhat.com, zheng.yan@oracle.com,
	jens.axboe@oracle.com, tj@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Frank Morales II <altf2o@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1284129724.23418.27.camel@ubuntu1004pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 10, 2010 at 5:42 PM, Frank Morales II <altf2o@gmail.com> wr=
ote:
> >From 1c304defc543738f82ccb18fe10b558dd2098d74 Mon Sep 17 00:00:00 20=
01
> From: Frank Morales II <altf2o@gmail.com>
> Date: Fri, 10 Sep 2010 07:34:23 -0700
> Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for=
 using uninitialized variable
>
> In the function tree_search, the variable prev was used without first
> being initialized, causing compiler warning messages. Initializing
> prev to NULL resolved the issue.
>
> Kernal patched against: 2.6.36-rc3 (df423dc7)

Signed-of-by: Felipe Contreras <felipe.contreras@gmail.com>

I came up with exactly this patch, but this is my commit message:

    Btrfs: fix compilation warning

    fs/btrfs/ordered-data.c: In function =E2=80=98tree_search=E2=80=99:
    fs/btrfs/ordered-data.c:144: warning: =E2=80=98prev=E2=80=99 may be=
 used
uninitialized in this function
    fs/btrfs/ordered-data.c: In function =E2=80=98btrfs_lookup_first_or=
dered_extent=E2=80=99:
    fs/btrfs/ordered-data.c:144: warning: =E2=80=98prev=E2=80=99 may be=
 used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: =E2=80=98prev=E2=80=99 was decla=
red here
    fs/btrfs/ordered-data.c: In function =E2=80=98btrfs_lookup_ordered_=
extent=E2=80=99:
    fs/btrfs/ordered-data.c:144: warning: =E2=80=98prev=E2=80=99 may be=
 used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: =E2=80=98prev=E2=80=99 was decla=
red here
    fs/btrfs/ordered-data.c: In function =E2=80=98btrfs_lookup_ordered_=
range=E2=80=99:
    fs/btrfs/ordered-data.c:144: warning: =E2=80=98prev=E2=80=99 may be=
 used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: =E2=80=98prev=E2=80=99 was decla=
red here
    fs/btrfs/ordered-data.c: In function =E2=80=98btrfs_dec_test_ordere=
d_pending=E2=80=99:
    fs/btrfs/ordered-data.c:144: warning: =E2=80=98prev=E2=80=99 may be=
 used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: =E2=80=98prev=E2=80=99 was decla=
red here

    __tree_search() might not set &prev.

--=20
=46elipe Contreras
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
