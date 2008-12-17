From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: weird bash autocomplete issue
Date: Wed, 17 Dec 2008 03:55:22 +0100
Message-ID: <1229482522.7574.6.camel@nga>
References: <545246795@web.de>
	 <ac3eb2510812161341x6af4b26erc4254850f11a6fcc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812161341x6af4b26erc4254850f11a6fcc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-16 at 22:41 +0100, Kay Sievers wrote:
> On Tue, Dec 16, 2008 at 21:46,  <devzero@web.de> wrote:
> >> On Tue, Dec 16, 2008 at 20:37, Roland <devzero@web.de> wrote:
> >> > i have come across a weird autocomplete issue i assume it is related to
> >> > btrfs.
> >> >
> >> > let`s have some dirs:
> >> >
> >> > /non-btrfs-mount
> >> >   ./linux
> >> >   ./testdir
> >> >
> >> > /brtfs-mount
> >> >   ./linux
> >> >   ./testdir
> >> >
> >> > now, if i do "cd t<tab>" in /non-btrfs-mount, "t" autocompletes to "testdir"
> >> > same for l<tab>inux - bash autocompletes as expected.
> >> >
> >> > now, the weird thing is, that on /btrfs-mount this behaves different.
> >> >
> >> > autocompletion for testdir works, but not for linux dir. weird.
> >> >
> >> > can someone reproduce this ?
> >>
> >> Open another shell, find the bash process pid of the first shell with:
> >>   ps afx
> >> and do:
> >>   strace -p <pid>
> >> Go back to the first shell, hit <tab>, and the trace should show
> >> what's going on. You see a significant difference there?
> >
> >
> > ok, here we go (i hope i did not cut important parts).
> > i don`t see the real issue, but i did another interesting finding - see below
> >
> >
> > bad (cd l<tab>):
> >
> > open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
> > fstat64(3, {st_dev=makedev(0, 19), st_ino=256, st_mode=S_IFDIR|0555, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=18, st_atime=2008/12/16-21:32:38, st_mtime=2008/12/16-21:32:37, st_ctime=2008/12/16-21:32:37}) = 0
> > getdents64(3, {{d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, d_name="."} {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, d_name=".."} {d_ino=257, d_off=3, d_type=DT_DIR, d_reclen=24, d_name="test"} {d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, d_reclen=32, d_name="linux"}}, 4096) = 104
> > _llseek(3, 3, [3], SEEK_SET)            = 0
> > getdents64(3, {{d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, d_reclen=32, d_name="linux"}}, 4096) = 32
> 
> On Tue, Dec 16, 2008 at 22:26,  <devzero@web.de> wrote:
> > i assume it has something to do with the large value for d_off of the last dirent ?
> 
> Looks like, 9223372036854775807 is just LLONG_MAX.

I can not reproduce that (on openSUSE 11.1). I also don't see
the _llseek() calls.

open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
fstat(3, {st_dev=makedev(0, 18), ...
getdents64(3, {
  {d_ino=260, d_off=2, d_type=DT_DIR, d_reclen=24, d_name="."}
  {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, d_name=".."}
  {d_ino=261, d_off=3, d_type=DT_REG, d_reclen=24, d_name="a"}
  {d_ino=262, d_off=4, d_type=DT_REG, d_reclen=24, d_name="b"}
  {d_ino=263, d_off=5, d_type=DT_REG, d_reclen=24, d_name="c"}
  {d_ino=264, d_off=6, d_type=DT_DIR, d_reclen=24, d_name="test"}
  {d_ino=265, d_off=9223372036854775807, d_type=DT_DIR, d_reclen=32, d_name="linux"}
}, 4096) = 176
getdents64(3, {}, 4096)                 = 0
close(3)                     

This is with today's git kernel and today's standalone btrfs unstable.

You are using the distro kernel and compile the standalone btrfs module?

Kay

