Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752056AbeFEOPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 10:15:07 -0400
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
Date: Tue, 5 Jun 2018 22:14:51 +0800
MIME-Version: 1.0
In-Reply-To: <20180605140721.GB3539@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HrIpHTsBE9zZkxDmpGReRo8Ee2xuOp9MQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HrIpHTsBE9zZkxDmpGReRo8Ee2xuOp9MQ
Content-Type: multipart/mixed; boundary="QW9nQB3NqCdzYq2GuIcUNnc2lfOR5n9Fh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
In-Reply-To: <20180605140721.GB3539@twin.jikos.cz>

--QW9nQB3NqCdzYq2GuIcUNnc2lfOR5n9Fh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 22:07, David Sterba wrote:
> On Tue, Jun 05, 2018 at 09:47:46PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 21:42, David Sterba wrote:
>>> On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
>>>> Hi David,
>>>>
>>>> It would be pretty nice if we could get this fix (or previous RFC pa=
tch)
>>>> to get into current release cycle.
>>>>
>>>> As it's a unrecoverable data corruption, it would be better to get i=
t
>>>> fixed as soon as possible.
>>>
>>> That we can do, I'm planning to send 2nd pull by the end of the next
>>> week as there's at least one patch in the queue now.
>>>
>>> This patch seems to big, can you please prepare a minimal version?
>>
>> The previous version (a completely different direction though) is much=

>> smaller.
>> https://patchwork.kernel.org/patch/10440541/
>>
>> However personally speaking, I still prefer this one, as it's much sim=
pler.
>=20
> As this will go to older stable kernels, I'd rather split that to more
> patches where the first one is
>=20
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2799,7 +2799,7 @@ static int scrub_extent(struct scrub_ctx *sctx, s=
truct map_lookup *map,
>                         have_csum =3D scrub_find_csum(sctx, logical, cs=
um);
>                         if (have_csum =3D=3D 0)
>                                 ++sctx->stat.no_csum;
> -                       if (sctx->is_dev_replace && !have_csum) {
> +                       if (0 && sctx->is_dev_replace && !have_csum) {
>                                 ret =3D copy_nocow_pages(sctx, logical,=
 l,
>                                                        mirror_num,
>                                                       physical_for_dev_=
replace);
> ---
>=20
> and then the whole callchain of copy_nocow_pages continues.

Understood.
I could go this method.

However I'm a little concerned about such "if (0 &&" usage.

Although with gcc 8.1 it works without any warning, it still looks
pretty strange, as compiler could one day detect such dead branch and
find copy_nocow_pages() is never used.

Thanks,
Qu


--QW9nQB3NqCdzYq2GuIcUNnc2lfOR5n9Fh--

--HrIpHTsBE9zZkxDmpGReRo8Ee2xuOp9MQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWmtsACgkQwj2R86El
/qjvZAgAg5Vg2bva23/vS+2R9UuM8Tm67GR4mvn0tfDqo3TMynaZmeGpSt6g4pnv
ZBfH2+ZEzvnuZ85YJ2zLAuIIwUDiZoyO1SaEW4KtJgSeq+59ul1RZ/x48okibasa
+H9iLLq0C2+c4cHoH7oGiKdzSCjO3nG8u2Ojc4BMkvQniLvOrjFiRsbx2MibFCRc
YBA71KiXZP1OFqJe9ULFDRzjJybEkFdv0l9jtmiWyiGrbQ/u3g9aD0rkoKDlZZvN
2CTC03jszHHoIIapcefLHEsgt0Yt1MVMxGkzXoDhb8sxa9k13FqjXeA9oWkijukU
C6N/rBTfvqDL6BfP3n5v59c2IzFi3g==
=32sR
-----END PGP SIGNATURE-----

--HrIpHTsBE9zZkxDmpGReRo8Ee2xuOp9MQ--
