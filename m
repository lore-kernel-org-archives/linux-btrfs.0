From: Bart Noordervliet <bart@noordervliet.net>
Subject: Re: fsck.btrfs dumps core
Date: Thu, 25 Feb 2010 16:17:15 +0100
Message-ID: <b7130efa1002250717l3ea131b0r14c036676c4cb7c9@mail.gmail.com>
References: <4B8638AD.5090408@gmail.com> <4B86845F.7080500@gmail.com>
	<4B8686F0.2040400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B8686F0.2040400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/2/25 Adam K=C5=82obukowski <adamklobukowski@gmail.com>:
> Is it possible to find out if I've done any harm to the fs by trying =
to
> do online fsck?

btrfsck doesn't make any changes to the filesystem, so no harm will
have been done.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
