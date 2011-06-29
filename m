From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Snapshot reconciliation
Date: Wed, 29 Jun 2011 14:03:29 +0800
Message-ID: <4E0AC031.3090603@cn.fujitsu.com>
References: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Jo=E3o Eduardo Lu=EDs wrote:
> Hello.
>=20
> Can anyone think of a simple way to copy a set of pages from a given =
file (which may or may not be scattered throughout multiple extents) fr=
om a snapshot to correct pages within another file on another snapshot?
>=20
> This might sound silly, but the whole purpose is to create some sort =
of reconciliation method between divergent snapshots taken from the sam=
e original subvolume.
>=20

How about the file clone ioctl? It won't copy data, but it makes the de=
st file points
to the same extents of the source file.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
