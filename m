Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37891 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbeERUyX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 16:54:23 -0400
Received: by mail-pf0-f195.google.com with SMTP id o76-v6so4294612pfi.5
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 13:54:23 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <ECD5447C-811E-409B-ACBD-702E86C78C06@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FE2FFAF4-8F19-49C1-B9BD-6486E8CE283D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 10/10] Dynamic fault injection
Date: Fri, 18 May 2018 14:54:18 -0600
In-Reply-To: <20180518191040.GG31737@kmo-pixel>
Cc: LKML <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com,
        tytso@mit.edu, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        viro@zeniv.linux.org.uk, willy@infradead.org, peterz@infradead.org
To: Kent Overstreet <kent.overstreet@gmail.com>
References: <20180518074918.13816-1-kent.overstreet@gmail.com>
 <20180518074918.13816-21-kent.overstreet@gmail.com>
 <905DA1CC-63F8-4020-A1D7-1F59ABDF3448@dilger.ca>
 <20180518191040.GG31737@kmo-pixel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_FE2FFAF4-8F19-49C1-B9BD-6486E8CE283D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 18, 2018, at 1:10 PM, Kent Overstreet <kent.overstreet@gmail.com> =
wrote:
>=20
> On Fri, May 18, 2018 at 01:05:20PM -0600, Andreas Dilger wrote:
>> On May 18, 2018, at 1:49 AM, Kent Overstreet =
<kent.overstreet@gmail.com> wrote:
>>>=20
>>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>>=20
>> I agree with Christoph that even if there was some explanation in the =
cover
>> letter, there should be something at least as good in the patch =
itself.  The
>> cover letter is not saved, but the commit stays around forever, and =
should
>> explain how this should be added to code, and how to use it from =
userspace.
>>=20
>>=20
>> That said, I think this is a useful functionality.  We have something =
similar
>> in Lustre (OBD_FAIL_CHECK() and friends) that is necessary for being =
able to
>> test a distributed filesystem, which is just a CPP macro with an =
unlikely()
>> branch, while this looks more sophisticated.  This looks like it has =
some
>> added functionality like having more than one fault enabled at a =
time.
>> If this lands we could likely switch our code over to using this.
>=20
> This is pretty much what I was looking for, I just wanted to know if =
this
> patch was interesting enough to anyone that I should spend more time =
on it
> or just drop it :) Agreed on documentation. I think it's also worth
> factoring out the functionality for the elf section trick that dynamic
> debug uses too.
>=20
>> Some things that are missing from this patch that is in our code:
>>=20
>> - in addition to the basic "enabled" and "oneshot" mechanisms, we =
have:
>>  - timeout: sleep for N msec to simulate network/disk/locking delays
>>  - race: wait with one thread until a second thread hits matching =
check
>>=20
>> We also have a "fail_val" that allows making the check conditional =
(e.g.
>> only operation on server "N" should fail, only RPC opcode "N", etc).
>=20
> Those all sound like good ideas... fail_val especially, I think with =
that
> we'd have all the functionality the existing fault injection framework =
has
> (which is way too heavyweight to actually get used, imo)

The other thing that we have that is slightly orthogonal to your modes,
which is possible because we just have a __u32 for the fault location,
is that the "oneshot" mode is just a mask added to the fault location
together with "fail_val" is that we can add other masks "fail N times",
"fail randomly 1/N times", or "pass N times before failure".  The other
mask is set in the kernel when the fault was actually hit, so that test
scripts can poll until that happens, and then continue running.

The "fail randomly 1/N times" was useful for detecting memory allocation
failure handling under load, but that has been superseded by the same
functionality in kmalloc(), and it sounds like your fault injection can
do this deterministically for every allocation?

Cheers, Andreas






--Apple-Mail=_FE2FFAF4-8F19-49C1-B9BD-6486E8CE283D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlr/PXoACgkQcqXauRfM
H+DdRQ/+KUz1HI3KOGg9OyrM1tcKHlrTNWjy4CTiNxN1xWcuMCbynur5WhiY/vvr
xbCooFEWoxAbyZC8l3Tkt0J4Z9bnb7E/BlEpLHBaYc7HNhfF3gi3dsTZGHfSla1M
1xhpsDM97PaaLNbh/9pSg5JjyxbpHdlaelZM46W8ZySSAYUwR3wRjqR1Ppuu98cD
CmLUlIkvFURmuofr25WzKe4+VTVMjTROrsmyRkhPfyxGe95tOxmud/s2QpxHsm6k
pHs0oK2gXDr9f+BC1T44dWQa2Q5R7hGpP1zpB6pDNIbIyUTvCmeAUc/KIGJDhKBz
8w126dgyVYYepaygyVnVSSZQYV8naFHCY5/eqzrfDsugydtKrv02GF8CUarJqHmz
Usc5EkXpAs14jQDguSIhgT0mJvGL+krBN4CyOAeAu2dQh29pXzjvMa7EiVDKPcMu
TKgqHXMkN+azTFgft20Gx5Sa/WMpvru4OzEAUUor/27PNRyt2kinI33HCvedmckd
bKrun2zhbDOF2F0HuoPfNx5V34g14fgU+CGga/nFmdIck8U+4C5AjyDM3XKT65xm
h/iTfXik2Saj74yk3o7EtT224BWIsqAw1BnUgZgWqMPeb/qtxL6cjjO65HKyD7OI
1z/6tdroVcdGzw1PETdzvt1qPZbFSSP5agxG90GWF7SOheY2fQo=
=FNyV
-----END PGP SIGNATURE-----

--Apple-Mail=_FE2FFAF4-8F19-49C1-B9BD-6486E8CE283D--
