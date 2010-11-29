From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [next-rc] Compile Error fs/btrfs/diskio.c
Date: Mon, 29 Nov 2010 10:41:27 -0500
Message-ID: <1291045244-sup-6390@think>
References: <AANLkTi=GVdSTacEVPRqQJu0Fktm8H4aDYfF5wuDDnrH4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=GVdSTacEVPRqQJu0Fktm8H4aDYfF5wuDDnrH4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2010-11-27 17:53:23 -0500:
> I've been getting a compile error when building the 'next-rc' branch
> of btrfs-unstable.
>=20
>   CC      fs/btrfs/disk-io.o
> fs/btrfs/disk-io.c: In function =E2=80=98btree_migratepage=E2=80=99:
> fs/btrfs/disk-io.c:716: error: called object =E2=80=980u=E2=80=99 is =
not a function
> make[2]: *** [fs/btrfs/disk-io.o] Error 1
> make[1]: *** [fs/btrfs] Error 2
> make: *** [fs] Error 2
>=20
> Line 716 of fs/btrfs/disk-io.c is:
>=20
>         return migrate_page(mapping, newpage, page);
>=20
> This is related to the "Btrfs: add migrate page for metadata inode"
> patch (the first patch in the set of patches added to the next-rc
> branch).

I've pushed out a similar fix in the next-rc branch and the master
branch.  Waiting on korg mirrors to update before I send the pull
request.

Thanks!

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
