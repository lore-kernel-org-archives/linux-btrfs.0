Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50497 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdKHATe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 19:19:34 -0500
Subject: Re: [PATCH 2/2] btrfs: Cleanup existing name_len checks
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171101122213.7122-1-wqu@suse.com>
 <20171101122213.7122-2-wqu@suse.com> <20171107205604.GF27557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bb13d1c2-53fa-f9ee-800d-315a2fa7a43d@gmx.com>
Date: Wed, 8 Nov 2017 08:19:19 +0800
MIME-Version: 1.0
In-Reply-To: <20171107205604.GF27557@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="duvNMxgjbI3tlaiRqQHqEMDJ87iPFdXdF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--duvNMxgjbI3tlaiRqQHqEMDJ87iPFdXdF
Content-Type: multipart/mixed; boundary="bm3fADVQU2VpklJ5pF8LSOjKDOsLCHr7E";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <bb13d1c2-53fa-f9ee-800d-315a2fa7a43d@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: Cleanup existing name_len checks
References: <20171101122213.7122-1-wqu@suse.com>
 <20171101122213.7122-2-wqu@suse.com> <20171107205604.GF27557@twin.jikos.cz>
In-Reply-To: <20171107205604.GF27557@twin.jikos.cz>

--bm3fADVQU2VpklJ5pF8LSOjKDOsLCHr7E
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8808=E6=97=A5 04:56, David Sterba wrote:
> On Wed, Nov 01, 2017 at 08:22:13PM +0800, Qu Wenruo wrote:
>> Since tree-checker has verified leaf when reading from disk, we don't
>> need the existing checker.
>>
>> This cleanup reverts the following commits:
>> fbc326159a01 ("btrfs: Verify dir_item in iterate_object_props")
>> 64c7b01446f4 ("btrfs: Check name_len before in btrfs_del_root_ref")
>> 488d7c456653 ("btrfs: Check name_len before reading btrfs_get_name")
>> 59b0a7f2c7c1 ("btrfs: Check name_len before read in iterate_dir_item")=

>> 3c1d41844896 ("btrfs: Check name_len in btrfs_check_ref_name_override"=
)
>> 8ee8c2d62d5f ("btrfs: Verify dir_item in replay_xattr_deletes")
>> 26a836cec2ea ("btrfs: Check name_len on add_inode_ref call path")
>> e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item"=
)
>> 19c6dcbfa746 ("btrfs: Introduce btrfs_is_name_len_valid to avoid readi=
ng beyond boundary")
>=20
> Oh well, there it goes, but I like the centralized tree checker more,
> so this is a small cost.
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>

Sorry, in v2 patch this patch is also affected.

Since in v2, even verify_dir_item() also get removed, so it's no longer
a big revert patch.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--bm3fADVQU2VpklJ5pF8LSOjKDOsLCHr7E--

--duvNMxgjbI3tlaiRqQHqEMDJ87iPFdXdF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloCTYcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhoQAf+Pi3LZcSXalMb+3kmuYNNjO+b
fWdy+5vbNkKdiG/yoMOqwSJWutshL+GRa3BVJSNM++y+1+g157Rf+YoW5BZqIo1L
oyHuxDns2aBlFd6xhBnouc0HIOWscSXiJvS3x+XuH3cnOJg7tghCZV5wrGSFQYow
+TzdGzIPd/WnaadBiVnIah7xLkcO55FNdR456eot89J7hYo4xqqTuVmkApq0y1ol
wkxvt4LsS15ptczF4XvtWjdpPF9WnUpY25leJTP3pObQUPELhsLoJ/ytyBv7bklP
nuXOV6KTS+T/rgCbLK0LxkEpb8IQuJfytwYyEYd7jZA/+6gxFmbNKKi6kWK9Fg==
=tviU
-----END PGP SIGNATURE-----

--duvNMxgjbI3tlaiRqQHqEMDJ87iPFdXdF--
