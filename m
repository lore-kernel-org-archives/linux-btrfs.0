From: Erik Logtenberg <erik@logtenberg.eu>
Subject: What do the arguments of btrfs filesystem defragment do?
Date: Wed, 15 Dec 2010 17:06:03 +0100
Message-ID: <4D08E76B.40400@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I would like to know that the arguments of "btrfs filesystem defragment"
do. According to the built-in help page, the invocation is as follows:

>         btrfs filesystem defragment [-vcf] [-s start] [-l len] [-t
>                 size] <file>|<dir> [<file>|<dir>...]
>                 Defragment a file or a directory.

Unfortunately I can't find any documentation on the meaning of these
arguments. The man page doesn't list these arguments:

>       filesystem defragment <file>|<dir> [<file>|<dir>...]
>              Defragment files and/or directories.

Also the online documentation [1] is identical to the man page.

[1] https://btrfs.wiki.kernel.org/index.php/Btrfs(command)

On a somewhat related note I did find another page on the wiki [2] that
explains a bit on the defragmenting subject, more specifically it
mentions this rather important caveat:

> Caveat: Defragmenting a file which has a COW copy (either a snapshot
> copy or one made with bcp or cp --reflinks) will produce two unrelated
> files. If you defragment a subvolume that has a snapshot, you will
> roughly double the disk usage, as the snapshot files are no longer COW
> images of the originals.

[2] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

>From what I've heard on IRC this is still the case in current versions,
but the Btrfs(command) documentation contains no mention of this.

I hope someone can shed some light on these subjects.

Kind regards,

Erik.
