Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33299 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934327AbbEMXIK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 19:08:10 -0400
Date: Wed, 13 May 2015 19:07:56 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recipe for creating unlink deadlocks (v2, verified on 4.1-rc3)
 (resend)
Message-ID: <20150513230756.GB12262@hungrycats.org>
References: <20150507222034.GC18025@hungrycats.org>
 <CAL3q7H5XsorEcdG+OdPEz=YaqVoNcmM5GXzs_DFY0yzLQNmaXA@mail.gmail.com>
 <20150508132101.GE18025@hungrycats.org>
 <20150513053340.GF18025@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
In-Reply-To: <20150513053340.GF18025@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Apologies for the duplication, if any.  I gave the original, longer
version 18 hours to appear, and it doesn't seem to have shown up yet.]

On Fri, May 08, 2015 at 09:21:02AM -0400, Zygo Blaxell wrote:
> On Fri, May 08, 2015 at 11:32:07AM +0100, Filipe David Manana wrote:
> > On Thu, May 7, 2015 at 11:20 PM, Zygo Blaxell
> > <ce3g8jdj@umail.furryterror.org> wrote:
> > > This is the simplest repro recipe for this that I have found so far.
> > > It takes only a few minutes for the rm processes to get stuck here:
> > >
> > > # cat /proc/28396/stack                                              =
                                                                           =
              Thu May  7 18:13:05 2015
> > >
> > > [<ffffffff813c8a2d>] lock_extent_bits+0x1ad/0x200
> > > [<ffffffff813b5dfa>] btrfs_evict_inode+0x17a/0x5e0
> > > [<ffffffff8123fc68>] evict+0xb8/0x1b0
> > > [<ffffffff81240813>] iput+0x1f3/0x260
> > > [<ffffffff81233c68>] do_unlinkat+0x1d8/0x360
> > > [<ffffffff812346db>] SyS_unlinkat+0x1b/0x40
> > > [<ffffffff8190024d>] system_call_fastpath+0x16/0x1b
> > > [<ffffffffffffffff>] 0xffffffffffffffff
> > >
> > >
> > > Run these three scripts in a directory that is the top of a subvol:

New versions of these scripts make the results a little more reproducible:


	#!/bin/bash
	set -x
	# Script #1:  randomly create or delete snapshots
	# v2:  no significant changes
	while date; do
		if [ $[RANDOM%2] =3D 0 ]; then
			btrfs sub snap . snaps-$RANDOM
		else
			for x in snaps-*; do
				btrfs sub del $x
				break
			done
			btrfs sub sync .
		fi
		sleep 1
	done


	#!/bin/bash
	# Script #2:  create a bunch of files of random sizes
	# v2:  create our own test file instead of using Chromium's 1.6M copyright=
 file
	while echo -ne "\r$(date)"; do
		[ -s tester ] || head -c 1024k /dev/urandom > tester
		d=3D$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]
		mkdir -p ${d%/*}
		head -c $[RANDOM%1024]k tester > $d
	done



	#!/bin/bash
	set -x
	# Script #3:  read and immediately delete all the files
	# v3:  let script #2 create some more files
	while date; do
		find *[0-9] -type f -exec sh -c 'cat >/dev/null "$@"' -- {} \; -exec rm -=
fv {} \;

		# Allow some files to build up between runs
		sleep 1m

		# Make sure we are not reading from cache.
		# These are not strictly necessary but they reduce
		# the repro time by a minute or so.
		sync
		sysctl vm.drop_caches=3D1
	done


> > Tried that for over 3 hours, on a 4.1-rc2 kernel with a few patches
> > from the list, with several combinations of mount options (compress,
> > autodefrag, nodatacow, etc) and didn't got any issue.
> >
> > What kernel version are you testing? Any specific combination of mount =
options?
>
> I've seen it on the field on versions from v3.15 to v4.0.1.  The test I d=
id
> yesterday was v4.0.1.

I just verified that the issue is still present in v4.1-rc3.  Tested on
bare hardware and kvm, and a mix of AMD and Intel CPUs.

The issue appears immediately after the test file collection becomes too
large to fit in the host RAM.  In my test environment I used RAM sizes
=66rom 3GB to 16GB with a 16GB btrfs filesystem.  The test ran without
incident until the filesystem used space (reported by df) exceeded the
RAM size, then rm hung a few seconds later.

If I reboot after an rm hang and run scripts #1 and #3 (snapshots and
rm), it hangs almost immediately as soon as subvol delete and rm are
running at the same time.

If script #3 (remove files) runs too quickly (i.e. your disks are too
fast ;), try delaying script #3 until after #1 and #2 have accumulated
enough data to exceed RAM size.

I used default mkfs and mount options this time.  For kvm tests I used
a freshly debootstrapped Debian Jessie, and for the bare hardware tests
I used some random Debian Wheezy systems.

My kernel config file, logs, and repro scripts are available at:

	http://furryterror.org/~zblaxell/tmp/.ma12/

This is part of the kernel log after a typical failure (the whole thing
is available at the URL above):

	May 13 04:59:34 testhost kernel: [  720.290141] rm              D ffff8800=
ab8ebc78     0  4994  23006 0x00000000
	May 13 04:59:34 testhost kernel: [  720.329903]  ffff8800ab8ebc78 ffffffff=
814291b8 00000000ffffffff ffff8800aa831000
	May 13 04:59:34 testhost kernel: [  720.330512]  ffff8800ac4ed000 00000000=
000b0000 ffff8800ab8ec000 ffff8800acd670f0
	May 13 04:59:34 testhost kernel: [  720.331090]  ffff8800acd670d0 00000000=
000b0000 ffff8800aa62dae0 ffff8800ab8ebc98
	May 13 04:59:34 testhost kernel: [  720.400161] Call Trace:
	May 13 04:59:34 testhost kernel: [  720.401020]  [<ffffffff814291b8>] ? lo=
ck_extent_bits+0x1a8/0x200
	May 13 04:59:34 testhost kernel: [  720.462318]  [<ffffffff819a8297>] sche=
dule+0x37/0x90
	May 13 04:59:34 testhost kernel: [  720.467741]  [<ffffffff814291bd>] lock=
_extent_bits+0x1ad/0x200
	May 13 04:59:34 testhost kernel: [  720.468489]  [<ffffffff810dfa30>] ? wa=
it_woken+0xc0/0xc0
	May 13 04:59:34 testhost kernel: [  720.492572]  [<ffffffff814156ea>] btrf=
s_evict_inode+0x19a/0x760
	May 13 04:59:34 testhost kernel: [  720.493048]  [<ffffffff8127fc88>] evic=
t+0xb8/0x1b0
	May 13 04:59:34 testhost kernel: [  720.494419]  [<ffffffff812808fe>] iput=
+0x2be/0x3e0
	May 13 04:59:34 testhost kernel: [  720.494598]  [<ffffffff81272cb8>] do_u=
nlinkat+0x208/0x330
	May 13 04:59:34 testhost kernel: [  720.495086]  [<ffffffff81265cda>] ? Sy=
S_newfstatat+0x2a/0x40
	May 13 04:59:34 testhost kernel: [  720.495511]  [<ffffffff81566925>] ? lo=
ckdep_sys_exit_thunk+0x12/0x14
	May 13 04:59:34 testhost kernel: [  720.495750]  [<ffffffff8127359b>] SyS_=
unlinkat+0x1b/0x40
	May 13 04:59:34 testhost kernel: [  720.496101]  [<ffffffff819af5b2>] syst=
em_call_fastpath+0x16/0x7a
	May 13 04:59:34 testhost kernel: [  720.628063] 1 lock held by rm/4994:
	May 13 04:59:34 testhost kernel: [  720.628239]  #0:  (sb_writers#3){.+.+.=
+}, at: [<ffffffff812861f4>] mnt_want_write+0x24/0x50

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVT2UwACgkQgfmLGlazG5wPJQCgknTvXu7HfwLtZ5Qkn8WaqraQ
DtsAn39NEOnAR1+RnxLVAGIIO4hJ7Ete
=g1f6
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
