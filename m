Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62194 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754070AbeASKEb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 05:04:31 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
Date: Fri, 19 Jan 2018 18:03:48 +0800
MIME-Version: 1.0
In-Reply-To: <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eiaaPztD4qr6xY1fkFK7eyHUwfxOWRbps"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eiaaPztD4qr6xY1fkFK7eyHUwfxOWRbps
Content-Type: multipart/mixed; boundary="KB6eOTj2LwimJrtjLmQk4o6nR4nWUwcCG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
In-Reply-To: <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>

--KB6eOTj2LwimJrtjLmQk4o6nR4nWUwcCG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 17:40, Nikolay Borisov wrote:
>=20
>=20
> On 19.01.2018 09:25, Qu Wenruo wrote:
>> btrfs_match_dir_item_name() will check if its filetype is valid before=

>> doing search, this makes btrfs-progs unable to locate and remove inval=
id
>> dir_index for btrfs_unlink().>
>> This function only affects btrfs_link() and btrfs_unlink() in upper
>> layer, and normal check can find invalid filetype by itself.
>=20
> There is no function btrfs_link in btrfs-progs, there is, however,
> btrfs_add_link did you mean that function?

Yep, sorry for the wrong name.

> However, it doesn't seem to
> use verify_dir_item hence the check you are removing. I think this part=

> of the commit log should be more precise. Also it's not really clear
> what you mean by "normal check" in this sentence.

I skipped several function calls.

btrfs_add_link()
|- check_dir_conflict
   |- btrfs_lookup_dir_index() / btrfs_lookup_dir_item()
      |- btrfs_match_dir_item_name()
         |- verify_dir_item()

And for btrfs_add_link() without checking invalid filetype, we can avoid
case like inserting duplicated DIR_ITEM/DIR_INDEX to avoid further
screwing up things.

For btrfs_unlink() it will be different story, as btrfs_unlink() can
locate the conflicting but invalid DIR_ITEM/DIR_INDEX and remove it,
allow us to fix the problem.

And by "normal check" I mean btrfs check.

I'll add the call trace to it.

>>
>> So remove the filetype check is completely safe in this case, and will=

>> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair=
=2E
>=20
> So the problem is that since btrfs_unlink calls verify_item and the
> latter has the filetype check in case of wrong filetype (corruption)
> verify_dir_item fails, hence we cannot perform the unlink? If my
> understanding is correct how about something like:
>=20
>=20
> If we have a corrupted dir item and enough information to repair it we
> need to first delete the old/corrupted version and then insert a new
> one.
> However, btrfs_unlink calls btrfs_match_dir_item_name to locate the
> offending dir item for deletion. The latter, in turn, uses
> verify_dir_item which checks if the value for DIR item's type is sane.
> In case of a corrupted type value then verify_dir_item will fail which
> in turn will prevent btrfs_unlink from deleting the offending item.

Your understanding is completely right, and much shorter than my planned
explanation.

I'll take it with extra call trace.

Thanks,
Qu

>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  dir-item.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/dir-item.c b/dir-item.c
>> index 462546c0eaf4..e0a0ab4d7a5d 100644
>> --- a/dir-item.c
>> +++ b/dir-item.c
>> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *roo=
t,
>>  	u16 namelen =3D BTRFS_NAME_LEN;
>>  	u8 type =3D btrfs_dir_type(leaf, dir_item);
>> =20
>> -	if (type >=3D BTRFS_FT_MAX) {
>> -		fprintf(stderr, "invalid dir item type: %d\n",
>> -		       (int)type);
>> -		return 1;
>> -	}
>> -
>>  	if (type =3D=3D BTRFS_FT_XATTR)
>>  		namelen =3D XATTR_NAME_MAX;
>> =20
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--KB6eOTj2LwimJrtjLmQk4o6nR4nWUwcCG--

--eiaaPztD4qr6xY1fkFK7eyHUwfxOWRbps
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphwoUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhO3wf/TuPyj+8IME7BvNZfJN9jT18q
t0C8aASbFQI1VayxHtfUeTXuCjki1AzawWULvhyR0uqjL3jFqyqe+1A54SrV8jQO
VJ45u5NN1m7c+suM8O0SCFHk3+jG89uig4dLfu9U+AstvE+YsuiwZAGAqSKLVZRx
Kk0aSMjwdzmmToRllUgBCymy/C3sXPgXI2rhyVOAWIZCkOXTBPxzqvVigJ4Rrkig
9gwo7Y/QLVgld74ofC/4yAXRsPNNxZqQSRXrk/O+6uiJOjPq8/eXXirt203S99El
NMUtsYLR+rdTBbpDUNmvN8+zO5rtPp5Wsxx6yWzfe6tt6dbSpx+AdR91ExT5NQ==
=aUOs
-----END PGP SIGNATURE-----

--eiaaPztD4qr6xY1fkFK7eyHUwfxOWRbps--
