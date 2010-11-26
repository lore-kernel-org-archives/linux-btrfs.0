From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: btrfs problems and fedora 14
Date: Fri, 26 Nov 2010 11:11:28 +0100
Message-ID: <03d3ps1jjj.fsf@msgid.viggen.net>
References: <1290467983.24502.66.camel@main-wireless>
	<AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
	<AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
	<1290583953.2235.28.camel@main-wireless>
	<AANLkTimhA5z8xB_t9bGCC4=jzezPhHTPzBPy=0PW9Kpg@mail.gmail.com>
	<1290764456.4380.20.camel@main-wireless>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [david grant]=20

> BUT I am still left with the problem that caused it for me: how do I
> backup (clone?) a btrfs file system with snapshots to another btrfs
> partition (apart from using dd). I just hope I don't get scolded agai=
n
> and told I am not up to it.

I don't think you can conveniently clone the filesystem including the
snapshots to another computer or partition using traditional userspace
tools like tar or rsync, since they'd end up de-linking the reflink-nes=
s
of the snapshots, so that all the snapshots end up taking the full
space.

However, I can think of one or two strategies that might help you
achieve something close to what you actually want:

1. If the snapshots are just for "online backup", you could backup only
what you consider the live subvol (or even better: a very recent
snapshot of it), and then make snapshots on the target filesystem after
each backup.  While this isn't really a backup including the snapshots,
it might serve the purpose you want.

2. You could rsync the oldest snapshot, make a snapshot of it on the
target filesystem named the same as your second-oldest snapshot, rsync
(--inplace) the second-oldest snapshot into that newly created snapshot=
,
and repeat until you've done all the snapshots.  My head is already
spinning, but it seems to me that it should be possible to automate thi=
s
in a not-too-ugly shell script that also handles updates in a sane way.
This falls to bits, however, if the various snapshots are regularly
written to, or if you can't be sure of their creation order.  (for date=
d
backup snapshots, there shouldn't be a problem).

What would be really awesome is some sort of "btrfs-send" program that
handles all this the best way for you, but I don't think that exists
(yet).  User friendly tools will undoubtedly appear as btrfs is more
used, but I guess it's still partly in the "roll your own" early adopte=
r
stage.  :)

=D8ystein
--=20
"Windows is too dangerous to be left to Windows admins."
                 -- James Riden in the monastery

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
