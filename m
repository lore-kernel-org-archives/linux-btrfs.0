Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab3JVSjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 14:39:14 -0400
Message-ID: <5266C64A.90506@suse.com>
Date: Tue, 22 Oct 2013 14:39:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [patch 00/13] sysfs publishing patchset
References: <20131021211940.432195222@suse.com> <20131022182602.GC27304@localhost.localdomain>
In-Reply-To: <20131022182602.GC27304@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LB8NDD51JlKhQShWAgXpH3NoUKUlPDLHs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LB8NDD51JlKhQShWAgXpH3NoUKUlPDLHs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/22/13 2:26 PM, Josef Bacik wrote:
> On Mon, Oct 21, 2013 at 05:19:40PM -0400, Jeff Mahoney wrote:
>> This patchset implements the stubbed-out sysfs interface for btrfs. Or=

>> at least begins to do so.
>>
>> We publish:
>> - Features supported by the file system implementation
>> - Features enabled on the file system, including features unknown to
>>   the implemenation. These attributes can also be used to enable or
>>   disable features at runtime, subjecting to a safety mask.
>> - Uses the attribute names to print feature names when declining to
>>   mount a file system.
>> - The allocation data: global metadata reservation size and reserved,
>>   space_infos, and sums of the block groups total and used bytes.
>> - Device membership via links to the block devices.
>> - FS label, which is writeable.
>>
>> - I've also added matching ioctls for some of the functionality here s=
o
>>   that btrfsprogs can use the information without jumping through hoop=
s
>>   to read/parse the sysfs files. There are ioctls to query the support=
ed
>>   features and to query/set features on a particular file system. Ther=
e's
>>   also one to export the size of the global metadata reservation. I ha=
ve
>>   a patch for btrfs-progs that uses this to print useful info in 'btrf=
s
>>   fi df' output.
>>
>> Ultimately, the tree structure looks like the following, under /sys/fs=
/btrfs.
>> This is from a test file system, using two devices in raid1. You'll no=
tice
>> the 'single' and 'raid1' directories under the {data,metadata,system} =
dirs.
>> The raid profiles are created and removed as the first/last block grou=
p
>> of a certain profile is added and removed.
>>
>=20
> I'm not pulling in patches that add new functionality without an accomp=
anying
> xfstest so that we're not merging features without a way to test to mak=
e sure

Sure, that's reasonable.

> they are working properly, this applies to the global metadata reservat=
ion ioctl
> as well.  Thanks,

What would a test look like for that? It's information that isn't
currently available anywhere in userspace and isn't represented in the
file system itself.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--LB8NDD51JlKhQShWAgXpH3NoUKUlPDLHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSZsZNAAoJEB57S2MheeWyP64P/2Sym+86XyD8VzmcLePTPgyj
eaHaPHYEx3FjcSShH1TTpeGmigP7pkpePl1EETo/Viywle0iN2t0leJttQiBgWmU
ZU9lIubt5pVx8iyWl3DZS4dpKhINpf1XmgoPkUnLGmGexuXvqWKoWF2K++kBDdOl
tXlr2pexYgrhynSFRslHbbfYqBBnD/hEvyAOcRP3z7hK/+J8wC4BEEkD9sz049Fp
a3bXH2+i1V3FAOe2jHc0PKAPfjYqSzLozyTjmERmDchz+zTZSzj0rZFT6nUKrsSn
lW7a4rqWC0Tv56JljFhWoP7Cb1vAnsz3OEjsUue+rXrd3T9P0eV507z3DB5ygyln
3BgwL2s9nhOkQQOX5RBaGtI4RSwcRpIR6rcMGjBCcNz/mnQTi82LDE0Bb+/N+gGT
b4QOkOrX0lhtnkTuwMDl2vyUn6DyRjG5qmbVEV7EQEQtOy7Y+jdE6Tr7tx8KXEOl
5TfUWi3yJ6VcjEWjUL3eiAEBbGWbeh4cyA+LeQw1S3VZYr11iLKv84wsHbxw9wGV
6hhqm9qy1rbVGAREf+rBCYZ+3/1t7W4TihEGjHaiiRZABqez33nekoUxi0n9+3YY
FuFseMTK0qozamq4eCfia7VIll05sFka+HojYfqIwhNGzMsSNra2NpyKHMzRLqIw
Vobvz5uYzfzDjPzyrIDC
=jwSg
-----END PGP SIGNATURE-----

--LB8NDD51JlKhQShWAgXpH3NoUKUlPDLHs--
