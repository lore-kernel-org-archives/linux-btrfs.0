From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: please review recent fixes for file write and fiemap
Date: Wed, 9 Mar 2011 00:06:37 -0600
Message-ID: <AANLkTimxffcWmYp4rV4MLYUbjRUHwN0cpR-LUcPgix7+@mail.gmail.com>
References: <1299606753-sup-5310@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299606753-sup-5310@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 8, 2011 at 11:58 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Hi Everyone,
>
> The master branch of the btrfs-unstable tree has three shiny new
> commits, which fix some important bugs in file_write and fiemap.
>
> These are not yet pushed to Linus but the plan is to send them out
> before the final .38 release.
>
> The commits fix errors in the copy_from_user handling where short
> returns or zero returns would make btrfs_file_write do the wrong thin=
g.
> This included looping forever, or pretending pages were up to date wh=
en
> they really were not.
>
> There is also another fiemap fix. Our fiemap was returning overlappin=
g
> extents, which made recent versions of cp copy too many bytes into th=
e
> destination file.
>
> The top commit is this one (just in case kernel.org hasn't caught up
> yet)
>
> commit ea8efc74bd0402b4d5f663d007b4e25fa29ea778
> Author: Chris Mason <chris.mason@oracle.com>
> Date: =A0 Tue Mar 8 11:54:40 2011 -0500
>
> =A0 =A0Btrfs: make sure not to return overlapping extents to fiemap
>
> Please read them, and try to break them ;)
>
> -chris

I applied these three patches as commited to btrfs-unstable, and
re-tested the operations that had been giving me problems (Openmotif
and gcc-4.4.5 building).

They are working good for me.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
