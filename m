Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbcIGO0F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 10:26:05 -0400
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
To: bo.li.liu@oracle.com, Filipe Manana <fdmanana@gmail.com>
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
 <20160906215151.GB31641@localhost.localdomain>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <4c163cdc-e736-55b5-88b2-5d47bcd4f554@suse.com>
Date: Wed, 7 Sep 2016 10:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <20160906215151.GB31641@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gRj1Ec40PAekpvRtfHIdm9A6jS1SLUVN1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gRj1Ec40PAekpvRtfHIdm9A6jS1SLUVN1
Content-Type: multipart/mixed; boundary="IMFL0D6WhjlfMKG3RjFUaMoiaRlFw9oSM";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: bo.li.liu@oracle.com, Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 David Sterba <dsterba@suse.cz>
Message-ID: <4c163cdc-e736-55b5-88b2-5d47bcd4f554@suse.com>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
 <20160906215151.GB31641@localhost.localdomain>
In-Reply-To: <20160906215151.GB31641@localhost.localdomain>

--IMFL0D6WhjlfMKG3RjFUaMoiaRlFw9oSM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/6/16 5:51 PM, Liu Bo wrote:
> Hi Filipe,
>=20
> On Mon, Sep 05, 2016 at 04:28:09PM +0100, Filipe Manana wrote:
>> On Fri, Sep 2, 2016 at 8:35 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>> This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=3Dy.
>>>
>>> Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero=
 item")
>>> assumes that a leaf is its root when leaf->bytenr =3D=3D btrfs_root_b=
ytenr(root),
>>> however, we should not use btrfs_root_bytenr(root) since it's mainly =
got
>>> updated during committing transaction.  So the check can fail when do=
ing
>>> COW on this leaf while it is a root.
>>>
>>> This changes to use "if (leaf =3D=3D btrfs_root_node(root))" instead,=
 just like
>>> how we check whether leaf is a root in __btrfs_cow_block().
>>>
>>> Reported-by: Jeff Mahoney <jeffm@suse.com>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>
>> Hi Bo,
>>
>> Even with this patch applied against latest branch for-linus-4.8, at
>> least on a build with CONFIG_BTRFS_FS_CHECK_INTEGRITY=3Dy,
>> the issue still happens for me when running fsstress with balance in p=
arallel:
>=20
> Thanks for the report.
>=20
> This panic shows that we can have non-root btree leaf with 0 nritems du=
ring
> split_leaf(), but a btrfs_search_slot which calls split_leaf() like thi=
s is
> inserting an item, and while we set @right's nritems to 0, we also assi=
gn @disk_key
> associated with @right in the parent node, so I think we're actually ha=
ving
>  nritem 0 temporarily and we can remove this btrfs_mark_buffer_dirty() =
like the
> following quick patch.
>=20
> Thanks,
>=20
> -liubo
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index d1c56c9..5e5ceb5 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4341,7 +4341,11 @@ again:
>  			if (path->slots[1] =3D=3D 0)
>  				fixup_low_keys(fs_info, path, &disk_key, 1);
>  		}
> -		btrfs_mark_buffer_dirty(right);
> +		/*
> +		 * We create a new leaf 'right' for the required ins_len and
> +		 * we'll do btrfs_mark_buffer_dirty() on this leaf after copying
> +		 * the content of ins_len to 'right'.
> +		 */
>  		return ret;
>  	}
> =20
>=20
>=20

I think you're on the right track here.  I need to see if I still have
the code lying around, but when I was debugging the btrfs_rename issue
that ended up being a compiler bug, I hooked into check_leaf and ran
into similar issues.  We mark the buffer dirty before it's in a
consistent state.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--IMFL0D6WhjlfMKG3RjFUaMoiaRlFw9oSM--

--gRj1Ec40PAekpvRtfHIdm9A6jS1SLUVN1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX0CN1AAoJEB57S2MheeWysj0QAMPnEazenO9DdlwTqQqDmTSb
RY8PnapsNl5S+7+O+/PPz94zHwAPYStw+j+xFXr2ewyyQNhzDFHaTU8llsw2H5Bt
Z9rKBFL9cIo5suGGvcxdShqkffpukb4H+ehcUkBnRvtEXXVnmZTJKe2JnYLTcit0
ESl4mIviiyP6G0S/Q/cleRKOQld/eWx7aW1LVtqv9O7c5y1xJczkE62aZZs9hlK1
wov2OMhZYAn8DD5pRoGixr9bZYvFo6rQSEo/5jChmSkk6fiXkT5QjCsOTPgl6cHw
xX5aCOzeFvvrH7gx+oHHrMUVo3yGVK3fuwP3ZTsFeGZuwr9+RKx7TMF+eTsaqKCO
kJN96C6Pli6T8sllz1k110mCZH/pp2wzt2eEo56Q3VdKRmgmn/Xe3LOET5UMYNkx
nE83RXkTnqUKtnGx8ykKQ1NBMQKyiKuBguCwMcSbQOoHXV3Mx44yMsMGKWnLy/MO
UDkyuvmSAID35HOKKnKyow3TrICOnWqgQiWdG4oLsAXSQyL3snD+9YhuZCZA6ZCz
BvoU/QPaH+6HN5RkTePxSNDTmdrFCKNEoVIQH9W9n/1ivXbbRB8PuAOmo3yD4TQ6
QzjcG4SwP0ASdQY7R05MOUaWp2K6tLz2Rltfon4L3IVAMSwS4It0s4KfQb/I5i+t
BiYn0G2gH8pXQDeV1kAW
=9jXE
-----END PGP SIGNATURE-----

--gRj1Ec40PAekpvRtfHIdm9A6jS1SLUVN1--
