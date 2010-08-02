From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: Number of hard links limit
Date: Mon, 02 Aug 2010 12:31:12 -0600
Message-ID: <4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com>
References: <20100802114046.GA29926@lh.kyla.fi> <20100802130556.GF30325@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: <linux-btrfs@vger.kernel.org>, <cbarratt@users.sourceforge.net>
To: <nicollet@jeru.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100802130556.GF30325@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2 Aug 2010 15:05:56 +0200, Xavier Nicollet <nicollet@jeru.org>
wrote:
> Le 02 ao=C3=BBt 2010 =C3=A0 14:40, Sami Liedes a =C3=A9crit:
>> [BTRFS supports only 256 hard-links per directory ...] but if it
>> indeed needs a disk format change, I think this should be considered
>> before the format is set in stone. I won't personally lose my sleep =
if
>> this is not fixed - I can use other filesystems for backuppc and oth=
er
>> similar systems,=20
>=20
> Wouldn't it be even better to actually patch BackupPC to handle btrfs
> snapshots and COW (bcp) ?

That's not the only application impacted by this.

Also, I think it's unrealistic to expect everyone else to code to
BTRFS-specific ioctls when there's other filesystems and other platform=
s to
worry about. It would also be nice if we could tar/rsync/whatever betwe=
en
BTRFS and something else like ext3 or some other OS entirely, without
archiving tools either blowing up or requiring application-specific
knowledge of how to convert dedups to hard links and back.

Also, I believe it's not strictly 256 links, it's dependent on the leng=
th
of the names.

I recall Chris posting something about being able to fix this without a
format change, though it wasn't a priority yet.

-Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
