Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56635 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbeFIHKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Jun 2018 03:10:11 -0400
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
 <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
 <20180609003306.GJ3215@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dcbe7ff9-aa51-5e80-f242-396dbc3ddb05@gmx.com>
Date: Sat, 9 Jun 2018 15:09:52 +0800
MIME-Version: 1.0
In-Reply-To: <20180609003306.GJ3215@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bd1F9YjkdYoOvbmRt337zeUuv8QIaKHnF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bd1F9YjkdYoOvbmRt337zeUuv8QIaKHnF
Content-Type: multipart/mixed; boundary="BONhWzfRD12JrRroQsFV2kCsvc0JTT1xX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <dcbe7ff9-aa51-5e80-f242-396dbc3ddb05@gmx.com>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
 <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
 <20180609003306.GJ3215@twin.jikos.cz>
In-Reply-To: <20180609003306.GJ3215@twin.jikos.cz>

--BONhWzfRD12JrRroQsFV2kCsvc0JTT1xX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8809=E6=97=A5 08:33, David Sterba wrote:
> On Tue, Jun 05, 2018 at 10:14:51PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 22:07, David Sterba wrote:
>>> On Tue, Jun 05, 2018 at 09:47:46PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 21:42, David Sterba wrote:
>>>>> On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
>>>>>> Hi David,
>>>>>>
>>>>>> It would be pretty nice if we could get this fix (or previous RFC =
patch)
>>>>>> to get into current release cycle.
>>>>>>
>>>>>> As it's a unrecoverable data corruption, it would be better to get=
 it
>>>>>> fixed as soon as possible.
>>>>>
>>>>> That we can do, I'm planning to send 2nd pull by the end of the nex=
t
>>>>> week as there's at least one patch in the queue now.
>>>>>
>>>>> This patch seems to big, can you please prepare a minimal version?
>>>>
>>>> The previous version (a completely different direction though) is mu=
ch
>>>> smaller.
>>>> https://patchwork.kernel.org/patch/10440541/
>>>>
>>>> However personally speaking, I still prefer this one, as it's much s=
impler.
>>>
>>> As this will go to older stable kernels, I'd rather split that to mor=
e
>>> patches where the first one is
>>>
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -2799,7 +2799,7 @@ static int scrub_extent(struct scrub_ctx *sctx,=
 struct map_lookup *map,
>>>                         have_csum =3D scrub_find_csum(sctx, logical, =
csum);
>>>                         if (have_csum =3D=3D 0)
>>>                                 ++sctx->stat.no_csum;
>>> -                       if (sctx->is_dev_replace && !have_csum) {
>>> +                       if (0 && sctx->is_dev_replace && !have_csum) =
{
>>>                                 ret =3D copy_nocow_pages(sctx, logica=
l, l,
>>>                                                        mirror_num,
>>>                                                       physical_for_de=
v_replace);
>>> ---
>>>
>>> and then the whole callchain of copy_nocow_pages continues.
>>
>> Understood.
>> I could go this method.
>=20
> FYI, I'd need to send the 2nd pull request on Tuesday so I'm adding the=

> proposed fix with the current changelog to the queue now.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/commit/=
?h=3Dnext-fixes&id=3D8c83e0b1b20b094491bec6c52839aa3596a87f03

The note looks better than the final version I sent.
https://patchwork.kernel.org/patch/10449605/

Glad to see it merged.

Thanks,
Qu


--BONhWzfRD12JrRroQsFV2kCsvc0JTT1xX--

--bd1F9YjkdYoOvbmRt337zeUuv8QIaKHnF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsbfUAACgkQwj2R86El
/qhF4wf/RGQP86Gh4qXWMcy4vXM7CSwyXRPxfliGuwqdLOkG3A4UiflrkPumKT1Q
QhHDHgdbJtJdsGZ4oSIKC4gztMjdOYoMMh+iEzIOg+1o8XbbTtAVHFIUi1pKHfPY
BouAD6x8te1SzQXE8F9hnjK6ONZSmKEsIAQPa8EoQlw6UtKeZRAy8gKv1rSTr73/
nhBE4RMnSM4Ifa8X0IzVDbOkrFkmbmcnimjKMffd07VEfotBOf30m/w2iR3qkFKW
ex1rM/V8N0pD02pifN54Jq9qcJHLYzT9UXm6QnXSaUarl1z2ayG4cZS1BOeLdAij
8rYTeU3cDRUdtFr3T4tMVTk4CtJcAw==
=6Vm/
-----END PGP SIGNATURE-----

--bd1F9YjkdYoOvbmRt337zeUuv8QIaKHnF--
