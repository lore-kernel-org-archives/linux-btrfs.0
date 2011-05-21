From: Craig Johnson <crajohns@gmail.com>
Subject: Re: btrfsck: couldn't open because of unsupported option features (8)
Date: Fri, 20 May 2011 22:20:15 -0500
Message-ID: <BANLkTiknUL+xPt0QY9W+RiGMJ0FS_bosRQ@mail.gmail.com>
References: <BANLkTimkczntdTaPYOGznnPp6xfA+=wNSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, crajohns@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimkczntdTaPYOGznnPp6xfA+=wNSA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I've made a little progress - compiled from the tmp branch of
btrfs-progs-unstable, and the unsupported feature error message goes
away.  However, now I segfault when running any command after three
parent transid failures.  Gdb gives me this:

Starting program: /home/xbmc/btrfs-progs-unstable/btrfs-debug-tree /dev=
/sda1
parent transid verify failed on 6038227976192 wanted 337418 found 33785=
3
parent transid verify failed on 6038227976192 wanted 337418 found 33785=
3
parent transid verify failed on 6038227976192 wanted 337418 found 33785=
3

Program received signal SIGSEGV, Segmentation fault.
find_first_block_group (root=3D0x61d1b0, path=3D0x61ef10, key=3D0x7ffff=
fffe240)
    at extent-tree.c:3028
3028                    if (slot >=3D btrfs_header_nritems(leaf)) {

Any possible way to recover from this?

On Fri, May 20, 2011 at 8:08 AM, Craig Johnson <crajohns@gmail.com> wro=
te:
> After upgrading from 2.6.39-rc7 to 2.6.39 this morning, I tried to
> mount my 3 disk btrfs volume (no subvolumes, space caching enabled,
> lzo compression) and received some parent transid errors (going back
> to rc7 didn't help, though):
>
> btrfs: disk space caching is enabled
> parent transid verify failed on 6038227976192 wanted 337418 found 337=
853
> parent transid verify failed on 6038227976192 wanted 337418 found 337=
853
> parent transid verify failed on 6038227976192 wanted 337418 found 337=
853
> parent transid verify failed on 6038227976192 wanted 337418 found 337=
853
> parent transid verify failed on 6038227976192 wanted 337418 found 337=
853
> Failed to read block groups: -5
> btrfs: open_ctree failed
>
> Tried to mount without space_cache give the same message.
>
> Trying to run btrfsck (or btrfs-debug-tree), compiled from git gives =
me this:
>
>
> couldn't open because of unsupported option features (8).
> btrfsck: disk-io.c:683: open_ctree_fd: Assertion `!(1)' failed.
> Aborted
>
>
> I see an Ubuntu bug (748340 -
> https://bugs.launchpad.net/ubuntu/+source/btrfs-tools/+bug/748340)
> with a similar output (they get an unsupported option features (2)
> instead of (8)), but there isn't any resolution that I see. =A0Is the=
re
> anything I can do to resolve this? =A0I can't mount degraded or ro or
> anything. =A0Thanks!
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
