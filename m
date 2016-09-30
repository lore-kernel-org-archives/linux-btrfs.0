Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52819 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbcI3Uzb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:55:31 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
 <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
Date: Fri, 30 Sep 2016 16:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VOJCoCf4JfLSpGHtGfJ8LBJgDcXBC7A5M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VOJCoCf4JfLSpGHtGfJ8LBJgDcXBC7A5M
Content-Type: multipart/mixed; boundary="8QWgJHIv92mvNT549XlepGo4gXspKvucx";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
Subject: Re: unable to handle kernel paging request - btrfs
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
 <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
In-Reply-To: <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>

--8QWgJHIv92mvNT549XlepGo4gXspKvucx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/30/16 2:54 PM, Rich Freeman wrote:
> On Thu, Sep 22, 2016 at 1:41 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 9/22/16 8:18 AM, Rich Freeman wrote:
>>> I have been getting panics consistently after doing a btrfs replace
>>> operation on a raid1 and rebooting.  I linked a photo of the panic; I=

>>> haven't been able to get a text capture of it.
>>>
>>> https://ibin.co/2vx0HhDeViu3.jpg
>>>
>>> I'm getting this error on the latest 4.4, 4.1, and even on an old
>>> 3.18.26 kernel I had lying around.
>>>
>>> I tried the remove root_log_ctx from ctx list before btrfs_sync_log
>>> returns patch on 4.1 and that did not solve my problem either.
>>>
>>> I'm able to boot into single-user mode and if I don't start any
>>> processes the system seems fairly stable.  I am also able to start a
>>> btrfs balance and run that for several hours without issue.  If I
>>> start launching services the system will tend to panic, though how
>>> many processes I can launch will vary.  I don't think that it is a
>>> particular file being accessed that is triggering the issue since the=

>>> point where it fails varies.  I suspect it may be load-related.
>>>
>>> Mounting with compress=3Dno doesn't seem to help either.  Granted, I =
see
>>> lzo_decompress in the backtrace and that is probably a read operation=
=2E
>>>
>>> Any suggestions?  Google hasn't been helpful on this one...
>>
>> Can you boot with panic_on_oops=3D1, reproduce it, and capture that Oo=
ps?
>> The trace in your photo is a secondary Oops (tainted D), which means
>> that something else went wrong before that and now the system is
>> tripping over it.  Secondary Oopses don't really help the debugging
>> process because the system was already in a broken, undefined, state.
>>
>=20
> Ok, the system has been up for a week without issue, but just paniced
> and rebooted right towards the end of a balance (it literally had
> about 30 of 2500 chunks left).
>=20
> After it came up (and waiting for it to fully mount as there were a
> bunch of free space warnings/etc) I managed to capture an initial oops
> when it happened again:
>=20
> https://ibin.co/2wt0n2IaCOA3.jpg
>=20
> This is on a system without swap, though my understanding is that the
> paging system is used for other things.

It's not paging in the way Microsoft uses the term.  In this context, it
just means that the kernel tried to resolve a virtual address and
failed.  When the address is < PAGE_SIZE, it prints the NULL pointer
dereference message instead.  It's literally the same code otherwise.
Short version: it's the same thing as a segfault in userspace code.

This looks like a use-after-free on one of the pages used for
compression.  Can you post the output of objdump -Dr
/lib/modules/$(uname -r)/kernel/fs/btrfs/btrfs.ko somewhere?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--8QWgJHIv92mvNT549XlepGo4gXspKvucx--

--VOJCoCf4JfLSpGHtGfJ8LBJgDcXBC7A5M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX7tE9AAoJEB57S2MheeWyBJwP/2nu46pJnaU06JGiTJma7qa8
a0RMfg8kSpfXk11CFsb1HbG+OIzxKb+ePAaURS61OZcXLBbX7V0zfT20USY8+mEx
4CfUzT8pSc+SGqHYRmSMedTHQTgrO4Wnt6X0/U6KkXp50YhE8meCElZMBOEo9FZ3
7ODiwo/vcD9YTADeqznqW+4JhDJooifUUi9midwQD5Im1OcFnxrUAGJoRvI8Ey6e
N044f6rI4gnbLjiQYWzeHjvlSwn51msfeXJGjxLJXzHGSoDcS8cJw51zCSplUidw
CvmJGPModqTe6DGhdAC9p/wGcSud4uovYYL5tgPL0elXfsIliBpadtgPf0BQaQGA
ojhXrJC4EBP1BqsPNqyPokaGvb3qUfAOQIsOz/cNhphOVjsh8GX9wkmsA/7gPcda
xjlBGsIhYIwXaTuROaZw2dhCgvAykK856DU+aycfUOMIP2vVWp7ENr++HtMvmKOn
ZkdauW/Xr61vIuJrmJ+fgdkkFx4mbkpMwGSo/3R2/Zgr6uGEMDGUuyMsRDqnnMwS
FMbrIthLaM0WGEgA4wlOmkXXElhyJNmy2umSQDyWW7C7I7UH63C++lzDAcotuGgr
TdVrJ+xIiUx+jszGSIGHp2N4rJ5CxzG+uFomhCzAb5WbXshy6qzJF5nwPfuBX5nM
fUunOnooFrRH3FtpyZl8
=XFMo
-----END PGP SIGNATURE-----

--VOJCoCf4JfLSpGHtGfJ8LBJgDcXBC7A5M--
