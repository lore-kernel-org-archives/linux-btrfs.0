Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYKi2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:38:28 -0400
Date: Fri, 25 Apr 2014 18:38:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs-progs: open file with O_RDONLY on getting
 property
Message-ID: <20140425103818.GC6138@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
 <1398407399-10963-2-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H58hq4jQtd5seBN96LhW3tDYHB1D0+Gsde6=En3MMF_4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H58hq4jQtd5seBN96LhW3tDYHB1D0+Gsde6=En3MMF_4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 11:04:39AM +0100, Filipe David Manana wrote:
> On Fri, Apr 25, 2014 at 7:29 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > We don't need change an object when getting its property,
> > so O_RDWR is not necessary in this case.  Moreover, the object
> > may be readonly, with O_RDWR it will fail.
> 
> 
> This was already addressed here Liu:
> https://patchwork.kernel.org/patch/3995151/

Okay, please ignore this.

thanks,
-liubo

> 
> thanks
> 
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  props.c |  5 ++++-
> >  utils.c | 14 ++++++++++++--
> >  utils.h |  1 +
> >  3 files changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/props.c b/props.c
> > index 53223a3..a49f8e0 100644
> > --- a/props.c
> > +++ b/props.c
> > @@ -120,7 +120,10 @@ static int prop_compression(enum prop_object_type type,
> >         char *buf = NULL;
> >         char *xattr_name = NULL;
> >
> > -       fd = open_file_or_dir(object, &dirstream);
> > +       if (!value)
> > +               fd = open_file_or_dir_ro(object, &dirstream);
> > +       else
> > +               fd = open_file_or_dir(object, &dirstream);
> >         if (fd == -1) {
> >                 ret = -errno;
> >                 fprintf(stderr, "ERROR: open %s failed. %s\n",
> > diff --git a/utils.c b/utils.c
> > index 3e9c527..110a0d1 100644
> > --- a/utils.c
> > +++ b/utils.c
> > @@ -1622,7 +1622,7 @@ u64 parse_size(char *s)
> >         return strtoull(s, NULL, 10) * mult;
> >  }
> >
> > -int open_file_or_dir(const char *fname, DIR **dirstream)
> > +static int __open_file_or_dir(const char *fname, DIR **dirstream, int ro)
> >  {
> >         int ret;
> >         struct stat st;
> > @@ -1638,7 +1638,7 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
> >                         return -1;
> >                 fd = dirfd(*dirstream);
> >         } else if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
> > -               fd = open(fname, O_RDWR);
> > +               fd = open(fname, (!!ro) ? O_RDONLY : O_RDWR);
> >         } else {
> >                 /*
> >                  * we set this on purpose, in case the caller output
> > @@ -1655,6 +1655,16 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
> >         return fd;
> >  }
> >
> > +int open_file_or_dir(const char *fname, DIR **dirstream)
> > +{
> > +       return __open_file_or_dir(fname, dirstream, 0);
> > +}
> > +
> > +int open_file_or_dir_ro(const char *fname, DIR **dirstream)
> > +{
> > +       return __open_file_or_dir(fname, dirstream, 1);
> > +}
> > +
> >  void close_file_or_dir(int fd, DIR *dirstream)
> >  {
> >         if (dirstream)
> > diff --git a/utils.h b/utils.h
> > index 3c62066..5489cc2 100644
> > --- a/utils.h
> > +++ b/utils.h
> > @@ -72,6 +72,7 @@ int btrfs_scan_block_devices(int run_ioctl);
> >  u64 parse_size(char *s);
> >  u64 arg_strtou64(const char *str);
> >  int open_file_or_dir(const char *fname, DIR **dirstream);
> > +int open_file_or_dir_ro(const char *fname, DIR **dirstream);
> >  void close_file_or_dir(int fd, DIR *dirstream);
> >  int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
> >                 struct btrfs_ioctl_dev_info_args **di_ret);
> > --
> > 1.8.2.1
> >
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
