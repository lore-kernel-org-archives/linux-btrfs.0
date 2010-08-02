From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: Number of hard links limit
Date: Mon, 2 Aug 2010 15:05:56 +0200
Message-ID: <20100802130556.GF30325@jeru.org>
References: <20100802114046.GA29926@lh.kyla.fi>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: cbarratt@users.sourceforge.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100802114046.GA29926@lh.kyla.fi>
List-ID: <linux-btrfs.vger.kernel.org>

Le 02 ao=FBt 2010 =E0 14:40, Sami Liedes a =E9crit:
> [BTRFS supports only 256 hard-links per directory ...] but if it
> indeed needs a disk format change, I think this should be considered
> before the format is set in stone. I won't personally lose my sleep i=
f
> this is not fixed - I can use other filesystems for backuppc and othe=
r
> similar systems,=20

Wouldn't it be even better to actually patch BackupPC to handle btrfs
snapshots and COW (bcp) ?

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
