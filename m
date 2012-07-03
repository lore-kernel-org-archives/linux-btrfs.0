Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab2GCCre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 22:47:34 -0400
Date: Tue, 3 Jul 2012 12:47:27 +1000
From: NeilBrown <neilb@suse.de>
To: Kerin Millar <kerframil@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Message-ID: <20120703124727.6e2232d1@notabene.brown>
In-Reply-To: <4FF2554D.2040300@gmail.com>
References: <4FF108A8.6090606@gmail.com>
	<20120702125227.179c4343@notabene.brown>
	<4FF10E71.2090501@gmail.com>
	<20120703113943.3e4c43ad@notabene.brown>
	<4FF2554D.2040300@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oFYIo4/0pUi2NDTUibc8/KB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/oFYIo4/0pUi2NDTUibc8/KB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Jul 2012 03:13:33 +0100 Kerin Millar <kerframil@gmail.com> wrote:

> Hi,
>=20
> On 03/07/2012 02:39, NeilBrown wrote:
>=20
> [snip]
>=20
>  >>> Could you please double check that you are running a kernel with
>  >>>
>  >>> commit aba336bd1d46d6b0404b06f6915ed76150739057
>  >>> Author: NeilBrown<neilb@suse.de>
>  >>> Date:   Thu May 31 15:39:11 2012 +1000
>  >>>
>  >>>       md: raid1/raid10: fix problem with merge_bvec_fn
>  >>>
>  >>> in it?
>  >>
>  >> I am indeed. I searched the list beforehand and noticed the patch in
>  >> question. Not sure which -rc it landed in but I checked my source tree
>  >> and it's definitely in there.
>  >>
>  >> Cheers,
>  >>
>  >> --Kerin
>  >
>  > Thanks.
>  > Looking at it again I see that it is definitely a different bug, that =
patch
>  > wouldn't affect it.
>  >
>  > But I cannot see what could possibly be causing the problem.
>  > You have a 256K chunk size, so requests should be limited to 512 secto=
rs
>  > aligned at a 512-sector boundary.
>  > However all the requests that a causing errors are 512 sectors long, b=
ut
>  > aligned on a 256-sector boundary (which is not also 512-sector).  This=
 is
>  > wrong.
>=20
> I see.
>=20
>  >
>  > It could be that btrfs is submitting bad requests, but I think it alwa=
ys uses
>  > bio_add_page, and bio_add_page appears to do the right thing.
>  > It could be that dm-linear is causing problem, but it seems to correct=
ly after
>  > the underlying device for alignment, and reports that alignment to
>  > bio_add_page.
>  > It could be that md/raid10 is the problem but I cannot find any fault =
in
>  > raid10_mergeable_bvec - performs much the same tests that the
>  > raid01 make_request function does.
>  >
>  > So it is a mystery.
>  >
>  > Is this failure repeatable?
>=20
> Yes, it's reproducible with 100% consistency. Furthermore, I tried to
> use the btrfs volume as a store for the package manager, so as to try
> with a 'realistic' workload. Many of these errors were triggered
> immediately upon invoking the package manager. In case it matters, the
> package manager is portage (in Gentoo Linux) and the directory structure
> entails a shallow directory depth with a large number of distributed
> small files. I haven't been able to reproduce with xfs, ext4 or reiserfs.
>=20
>  >
>  > If so, could you please insert
>  >     WARN_ON_ONCE(1);
>  > in drivers/md/raid10.c where it prints out the message: just after the
>  > "bad_map:" label.
>  >
>  > Also, in raid10_mergeable_bvec, insert
>  >     WARN_ON_ONCE(max<  0);
>  > just before
>  > 		if (max<  0)
>  > 			/* bio_add cannot handle a negative return */
>  > 			max =3D 0;
>  >
>  > and then see if either of those generate a warning, and post the full =
stack
>  > trace  if they do.
>=20
> OK. I ran iozone again on a fresh filesystem, mounted with the default
> options. Here's the trace that appears, just before the first
> make_request_bug message:
>=20
> WARNING: at drivers/md/raid10.c:1094 make_request+0xda5/0xe20()
> Hardware name: ProLiant MicroServer
> Modules linked in: btrfs zlib_deflate lzo_compress kvm_amd kvm sp5100_tco=
 i2c_piix4
> Pid: 1031, comm: btrfs-submit-1 Not tainted 3.5.0-rc5 #3
> Call Trace:
> [<ffffffff81031987>] ? warn_slowpath_common+0x67/0xa0
> [<ffffffff81442b45>] ? make_request+0xda5/0xe20
> [<ffffffff81460b34>] ? __split_and_process_bio+0x2d4/0x600
> [<ffffffff81063429>] ? set_next_entity+0x29/0x60
> [<ffffffff810652c3>] ? pick_next_task_fair+0x63/0x140
> [<ffffffff81450b7f>] ? md_make_request+0xbf/0x1e0
> [<ffffffff8123d12f>] ? generic_make_request+0xaf/0xe0
> [<ffffffff8123d1c3>] ? submit_bio+0x63/0xe0
> [<ffffffff81040abd>] ? try_to_del_timer_sync+0x7d/0x120
> [<ffffffffa016839a>] ? run_scheduled_bios+0x23a/0x520 [btrfs]
> [<ffffffffa0170e40>] ? worker_loop+0x120/0x520 [btrfs]
> [<ffffffffa0170d20>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
> [<ffffffff810520c5>] ? kthread+0x85/0xa0
> [<ffffffff815441f4>] ? kernel_thread_helper+0x4/0x10
> [<ffffffff81052040>] ? kthread_freezable_should_stop+0x60/0x60
> [<ffffffff815441f0>] ? gs_change+0xb/0xb
>=20
> Cheers,
>=20
> --Kerin

Thanks.  Looks like it is a btrfs bug - so a big "hello" to linux-btrfs :-)

The symptom is that iozone on btrfs on md/raid10 can result in

[  919.893454] md/raid10:md0: make_request bug: can't convert block across =
chunks or bigger than 256k 6653500160 256
[  919.893465] btrfs: bdev /dev/mapper/vg0-test errs: wr 1, rd 0, flush 0, =
corrupt 0, gen 0


i.e. RAID10 has a 256K chunk size, but is getting 256K requests which overl=
ap
two chunks - the last half of one chunk and the first half of the next.
That isn't allowed and raid10_mergeable_bvec, called by bio_add_page, should
prevent it.

However btrfs_map_bio() sets ->bi_sector to a new value without verifying
that the resulting bio is still acceptable - which it isn't.

The core problem is that you cannot build a bio for one location, then use =
it
freely at another location.
md/raid1 handles this by checking each addition to a bio against all the
possible location that it might read/write it.  Maybe btrfs could do the
same.
Alternately we could work with Kent Overstreet (of bcache fame) to remove t=
he
restriction that the fs must make the bio compatible with the device -
instead requiring the device to split bios when needed, and making it easy =
to
do that (currently it is not easy).
And there are probably other alternative.

Thanks,
NeilBrown

--Sig_/oFYIo4/0pUi2NDTUibc8/KB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/JdPznsnt1WYoG5AQKoBw//YRb104dMq0mn1bZPUcIFnAUMKYvQiM1A
BXSmPZFiEUhgKY1FIT9yqZwUbxCPKPqStiPQ8dBAKEDnwmVj4Jbx5qRlUhwyjxxe
VPnh26UuC0wMWLhIGj94BBGHYX5536kpIxmHKfG591/mKs3XTygbmP1p9OomHvzg
slILyHibyF2TXrkDRAKZVgug2MZ9Xvtz5vN+95+v6TADhKdR30hVaCl2dCALasyw
iUVPR2jEfN8zas3JV7iU3hnxOHLDhoGtf9FOEIAEn/+pVyaEYuUbPcgdzPX1faCb
7EL2BuL0yeNn6jesqNIAuY+GBpqU/u/Tl2ENZXZQ5+DdOXEPfmM+AOaYmg4hB/eh
f+Wmn1C2TMlsh+ieENKVqX7vO168H0PYodDh6nEuIXEISVwjPrLTGYhaSU33c7Fh
VShnvAkkAGo844c4spvzRuyjC4+fnu9yUdnwC7ieFrLTo0c0UgJfVVmKAEgKG39v
ud0JC5iQlCHWB7kTGuJ0iniseLMD3oDX3D69Jz2rR5H5Hl1fAoHW3nTfv0XeXdZt
ydYTQCqvcllcoMeznGB3NJocYwEKaTY9X4/yMgyLItqUQXVL0IFJkM83SCOy9Tun
ukBdLDGGUxm1+nzrqHk9B7WwBHyktJ49qcJ9zIj8VzCcFIAdt9RlhFVaVI4+FJsq
8+mo8jBLYMs=
=WbOU
-----END PGP SIGNATURE-----

--Sig_/oFYIo4/0pUi2NDTUibc8/KB--
