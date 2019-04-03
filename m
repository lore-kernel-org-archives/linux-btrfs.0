Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8765EC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 17:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3573C206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554312935;
	bh=+5t79MGxrIuSo8TcuD+ehD21k5iP208mS6zpHYmn874=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=s5r6wYVMA/+yJGxObfRkZDZhdmFImItqjFTZyt7jsCJu5EOrXKb21hiGm55w17fo/
	 NvJQo+9l2x4P6mwVigNFvzQaztK9nxZxQqzozNNHlpVRUZPEu/iHZSBY72UJ38vTTb
	 sBkWT3IA4tE+hAdcBpIh0MSNchFiFx4AYD7dsjUU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDCRfe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfDCRfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 13:35:34 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5198820830;
        Wed,  3 Apr 2019 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554312932;
        bh=+5t79MGxrIuSo8TcuD+ehD21k5iP208mS6zpHYmn874=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FvidhN33cdv3ePQJK7FgFULE4PnVAMLnjRG959pOrsszXvcoybqMaev3J3CecHYUK
         T59yNzUE9vg3Zw0iypgxVpg8GH4CeBkEoXubUrRKbJ6v6xZrdErRo8bOJxfCD/XUl9
         FWsxBkJr2+sE6mMbPYexs95HPELb4bbA9pXvQbfE=
Received: by mail-vs1-f53.google.com with SMTP id n4so10500051vsm.3;
        Wed, 03 Apr 2019 10:35:32 -0700 (PDT)
X-Gm-Message-State: APjAAAWuVsSWDadY6rmzP914h0WyuozUnzcCCcda3yxuwLOLwTYuehbx
        UPszdfDf0sQ3WOE36GphRMY/UlpCSBkvKpcIh9o=
X-Google-Smtp-Source: APXvYqyiMHk1TMTgt3rT+P/j6cdKf8hcM8aEZG3lbMAMwiuJvftKGCxmeuE+A3D99jsHHUz+gNQQ1xNOyvKMC+Xw/K8=
X-Received: by 2002:a67:f3c3:: with SMTP id j3mr1080830vsn.206.1554312931467;
 Wed, 03 Apr 2019 10:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190401125018.10009-1-fdmanana@kernel.org> <20190403021819.GW23020@dastard>
In-Reply-To: <20190403021819.GW23020@dastard>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 3 Apr 2019 17:35:20 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7kJ5VnCxBA+NYuxrpeRbi=vTQXsk7TFwSjCAQSixNGew@mail.gmail.com>
Message-ID: <CAL3q7H7kJ5VnCxBA+NYuxrpeRbi=vTQXsk7TFwSjCAQSixNGew@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] fsstress: allow fsync on directories too
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 3, 2019 at 3:18 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Apr 01, 2019 at 01:50:18PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Currently the fsync function can only be performed against regular files.
> > Allow it to operate on directories too, to increase test coverage and
> > allow for chances of finding bugs in a filesystem's implementation of
> > fsync against directories.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Added helper functions to open and close files or directories.
>
> not exactly what I meant, more below....
> >
> >  ltp/fsstress.c | 42 +++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 3 deletions(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 2223fd7d..1169b840 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -303,6 +303,7 @@ int       attr_remove_path(pathname_t *, const char *, int);
> >  int  attr_set_path(pathname_t *, const char *, const char *, const int, int);
> >  void check_cwd(void);
> >  void cleanup_flist(void);
> > +void close_file_or_dir(int, DIR *);
> >  int  creat_path(pathname_t *, mode_t);
> >  void dcache_enter(int, int);
> >  void dcache_init(void);
> > @@ -324,6 +325,7 @@ void      make_freq_table(void);
> >  int  mkdir_path(pathname_t *, mode_t);
> >  int  mknod_path(pathname_t *, mode_t, dev_t);
> >  void namerandpad(int, char *, int);
> > +int  open_file_or_dir(pathname_t *, int, DIR **);
> >  int  open_path(pathname_t *, int);
> >  DIR  *opendir_path(pathname_t *);
> >  void process_freq(char *);
> > @@ -852,6 +854,15 @@ cleanup_flist(void)
> >       }
> >  }
> >
> > +void
> > +close_file_or_dir(int fd, DIR *dir)
> > +{
> > +     if (dir)
> > +             closedir(dir);
> > +     else
> > +             close(fd);
> > +}
> > +
> >  int
> >  creat_path(pathname_t *name, mode_t mode)
> >  {
> > @@ -1385,6 +1396,30 @@ namerandpad(int id, char *buf, int i)
> >  }
> >
> >  int
> > +open_file_or_dir(pathname_t *name, int flags, DIR **dir)
> > +{
> > +     int fd;
> > +
> > +     fd = open_path(name, flags);
> > +     if (fd < 0 && errno == EISDIR) {
> > +             *dir = opendir_path(name);
>
> Why this function, and not just open(O_DIRECTORY)?

The reason I did it is because if flags are O_WRONLY (or O_RDWR),
opening a directory always fails (even with O_DIRECTORY) with errno
EISDIR.
If the access flags are O_RDONLY, opening a directory succeeds
regardless of O_DIRECTORY being passed to open(2).

Since I supposed fsetxattr(2) and fsync(2) could be considered write
operations, I went for the use of opendir_path(), using the dir stream
and all that hassle.

But now I just tested if fsync and fsetxattr work if the file is open
O_RDONLY, and to my surprise they do.

Test program:

https://friendpaste.com/7gUN4kB3ZfHwVdlDggodUY

Output with O_WRONLY |  O_DIRECTORY passed to open(2):

$ mkfs.xfs -f /dev/sdc
$ mount /dev/sdc /mnt

$ touch /mnt/file
$ mkdir /mnt/dir

$ ./test_open /mnt/file
open error 20: Not a directory
$ ./test_open /mnt/dir
open error 21: Is a directory

Output with only O_RDONLY passed to open(2):

$ mkfs.xfs -f /dev/sdc
$ mount /dev/sdc /mnt

$ touch /mnt/file
$ mkdir /mnt/dir

$ ./test_open /mnt/file
file open fd = 3, setxattr(fd) = 0, fsync(fd) = 0
$ ./test_open /mnt/dir
file open fd = 3, setxattr(fd) = 0, fsync(fd) = 0

Perhaps I did something wrong, as it's late here right now.

So should we go for ensuring O_RDONLY is used when the first open
fails with EISDIR (and add some comment explaining this in case I'm
not the only for which this was a surprise)

Thanks.


> None of the code that uses this function actually uses the DIR *
> that is returned, just the fd that is extracted from it. So why no
> just open() the directory directly and avoid having all the mess
> with dir streams that aren't needed?
>
>
> > +             if (*dir) {
> > +                     fd = dirfd(*dir);
> > +                     if (fd < 0) {
> > +                             int e = errno;
> > +
> > +                             closedir(*dir);
> > +                             *dir = NULL;
> > +                             errno = e;
> > +                     }
> > +             }
> > +     } else {
> > +             *dir = NULL;
> > +     }
> > +     return fd;
>
> Excessive nesting. I think this should be as simple as:
>
>         fd = open_path(name, flags);
>         if (fd < 0 && errno != EISDIR) {
>                 return -1;
>         return open_path(name, flags | O_DIRECTORY);
>
> And the close_file_or_dir() function is completely unnecessary.
>
>
> > +
> > +int
> >  open_path(pathname_t *name, int oflag)
> >  {
> >       char            buf[NAME_MAX + 1];
> > @@ -3440,15 +3475,16 @@ fsync_f(int opno, long r)
> >       pathname_t      f;
> >       int             fd;
> >       int             v;
> > +     DIR             *dir;
> >
> >       init_pathname(&f);
> > -     if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> > +     if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
> >               if (v)
> >                       printf("%d/%d: fsync - no filename\n", procid, opno);
> >               free_pathname(&f);
> >               return;
> >       }
> > -     fd = open_path(&f, O_WRONLY);
> > +     fd = open_file_or_dir(&f, O_WRONLY, &dir);
> >       e = fd < 0 ? errno : 0;
> >       check_cwd();
> >       if (fd < 0) {
>
> This whole hunk - from init_pathname to check_cwd - was what I was
> suggesting you factor out, not just the open_path() code.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
