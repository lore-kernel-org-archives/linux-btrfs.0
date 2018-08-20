Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46244 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbeHTRic (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 13:38:32 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEA75B003
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 14:22:39 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: extent-tree: refactor find_free_extent()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180725081242.8327-1-wqu@suse.com>
 <20180820141704.GZ24025@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <40c6e40c-1d36-528b-5030-3fc2f2f06690@suse.de>
Date: Mon, 20 Aug 2018 22:22:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180820141704.GZ24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m4x4Ut6ids6DtUsS3e2xCpesnfZAs6GIB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m4x4Ut6ids6DtUsS3e2xCpesnfZAs6GIB
Content-Type: multipart/mixed; boundary="FaW0QhKfcEsjjaq9Jg2sF07NbphZQQ467";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <40c6e40c-1d36-528b-5030-3fc2f2f06690@suse.de>
Subject: Re: [PATCH RFC] btrfs: extent-tree: refactor find_free_extent()
References: <20180725081242.8327-1-wqu@suse.com>
 <20180820141704.GZ24025@twin.jikos.cz>
In-Reply-To: <20180820141704.GZ24025@twin.jikos.cz>

--FaW0QhKfcEsjjaq9Jg2sF07NbphZQQ467
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/20 =E4=B8=8B=E5=8D=8810:17, David Sterba wrote:
> On Wed, Jul 25, 2018 at 04:12:42PM +0800, Qu Wenruo wrote:
>> extent-tree.c::find_free_extent() could be one of the most
>> ill-structured function, it has at least 4 non-exit tags and jumps
>> between them.
>>
>> To make it a little easier to understand, extract that big functions
>> into 4 parts:
>>
>> 1) find_free_extent()
>>    Do the block group iterations, still the main function.
>>
>> 2) find_free_extent_clustered()
>>    Do the clustered allocation and cluster refill if needed.
>>
>> 3) find_free_extent_unclustered()
>>    Do the unclustered allocation and free space cache update if needed=
=2E
>>
>> 4) find_free_extent_update_loop()
>>    Do the corner-case black magic handling, like allocating new chunk
>>    and update loop condition.
>>
>> Also, for internal communication, created a new internal structure
>> find_free_extent_ctrl, to make the parameter list shorter for function=

>> 2~4.
>>
>> Please note that this patch will try to avoid any functional/logical
>> modification during the refactor, so still a lot of bad practice like =
in
>> find_free_extent() we still use search/have_block_group/loop tags to
>> implement a custom loop.
>>
>> But at least, this should provide the basis for later cleanup.
>=20
> I'd prefer to do the cleanup in smaller pieces, this patch is too big
> for review.
>=20
>> ---
>> I know such large patch is not a good practice, and there is choice to=

>> split the patch into 4 patches (one patch for each helper function), b=
ut
>> that will make later rebase more error prone since new function will n=
ever
>> conflict with newer changes.
>=20
> Small patches can be refreshed and updated easily, also each refresh
> reviewed that the change is still correct.
>=20
> The big blob patches are the worst thing one can find in git history,
> hunting a clustered allocation bug and ending up in a cleanup patch. No=

> amount of written assurance or "it worked on my machine" can change
> that.

Well, if error really happens, it will still ends up in a cleanup patch.
As even with patch split into small ones, it will still be the final
patch to touch the real function.

>=20
> Finding the right way to split the patch and isolate nice and reviewabl=
e
> changes requires more thinking which is not a bad thing on itself.
>=20
> I know everybody hates that because it's more work for them, but
> consider the work on both sides
This makes sense, but it still doesn't solve the problem that changes in
new helper functions won't cause any conflict, thus rebasing or applying
older version patch could still leads to frustrating bugs.

I'll change to small patches, but I really hope to get some clue to
solve above problems.

Thanks,
Qu


--FaW0QhKfcEsjjaq9Jg2sF07NbphZQQ467--

--m4x4Ut6ids6DtUsS3e2xCpesnfZAs6GIB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt6zqgACgkQwj2R86El
/qjoHAf+JMp+v6aKkbt0TLsImuLfUy28heHKntkuP3e4fY13pe4M3A/yNTk2MSXL
jDh/Xc1Y1HjV1gwWaaAE5FSwkJSzHTPGwEileViYs4T8tnVz2m70sx9anf9+GVBT
ATuBFvawOcCpSY8RFYp/ee+eq4kOb9hmChCqIpuvSpbmTfLPPRXI2nwrzjGEqaUA
F3FfIY8VB+FKlWVAeuGcn4Vwe5euv3s64guOVnpWAV7nvVap4/OIafx01DnxODIs
1jNXh+kOYpafxl4LP3Z7Y0f4P0YbFAvVico8P3v5PhKM7EZ1ZUD1SiG56iOBR1Ul
p1udnLDsE/fh/a6uHOJjXI0xdB9Xag==
=W1/Q
-----END PGP SIGNATURE-----

--m4x4Ut6ids6DtUsS3e2xCpesnfZAs6GIB--
