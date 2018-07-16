Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbeGPOZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 10:25:33 -0400
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
Date: Mon, 16 Jul 2018 21:57:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180716131622.GI3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6qfl5c8SkrRYETKZXVl1sxpTlE4SYVvM5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6qfl5c8SkrRYETKZXVl1sxpTlE4SYVvM5
Content-Type: multipart/mixed; boundary="NMKCIbYeN7NK9UvwzIN8HOCbKDokkTftg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
In-Reply-To: <20180716131622.GI3126@twin.jikos.cz>

--NMKCIbYeN7NK9UvwzIN8HOCbKDokkTftg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8816=E6=97=A5 21:16, David Sterba wrote:
> On Fri, Jul 06, 2018 at 07:44:37AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8805=E6=97=A5 23:18, David Sterba wrote:
>>> On Tue, Jul 03, 2018 at 05:10:09PM +0800, Qu Wenruo wrote:
>>>> If a crafted btrfs has missing block group items, it could cause
>>>> unexpected behavior and breaks our expectation on 1:1
>>>> chunk<->block group mapping.
>>>>
>>>> Although we added block group -> chunk mapping check, we still need
>>>> chunk -> block group mapping check.
>>>>
>>>> This patch will do extra check to ensure each chunk has its
>>>> corresponding block group.
>>>>
>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>>>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++++++++++++++++++++++=
++-
>>>>  1 file changed, 51 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 82b446f014b9..746095034ca2 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -10038,6 +10038,56 @@ static int check_exist_chunk(struct btrfs_f=
s_info *fs_info, u64 start, u64 len,
>>>>  	return ret;
>>>>  }
>>>> =20
>>>> +/*
>>>> + * Iterate all chunks and verify each of them has corresponding blo=
ck group
>>>> + */
>>>> +static int check_chunk_block_group_mappings(struct btrfs_fs_info *f=
s_info)
>>>> +{
>>>> +	struct btrfs_mapping_tree *map_tree =3D &fs_info->mapping_tree;
>>>> +	struct extent_map *em;
>>>> +	struct btrfs_block_group_cache *bg;
>>>> +	u64 start =3D 0;
>>>> +	int ret =3D 0;
>>>> +
>>>> +	while (1) {
>>>> +		read_lock(&map_tree->map_tree.lock);
>>>> +		em =3D lookup_extent_mapping(&map_tree->map_tree, start,
>>>> +					   (u64)-1 - start);
>>>
>>> This needs a comment.
>>
>> For the @len part?
>=20
> Yes, for the expression how it's calculated.
>=20
>>>
>>>> +		read_unlock(&map_tree->map_tree.lock);
>>>> +		if (!em)
>>>> +			break;
>>>> +
>>>> +		bg =3D btrfs_lookup_block_group(fs_info, em->start);
>>>> +		if (!bg) {
>>>> +			btrfs_err_rl(fs_info,
>>>> +	"chunk start=3D%llu len=3D%llu doesn't have corresponding block gr=
oup",
>>>> +				     em->start, em->len);
>>>> +			ret =3D -ENOENT;
>>>
>>> -EUCLEAN ?
>>
>> Either works for me.
>=20
> That's not just a cosmetic change, there's a semantic difference betwee=
n
> the error codes, I maybe make that more explicit and not expect that th=
is
> is obvious.
>=20
> ENOENT does not make much sense in this context, the caller (mount in
> this case) cannot do anything about a code that says 'some internal
> structure not found'.

The point here is, if every self-checker should only return -EUCLEAN, it
won't really indicate what's going wrong, except points to some
self-checker (and such self-checkers are growing larger than our
expectation already).

My practice here is, put some human readable and meaningful error
message. No matter what we choose to return, the error message should
tell us what's going wrong.

In this case, I don't really care the return value. If it's explicitly
needed to return -EUCLEAN, I could make all existing checker (from
tree-checker to chunk/bg/dev-extent checker) to return -EUCLEAN if
anything is wrong (and save several "ret =3D -EUCLEAN" lines).
The return value doesn't really have much meaning nowadays, it's the
error message important now.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--NMKCIbYeN7NK9UvwzIN8HOCbKDokkTftg--

--6qfl5c8SkrRYETKZXVl1sxpTlE4SYVvM5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltMpFgACgkQwj2R86El
/qiS1Af/QWRYxThesiok7hVKxRtn/5bvTPv1FWFGrOHSLkgyfmsz4R3cbYq+jLKa
tFyPbg8Qr/ur1+edatPK/dtWrlA1lit7SUytTKFMOti44cGofL/38/5wAj8hZRz1
1PckVFQjA74hPfX5hFmUqSNck5TM4i3r/UQvpjW3euuxnsKpFCYFwG7WEDvWwMyb
gYao6wr/SHZmEk3B4F28weCU1JCB4vSSpig4XOCvEfQu85nMe0tnlRzy5MeBC8rL
LcoApdPOmESI0s0hAPHsrLosneIx4ZjBgIIk0EUc362hM54SKWDvCP4sU4yIDYz3
9hYlB5RlBDgwN99iPQGHAhKrYhmz+w==
=VuxS
-----END PGP SIGNATURE-----

--6qfl5c8SkrRYETKZXVl1sxpTlE4SYVvM5--
