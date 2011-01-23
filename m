From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: [regression?] hang with 2.6.37 on a BTRFS test machine
Date: Sun, 23 Jan 2011 13:06:15 +0100
Message-ID: <201101231306.23069.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1697350.R2vUlN4PxF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1697350.R2vUlN4PxF
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Not reported on bugzilla.kernel.org yet as its so vague.


Hi!

I have something I do not have the slightest clue on how to track down:

Occasionally with 2.6.37 plain vanilla my ThinkPad T23 freezes in such a=20
way, that when I type a command at the prompt, nothing will happen=20
anymore. Same goes for login into a tty. Even dmesg is not executed=20
anymore. My KDE session doesn't react to clicks anymore, except for window=
=20
movement. Most of the time the mouse pointer is still movable, but=20
sometimes it is frozen as well. But the latter might be a different problem=
=20
with X.org.

My theory is that at least I/O related kernel functions do not return=20
anymore at that time.

Nothing is in the logs after a reboot.

Problem now is: This happens rather irregularily. That kernel run for days=
=20
without problems. But today two times it hung after the first time it hung.=
=20
One time it was on TTY 1 instead of in X.org. So when this happens it=20
seems to persist a while.

But I now booted with 2.6.36 and the machine is as stable as if nothing=20
has happened at all.

OTOH a 2.6.37 with recursive mtime patches from Jan Kara - that hung on=20
the T23 as well - runs just fine on my T42 for nine days (minus hibernation=
=20
times) already.

Now it could be something hardware related, the T23 is different from the=20
T42. Also the T23 has a fan that should be replaced or oiled - but it=20
still works right up to now. Also with 2.6.36 or earlier kernels the=20
machine never hung that way so far.

Or it could be something BTRFS related. The T23 is using BTRFS on /home=20
for months already and for / since beginning this year or end of last year=
=20
while the T42 is still with Ext4 - until there is a robust fsck for BTRFS=20
and BTRFS is marked stable in the kernel at last.

A bisection is too much effort for me - especially as it could take days=20
till the problems shows up. Some sysrq stuff doesn't work without serial or=
=20
netconsole since a call to dmesg does not return anymore when it happens.=20
Having netconsole and serial running for days for just in case it happens=20
is also quite some effort, since I have to remember to reinitialize it=20
after each hibernation cycle to have a permanent setup.

Since I have no other idea on how to track this with reasonable effort - I=
=20
spent tons of time with trying to help debugging various, partly=20
intermittent, kernel problems in the last months and I have enough of that=
=20
ATM - I will stick to 2.6.36 for the time being and see whether the T23 is=
=20
really stable with that one. I still wanted to report my - admittedly=20
vague - findings in case it rings a bell for someone. I will monitor=20
2.6.37.y updates in case they contain BTRFS and or T23 hardware related=20
fixes.

Last but not least: I have no seen BTRFS related errors or other oddities=20
in syslog. The following looks quite normal to me, I did a btrfs filesystem=
=20
balance some time ago and had some hard switch off cold reboots due to the=
=20
issue mentioned:

artin@deepdance:~> zgrep -i btrfs /var/log/syslog*
/var/log/syslog.1:Jan 17 20:43:06 localhost kernel: Btrfs loaded
/var/log/syslog.1:Jan 23 12:01:12 localhost kernel: Btrfs loaded
/var/log/syslog.1:Jan 23 12:01:12 localhost kernel: btrfs: unlinked 3=20
orphans
/var/log/syslog.1:Jan 23 12:09:36 localhost kernel: Btrfs loaded
/var/log/syslog.1:Jan 23 12:09:36 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.1:Jan 23 12:20:52 localhost kernel: Btrfs loaded
/var/log/syslog.1:Jan 23 12:20:52 localhost kernel: btrfs: unlinked 18=20
orphans
/var/log/syslog.2.gz:Jan 14 12:32:16 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 14 12:32:16 localhost kernel: btrfs: unlinked 116=
=20
orphans
/var/log/syslog.2.gz:Jan 14 12:40:02 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 14 14:44:28 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 18:14:06 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 18:14:06 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.2.gz:Jan 16 18:26:46 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 18:26:46 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.2.gz:Jan 16 18:41:11 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 18:41:11 localhost kernel: btrfs: unlinked 3=20
orphans
/var/log/syslog.2.gz:Jan 16 18:53:47 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 18:53:47 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.2.gz:Jan 16 19:00:14 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 19:00:14 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.2.gz:Jan 16 19:05:53 localhost kernel: Btrfs loaded
/var/log/syslog.2.gz:Jan 16 19:05:54 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.7.gz:Dec  9 19:05:38 localhost kernel: Btrfs loaded
/var/log/syslog.7.gz:Dec  9 19:05:38 localhost kernel: btrfs: unlinked 2=20
orphans
/var/log/syslog.7.gz:Dec  9 19:05:38 localhost kernel: btrfs: truncated 1=20
orphans
/var/log/syslog.7.gz:Dec  9 20:54:10 localhost kernel: btrfs: relocating=20
block group 10900996096 flags 36
/var/log/syslog.7.gz:Dec  9 20:55:02 localhost kernel: btrfs: found 2036=20
extents
/var/log/syslog.7.gz:Dec  9 20:55:02 localhost kernel: btrfs: relocating=20
block group 10766778368 flags 36
/var/log/syslog.7.gz:Dec  9 20:56:15 localhost kernel: btrfs: found 10432=20
extents
/var/log/syslog.7.gz:Dec  9 20:56:16 localhost kernel: btrfs: relocating=20
block group 9693036544 flags 1
/var/log/syslog.7.gz:Dec  9 20:56:26 localhost kernel: btrfs: found 155=20
extents
/var/log/syslog.7.gz:Dec  9 20:56:31 localhost kernel: btrfs: found 154=20
extents
/var/log/syslog.7.gz:Dec  9 20:56:31 localhost kernel: btrfs: relocating=20
block group 8619294720 flags 1
/var/log/syslog.7.gz:Dec  9 20:57:37 localhost kernel: btrfs: found 5027=20
extents
/var/log/syslog.7.gz:Dec  9 20:57:49 localhost kernel: btrfs: found 5027=20
extents
/var/log/syslog.7.gz:Dec  9 20:57:51 localhost kernel: btrfs: relocating=20
block group 7545552896 flags 1
/var/log/syslog.7.gz:Dec  9 20:59:48 localhost kernel: btrfs: found 12851=20
extents
/var/log/syslog.7.gz:Dec  9 21:00:28 localhost kernel: btrfs: found 12846=20
extents
/var/log/syslog.7.gz:Dec  9 21:00:29 localhost kernel: btrfs: relocating=20
block group 6471811072 flags 1
/var/log/syslog.7.gz:Dec  9 21:01:59 localhost kernel: btrfs: found 46780=20
extents
/var/log/syslog.7.gz:Dec  9 21:03:21 localhost kernel: btrfs: found 46780=20
extents
/var/log/syslog.7.gz:Dec  9 21:03:26 localhost kernel: btrfs: relocating=20
block group 5398069248 flags 1
/var/log/syslog.7.gz:Dec  9 21:04:34 localhost kernel: btrfs: found 19425=20
extents
/var/log/syslog.7.gz:Dec  9 21:05:15 localhost kernel: btrfs: found 19425=20
extents
/var/log/syslog.7.gz:Dec  9 21:05:16 localhost kernel: btrfs: relocating=20
block group 4324327424 flags 1
/var/log/syslog.7.gz:Dec  9 21:06:33 localhost kernel: btrfs: found 26059=20
extents
/var/log/syslog.7.gz:Dec  9 21:07:22 localhost kernel: btrfs: found 26059=20
extents
/var/log/syslog.7.gz:Dec  9 21:07:25 localhost kernel: btrfs: relocating=20
block group 3250585600 flags 1
/var/log/syslog.7.gz:Dec  9 21:08:47 localhost kernel: btrfs: found 15614=20
extents
/var/log/syslog.7.gz:Dec  9 21:09:29 localhost kernel: btrfs: found 15614=20
extents
/var/log/syslog.7.gz:Dec  9 21:09:31 localhost kernel: btrfs: relocating=20
block group 2176843776 flags 1
/var/log/syslog.7.gz:Dec  9 21:10:58 localhost kernel: btrfs: found 4275=20
extents
/var/log/syslog.7.gz:Dec  9 21:11:34 localhost kernel: btrfs: found 4275=20
extents
/var/log/syslog.7.gz:Dec  9 21:11:35 localhost kernel: btrfs: relocating=20
block group 1103101952 flags 1
/var/log/syslog.7.gz:Dec  9 21:13:01 localhost kernel: btrfs: found 7296=20
extents
/var/log/syslog.7.gz:Dec  9 21:13:35 localhost kernel: btrfs: found 7296=20
extents
/var/log/syslog.7.gz:Dec  9 21:13:36 localhost kernel: btrfs: relocating=20
block group 29360128 flags 36
/var/log/syslog.7.gz:Dec  9 21:16:53 localhost kernel: btrfs: found 78308=20
extents
/var/log/syslog.7.gz:Dec  9 21:16:54 localhost kernel: btrfs: relocating=20
block group 20971520 flags 34
/var/log/syslog.7.gz:Dec  9 21:16:54 localhost kernel: btrfs: found 1=20
extents
/var/log/syslog.7.gz:Dec  9 21:16:56 localhost kernel: btrfs: relocating=20
block group 12582912 flags 1
/var/log/syslog.7.gz:Dec  9 21:16:57 localhost kernel: btrfs: found 85=20
extents
/var/log/syslog.7.gz:Dec  9 21:16:59 localhost kernel: btrfs: found 85=20
extents
/var/log/syslog.7.gz:Dec  9 21:17:01 localhost kernel: btrfs: relocating=20
block group 4194304 flags 4

Hmmm, one thing there is:

Jan 13 13:27:15 localhost kernel: INFO: task dpkg:21162 blocked for more=20
than 120 seconds.
Jan 13 13:27:15 localhost kernel: "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 13 13:27:15 localhost kernel: dpkg          D ef891b0c     0 21162  =20
2334 0x00000000
Jan 13 13:27:15 localhost kernel: d2e4be7c 00000082 ef8918cc ef891b0c=20
ef8918a0 ef891b0c ef891b10 1b8b88c5
Jan 13 13:27:15 localhost kernel: 00018796 ef8918a0 7fffffff d2e4bf4c 7ffff=
fff=20
d2e4bee4 c13c4495 cb7862ac
Jan 13 13:27:15 localhost kernel: d2e4be98 c102ab56 cb7862ac c1514fa0=20
d2e4beb4 c102d740 ee303140 d2e4bec0
Jan 13 13:27:15 localhost kernel: Call Trace:
Jan 13 13:27:15 localhost kernel: [<c13c4495>]=20
schedule_timeout+0x175/0x280
Jan 13 13:27:15 localhost kernel: [<c102ab56>] ?=20
__dequeue_entity+0x26/0x50
Jan 13 13:27:15 localhost kernel: [<c102d740>] ? set_next_entity+0xc0/0xe0
Jan 13 13:27:15 localhost kernel: [<c10017b3>] ? __switch_to+0xa3/0x160
Jan 13 13:27:15 localhost kernel: [<c1030132>] ? T.1277+0x32/0xa0
Jan 13 13:27:15 localhost kernel: [<c13c394c>] ? schedule+0x1fc/0x5d0
Jan 13 13:27:15 localhost kernel: [<c13c4006>] wait_for_common+0xa6/0x160
Jan 13 13:27:15 localhost kernel: [<c10316a0>] ?=20
default_wake_function+0x0/0x20
Jan 13 13:27:15 localhost kernel: [<c13c4197>]=20
wait_for_completion+0x17/0x20
Jan 13 13:27:15 localhost kernel: [<c10f8d52>] sync_inodes_sb+0x92/0x1a0
Jan 13 13:27:15 localhost kernel: [<c111f230>] ?=20
dquot_quota_sync+0x0/0x310
Jan 13 13:27:15 localhost kernel: [<c10fd4f7>] __sync_filesystem+0x87/0xa0
Jan 13 13:27:15 localhost kernel: [<c10fd52f>] sync_one_sb+0x1f/0x30
Jan 13 13:27:15 localhost kernel: [<c10d9e6b>] iterate_supers+0x7b/0xf0
Jan 13 13:27:15 localhost kernel: [<c10fd510>] ? sync_one_sb+0x0/0x30
Jan 13 13:27:15 localhost kernel: [<c10fd57c>] sys_sync+0x3c/0x60
Jan 13 13:27:15 localhost kernel: [<c1002f23>] sysenter_do_call+0x12/0x2c
Jan 13 13:33:38 localhost init: Trying to re-exec init

There is only one occurance of it:

martin@deepdance:~> zgrep -i "blocked" /var/log/syslog*
/var/log/syslog.2.gz:Jan 13 13:27:15 localhost kernel: INFO: task=20
dpkg:21162 blocked for more than 120 seconds.
martin@deepdance:~#1>

I put the logs aside in case anyone wants to have a closer look.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1697350.R2vUlN4PxF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk08GbgACgkQmRvqrKWZhMdw2ACgtuJtvghc8sqC3C+ZGM17huIr
4TcAnjSRPeJFpaNNjOAldx5NkaT3aK8T
=oCr8
-----END PGP SIGNATURE-----

--nextPart1697350.R2vUlN4PxF--
