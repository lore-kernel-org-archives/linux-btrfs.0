Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754632AbdARND6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 08:03:58 -0500
Subject: Re: gdb log of crashed "btrfs-image -s"
To: Christoph Groth <christoph@grothesque.org>,
        Chris Murphy <lists@colorremedies.com>
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
 <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
 <877f5tcmgk.fsf@grothesque.org> <87wpdsc03i.fsf_-_@grothesque.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <ab4eb6a1-f634-6a8d-b260-1a7abf09f6f1@suse.de>
Date: Wed, 18 Jan 2017 05:49:50 -0600
MIME-Version: 1.0
In-Reply-To: <87wpdsc03i.fsf_-_@grothesque.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eJIUtjXAUI2RFvgfIGNmihUiC0gffHkHR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eJIUtjXAUI2RFvgfIGNmihUiC0gffHkHR
Content-Type: multipart/mixed; boundary="aMOpUfmUDwtVrti52VTVOBJHmJ1p5B0ch";
 protected-headers="v1"
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Christoph Groth <christoph@grothesque.org>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <ab4eb6a1-f634-6a8d-b260-1a7abf09f6f1@suse.de>
Subject: Re: gdb log of crashed "btrfs-image -s"
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
 <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
 <877f5tcmgk.fsf@grothesque.org> <87wpdsc03i.fsf_-_@grothesque.org>
In-Reply-To: <87wpdsc03i.fsf_-_@grothesque.org>

--aMOpUfmUDwtVrti52VTVOBJHmJ1p5B0ch
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 01/18/2017 01:13 AM, Christoph Groth wrote:
> Christoph Groth wrote:
>> Chris Murphy wrote:
>>> On Tue, Jan 17, 2017 at 1:25 PM, Christoph Groth
>>> <christoph@grothesque.org> wrote:
>>>> Any ideas on what could be done?  If you need help to debug the
>>>> problem with
>>>> btrfs-image, please tell me what I should do.  I can keep the broken=

>>>> file
>>>> system around until an image can be created at some later time.
>>>
>>> Try 4.9, or even 4.8.5, tons of bugs have been fixed since 4.7.3
>>> although I don't know off hand if this particular bug is fixed. I did=

>>> recently do a btrfs-image with btrfs-progs v4.9 with -s and did not
>>> get a segfault.
>>
>> I compiled btrfs-image.static from btrfs-tools 4.9 (from git) and
>> started it from Debian testing's initramfs.  The exact command that I
>> use is:
>>
>> /mnt/btrfs-image.static -c3 -s /dev/sda2 /mnt/mim-s.bim
>>
>> It runs for a couple of seconds (enough to write 20263936 bytes of
>> output) and then quits with
>>
>> *** Error in `/mnt/btrfs-image.static`: double free or corruption=20
>> (!prev): 0x00000000009f0940 ***
>> =3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D
>> [0x45fb97]
>> [0x465442]
>> [0x465c1e]
>> [0x402694]
>> [0x402dcb]
>> [0x4031fe]
>> [0x4050ff]
>> [0x405783]
>> [0x44cb73]
>> [0x44cdfe]
>> [0x400b2a]
>>
>> (I had to type the above off the other screen, but I double checked
>> that there are no errors.)
>>
>> The executable that I used can be downloaded from
>> http://groth.fr/btrfs-image.static
>> Its md5sum is 48abbc82ac6d3c0cb88cba1e5edb85fd.
>>
>> I hope that this can help someone to see what's going on.
>=20
> I ran the same executable under gdb from a live system.  The log is
> attached.
>=20

Thanks Christoph for the backtrace. I am unable to reproduce it, but
looking at your backtrace, I found a bug. Would you be able to give it a
try and check if it fixes the problem?

diff --git a/image/main.c b/image/main.c
index 58dcecb..0158844 100644
--- a/image/main.c
+++ b/image/main.c
@@ -550,7 +550,7 @@ static void sanitize_name(struct metadump_struct
*md, u8 *dst,
                return;
        }

-       memcpy(eb->data, dst, eb->len);
+       memcpy(eb->data, src->data, src->len);

        switch (key->type) {
        case BTRFS_DIR_ITEM_KEY:



--=20
Goldwyn


--aMOpUfmUDwtVrti52VTVOBJHmJ1p5B0ch--

--eJIUtjXAUI2RFvgfIGNmihUiC0gffHkHR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJYf1ZlAAoJEAE1niapr6PJiSoH/0nXu+TfcKUM9QOaSRu6eybh
XQT62p6OBpdR4K7NMB91NeunD35kSqGFgystrfnf33JS8z/M1uzQ1SfZrVr9bcKY
kZSr2Kei3GdWFXbt2oFu+0nskmgWeujWF0W25VBYB/Lo6VAAsC5PpxYj+gS0jvy3
JspvIbZSzO+k8Dk/5Ocib8dO+I0dr6tYZsOTA7C78gJ4vBN9TCH7060Z5HKxkvtZ
T5iUgWVeqaozHbceRJYXzP/I8PLSBXZmlYbhYEF1i35m4bvVl96qS7PtQW/8x2je
B+QE9Iu5IC/EY9Srf7OzG661sfQIYED7wC7A3se70yAA7yJg8hB27HMVf/NAGx8=
=6Edw
-----END PGP SIGNATURE-----

--eJIUtjXAUI2RFvgfIGNmihUiC0gffHkHR--
