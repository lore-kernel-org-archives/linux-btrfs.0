From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: Snapshot reconciliation
Date: Tue, 28 Jun 2011 10:07:19 -0500
Message-ID: <BANLkTikgueaxBXMhK1T4dKwMhLTsGn8Mag@mail.gmail.com>
References: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?UTF-8?Q?Jo=C3=A3o_Eduardo_Lu=C3=ADs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/6/28 Jo=C3=A3o Eduardo Lu=C3=ADs <jecluis@gmail.com>:
> Hello.
>
> Can anyone think of a simple way to copy a set of pages from a given =
file (which may or may not be scattered throughout multiple extents) fr=
om a snapshot to correct pages within another file on another snapshot?
>
> This might sound silly, but the whole purpose is to create some sort =
of reconciliation method between divergent snapshots taken from the sam=
e original subvolume.

generic deduplication?

Josef posted some patches back in Jan:

http://www.spinics.net/lists/linux-btrfs/msg07818.html
http://www.spinics.net/lists/linux-btrfs/msg07819.html
(etc)

=2E.. if that's what your looking for.  i don't know whats all needed t=
o
make it work at this point, ie. if you only need the patch to
btrfs-progs or some combination.  there could be more recent patches
but i don't recall anyone talking about any.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
