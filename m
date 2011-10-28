From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Fri, 28 Oct 2011 07:57:41 +0700
Message-ID: <CAG1y0sfBkczDLRgq=c42_nKwtG3M2UTRB2NHjnZz3L1-jta90w@mail.gmail.com>
References: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2011 at 7:32 AM, Ken D'Ambrosio <ken@jots.org> wrote:
>> some of us make use of snapshot/clone, whether it's using btrfs or z=
fs :)
>
> No, this is just flat my fault: it doesn't matter what backup method =
you use if
> you do it wrong. =A0(I actually have three snapshots of each of my tw=
o
> partitions.)

What I meant was, if you use snapshot you can easily rollback, and not
having to dd-back. But you're right though, it doesn't matter what you
use if you do it wrong.

>> Try getting source of btrfs-progs, do "make btrfs-zero-log", and use=
 it.
>
> Already got 'em. =A0Everything that tries to even think about modifyi=
ng stuff
> (btrfs-zero-log, btrfsck, and btrfs-debug-tree) all dump core:

Your last resort (for now, anyway) might be using "restore" from
Josef's btrfs-progs: https://github.com/josefbacik/btrfs-progs

It might be able to copy some data.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
