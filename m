From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: weird bash autocomplete issue
Date: Wed, 17 Dec 2008 23:15:29 +0100
Message-ID: <ac3eb2510812171415u1b2fc166r2ba10999542808fe@mail.gmail.com>
References: <545246795@web.de>
	 <ac3eb2510812161341x6af4b26erc4254850f11a6fcc@mail.gmail.com>
	 <1229482522.7574.6.camel@nga>
	 <120501c96025$3bfca7c0$0301a8c0@bui.materna.com>
	 <ac3eb2510812170559o32e1942mbaac558dfc380f19@mail.gmail.com>
	 <1229523456.27170.4.camel@think.oraclecorp.com>
	 <ac3eb2510812170646t5f02a9dfp6b01382c84db939d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roland <devzero@web.de>, linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812170646t5f02a9dfp6b01382c84db939d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2008 at 15:46, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Dec 17, 2008 at 15:17, Chris Mason <chris.mason@oracle.com> wrote:
>> On Wed, 2008-12-17 at 14:59 +0100, Kay Sievers wrote:
>>> On Wed, Dec 17, 2008 at 09:45, Roland <devzero@web.de> wrote:
>>> >> On Tue, 2008-12-16 at 22:41 +0100, Kay Sievers wrote:
>>> >>>
>>> >>> > open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
>>> >>> > fstat64(3, {st_dev=makedev(0, 19), st_ino=256, st_mode=S_IFDIR|0555, >
>>> >>> > st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, > st_size=18,
>>> >>> > st_atime=2008/12/16-21:32:38, st_mtime=2008/12/16-21:32:37, >
>>> >>> > st_ctime=2008/12/16-21:32:37}) = 0
>>> >>> > getdents64(3, {{d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, >
>>> >>> > d_name="."} {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, > d_name=".."}
>>> >>> > {d_ino=257, d_off=3, d_type=DT_DIR, d_reclen=24, > d_name="test"}
>>> >>> > {d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, > d_reclen=32,
>>> >>> > d_name="linux"}}, 4096) = 104
>>> >>> > _llseek(3, 3, [3], SEEK_SET)            = 0
>>> >>> > getdents64(3, {{d_ino=258, d_off=9223372036854775807, d_type=DT_DIR, >
>>> >>> > d_reclen=32, d_name="linux"}}, 4096) = 32
>>> >>>
>>> >>> On Tue, Dec 16, 2008 at 22:26,  <devzero@web.de> wrote:
>>> >>> > i assume it has something to do with the large value for d_off of the >
>>> >>> > last dirent ?
>>> >>>
>>> >>> Looks like, 9223372036854775807 is just LLONG_MAX.
>>> >>
>>> >> I can not reproduce that (on openSUSE 11.1). I also don't see
>>> >> the _llseek() calls.
>>> >
>>> > weird. no btrfs issue then !?
>>> >
>>> >>
>>> >> open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
>>> >> fstat(3, {st_dev=makedev(0, 18), ...
>>> >> getdents64(3, {
>>> >>  {d_ino=260, d_off=2, d_type=DT_DIR, d_reclen=24, d_name="."}
>>> >>  {d_ino=256, d_off=2, d_type=DT_DIR, d_reclen=24, d_name=".."}
>>> >>  {d_ino=261, d_off=3, d_type=DT_REG, d_reclen=24, d_name="a"}
>>> >>  {d_ino=262, d_off=4, d_type=DT_REG, d_reclen=24, d_name="b"}
>>> >>  {d_ino=263, d_off=5, d_type=DT_REG, d_reclen=24, d_name="c"}
>>> >>  {d_ino=264, d_off=6, d_type=DT_DIR, d_reclen=24, d_name="test"}
>>> >>  {d_ino=265, d_off=9223372036854775807, d_type=DT_DIR, d_reclen=32,
>>> >> d_name="linux"}
>>> >> }, 4096) = 176
>>> >> getdents64(3, {}, 4096)                 = 0
>>> >> close(3)
>>> >>
>>> >> This is with today's git kernel and today's standalone btrfs unstable.
>>> >>
>>> >> You are using the distro kernel and compile the standalone btrfs module?
>>> >
>>> > yes.
>>> > to be honest, i`m slightly newer than 11.1 (did zypper dup to latest factory
>>> > some days ago)
>>> >
>>> > linux:~ # bash -version
>>> > GNU bash, version 3.2.39(1)-release (i586-suse-linux-gnu)
>>> > Copyright (C) 2007 Free Software Foundation, Inc.
>>>
>>> That is still the same bash, the one you use is a 32bit version. Do
>>> you run a 32 bit kernel too? I could try that on a 32 bit box then.
>>
>> At least on my 32 bit box, tab completion works fine.
>
> It works fine here too on 64 bit. I'll try with openSUSE 11.1 on a
> 32bit box later tonight.
>
>> But, the d_off of
>> LLONG_MAX comes from btrfs_readdir().  Git had a feature where it would
>> loop infinitely over a directory in some cases and this was my
>> workaround.
>
> There are other filesystems doing the same, usually with 32bit int max
> instead of 64 bit int max, I guess that should work fine.
>
>> This should be fixed in git by now, so I can drop it if that really is
>> causing problems in bash.
>
> I'll come back if I can reproduce it with the same environment Roland is using.

I see the same issue on x86 32 bit, with the additional __llseek()
between the getdents64(), and the last entry returned by readdir
ignored.

If I change the returned LLONG_MAX to LONG_MAX in inode.c, it all
works fine, and the __llseek() disappears.

Kay
