Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37348 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbJOEj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 00:39:28 -0400
Date: Thu, 15 Oct 2015 00:39:27 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Carmine Paolino <carmine@paolino.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
Message-ID: <20151015043927.GC4400@hungrycats.org>
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
In-Reply-To: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2015 at 11:21:49PM +0200, Carmine Paolino wrote:
> I have an home server with 3 hard drives that I added to the same btrfs
> filesystem. Several hours ago I run `btrfs balance start -dconvert=3Draid0
> /` and as soon as I run `btrfs fi show /` I lost my ssh connection to
> the machine. The machine is still on, but it doesn=E2=80=99t even respond
> to ping: I always get a request timeout and sometimes even an host
> is down message. Its fans are spinning at full blast and the hard
> drives=E2=80=99s led are registering activity all the time. I run Plex Ho=
me
> Theater too there and the display output is stuck at the time when
> I run those two commands. I left it running because I fear to lose
> everything by powering it down manually.
>=20
> Should I leave it like this and let it finish? How long it might
> take? (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a
> 2TB usb 2.0 one so the transfer speeds are pretty low) Is it safe to
> power it off manually? Should I file a bug after it?

As others have pointed out, the raid0 allocator has a 2-disk-minimum
constraint, so any difference in size between the largest and
second-largest disk is unusable.  In your case that's 73% of the raw
space.

If the two smaller disks were almost full (no space unallocated in 'btrfs
fi usage') before you converted to raid0, then immediately after starting
a conversion to raid0 you have no space left _at all_.  This is because
the space you previously had under some other data profile is no longer
considered "free" even if it isn't in use.  All future allocations must
be raid0, starting immediately, but no space is available for raid0
data chunks.

This will cause some symptoms like huge write latency (it will not take
seconds or minutes, but *hours* to write anything to the disk) and
insanely high CPU usage.

Normally btrfs gets slower exponentially as it gets full (this is arguably
a performance bug), so you'll have plenty of opportunity to get the system
under control before things get unusably slow.  What you have done is
somewhat different--you've gone all the way to zero free space all at
once, but you still have lots of what _might_ be free space to search
through when doing allocations.  Now your CPU is spending all of its time
searching everywhere for free space that isn't really there--and when
it doesn't find any free space, it immediately starts the search over
=66rom scratch.

If you're running root on this filesystem, it is likely that various
daemons are trying to write data constantly, e.g. kernel log messages.
Each of these writes, no matter how small, will take hours.  Then the
daemons will be trying to log the fact that writes are taking hours.
Which will take hours.  And so on.  This flood of writes at nearly 20K
per hour will overwhelm the tiny amount of bandwidth btrfs can accomodate
in this condition.

The way to get out of this is to mount the filesystem such that nothing
is attempting to write to it (e.g. boot from rescue media).  Mount the
filesystem with the 'skip_balance' option, and do 'btrfs balance cancel
/fs; btrfs balance start -dconvert=3Dsingle,soft /fs'.  Expect both commands
to take several hours (maybe even days) to run.

In theory, you can add another disk in order to enable raid0 allocations,
but you have to mount the filesystem and stop the running balance before
you can add any disks...and that will take hours anyway, so extra disks
won't really help.

If you can get a root shell and find the kworker threads that are spinning
on your CPU, you can renice them.  If you have RT priority processes in
your system, some random kworkers will randomly acquire RT privileges.
Random kworkers are used by btrfs, so when btrfs eats all your CPU it
can block everything for minutes at a time.  The kworkers obey the usual
schedtool commands, e.g. 'schedtool -D -n20 -v <pids of kworker threads>'
to make them only run when the CPU is idle.

> Any help would be appreciated.
>=20
> Thanks,
> Carmine--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYfLf8ACgkQgfmLGlazG5ztSgCeNINvGXgqSV9LPatA+68JShQ4
fhQAnRnKy5VWlgORwv9bUIfqvFX+Aj0O
=8YJr
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
