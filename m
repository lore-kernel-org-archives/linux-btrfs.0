Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96929C282CA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 06:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595832184A
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 06:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfBLGvS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:51:18 -0500
Received: from mout.gmx.net ([212.227.15.18]:50077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbfBLGvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 01:51:17 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Ld0jY-1hJwyM2Lp2-00i9Gg; Tue, 12
 Feb 2019 07:51:11 +0100
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
To:     Steve Leung <sjleung@shaw.ca>
Cc:     linux-btrfs@vger.kernel.org
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
 <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
 <902519958.253211268.1549952537314.JavaMail.zimbra@shaw.ca>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <a399c4ab-7eef-a763-e91a-cb009a72090c@gmx.com>
Date:   Tue, 12 Feb 2019 14:51:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <902519958.253211268.1549952537314.JavaMail.zimbra@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VWJPfs4FYusV8cHH63voGkcJ5Qn5B3iJr"
X-Provags-ID: V03:K1:ujRfZ/MAlMcWz5fkW5T05e+cV/miyJzEwNonENYdB9nGo0PljfS
 jouFxNszVQZ+qHOTmg67z8jjx8bJ4ZW7xGt6/AVNo08sfCNj4HmkohC/k8l948sUoxV1LUs
 effkRFfjJElrt40EOyfqMxaAyP0L+rUveXA+9ICngfJwEIBSMiJ+Vre75tbQLA38qywzJOm
 fy7JKyG6P3jIeTbHcJV/A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rrOoINRn5pk=:QkIwrFlOMM1HYz+DvO1ePp
 z/ZaMzMwVcmUNQT1+36OXtV8ZiC7jCzZ+K2z9o/LyCuNMGEngGdTT/pfXzOaEky08+rFpZ8sw
 LCKVocl0gsj05VNLnAg5yM/LI3U+f7eWFHXFJzBb7021avnA3m3TMkVjh7YeaBKisu8mFNAgF
 Csf5LksYxSJ3kLvP5FEsHVhm8lIF+LtiKPmCdJ/dsTm26C0+IzFnDYaZQOTUloSKa8WdVmNS3
 Bh7An01y81qEIwUeZg3/p7ipRvCeggdZRbWYclggV0pVSUlytmlYftnRGyX7WTTopscunJmyj
 /ag2APRsRVyAqMxKZE7z6PMrhgUmSvYgHs3LEwvLACVg5Pc2J8CRUzCGRvya8SQf5BSM3R3RO
 9EXiuYmVxkkrGWCWiX3Y5XhhUiHBqdIxQwDdrhahkJdXuN7nRzejxhDSvMzm0h23PAugVklRT
 7fb7fwoURsSWNIZu0fQtiXceG88N6KhtWyK+fLFEUBbyAJIR5XbMi7sl2641P1nljfxb3vWG1
 0WrtaMsK3OTs1ZSl/g9kDQ9eEjm5oGUe0RWqYkrJYetl3LUpucrXXvB5D3x0yld7qgx9asP0M
 HOKdRGOwM5Xv+Aoli9l5grIRP2ln+3tN3fwquaxV71ENijUWtY8XsXdvJMcDPotOnVuK6UzdH
 vEj+plI0ki/9Xy10H4AfRU0KyT7hwOR1U9bYt1xKBxWedOoF7BItP+k23fRDo7Nhb2bRrjYri
 yNYM52lkIWH3uEf4yFK9d0/tuDyosP8AdhfnXs7mwdkBPhweTaPMJ/T1G5Zm+PGoM7GobVr/G
 w/VxPF53KOZVDQrhvGEqST4jM9K9nWAkx0KEF+tP82gyssxWjRoqzbS3oZ83NfPjwkJp52iK0
 UVYtq3VJZzXh3iSpHboBU+McMtbf9P6sf6S3qY3tcHsXSOQkGRsoAUYNDWsT4Z
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VWJPfs4FYusV8cHH63voGkcJ5Qn5B3iJr
Content-Type: multipart/mixed; boundary="VCPkFKFR8c6u0kDxMnu8hbFBJGrPsYooS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <a399c4ab-7eef-a763-e91a-cb009a72090c@gmx.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
 <e8219111-4e0d-65f4-ac06-627cebaac94a@gmx.com>
 <902519958.253211268.1549952537314.JavaMail.zimbra@shaw.ca>
In-Reply-To: <902519958.253211268.1549952537314.JavaMail.zimbra@shaw.ca>

--VCPkFKFR8c6u0kDxMnu8hbFBJGrPsYooS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/12 =E4=B8=8B=E5=8D=882:22, Steve Leung wrote:
>=20
>=20
> ----- Original Message -----
>> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
>> To: "STEVE LEUNG" <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
>> Sent: Sunday, February 10, 2019 6:52:23 AM
>> Subject: Re: corruption with multi-device btrfs + single bcache, won't=
 mount
>=20
>> ----- Original Message -----
>> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
>> On 2019/2/10 =E4=B8=8B=E5=8D=882:56, STEVE LEUNG wrote:
>>> Hi all,
>>>
>>> I decided to try something a bit crazy, and try multi-device raid1 bt=
rfs on
>>> top of dm-crypt and bcache.  That is:
>>>
>>>   btrfs -> dm-crypt -> bcache -> physical disks
>>>
>>> I have a single cache device in front of 4 disks.  Maybe this wasn't
>>> that good of an idea, because the filesystem went read-only a few
>>> days after setting it up, and now it won't mount.  I'd been running
>>> btrfs on top of 4 dm-crypt-ed disks for some time without any
>>> problems, and only added bcache (taking one device out at a time,
>>> converting it over, adding it back) recently.
>>>
>>> This was on Arch Linux x86-64, kernel 4.20.1.
>>>
>>> dmesg from a mount attempt (using -o usebackuproot,nospace_cache,clea=
r_cache):
>>>
>>>   [  267.355024] BTRFS info (device dm-5): trying to use backup root =
at mount time
>>>   [  267.355027] BTRFS info (device dm-5): force clearing of disk cac=
he
>>>   [  267.355030] BTRFS info (device dm-5): disabling disk space cachi=
ng
>>>   [  267.355032] BTRFS info (device dm-5): has skinny extents
>>>   [  271.446808] BTRFS error (device dm-5): parent transid verify fai=
led on
>>>   13069706166272 wanted 4196588 found 4196585
>>>   [  271.447485] BTRFS error (device dm-5): parent transid verify fai=
led on
>>>   13069706166272 wanted 4196588 found 4196585
>>
>> When this happens, there is no good way to completely recover (btrfs
>> check pass after the recovery) the fs.
>>
>> We should enhance btrfs-progs to handle it, but it will take some time=
=2E
>>
>>>   [  271.447491] BTRFS error (device dm-5): failed to read block grou=
ps: -5
>>>   [  271.455868] BTRFS error (device dm-5): open_ctree failed
>>>
>>> btrfs check:
>>>
>>>   parent transid verify failed on 13069706166272 wanted 4196588 found=
 4196585
>>>   parent transid verify failed on 13069706166272 wanted 4196588 found=
 4196585
>>>   parent transid verify failed on 13069706166272 wanted 4196588 found=
 4196585
>>>   parent transid verify failed on 13069706166272 wanted 4196588 found=
 4196585
>>>   Ignoring transid failure
>>>   ERROR: child eb corrupted: parent bytenr=3D13069708722176 item=3D7 =
parent level=3D2
>>>   child level=3D0
>>>   ERROR: cannot open file system
>>>
>>> Any simple fix for the filesystem?  It'd be nice to recover the data
>>> that's hopefully still intact.  I have some backups that I can dust
>>> off if it really comes down to it, but it's more convenient to
>>> recover the data in-place.
>>
>> However there is a patch to address this kinda "common" corruption sce=
nario.
>>
>> https://lwn.net/Articles/777265/
>>
>> In that patchset, there is a new rescue=3Dbg_skip mount option (needs =
to
>> be used with ro), which should allow you to access whatever you still
>> have from the fs.
>>
>> From other reporters, such corruption is mainly related to extent tree=
,
>> thus data damage should be pretty small.
>=20
> Ok I think I spoke too soon.  Some files are recoverable, but many
> cannot be read.  Userspace gets back an I/O error, and the kernel log
> reports similar parent transid verify failed errors, with what seem
> to be similar generation numbers to what I saw in my original mount
> error.
>=20
> i.e. wants 4196588, found something that's off by usually 2 or 3.
> Occasionally there's one that's off by about 1300.

That's more or less expected for such transid corruption.
The fs is already screwed up.

The lowest generation you found during all these error message could be
when the first corruption happens.
(And it may date back to very old days)

>=20
> There are multiple snapshots on this filesystem (going back a few
> days), and the same file in each snapshot seems to be equally
> affected, even if the file hasn't changed in many months.>
> Metadata seems to be intact - I can stat every file in one of the
> snapshots and I don't get any errors back.
>=20
> Any other ideas?  It kind of seems like "btrfs restore" would be
> suitable here, but it sounds like it would need to be taught about
> rescue=3Dbg_skip first.

Since v4.16.1, btrfs-restore should be OK to ignore extent tree
completely, thus you can try btrfs-restore.

Btrfs-restore may be a little better, since it can ignore csum errors
completely.

Thanks,
Qu

>=20
> Thanks for all the help.  Even a partial recovery is a lot better
> than what I was facing before.
>=20
> Steve
>=20


--VCPkFKFR8c6u0kDxMnu8hbFBJGrPsYooS--

--VWJPfs4FYusV8cHH63voGkcJ5Qn5B3iJr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxibNoACgkQwj2R86El
/qiFygf9GfmRbY+KqF5V5UTq0PR/Bi/UMUH/biMkANvAYE08st4jZ223zzsp6SkP
KJ7Umv2V7KDCcGDILh3+kS1Vhaho2thdFf8WMDGFSgzga3w1O9wsf0L8LcnctyqY
EO74EFauiWLiiyzIUiCSrpb5NsywVXiwLCDf4+Rb2P2oQ5ft6LK7+oRoB2JgHs27
1egj9aXfREmrQ3Ppnw8BM0SRyDYq3VSye/makXDE9NUXT5jW1kSDDVOe+p/xd5fi
GEygWY1KWjn222iO1Xm5qxXzIQNrdIIf8+A4YkVwKaBxGabuw2SDnlQu3NLz8XY6
n7ppDR46lFfZ7pw0cWfEpIxvffYX8A==
=WrVa
-----END PGP SIGNATURE-----

--VWJPfs4FYusV8cHH63voGkcJ5Qn5B3iJr--
