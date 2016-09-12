Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759141AbcILN1x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:27:53 -0400
Subject: Re: btrfs kernel oops on mount
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        moparisthebest <admin@moparisthebest.com>, linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
 <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e03a83f1-1a1e-30f7-379a-47f8de057187@suse.com>
Date: Mon, 12 Sep 2016 15:27:50 +0200
MIME-Version: 1.0
In-Reply-To: <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BtRIahjUur7w5xtArw3bGUP0iGLTU65Qx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BtRIahjUur7w5xtArw3bGUP0iGLTU65Qx
Content-Type: multipart/mixed; boundary="uG5pURVG97sJk9twVksCvu6evxEFqS4VH";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 moparisthebest <admin@moparisthebest.com>, linux-btrfs@vger.kernel.org
Message-ID: <e03a83f1-1a1e-30f7-379a-47f8de057187@suse.com>
Subject: Re: btrfs kernel oops on mount
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
 <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>
In-Reply-To: <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>

--uG5pURVG97sJk9twVksCvu6evxEFqS4VH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/12/16 2:54 PM, Austin S. Hemmelgarn wrote:
> On 2016-09-12 08:33, Jeff Mahoney wrote:
>> On 9/9/16 8:47 PM, Austin S. Hemmelgarn wrote:
>>> A couple of other things to comment about on this:
>>> 1. 'can_overcommit' (the function that the Arch kernel choked on) is
>>> from the memory management subsystem.  The fact that that's throwing =
a
>>> null pointer says to me either your hardware has issues, or the Arch
>>> kernel itself has problems (which would probably mean the kernel imag=
e
>>> is corrupted).
>>
>> fs/btrfs/extent-tree.c:
>> static int can_overcommit(struct btrfs_root *root,
>>                           struct btrfs_space_info *space_info, u64 byt=
es,
>>                           enum btrfs_reserve_flush_enum flush)
>>
> OK, my bad there, but that begs the question: why does a BTRFS function=

> not have a BTRFS prefix?  The name blatantly sounds like a mm function
> (and I could have sworn I can across one with an almost identical name
> when I was trying to understand the mm code a couple months ago), and
> the lack of a prefix combined with that heavily implies that it's a cor=
e
> kernel function.
>=20
> Given this, it's almost certainly the balance choking on corrupted
> metadata that's causing the issue.

Because it's a static function and has a namespace limited to the
current C file.  If we prefixed every function in a local namespace with
the subsystem, the code would be unreadable.  At any rate, the full
symbol name in the Oops is:

can_overcommit+0x1e/0x110 [btrfs]

So we do identify the proper namespace in the Oops already.

>>> 3. In general, it's a good idea to keep an eye on space usage on your=

>>> filesystems.  If it's getting to be more than about 95% full, you sho=
uld
>>> be looking at getting some more storage space.  This is especially tr=
ue
>>> for BTRFS, as a 100% full BTRFS filesystem functionally becomes
>>> permanently read-only because there's nowhere for the copy-on-write
>>> updates to write to.
>>
>> The entire point of having the global metadata reserve is to avoid tha=
t
>> situation.
> Except that the global metadata reserve is usually only just barely big=

> enough, and it only works for metadata.  While I get that this issue is=

> what it's supposed to fix, it doesn't do so in a way that makes it easy=

> to get out of that situation.  The reserve itself is often not big
> enough to do anything in any reasonable amount of time once the FS gets=

> beyond about a hundred GB and yous tart talking about very large files.=


Why would it need to apply to data?  The reserve is used to meet the
reservation requirements to CoW metadata blocks needed to release the
data blocks.  The data blocks themselves aren't touched; they're only
released.  The size of the file really should only matter in terms of
how many extent items need to be released but it shouldn't matter at all
in terms of how many blocks the file's data occupies.  E.g. a 100 GB
file that uses a handful of extents would be essentially free in this
context.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--uG5pURVG97sJk9twVksCvu6evxEFqS4VH--

--BtRIahjUur7w5xtArw3bGUP0iGLTU65Qx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX1q1WAAoJEB57S2MheeWypQgQAJYBpsFhpJemxPgliHwry7Zm
95IQSsdi9nGAuU8buSUHF0s+Gg5W7KMjBLN6g4wNjcBMpzmcGs0N33PSrbrN9Axa
s3zyvqodOOFHFmUaofwow8/xa0N1SxQq7L/FpF3IfchQJ1GBae9tcxGX1fJRfcm1
YbiJ+PO7esy/gwAei9GbfZ6Nnfc2liJOC3tm4s02WN4RPsxL2Ox6KZsl9OB9pl2+
n6LAgGlfjL8gBJGpOkbaJiIZ0Aga42YtN7TcrSUycy+xbJAq5SCedt7Aia5/c3Q8
YXVQuQukC26EwlzL6Qa0wIlzvq5YVeI/HHOPJVbsZ0zlDMsECaLATaCpx6HJQAQ2
aVeoiBPO4BA0g52AxdWxnL3IUn6wjnkKEBZG39eaPrwiANOwEiRgZ9G5qdq5K718
IXWZ2Ckmo5vEJl5mQW0+urNE4zIyIHcqv02KIxmIZ7/b3iBrDDJ62Gzh5BcsIrUo
tvQOIe+cc/lz6yoAnFBLu6e88Auc+f6aAouzKBdsCPDgznHb4lw4o7IgoZ0QaSvr
ISmHaeBRqcH6QF3prLiW+92Gq+xPvLP64zryzhbllwT0hD5txMXi/ctyiI1x2hBC
ju6HW5XNf1HoX3ecMNbzDwmg8N8ewyjbMA6gjjL4DoeolsvogUG39WZ/CisoEAvO
p83Lr74wL3GsvFt/AzRV
=BmoP
-----END PGP SIGNATURE-----

--BtRIahjUur7w5xtArw3bGUP0iGLTU65Qx--
