Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55401 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbeCUHpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 03:45:52 -0400
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
 <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
 <7c18da97-bd2f-792a-dc1f-a151a9de008e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ddabfb3c-2974-b08b-0309-ddd93f9966ca@gmx.com>
Date: Wed, 21 Mar 2018 15:45:35 +0800
MIME-Version: 1.0
In-Reply-To: <7c18da97-bd2f-792a-dc1f-a151a9de008e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RmpOn7rnAQJKXlOwa4HMKEnVAGYML2KSy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RmpOn7rnAQJKXlOwa4HMKEnVAGYML2KSy
Content-Type: multipart/mixed; boundary="5seTSpNFCgGG3hkTqUhV88WMvgh19584O";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ddabfb3c-2974-b08b-0309-ddd93f9966ca@gmx.com>
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
 <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
 <7c18da97-bd2f-792a-dc1f-a151a9de008e@suse.com>
In-Reply-To: <7c18da97-bd2f-792a-dc1f-a151a9de008e@suse.com>

--5seTSpNFCgGG3hkTqUhV88WMvgh19584O
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 15:38, Nikolay Borisov wrote:
>=20
>=20
> On 21.03.2018 09:16, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 15:03, Nikolay Borisov wrote:
>>> This function was removed in 24bc2843edd5 ("btrfs:
>>> Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
>>> remains is a defunct declaration. Remove it.
>>
>> Nice find, thanks for get this.
>>
>>
>> But strangely, I just fetched David's repo, but didn't find that commi=
t
>> hash anywhere.
>>
>> I'm fetching from git.kernel.org repo, or is that repo only updated wh=
en
>> pushing to Linus?
>=20
> It's update only when david pushes and preps the pull reqs. I base all
> my development on his misc-next branch on github.

No wonder.

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>> David,=20
>>>
>>> This is a fixlet to the aforementioned patch which is only in your mi=
sc-next,=20
>>> I'd suggest just squash this fixlet into the original one.=20
>>>
>>>  fs/btrfs/ctree.h | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index fbe51edb9cac..03be51d77357 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -2801,7 +2801,6 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info=
, struct fstrim_range *range);
>>>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
>>>  int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *=
trans,
>>>  					 struct btrfs_fs_info *fs_info);
>>> -int __get_raid_index(u64 flags);
>>>  int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
>>>  void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
>>>  void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--5seTSpNFCgGG3hkTqUhV88WMvgh19584O--

--RmpOn7rnAQJKXlOwa4HMKEnVAGYML2KSy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqyDZ8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjNDAf+I+i0mVh0zD02VCgcnblKM/Ev
KNugmwUQerI1h7BBCtYMUZRbVFWoVK0onhAc1n2tBINlrPH76KhRO9jchS/luUwy
xfYucXNktyOcNrz3o9SZ5X8NEezwIX0zQoLjf9cLjGsBA32tovWNUc7J3Lsbz74K
QKxbmDxXac7reBk9O5Um7cW2kqvwhXDbBaZiMjPNQaA8dyVO8wZm10K9fAQ3rwz9
9V/i4GMspbIRjM+SabkFp20I/d6GdZOEiL1JwvVaaT4JCXNzqDmqtRBjJhNAcSXT
DQkIXb+EU/CFaQHO/4as+gyH30oYm8xOA6h722Ty8jFqvH5nwqtfbPyqIeSQyA==
=VS+9
-----END PGP SIGNATURE-----

--RmpOn7rnAQJKXlOwa4HMKEnVAGYML2KSy--
