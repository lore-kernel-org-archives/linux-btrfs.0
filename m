Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57545 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752513AbcHaWgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 18:36:47 -0400
Subject: Re: [PATCH] btrfs: remove pointless debugfs interface
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
 <20160831190858.GJ16983@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <cf671f17-e5c1-fc67-d008-b771f81d9bfc@suse.com>
Date: Wed, 31 Aug 2016 18:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <20160831190858.GJ16983@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mwhrK2v3hSGxcw95tt2aqtN4oKvsMbwAI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mwhrK2v3hSGxcw95tt2aqtN4oKvsMbwAI
Content-Type: multipart/mixed; boundary="qF7JCCOTEsf8PGEqA0LbIeplew3tLdxLj";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <cf671f17-e5c1-fc67-d008-b771f81d9bfc@suse.com>
Subject: Re: [PATCH] btrfs: remove pointless debugfs interface
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
 <20160831190858.GJ16983@twin.jikos.cz>
In-Reply-To: <20160831190858.GJ16983@twin.jikos.cz>

--qF7JCCOTEsf8PGEqA0LbIeplew3tLdxLj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/31/16 3:08 PM, David Sterba wrote:
> On Wed, Aug 31, 2016 at 10:13:49AM -0500, Eric Sandeen wrote:
>> A /sys/kernel/debug/btrfs/test file was added nearly
>> two and a half years ago, but it serves no purpose;
>=20
> It does. Introduced in 1bae30982bc86ab66d61ccb6e22792593b45d44d says
> something about helping developers to easily export information from th=
e
> filesystem, to aid debugging. Writing the debugfs support code is not
> obviously trivial, so it's idling in the source. Exporing a new value i=
s
> as easy as copy and update 3 lines of code. If you have no use for it,
> fine.
>=20
>> it stores and returns a value, but nothing in the btrfs
>> code uses this value in any way.  There are no other btrfs
>> files in this debugfs dir.
>>
>> This was brought to my attention because it is world-writable;
>> it is the only such file under /sys/kernel/debug, and without
>> knowledge of its purpose, some users were alarmed by this.
>=20
> So let's fix the permissions.

Perhaps we can also just stick it behind a CONFIG option as well if the
intention is to keep it around for developer debugging purposes.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--qF7JCCOTEsf8PGEqA0LbIeplew3tLdxLj--

--mwhrK2v3hSGxcw95tt2aqtN4oKvsMbwAI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXx1v5AAoJEB57S2MheeWyKTsQALzjiLcy1WNBIlQ1iz3ze8Ux
pm2ARZD8UwesG8BhxouU/PHGA7QqKjcdewrdhJwbFLeIcy5n637MRGuV0UYRb8kz
mjCRkaWa6rxHKumB1qiqRP7vjMuSF7jm9QZYU44bHVV+/w2Gr0ALA7RTl05KsrT7
seJib4hP7Cw8Z61HnC29/Etq3jQXqRJVQ3yNURVGuaEmRDpKzSI9GEoDmf3Tu2JB
B0TGO81049PFK/P3UDodlH+RSKIT5nb8JV/G6DELm00mEfdXx2Csi1QOq6BYXTl+
ZMsgQu8/A4ZAHkU8iGVMG7xHHFV9VNsuKrjvVLQHmFHBqwmmJcUA9y6eqNpBQ+QV
B7CuTI1M5ToeXYgIt9mXLCZNllGjVREdMCXbopWdohF9+vvjA0wk3q1GwtgjNnbM
LVl6/ZQ6dvb3xAbphkzBmNXx611njHEgqL2FHbUVTCL3oR/OeusDS5gxfHRUMoKT
XIN4dGj0aOvoEeQmr3mgtlnxjZ1OJRs/qgGveW+S4LF3fu9sZ4U5ow18AmzFnuR5
pE9JRP7HFdfGixgJW6l22XD+WVSQ+SPI9i1ooOjczwfV8+Be29z0ErlvX6pxgzxv
VFwkmGolDmxpF4I44eeqK3VSm1LAZ3kojAqIzQBpuetMfN5SjazAyttDo+yBmwsT
ixf6SRk9OQl10mMnS0kg
=JgvZ
-----END PGP SIGNATURE-----

--mwhrK2v3hSGxcw95tt2aqtN4oKvsMbwAI--
