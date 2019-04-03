Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09761C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 21:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D043E2082C
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 21:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfDCVf5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:35:57 -0400
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60122
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfDCVf5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 17:35:57 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail02.adl6.internode.on.net with ESMTP; 04 Apr 2019 08:05:51 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hBnXw-0008KZ-OJ; Thu, 04 Apr 2019 08:35:48 +1100
Date:   Thu, 4 Apr 2019 08:35:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2 1/7] fsstress: allow fsync on directories too
Message-ID: <20190403213548.GZ26298@dastard>
References: <20190401125018.10009-1-fdmanana@kernel.org>
 <20190403021819.GW23020@dastard>
 <CAL3q7H7kJ5VnCxBA+NYuxrpeRbi=vTQXsk7TFwSjCAQSixNGew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7kJ5VnCxBA+NYuxrpeRbi=vTQXsk7TFwSjCAQSixNGew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 03, 2019 at 05:35:20PM +0000, Filipe Manana wrote:
> On Wed, Apr 3, 2019 at 3:18 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Apr 01, 2019 at 01:50:18PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Currently the fsync function can only be performed against regular files.
> > > Allow it to operate on directories too, to increase test coverage and
> > > allow for chances of finding bugs in a filesystem's implementation of
> > > fsync against directories.
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >
> > > V2: Added helper functions to open and close files or directories.
> >
> > not exactly what I meant, more below....
> > >
> > >  ltp/fsstress.c | 42 +++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 39 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > index 2223fd7d..1169b840 100644
> > > --- a/ltp/fsstress.c
> > > +++ b/ltp/fsstress.c
> > > @@ -303,6 +303,7 @@ int       attr_remove_path(pathname_t *, const char *, int);
> > >  int  attr_set_path(pathname_t *, const char *, const char *, const int, int);
> > >  void check_cwd(void);
> > >  void cleanup_flist(void);
> > > +void close_file_or_dir(int, DIR *);
> > >  int  creat_path(pathname_t *, mode_t);
> > >  void dcache_enter(int, int);
> > >  void dcache_init(void);
> > > @@ -324,6 +325,7 @@ void      make_freq_table(void);
> > >  int  mkdir_path(pathname_t *, mode_t);
> > >  int  mknod_path(pathname_t *, mode_t, dev_t);
> > >  void namerandpad(int, char *, int);
> > > +int  open_file_or_dir(pathname_t *, int, DIR **);
> > >  int  open_path(pathname_t *, int);
> > >  DIR  *opendir_path(pathname_t *);
> > >  void process_freq(char *);
> > > @@ -852,6 +854,15 @@ cleanup_flist(void)
> > >       }
> > >  }
> > >
> > > +void
> > > +close_file_or_dir(int fd, DIR *dir)
> > > +{
> > > +     if (dir)
> > > +             closedir(dir);
> > > +     else
> > > +             close(fd);
> > > +}
> > > +
> > >  int
> > >  creat_path(pathname_t *name, mode_t mode)
> > >  {
> > > @@ -1385,6 +1396,30 @@ namerandpad(int id, char *buf, int i)
> > >  }
> > >
> > >  int
> > > +open_file_or_dir(pathname_t *name, int flags, DIR **dir)
> > > +{
> > > +     int fd;
> > > +
> > > +     fd = open_path(name, flags);
> > > +     if (fd < 0 && errno == EISDIR) {
> > > +             *dir = opendir_path(name);
> >
> > Why this function, and not just open(O_DIRECTORY)?
> 
> The reason I did it is because if flags are O_WRONLY (or O_RDWR),
> opening a directory always fails (even with O_DIRECTORY) with errno
> EISDIR.
> If the access flags are O_RDONLY, opening a directory succeeds
> regardless of O_DIRECTORY being passed to open(2).
> 
> Since I supposed fsetxattr(2) and fsync(2) could be considered write
> operations, I went for the use of opendir_path(), using the dir stream
> and all that hassle.
> 
> But now I just tested if fsync and fsetxattr work if the file is open
> O_RDONLY, and to my surprise they do.
> 
> Test program:
> 
> https://friendpaste.com/7gUN4kB3ZfHwVdlDggodUY
> 
> Output with O_WRONLY |  O_DIRECTORY passed to open(2):
> 
> $ mkfs.xfs -f /dev/sdc
> $ mount /dev/sdc /mnt
> 
> $ touch /mnt/file
> $ mkdir /mnt/dir
> 
> $ ./test_open /mnt/file
> open error 20: Not a directory
> $ ./test_open /mnt/dir
> open error 21: Is a directory
> 
> Output with only O_RDONLY passed to open(2):
> 
> $ mkfs.xfs -f /dev/sdc
> $ mount /dev/sdc /mnt
> 
> $ touch /mnt/file
> $ mkdir /mnt/dir
> 
> $ ./test_open /mnt/file
> file open fd = 3, setxattr(fd) = 0, fsync(fd) = 0
> $ ./test_open /mnt/dir
> file open fd = 3, setxattr(fd) = 0, fsync(fd) = 0
> 
> Perhaps I did something wrong, as it's late here right now.

Pretty sure this is because setxattr() checks inode permissions, not
file descriptor read/write modes to determine whether an xattr can
be set/modified/removed. i.e. you own the directory, have write
permissions to the directory, and so you can minipulate xattrs on
it.

FWIW, why even bother with opening fd's at all here? you could just
use set/get/removexattr() directly on the path name and not have to
worry about opening the file...

> So should we go for ensuring O_RDONLY is used when the first open
> fails with EISDIR (and add some comment explaining this in case I'm
> not the only for which this was a surprise)

If we actually need to open the fd, then yes - using
opendir()/dirfd() is essentially doing that for you behind the
scenes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
