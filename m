From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 13:39:46 -0800
Message-ID: <AANLkTim0PnMb4nzHxbpP-BVq_hRQYNWBpm9MYdmSv8jH@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
	<AANLkTimVFkAbnkd5BDavo6fDUJ1KcOVVC=6qA6nrkySx@mail.gmail.com>
	<AANLkTinZXirXQtd_Fd+AN+GbWbs0Wco7dxhEz+Cg6TjO@mail.gmail.com>
	<4D262EED.6030809@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D262EED.6030809@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 1:06 PM, Gordan Bobic <gordan@bobich.net> wrote:
>>> Unfortunately, we don't use btrfs or LVM on remote servers, so ther=
e's
>>> no snapshotting available during the backup run. =C2=A0In a perfect=
 world,
>>> btrfs would be production-ready, ZFS would be available on Linux, a=
nd
>>> we'd no longer need the abomination called LVM. =C2=A0:)
>
> As a matter of fact, ZFS _IS_ available on Linux:
> http://zfs.kqinfotech.com/

"Available", "usable", and "production-ready" are not synonymous.  :)
ZFS on Linux is not even in the experimental/testing stage right now.

ZFS-fuse is good for proof-of-concept stuff, but chokes on heavy
usage, especially with dedupe enabled.  We tried it for a couple weeks
to see what was available in ZFS versions above 14, but couldn't keep
it running for more than a day or two at a time.  Supposedly, things
are better now, but I wouldn't trust 15 TB of backups to it.  :)

The Lawrence-Liverpool ZFS module for Linux doesn't support ZFS
filesystems yet, only ZFS volumes.  It should be usable as an LVM
replacement, though, or as an iSCSI target box.  Haven't tried it yet.

The Middle-East (forget which country it's from) ZFS module for Linux
is in the private beta stage, but only available for a few distros and
kernel versions, and is significantly slower than ZFS on FreeBSD.
Hopefully, it will enter public beta this year, it sounds promising.
Don't think I'd trust 15 TB of backups to it for at least another
year, though.

If btrfs gets dedupe, "nicer" disk management (it's hard to use
non-pooled storage now), a working fsck (or similar), and integration
into Debian, then we may look at that as well.  :)

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
