Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753732AbeCVAJJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 20:09:09 -0400
Subject: Re: Crashes running btrfs scrub
To: Liu Bo <obuil.liubo@gmail.com>
Cc: Mike Stevens <michael.stevens@bayer.com>,
        "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
 <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
 <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
 <CANQeFDCR7skUgeY4esN5G4-y2Ry30fjFOyy7p8ayc6W1OtwxKw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <26da33fc-9a0c-5d73-a570-4f7ec84b69ff@gmx.com>
Date: Thu, 22 Mar 2018 08:08:52 +0800
MIME-Version: 1.0
In-Reply-To: <CANQeFDCR7skUgeY4esN5G4-y2Ry30fjFOyy7p8ayc6W1OtwxKw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xH7aafHVFxJd1Rnng1s8mDSCtTSmu6Y77"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xH7aafHVFxJd1Rnng1s8mDSCtTSmu6Y77
Content-Type: multipart/mixed; boundary="JkusjrNR13kkqU81gIkUOeK2MMgGvyK8u";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: Mike Stevens <michael.stevens@bayer.com>,
 "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
 "kreijack@inwind.it" <kreijack@inwind.it>, David Sterba <dsterba@suse.cz>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <26da33fc-9a0c-5d73-a570-4f7ec84b69ff@gmx.com>
Subject: Re: Crashes running btrfs scrub
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
 <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
 <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
 <CANQeFDCR7skUgeY4esN5G4-y2Ry30fjFOyy7p8ayc6W1OtwxKw@mail.gmail.com>
In-Reply-To: <CANQeFDCR7skUgeY4esN5G4-y2Ry30fjFOyy7p8ayc6W1OtwxKw@mail.gmail.com>

--JkusjrNR13kkqU81gIkUOeK2MMgGvyK8u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 01:13, Liu Bo wrote:
> On Tue, Mar 20, 2018 at 7:01 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 01:44, Mike Stevens wrote:
>>>
>>>>> 30 devices is really not that much, heck you get 90 disks top load =
JBOD
>>>>> storage chassis these days and BTRFS does sound like an attractive =
choice
>>>>> for things like that.
>>>
>>>> So Mike's case is, that both metadata and data are configured as
>>>> raid6, and the operations, balance and scrub, that he tried, need to=

>>>> set the existing block group as readonly (in order to avoid any
>>>> further changes being applied during operations are running), then w=
e
>>>> got into the place where another system chunk is needed.
>>>
>>>> However, I think it'd be better to have some warnings about this whe=
n
>>>> doing a) mkfs.btrfs -mraid6, b) btrfs device add.
>>>
>>>> David, any idea?
>>>
>>> I'll certainly vote for a warning, I would have set this up different=
ly had I been aware.
>>>
>>> My filesystem check seems to have returned successfully:
>>>
>>> [root@auswscs9903] ~ # btrfs check --readonly /dev/sdb
>>> Checking filesystem on /dev/sdb
>>> UUID: 77afc2bb-f7a8-4ce9-9047-c031f7571150
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> checking csums
>>> checking root refs
>>> found 97926270238720 bytes used err is 0
>>> total csum bytes: 95395030288
>>> total tree bytes: 201223503872
>>> total fs tree bytes: 84484636672
>>> total extent tree bytes: 7195869184
>>> btree space waste bytes: 29627784154
>>> file data blocks allocated: 97756261568512
>>>
>>> I've remounted the filesystem and I can at least touch a file.  I'm r=
estarting the rsync that was running when it originally went read only.
>>> What is the next step if it drops back to r/o?
>>
>> As already mentioned, if you're using tons of disks and RAID0/10/5/6 a=
s
>> metadata profile, you can just convert your metadata (or just system) =
to
>> RAID1/DUP.
>>
>> Then there will be more than enough space for system chunk array.
>>
>=20
> It's chicken & egg, balance seems to be the only way to switch raid
> profiles however users are stuck here because balance is aborted due
> to failing to allocate an extra system chunk.

Skip_balance to abort current balance and do the new convert.
Since convert will allocate new chunk in new profile, raid1 sys chunk
should be able to fit into superblock.

Thanks,
Qu

>=20
> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--JkusjrNR13kkqU81gIkUOeK2MMgGvyK8u--

--xH7aafHVFxJd1Rnng1s8mDSCtTSmu6Y77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqy9BQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjBDgf9GRAVQJG41wskUdIodfy/M7iD
kbItHTXvNlvmgQCbyJAjtbHv1y/ak3LouLdocWEYp8ps5dqbSIBUnPfJrGGsqMiB
h/mHghcmMHHlAzBDKZagm1Kcrixk5eDf6LvXkVPCh2o3gbP2J7jroQio22yYogmb
+HFqpzcrUATrt9ZDjkDqp5imCTUioNEdmE1a9BbY7GYxg85/DkgyQUxczxR/jEfu
jspHdtyfebIzn3W7i2EmtY5AQzO2rfJrEgkU3PiG0mdePqjqTGWjnKwdoG4Wy1p5
3ykj2Oimvex+PC1LYWQemLS1p8FDRt9qLTcGxDWxURqWFJvmGfzY5+Kb3yhs2w==
=MEPQ
-----END PGP SIGNATURE-----

--xH7aafHVFxJd1Rnng1s8mDSCtTSmu6Y77--
