Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754882AbeCVNyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:54:00 -0400
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
Date: Thu, 22 Mar 2018 21:53:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180322134058.GA6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DEADSxzjwLpaoQOA049Q799jrptGR2M90"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DEADSxzjwLpaoQOA049Q799jrptGR2M90
Content-Type: multipart/mixed; boundary="kSfSeamyenk4LqbvYUe9r3opSH9STDpzi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
In-Reply-To: <20180322134058.GA6955@twin.jikos.cz>

--kSfSeamyenk4LqbvYUe9r3opSH9STDpzi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 21:40, David Sterba wrote:
> On Mon, Mar 19, 2018 at 05:18:41PM +0800, Qu Wenruo wrote:
>> We have several reports about node pointer points to incorrect child
>> tree blocks, which could have even wrong owner and level but still wit=
h
>> valid generation and checksum.
>>
>> Although btrfs check could handle it and print error message like:
>> leaf parent key incorrect 60670574592
>>
>> Kernel doesn't have enough check on this type of corruption correctly.=

>> At least add such check to read_tree_block() and btrfs_read_buffer(),
>> where we need two new parameters @first_key and @level to verify the
>> child tree block.
>>
>> For case where we don't have parent node to get @first_key and @level,=

>> just pass @first_key as NULL and kernel will skip such check.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/backref.c     |  6 +++--
>>  fs/btrfs/ctree.c       | 25 +++++++++++++-----
>>  fs/btrfs/disk-io.c     | 69 ++++++++++++++++++++++++++++++++++++++++-=
---------
>>  fs/btrfs/disk-io.h     |  8 +++---
>>  fs/btrfs/extent-tree.c |  6 ++++-
>>  fs/btrfs/print-tree.c  | 10 +++++---
>>  fs/btrfs/qgroup.c      |  7 +++--
>>  fs/btrfs/relocation.c  | 21 ++++++++++++---
>>  fs/btrfs/tree-log.c    | 12 ++++++---
>>  9 files changed, 126 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 26484648d090..3866b8ab20f1 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *=
fs_info,
>>  		BUG_ON(ref->key_for_search.type);
>>  		BUG_ON(!ref->wanted_disk_byte);
>> =20
>> -		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0);
>> +		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
>> +				     0);
>=20
> Please add 2nd function that will take the extended parameters and
> keep read_tree_block as is.

So for any new caller of read_tree_block(), reviewer is the last person
to info the author to use these parameters for safety check?

And in fact, the old function should be avoid if possible, I think the
new parameters act as a pretty good sign to make any caller double think
about this.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--kSfSeamyenk4LqbvYUe9r3opSH9STDpzi--

--DEADSxzjwLpaoQOA049Q799jrptGR2M90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqztWsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg9pAf/bVlltMa6pjfcW5sZaw2BHeeC
SSXD4sPrv/sN8TG20fBq4pWcZYKgaLSUHoQ1jul4OHbbUkUnVWHe10gzFMNqypOp
anRPeWWrDe/i9CDQJvXHLddgQxBu4KFamP4J58f0BbBSnsSBQuW42DHvxpo3PqzI
MDq+ofUfTY3vDtekXTvRtTU8hkOD9P2SqRGuBOQkv6PnojfQcjD/i0/t9qbEMc9K
b3ule+18LNKNOUOj3m41e4a58RbdPZu2xTRNQJmIc7SEd2dTh5+ZoeXogeK8UmCS
oIkaoTAfvnNsQSsPB2TABau1MzadPEptRlKfk6g+0BMGxob7BDfl8vN28mmvTA==
=zGi5
-----END PGP SIGNATURE-----

--DEADSxzjwLpaoQOA049Q799jrptGR2M90--
