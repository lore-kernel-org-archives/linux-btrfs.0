Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:33459 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbeAPEcq (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 15 Jan 2018 23:32:46 -0500
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
From: Qu Wenruo <wqu@suse.com>
To: David Sterba <dsterba@suse.cz>
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
 <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a0e1484e-9dca-f946-203b-d9e223ebb6b1@suse.com>
Date: Tue, 16 Jan 2018 12:32:28 +0800
MIME-Version: 1.0
In-Reply-To: <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lx1aWMwIrYtYyEwarQyAoLd7aZL96NwWC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lx1aWMwIrYtYyEwarQyAoLd7aZL96NwWC
Content-Type: multipart/mixed; boundary="XdpyASZmM87BU46gcLeg1y3UTUyVouOc1";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: David Sterba <dsterba@suse.cz>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a0e1484e-9dca-f946-203b-d9e223ebb6b1@suse.com>
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
 <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>
In-Reply-To: <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>

--XdpyASZmM87BU46gcLeg1y3UTUyVouOc1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Would you please queue this patch to devel branch?

This is a small enough, but quite important fix when handling dump tree
output.

Thanks,
Qu

On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 16:20, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 16:10, Misono, Tomohiro wrote:
>> In the print_inode_item(), the argument order of sequence and flags ar=
e
>> reversed:
>>
>> printf("... sequence %llu flags 0x%llx(%s)\n",
>> 				...=20
>> 	       (unsigned long long)btrfs_inode_flags(eb,ii),
>>  	       (unsigned long long)btrfs_inode_sequence(eb, ii),
>> 				...)
>>
>> So, just fix it.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>=20
> Thanks,
> Qu
>=20
>> ---
>>  print-tree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 3c585e3..8abd760 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -896,8 +896,8 @@ static void print_inode_item(struct extent_buffer =
*eb,
>>  	       btrfs_inode_uid(eb, ii),
>>  	       btrfs_inode_gid(eb, ii),
>>  	       (unsigned long long)btrfs_inode_rdev(eb,ii),
>> -	       (unsigned long long)btrfs_inode_flags(eb,ii),
>>  	       (unsigned long long)btrfs_inode_sequence(eb, ii),
>> +	       (unsigned long long)btrfs_inode_flags(eb,ii),
>>  	       flags_str);
>>  	print_timespec(eb, btrfs_inode_atime(ii), "\t\tatime ", "\n");
>>  	print_timespec(eb, btrfs_inode_ctime(ii), "\t\tctime ", "\n");
>>
>=20


--XdpyASZmM87BU46gcLeg1y3UTUyVouOc1--

--lx1aWMwIrYtYyEwarQyAoLd7aZL96NwWC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpdgFwNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qHVGB/9TuZ3Q1B1j7KDNNHTlvNTCwCPQJgnOgcIazJyX
7S8kOGesKgAWfB0CwmIvhyRfhnMchZ81qmcKhUi82cnw7GWhhfHo5jGkw+byf1YR
/J1NDCXc8XxCsAkUpVO/lEwvqAOCLku++nhCk11kpWig6TgKukTk0oOeGYLDeOHA
e7HiZZMw+5AMod8DzQxA6qTudbcBxDuLjXF6Ygf7cxWrk+AuydNzdQnTrYqbZSKW
3Ckv1aWPVPjjqEHCjviM9lJuVa3OzlFUeKs/8cozidAvgbuwdB89HGOwcWIfaied
zYkGkH8W+GdYF4jJ9c/KPbqljnyuZoy9G/QfqJ3E9hkIyv6a
=Zwmk
-----END PGP SIGNATURE-----

--lx1aWMwIrYtYyEwarQyAoLd7aZL96NwWC--
