Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52743 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbaCTPVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 11:21:41 -0400
Received: from asusntb.lan ([147.32.122.213]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MO7ee-1WWAZL2EWi-005X9R for
 <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 16:21:39 +0100
Date: Thu, 20 Mar 2014 16:21:31 +0100
From: Jakub =?utf-8?Q?Klinkovsk=C3=BD?= <j.l.k@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub process prevents system suspend
Message-ID: <20140320152131.GA1172@asusntb.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today I accidentally discovered that it is not possible to suspend (hiberna=
te)
the system while the btrfs scrub process is running (see the attached log).
Could this be considered a bug, or did I miss something?

Some more info:

$ uname -a
Linux asusntb 3.13.6-1-ARCH #1 SMP PREEMPT Fri Mar 7 22:47:48 CET 2014 x86_=
64 GNU/Linux

and btrfs-progs-3.12 is installed.

Regards,
Jakub Klinkovsk=C3=BD

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs_scrub_hibernate.log"

Mar 20 09:03:13 asusntb systemd[1]: Starting Sleep.
Mar 20 09:03:13 asusntb systemd[1]: Reached target Sleep.
Mar 20 09:03:13 asusntb systemd[1]: Starting Hibernate...
Mar 20 09:03:13 asusntb systemd-sleep[12696]: Suspending system...
Mar 20 09:03:34 asusntb kernel: PM: Syncing filesystems ... done.
Mar 20 09:03:34 asusntb kernel: Freezing user space processes ...
Mar 20 09:03:34 asusntb kernel: Freezing of tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
Mar 20 09:03:34 asusntb kernel: btrfs           D 00000000ffffffff     0  9695      1 0x00000004
Mar 20 09:03:34 asusntb kernel:  ffff880101249920 0000000000000082 ffff8800baf02400 ffff880101249fd8
Mar 20 09:03:34 asusntb kernel:  0000000000014440 0000000000014440 ffff8800baf02400 ffff8800baf02400
Mar 20 09:03:34 asusntb kernel:  0000000000000001 ffff8800baf02400 ffff88013fff9b08 ffff8800baf02400
Mar 20 09:03:34 asusntb kernel: Call Trace:
Mar 20 09:03:34 asusntb kernel:  [<ffffffff8117e5c3>] ? alloc_pages_current+0xa3/0x160
Mar 20 09:03:34 asusntb kernel:  [<ffffffff81515d99>] schedule+0x29/0x70
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c2df3d>] scrub_pages+0x38d/0x4e0 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffff810a2c30>] ? __wake_up_sync+0x20/0x20
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c2eb68>] scrub_stripe+0x998/0x1110 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0bd7a06>] ? btrfs_buffer_uptodate+0x56/0x80 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c30bdb>] scrub_chunk.isra.12+0x10b/0x130 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c30e54>] scrub_enumerate_chunks+0x254/0x510 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffff810a2c00>] ? __wake_up_sync_key+0x50/0x60
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c312ac>] btrfs_scrub_dev+0x19c/0x4f0 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffffa0c0f078>] btrfs_ioctl+0x1528/0x27a0 [btrfs]
Mar 20 09:03:34 asusntb kernel:  [<ffffffff8107b5a6>] ? __queue_work+0x136/0x360
Mar 20 09:03:34 asusntb kernel:  [<ffffffff8151d5c4>] ? __do_page_fault+0x2c4/0x5b0
Mar 20 09:03:34 asusntb kernel:  [<ffffffff81292716>] ? put_io_context+0x66/0xa0
Mar 20 09:03:34 asusntb kernel:  [<ffffffff811b6080>] do_vfs_ioctl+0x2e0/0x4c0
Mar 20 09:03:34 asusntb kernel:  [<ffffffff811b62e1>] SyS_ioctl+0x81/0xa0
Mar 20 09:03:34 asusntb kernel:  [<ffffffff8151d8be>] ? do_page_fault+0xe/0x10
Mar 20 09:03:34 asusntb kernel:  [<ffffffff815216ad>] system_call_fastpath+0x1a/0x1f
Mar 20 09:03:34 asusntb kernel:
Mar 20 09:03:34 asusntb systemd-logind[246]: Lid closed.
Mar 20 09:03:34 asusntb kernel: Restarting tasks ... done.
Mar 20 09:03:34 asusntb kernel: video LNXVIDEO:00: Restoring backlight state
Mar 20 09:03:34 asusntb systemd[1]: systemd-hibernate.service: main process exited, code=exited, status=1/FAILURE
Mar 20 09:03:34 asusntb systemd[1]: Failed to start Hibernate.
Mar 20 09:03:34 asusntb systemd[1]: Dependency failed for Hibernate.
Mar 20 09:03:34 asusntb systemd[1]: Service sleep.target is not needed anymore. Stopping.
Mar 20 09:03:34 asusntb systemd[1]: Unit systemd-hibernate.service entered failed state.
Mar 20 09:03:34 asusntb systemd[1]: Stopping Sleep.
Mar 20 09:03:34 asusntb systemd[1]: Stopped target Sleep.
Mar 20 09:03:34 asusntb systemd[1]: Stopping Hibernate.
Mar 20 09:03:34 asusntb systemd[1]: Stopped target Hibernate.

--pWyiEgJYm5f9v55/--

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKwd7AAoJEMiJvVK88FbFtv4QAIlpx9/9JNRE59Hy1UFudHND
OY41fDzcp8ho/6JbNBJks610Hd9E6INd5Cl/b5pVs73glGvC8MRmlIyALZ56+FFR
RlsaCA/31EYAJSW0WSObZs41mPIyYDRmY1q7cMB7sWfVKNK8sSQr9hHw9Fndr81t
NedqMyNkoTwqZ/+n3kBleD8p3bQKk0yXY3s0wxGwaYIfcAAR4kmxK/WEjh4q1/gQ
IcTK1m6d6oEWjSj7BG14RTGJ+MdLvkiKvIW/dkrDN8+mQyGaVNIs2kOrJSHTxgIe
bn9RBH5+KERS4Yf6fSdLPtm/5l+XCpm+jmYOzuYAkW5cnVqz/E8iHRaq5XFe8Mha
3HkyulJirmtyqjhmJXf5QulYFpceHzdSJBVpEeZLljvLbsl7WnL/Lj1aDL6bPbgf
uPdZNTBGLplsZnNpE0grE+SzgemEI3hH/uHZ4pmyicNingEWjshYhQR5tzOPyJ3y
dIAimy1pelF+0rlRtfi3L6JDKICMQ1mzfZGJU2AIK9q1rKou3tFVtn+ZIHtFC66m
bV6OvT5bhBR5rFVLv6NlAxsw+gjetbK1eDQSBbu8SBJltONR488xvL0v6GgufC8Q
jZHKbvnVgTxst5lBMIQDSGewPE5zUwT50iomi4xgybdrZrD5S4KR0xcT9r+/Avjl
v62HWI1cCH+MTtvN9jhO
=cP9Z
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
