Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941229AbcIZAjt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 20:39:49 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
 <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
 <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
 <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <df57cbab-f316-c6a1-fccc-0a1c1e6dc276@suse.com>
Date: Sun, 25 Sep 2016 20:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MHeaNhfjeG1s8mTSpc2SVnJ6IjpFlW9I6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MHeaNhfjeG1s8mTSpc2SVnJ6IjpFlW9I6
Content-Type: multipart/mixed; boundary="MwRKcvWCfX3tS3Fpbf7Q6GAMkwPmexQB9";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <df57cbab-f316-c6a1-fccc-0a1c1e6dc276@suse.com>
Subject: Re: unable to handle kernel paging request - btrfs
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
 <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
 <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
 <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>
In-Reply-To: <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>

--MwRKcvWCfX3tS3Fpbf7Q6GAMkwPmexQB9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/25/16 8:37 PM, Rich Freeman wrote:
> On Sun, Sep 25, 2016 at 7:22 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 9/25/16 9:55 AM, Rich Freeman wrote:
>>> On Fri, Sep 23, 2016 at 12:58 AM, Duncan <1i5t5.duncan@cox.net> wrote=
:
>>>>
>>>> Btrfs raid1 you say, and you have existing compressed files it's try=
ing
>>>> to read in the backtrace?
>>>>
>>>> Sounds like the issues I see sometimes and have posted about where a=
fter
>>>> a crash that resulted in one device of my raid1 pair getting behind =
the
>>>> other, the kernel will crash if it sees too many csum-errors, even t=
ho
>>>> it's /supposed/ to check the other copy and read from it if valid (w=
hich
>>>> it is as a btrfs scrub resolves the issue).
>>>>
>>>> When booted to rescue/single-user mode, can you run a scrub?
>>>
>>> After a few reboots trying to capture the initial panic message (even=

>>> when I set panic_on_oops=3D1 I was getting multiple ones with only th=
e
>>> tainted one staying on screen), the system managed to stay up.  I
>>> completed a scrub and it found no errors.  I also haven't had any
>>> issues with it but haven't attempted another reboot.  I figured the
>>> safest course was to just leave it on for a good week so that whateve=
r
>>> was in the log/etc that was giving it trouble works its way out.  I'm=

>>> also doing a balance which may or may not help (and which is useful
>>> anyway since I increased the size of the drive I replaced).
>>
>> If it stays up, can you post the initial Oops then?
>>
>=20
> Unfortunately, it stays up because there is no OOPS.  It was crashing
> fairly consistently, but for whatever reason it didn't this time.
> Since I needed the box working and wasn't having a lot of luck
> capturing the OOPS I just let it run with minimal prodding, and
> hopefully it is now in a state where it won't crash.
>=20
> But, if it happens again I'll try to capture an initial OOPS output,
> and I'll do a memory test in any case (though I really am not
> expecting anything there).
>=20
> If I were able to get kernel core dumping working on this machine,
> would that contain information about the initial oops.  I forget if
> they contain the full ring buffer/etc.  I used to have it working but
> some change in either the kernel or the utils was causing issues with
> it.  I still boot my kernels with space set aside for the crash
> kernel...

I'm not sure about other distros, but at least with SLES/openSUSE you
can configure kdump to /just/ dump the dmesg.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--MwRKcvWCfX3tS3Fpbf7Q6GAMkwPmexQB9--

--MHeaNhfjeG1s8mTSpc2SVnJ6IjpFlW9I6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJX6G5QAAoJEB57S2MheeWyU9AP/jGHc6oAKVenWirX0nfz7tbC
IJUfQ3hLaN5uvRm8ZDhaSqfXkpG+zEeETG0CdN3JPKmr2v/qSaYxz0awApJm39h7
Ir7P9okqkaq6xyVj1NcGPORMNfq8l+7TNlpSFvTQDxeyTckSEN6C1sz4P+co8oRJ
ZIyq1kMB3DFA2VMc5w4UGMtSEbWX9+YPElPmLzpnHyUdDYD4kriHdsPd+byQzi9j
YnQW5p0hVucBwtDomilkiDzQiRX+REuQkbe1Cjp5nsFSeEjvosjsAKIgXYAgKqpm
2VDNRiOZzHzDKVJMyGFRbXsXNSdkfH5IV0Cry+Dq6/dlPDETCqfbMEUEKxE6Rjsj
XBRrPaZ/+Ju0CeJo6v5UME5qi0T0gUPXsPjw4u7VBBp16ISBzqLDdaw5TtOikBSA
ydH1TcbA78TQkWYt0epvkTfmp4LbHnQXPpWUtM7f6fihk3mOI49gOV7F/PmkvpcN
w+Nk/psWAAt5aX6ON6ll60nRjv10Izls1COyfXjO+dimsiOZSp0ljbDOKJU4A1rn
GfIvMie38C2WZkiX3Zg2RtnC3i1v2v1VVHiKWQB4M0GpfPg5OQ9uhkWQdBMuOOWf
i0C2HCfeLXFNVH2QKabpYKSDm6oyfb+f3a33nwd6ZpVduFFYYmTAysChtGufLHDP
DuiJ7q9ZNEJGAQCN48x8
=Uog3
-----END PGP SIGNATURE-----

--MHeaNhfjeG1s8mTSpc2SVnJ6IjpFlW9I6--
