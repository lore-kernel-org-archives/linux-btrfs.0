From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: Mass-Hardlinking Oops
Date: Thu, 15 Oct 2009 21:15:34 +0200
Message-ID: <03k4ywo4dl.fsf@msgid.viggen.net>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	<87my3y3r8u.fsf@faran.nsc.liu.se>
	<3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
	<4AD2E3CF.6080701@wpkg.org> <20091012124726.GL2632@think>
	<87my3urf75.fsf@fftw.org> <20091015175541.GI30805@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Tracy Reed]=20

> "clever" indeed. It creates filesystems with zillions of inodes which
> are a pain to work with. This is the sort of large storage applicatio=
n
> I would be looking to use btrfs for and apparently the currently
> implementation would croak.

As I understand it, the current implementation shouldn't croak unless
you keep a few hundred copies of the same file in one directory being
backed up, since the limit is apparently on hard links to the same file
in the same directory.  At least the last time I used it, BackupPC woul=
d
make a new tree for each backup (with hard links to the pool), so you
shouldn't hit this limit in the normal case.

However, speaking of BackupPC, it occurs to me that in the context of
btrfs, that kind of storage strategy looks fairly outmoded anyway, and
could benefit from using the block level copy-on-write features already
present in the file system (with a bit of block based data
de-duplication thrown in for good measure).

=D8ystein
--=20
My coat?  Oh, I left it in the bike shed..

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
