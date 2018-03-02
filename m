Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59021 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423832AbeCBKyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 05:54:50 -0500
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
Date: Fri, 2 Mar 2018 18:54:36 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SHGEMVXJLwERvVvXHmQjCh8BaKh7fmLbq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SHGEMVXJLwERvVvXHmQjCh8BaKh7fmLbq
Content-Type: multipart/mixed; boundary="uYsZB0dcCxaSb3aTXu4w7nyBJvl8l3qOL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Message-ID: <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
In-Reply-To: <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>

--uYsZB0dcCxaSb3aTXu4w7nyBJvl8l3qOL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 18:46, Filipe Manana wrote:
> On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
>> Normally when specifying max_inline, we should normally limit it by
>> uncompressed extent size, as it's the only thing user can control.
>=20
> Why does it matter that users can control it? Will they write less (or
> more) data to files because stuff won't get inlined?
> Why do they care about stuff getting inlined or not? That's an
> implementation detail of btrfs to speed up access to file data and
> save some space.

Then why we still have max_inline mount option?
Just do everything we *think* is best is good enough in that case.

If we provide that mount option to allow *user* to specify the behavior,
then allow then to do the same control.

Thanks,
Qu

>=20
>> (Control the algorithm and compressed data is almost impossible)
>>
>> Since btrfs is providing *TRANSPARENT* compression, max_inline should
>> behave the same for both plain and compress data.
>=20
> Taking away the benefits of compression for. So now some cases that
> ended up getting the benefits of inlining won't get them anymore.
>=20
> I don't agree with this change.


>=20
>>
>> So this patch will use @inline_len instead of @data_len in
>> cow_file_range_inline() so user will know their max_inline mount optio=
n
>> works exactly the same for both plain and compressed data extent.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index e1a7f3cb5be9..48472509239b 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -303,7 +303,7 @@ static noinline int cow_file_range_inline(struct b=
trfs_root *root,
>>             (!compressed_size &&
>>             (actual_end & (fs_info->sectorsize - 1)) =3D=3D 0) ||
>>             end + 1 < isize ||
>> -           data_len > fs_info->max_inline) {
>> +           inline_len > fs_info->max_inline) {
>>                 return 1;
>>         }
>>
>> --
>> 2.16.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--uYsZB0dcCxaSb3aTXu4w7nyBJvl8l3qOL--

--SHGEMVXJLwERvVvXHmQjCh8BaKh7fmLbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqZLWwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qisKQf/W5/pm1PY9vHs+dL8fph3gjqO
Ld+h2YCiHbsubKbAREgWFvZwEcApSaFMI8Bj5FVkGBJ9CfFPefzAfc6KhFVPwEmn
4aizuiWoUw8mWOLAnCxGMLNktJL+8vKEJ28tu5kJLokQXJnOFxR+ymDWE7lWdJa+
3AL+abp4nWU595uB3UZWPedurNq78aOypJhQnFaT52XTfVBTlO0nuT+tJxW+Uxnw
53UG92x0Ma9bTSpE0kwz9JOkCQcZghxT0K7A5n5wQvWwrGAVychXzQL4o7nplMew
Z9ZXcuNQlJdgBEveNYknI3GVDvIAq2XQmOlmsVrYBFZ+6KCqbYsFQ88wx9K5FQ==
=oNE/
-----END PGP SIGNATURE-----

--SHGEMVXJLwERvVvXHmQjCh8BaKh7fmLbq--
