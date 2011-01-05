From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 12:12:18 -0800
Message-ID: <AANLkTimbrE6R6Vc-YLYHgEYoJZq-pvMN1ZM8Zrtx8z7K@mail.gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
	<4D24AD92.4070107@bobich.net>
	<20110105194645.GC2562@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110105194645.GC2562@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 5, 2011 at 11:46 AM, Josef Bacik <josef@redhat.com> wrote:
> Dedup is only usefull if you _know_ you are going to have duplicate i=
nformation,
> so the two major usecases that come to mind are
>
> 1) Mail server. =C2=A0You have small files, probably less than 4k (bl=
ocksize) that
> you are storing hundreds to thousands of. =C2=A0Using dedup would be =
good for this
> case, and you'd have to have a small dedup blocksize for it to be use=
full.
>
> 2) Virtualized guests. =C2=A0If you have 5 different RHEL5 virt guest=
s, chances are
> you are going to share data between them, but unlike with the mail se=
rver
> example, you are likely to find much larger chunks that are the same,=
 so you'd
> want a larger dedup blocksize, say 64k. =C2=A0You want this because i=
f you did just
> 4k you'd end up with a ridiculous amount of framentation and performa=
nce would
> go down the toilet, so you need a larger dedup blocksize to make for =
better
> performance.

You missed out on the most obvious, and useful, use case for dedupe:
  central backups server.

Our current backup server does an rsync backup of 127 servers every
night into a single ZFS pool.  90+ of those servers are identical
Debian installs (school servers), 20-odd of those are identical
=46reeBSD installs (firewalls/routers), and the rest are mail/web/db
servers (Debian, Ubuntu, RedHat, Windows).

Just as a test, we copied a week of backups to a Linux box running
ZFS-fuse with dedupe enabled, and had a combined dedupe/compress
ration in the low double-digits (11 or 12x, something like that).  Now
we're just waiting for ZFSv22+ to hit FreeBSD to enable dedupe on the
backups server.

=46or backups, and central storage for VMs, online dedupe is a massive
win.  Offline, maybe.  Either way, dedupe is worthwhile.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
