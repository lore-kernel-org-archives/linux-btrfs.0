Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61536 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbdLKAYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 19:24:23 -0500
Subject: Re: exclusive subvolume space missing
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
 <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
Message-ID: <599e2f5d-8e78-9b59-879c-6ba375510508@gmx.com>
Date: Mon, 11 Dec 2017 08:24:16 +0800
MIME-Version: 1.0
In-Reply-To: <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2nJ5FD3Rit8AMrj65BQu2Gnt1QDpUUh1S"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2nJ5FD3Rit8AMrj65BQu2Gnt1QDpUUh1S
Content-Type: multipart/mixed; boundary="Htgvhglbe0V8XtFiTsdrNJgghETFBuPPs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
Message-ID: <599e2f5d-8e78-9b59-879c-6ba375510508@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
 <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
In-Reply-To: <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>

--Htgvhglbe0V8XtFiTsdrNJgghETFBuPPs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8811=E6=97=A5 07:44, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B412=E6=9C=8810=E6=97=A5 19:27, Tomasz Pala wrote:
>> On Mon, Dec 04, 2017 at 08:34:28 +0800, Qu Wenruo wrote:
>>
>>>> 1. is there any switch resulting in 'defrag only exclusive data'?
>>>
>>> IIRC, no.
>>
>> I have found a directory - pam_abl databases, which occupy 10 MB (yes,=

>> TEN MEGAbytes) and released ...8.7 GB (almost NINE GIGAbytes) after
>> defrag. After defragging files were not snapshotted again and I've los=
t
>> 3.6 GB again, so I got this fully reproducible.
>> There are 7 files, one of which is 99% of the space (10 MB). None of
>> them has nocow set, so they're riding all-btrfs.
>>
>> I could debug something before I'll clean this up, is there anything y=
ou
>> want to me to check/know about the files?
>=20
> fiemap result along with btrfs dump-tree -t2 result.
>=20
> Both output has nothing related to file name/dir name, but only some
> "meaningless" bytenr, so it should be completely OK to share them.
>=20
>>
>> The fragmentation impact is HUGE here, 1000-ratio is almost a DoS
>> condition which could be triggered by malicious user during a few hour=
s
>> or faster
>=20
> You won't want to hear this:
> The biggest ratio in theory is, 128M / 4K =3D 32768.
>=20
>> - I've lost 3.6 GB during the night with reasonably small
>> amount of writes, I guess it might be possible to trash entire
>> filesystem within 10 minutes if doing this on purpose.
>=20
> That's a little complex.
> To get into such situation, snapshot must be used and one must know
> which file extent is shared and how it's shared.
>=20
> But yes, it's possible.
>=20
> While on the other hand, XFS, which also supports reflink, handles it
> quite well, so I'm wondering if it's possible for btrfs to follow its
> behavior.
>=20
>>
>>>> 3. I guess there aren't, so how could I accomplish my target, i.e.
>>>>    reclaiming space that was lost due to fragmentation, without brea=
king
>>>>    spanshoted CoW where it would be not only pointless, but actually=
 harmful?
>>>
>>> What about using old kernel, like v4.13?
>>
>> Unfortunately (I guess you had 3.13 on mind), I need the new ones and
>> will be pushing towards 4.14.
>=20
> No, I really mean v4.13.

My fault, it is v3.13.

What a stupid error...

>=20
> From btrfs(5):
> ---
>                Warning
>                Defragmenting with Linux kernel versions < 3.9 or =E2=89=
=A5
> 3.14-rc2 as
>                well as with Linux stable kernel versions =E2=89=A5 3.10=
=2E31, =E2=89=A5
> 3.12.12
>                or =E2=89=A5 3.13.4 will break up the ref-links of CoW d=
ata (for
>                example files copied with cp --reflink, snapshots or
>                de-duplicated data). This may cause considerable increas=
e of
>                space usage depending on the broken up ref-links.
> ---
>=20
>>
>>>> 4. How can I prevent this from happening again? All the files, that =
are
>>>>    written constantly (stats collector here, PostgreSQL database and=

>>>>    logs on other machines), are marked with nocow (+C); maybe some n=
ew
>>>>    attribute to mark file as autodefrag? +t?
>>>
>>> Unfortunately, nocow only works if there is no other subvolume/inode
>>> referring to it.
>>
>> This shouldn't be my case anymore after defrag (=3D=3Dbreaking links).=

>> I guess no easy way to check refcounts of the blocks?
>=20
> No easy way unfortunately.
> It's either time consuming (used by qgroup) or complex (manually tree
> search and do the backref walk by yourself)
>=20
>>
>>> But in my understanding, btrfs is not suitable for such conflicting
>>> situation, where you want to have snapshots of frequent partial updat=
es.
>>>
>>> IIRC, btrfs is better for use case where either update is less freque=
nt,
>>> or update is replacing the whole file, not just part of it.
>>>
>>> So btrfs is good for root filesystem like /etc /usr (and /bin /lib wh=
ich
>>> is pointing to /usr/bin and /usr/lib) , but not for /var or /run.
>>
>> That is something coherent with my conclusions after 2 years on btrfs,=

>> however I didn't expect a single file to eat 1000 times more space tha=
n it
>> should...
>>
>>
>> I wonder how many other filesystems were trashed like this - I'm short=

>> of ~10 GB on other system, many other users might be affected by that
>> (telling the Internet stories about btrfs running out of space).
>=20
> Firstly, no other filesystem supports snapshot.
> So it's pretty hard to get a baseline.
>=20
> But as I mentioned, XFS supports reflink, which means file extent can b=
e
> shared between several inodes.
>=20
> From the message I got from XFS guys, they free any unused space of a
> file extent, so it should handle it quite well.
>=20
> But it's quite a hard work to achieve in btrfs, needs years development=

> at least.
>=20
>>
>> It is not a problem that I need to defrag a file, the problem is I don=
't know:
>> 1. whether I need to defrag,
>> 2. *what* should I defrag
>> nor have a tool that would defrag smart - only the exclusive data or, =
in
>> general, the block that are worth defragging if space released from
>> extents is greater than space lost on inter-snapshot duplication.
>>
>> I can't just defrag entire filesystem since it breaks links with snaps=
hots.
>> This change was a real deal-breaker here...
>=20
> IIRC it's better to add a option to make defrag snapshot-aware.
> (Don't break snapshot sharing but only to defrag exclusive data)
>=20
> Thanks,
> Qu
>=20
>>
>> Any way to fed the deduplication code with snapshots maybe? There are
>> directories and files in the same layout, this could be fast-tracked t=
o
>> check and deduplicate.
>>
>=20


--Htgvhglbe0V8XtFiTsdrNJgghETFBuPPs--

--2nJ5FD3Rit8AMrj65BQu2Gnt1QDpUUh1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlot0DAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qixtgf7BEBg+l3QUJKI0SUW6MjvkWel
midw9DYOfeXkcE6SJiTa+FpLvkFykT362c7WaF5HpbqkrA49LrexcSv7boEu/qZ+
YNnI4Fq8ejcoiXozmp5CCl9r2BS/8ScpcRS95B1lNUGe343nHQ8yWy/2bDMI31kr
KBhf3A99cKwYwJWNE9lEFZpPAc1P3O041H3m6sLTc8hnXaZBoW6lt84W2ERkrR39
RbwNN0QjmbSGk3thBST5GQEyscp/Ilm2AnrTBphDaz8hM/44CxbwObWs/xHny8/d
013fRd1cLbAZvEuTEG54yjQ2cIE8FDZ+cUEYDij8/Au0d9YmZk82XGf/IwkCkA==
=5AtY
-----END PGP SIGNATURE-----

--2nJ5FD3Rit8AMrj65BQu2Gnt1QDpUUh1S--
