Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbbKCBiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 20:38:25 -0500
From: Neil Brown <neil@brown.name>
To: Chris Mason <clm@fb.com>, "J. Bruce Fields" <bfields@fieldses.org>
Date: Tue, 03 Nov 2015 12:38:15 +1100
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] make btrfs subvol mounts appear in /proc/mounts
In-Reply-To: <20151102210347.GA20170@ret.masoncoding.com>
References: <87oafkc5kp.fsf@notabene.neil.brown.name> <20151102205012.GA26986@fieldses.org> <20151102210347.GA20170@ret.masoncoding.com>
Message-ID: <87ziyvj20o.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 03 2015, Chris Mason wrote:

> On Mon, Nov 02, 2015 at 03:50:12PM -0500, J. Bruce Fields wrote:
>> On Wed, Oct 28, 2015 at 07:25:10AM +0900, Neil Brown wrote:
>> >=20
>> > If you create a subvolume in btrfs and access it (by name) without
>> > mounting it, then the subvolume looks like a separate mount to some
>> > extent, returning a different st_dev to stat(), but it doesn't look li=
ke
>> > a separate mount in that it isn't listed in /proc/mounts. This
>> > inconsistency can confuse tools.
>> >=20
>> > This patch causes these subvolumes to become separate mounts by using
>> > the VFS' automount functionality, much like NFS uses automount when it
>> > discovered mountpoints on the server.
>> >=20
>> > The VFS currently makes it impossible to auto-mount a directory on to =
itself
>> > (i.e. a bind mount).  For NFS this isn't a problem as a new superblock
>> > is created for the child filesystem so there are two separate dentries
>> > (and inodes) for the one directory: one in the parent filesystem, one =
in
>> > the child (note that the two superblocks share a common connection to
>> > the server so there is still a lot of commonality).
>> >=20
>> > BTRFS has chosen instead to use a single superblock for all subvolumes.
>>=20
>> Naive question: was there a reason for that choice?
>
> They are really all part of the same FS, the single super better fits.
> Or said another way, it felt like there would be dramatically more duct
> tape around supers-per-subvolume than there was abusing st_dev.
>
> Neil's patch came up after I told him a few of us had tried to do the
> same thing and failed to find clean vfs changes to make it possible...he
> took it as a challenge.  Now I have to remember what it was about our
> past attempts that I didn't like.
>
> I'll test this and queue for 4.5 if it all works out, thanks Neil!

I'd rather resend with proper documentation updates and s-o-b before it
gets queued if that is OK.  So once you are happy, please let me know
and I'll do it "properly".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOBAHAAoJEDnsnt1WYoG576QP/1NraHVqNCrj7ovzkcDUgyF1
6rZMOEtMdmVdcoNeHk4bRnZnAZqluaZrsK2ni7MYi7RgTWFmT7UmiuRNDvM1hx9R
NMWmUoso1wtL3uv8e0C5aRgwLNjrhd+LopLgBquv5OqKkIaQxPGoY8TNT+6zDTRg
8q4dvJaYNMmb3MEQp771tc2XDHgdSBKOsXmVM0bEl+1j5UobctNwWWw64eNIq4vr
T3kWFqnPrNsoLUkOnOmT47jVVBXG+phbnFtkR4UcXorCYg8hzO/k5j1CrZ+BCR3k
yUxOCMNx14D98y1ybbJL7nFdmR+6e9jCcK1faRZBXH8KzLI+p4UGYCOEqO8IPIZQ
HKXj+isVynImpSjSCb8lye4ThAj+huPJYRlLGMpZCqbHj3/ud/izGNpJIhk23ruP
VcZKV81FbN1Qiks1wgdZCtN9SbUupBQxwDd86f5uyXEPicmYVsMvh50H6AmeWx1M
++7ZFNcPP5RLOd5QD5llOZv0JtvhGHOhoRQzFKwe02Fp4/1PR5IqSDLjUrRMeH//
mnYLwSjNRGlXD/wgHuNkVugV76qvfj/E3jva1kKeS0WeXcvAILLFrr1g1Bi14sm3
h+ndbLxJ4Y+uM69EHMhkGwxB6azAepd0TzrulOUmbirgU/SxB/uP+T40s3vJsv0s
DRH9r+82jMkohjmxN9Gd
=+HAj
-----END PGP SIGNATURE-----
--=-=-=--
