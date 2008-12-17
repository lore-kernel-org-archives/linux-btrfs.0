From: Chris Mason <chris.mason@oracle.com>
Subject: Re: weird bash autocomplete issue
Date: Wed, 17 Dec 2008 09:17:35 -0500
Message-ID: <1229523456.27170.4.camel@think.oraclecorp.com>
References: <545246795@web.de>
	 <ac3eb2510812161341x6af4b26erc4254850f11a6fcc@mail.gmail.com>
	 <1229482522.7574.6.camel@nga>
	 <120501c96025$3bfca7c0$0301a8c0@bui.materna.com>
	 <ac3eb2510812170559o32e1942mbaac558dfc380f19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Roland <devzero@web.de>, linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812170559o32e1942mbaac558dfc380f19@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-17 at 14:59 +0100, Kay Sievers wrote:
> On Wed, Dec 17, 2008 at 09:45, Roland <devzero@web.de> wrote:
> >> On Tue, 2008-12-16 at 22:41 +0100, Kay Sievers wrote:
> >>>
> >>> > open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
> >>> > fstat64(3, {st_dev=makedev(0, 19), st_ino=256, st_mode=S_IFDIR|0555, >
> >>> > st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, > st_size=18,
> >>> > st_atime=2008/12/16-21:32:38, st_mtime=2008/12/16-21:32:37, >
> >>> > st_ctime=2008/12/16-21:32:37}) = 0
> >>> > getdents64(3, {{d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, >
> >>> > d_name="."} {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, > d_name=".."}
> >>> > {d_ino=257, d_off=3, d_type=DT_DIR, d_reclen=24, > d_name="test"}
> >>> > {d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, > d_reclen=32,
> >>> > d_name="linux"}}, 4096) = 104
> >>> > _llseek(3, 3, [3], SEEK_SET)            = 0
> >>> > getdents64(3, {{d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, >
> >>> > d_reclen=32, d_name="linux"}}, 4096) = 32
> >>>
> >>> On Tue, Dec 16, 2008 at 22:26,  <devzero@web.de> wrote:
> >>> > i assume it has something to do with the large value for d_off of the >
> >>> > last dirent ?
> >>>
> >>> Looks like, 9223372036854775807 is just LLONG_MAX.
> >>
> >> I can not reproduce that (on openSUSE 11.1). I also don't see
> >> the _llseek() calls.
> >
> > weird. no btrfs issue then !?
> >
> >>
> >> open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
> >> fstat(3, {st_dev=makedev(0, 18), ...
> >> getdents64(3, {
> >>  {d_ino=260, d_off=2, d_type=DT_DIR, d_reclen=24, d_name="."}
> >>  {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, d_name=".."}
> >>  {d_ino=261, d_off=3, d_type=DT_REG, d_reclen=24, d_name="a"}
> >>  {d_ino=262, d_off=4, d_type=DT_REG, d_reclen=24, d_name="b"}
> >>  {d_ino=263, d_off=5, d_type=DT_REG, d_reclen=24, d_name="c"}
> >>  {d_ino=264, d_off=6, d_type=DT_DIR, d_reclen=24, d_name="test"}
> >>  {d_ino=265, d_off=9223372036854775807, d_type=DT_DIR, d_reclen=32,
> >> d_name="linux"}
> >> }, 4096) = 176
> >> getdents64(3, {}, 4096)                 = 0
> >> close(3)
> >>
> >> This is with today's git kernel and today's standalone btrfs unstable.
> >>
> >> You are using the distro kernel and compile the standalone btrfs module?
> >
> > yes.
> > to be honest, i`m slightly newer than 11.1 (did zypper dup to latest factory
> > some days ago)
> >
> > linux:~ # bash -version
> > GNU bash, version 3.2.39(1)-release (i586-suse-linux-gnu)
> > Copyright (C) 2007 Free Software Foundation, Inc.
> 
> That is still the same bash, the one you use is a 32bit version. Do
> you run a 32 bit kernel too? I could try that on a 32 bit box then.

At least on my 32 bit box, tab completion works fine.  But, the d_off of
LLONG_MAX comes from btrfs_readdir().  Git had a feature where it would
loop infinitely over a directory in some cases and this was my
workaround.

This should be fixed in git by now, so I can drop it if that really is
causing problems in bash.

-chris


