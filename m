Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D22C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 774A1218A4
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbeLXMCa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 07:02:30 -0500
Received: from mout.gmx.net ([212.227.15.15]:45423 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXMC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 07:02:29 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LgqQQ-1h7lUE2N9y-00oJMP; Mon, 24
 Dec 2018 13:02:26 +0100
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Peter Chant <pete@petezilla.co.uk>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
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
Message-ID: <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
Date:   Mon, 24 Dec 2018 20:02:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cYNglGHHEor8HOMHXTgBuzpE03TpNY5x9"
X-Provags-ID: V03:K1:Ob4Zbd/VP+Pdkf/mANUl9vrvc4XCsxWtwXDTc7YOaG+AFsm3V3E
 p8Y8CwjbdmL77/f8xLpDFGxi0SvdV0rnwI7ivWfAo3lmDxJF8WXAGRbGPgCqwez0A1Ep1dG
 C04pgYu8R66kYkENfQMPQSvZ0FQcDcLVITdngcyF+vvJO/72K0QnEx8MqDZ9nCqTFxexEDz
 UmcesZAA2enDTLvVUtS2Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:609UaSA4etY=:1BMRGWD5LtJ7xeVXYy8LRQ
 yHgShLSFC/eY/ihPXOomKvLLM7Ck8jwhnFYHUjL4GxJz/aqSN8E3LNn3NewCyp4+thbX/MUdj
 pMm420tQE2Tn9uvGOF84os0x+AZdke0/S6ngmBwuF7g5keKEM2RIk0FiXudjWpQr6HIub1vzP
 6zqtLfGjH6e3Xbph8DeGxwJCA+Lv8x5NrYW5WZWruRIb8+FnZA8thrnfYy9Bp4O5ocLfUL4lX
 4Im7diDJzVIT3kBVAqNn/bmh5jbtckGvPbU5C4lcz9l8rAsS8JJ3TBG2WB+VKhM2juPlW10sq
 xiRmKPKDmjEGapOPPH1cACsD67xCWEfvI9Jbs8oAsW3ZqdK44Slxerckrv8Kb6ZVfu08oM7CP
 YVuCLuZIh6ipZQuDNuWRvLJJvgJmpAKTyL/y7l3sIsvur/n8Vl4M2bPEfXz4JJVZdMtndZ0vx
 MGEI8q8SYpTPGfZXL8ISnMN3Imxa97HXQUv7cgH+yT607q0XWCtb+czgvo0CDZ+618Lj4CFFf
 XfBtrMBn7JXVYYY2y1ch6wL8uzW6svgNnQoy7Vgop2THvQnspEc4ON+WY4EC53HK9o3Ant2bg
 qjxP300/EzPegO8W6R3+xknMaDBcWTLSpEzQFneIsO6MmWJDeAe2hqrrK1c6p4YS3sSclCvA7
 zkWIMIqca/txDJIhGEAFv7eu3hytFexpSkh5GzjEdZdGzkQogZqRTuCQMaROHR2RZwk2Ivg7q
 D9QYp5qs5t01oNPbwpoSsIDLzevB/2hKOkJP5OgbOwTxQ6IhJQuUvzDmZaeiKQ6+xS2UvPrY/
 3kcz6ySvUAM5AbeHZ8y83SJgtLTDuiprJ0w7AI/VJijeYKoU6OpBB6iEKKVqsvrVOJVzwgAVB
 JnaEyXCMIFFTjBXuwnzH7ToHyx4ljuRNb/xaPLE6v58LrRRgcXTRK6ll1yHySn
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cYNglGHHEor8HOMHXTgBuzpE03TpNY5x9
Content-Type: multipart/mixed; boundary="wFiuvNm5Q32BHGPVgi4ENTKwfgkRBfXa6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Peter Chant <pete@petezilla.co.uk>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
In-Reply-To: <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>

--wFiuvNm5Q32BHGPVgi4ENTKwfgkRBfXa6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/24 =E4=B8=8B=E5=8D=887:31, Peter Chant wrote:
> On 12/24/18 12:58 AM, Chris Murphy wrote:
>> On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk> wr=
ote:
>>
>>> btrfs rescue super -v /dev/sdb2
>> ...
>>> All supers are valid, no need to recover
>>>
>>>
>>> btrfs insp dump-s -f <dev>
>> ...
>>> generation              7937947
>> ...
>>>         backup 0:
>>>                 backup_tree_root:       1113909100544   gen: 7937935 =
   level: 1
>> ...
>>>         backup 1:
>>>                 backup_tree_root:       1113907347456   gen: 7937936 =
   level: 1
>> ...
>>>         backup 2:
>>>                 backup_tree_root:       1113911951360   gen: 7937937 =
   level: 1
>> ...
>>>         backup 3:
>>>                 backup_tree_root:       1113907494912   gen: 7937934 =
   level: 1
>> ...
>>
>>
>> The kernel wrote out three valid checksummed supers, with what seems
>> to be a rather significant sanity violation. The super generation and
>> tree root address do not match any of the backup tree roots. The
>> *current* tree root is supposed to be in one of the backups as well.
>>
>=20
> I wonder if this is a result of my trying to fix things?  E.g. btrfs
> rescue super-recover or my attempts using the tools (and kernel) in Min=
t
> 18.1 at one point?

At least super-recover is not responsible for this.
While btrfs check --repair could indeed cause problems.

So it may be the case.

>=20
> I must admit, early on I had assumed that either this file system was a=

> simple fix or was completely trashed, so I thought I'd have a quick go
> at fixing it, or wipe it and start again.  But then I seemed to get
> close with only the one error, but unmountable.
>=20
>=20
>> Qu, any idea how this is even theoretically possible? Bit flip right
>> before the super is computed and checksummed? Seems like some kind of
>> corruption before checksum is computed.
>>
>>
>>> I'm getting suspicious of the drive as when I was trying the various
>>> btrfs rescue * tools I saw a 'bad block', or similar, error displayed=
=2E
>>> I also have a separate basic install on ext4 on the same disk.  Thoug=
h
>>> e2fsck shows no errors and mounts fine I cannot log into that install=
=2E
>>> Maybe a coincidence, but too many bad things thrown up make me
>>> suspicious.  Whatever is happening this seems to be really fighting m=
e.
>>
>> I'm not sure how even a bad device accounts for the super generation
>> and backup mismatches. That's damn strange.
>=20
> I'm less suspicious of the drive now.  I've been using an ext4 partitio=
n
> on the same drive for a few days now, having reinstalled on that and
> everything _seems_ fine.  Mind you, apart from usb sticks, I've not
> experienced a ssd failure.  Perhaps my hdd failure experience is not
> relevent, i.e. they work until they start throwing errors and then
> rapidly fail?

I don't really believe a drive can be so easily corrupted to certain
bits while all other bits are OK.

>=20
>=20
>>
>> If you get bored with the back and forth and just want to give up,
>> that's fine. I suggest that if you have the time and space, to take a
>> btrfs-image in case Qu or some other developer wants to look at this
>> file system at some point. The btrfs-image is a read only process, can=

>> be set to scrub filenames, and only contains metadata. Size of the
>> resulting file is around 1/2 of the size of metadata, when doing
>> 'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need that=

>> much free space to direct the command to.
>>
>> btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile
>=20
> Just done that:
> bash-4.3# btrfs-image -ss -c9 -t4 /dev/sdd2
> /mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_20181224.img
> WARNING: cannot find a hash collision for '..', generating garbage, it
> won't match indexes
>=20
>=20
>=20
>>
>> It might fail, if so you can try adding -w and see if that helps.
>=20
>=20
> OK, try with -w:
>=20
> OK, many many complaints about hash collisions:
> ...
> ARNING: cannot find a hash collision for 'ifup', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'catv', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'FDPC', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'LIBS', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'INTC', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'SPI', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'PDCA', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'EBI', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'SMC', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'WIFI', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'LWIP', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'HID', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'yun', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'avr4', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'avr6', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'WiFi', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'TFT', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'Knob', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'FP.h', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'SD.h', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'Beep', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'FORK', generating garbage, i=
t
> won't match indexes
> WARNING: cannot find a hash collision for 'CHM', generating garbage, it=

> won't match indexes
> WARNING: cannot find a hash collision for 'HandS', generating garbage,
> it won't match indexes
> WARNING: cannot find a hash collision for 'dm-0', generating garbage, i=
t
> won't match indexes
>=20
>=20
> Now seems to stopped producing output.  Can't see if it is doing
> something useful.  (note, started again, more such messages)

I don't know about other developers, normally I don't like btrfs-image
-ss at all.

Even plain btrfs-image isn't so helpful, especially considering its size.=


Anyway, from all the data you collected, I suspect it's a corruption in
tree blocks allocation, maybe a btrfs bug in older kernels, which buried
a dangerous seed into the fs, breaking the metadata CoW.

And one day, an unexpected powerloss makes the seed grow and screw up
the fs.

Just a personal recommendation, for btrfs especially used with older
kernels, after a powerloss, it's highly recommended to run btrfs check
--readonly before mounting it.

Thanks,
Qu

>=20
>=20
>>
>> There is no log listed in the super so zero-log isn't indicated, and
>> also tells me there were no fsync's still flushing at the time of the
>> crash. The loss should be at most a minute of data, not an
>> inconsistent file system that can't be mounted anymore. Pretty weird.
>>
>=20
> I think I ran zero-log to see if that helped.  Given that there was no
> important data and I'd assume I'd either easily fix it, or wipe it and
> start over I may have taken the 'monkey radomly pounding the buttons'
> approach, short of 'btrfs check --repair'.  I only posted here as I
> though I'd fixed it apart from the one error!  If it were a simple fix
> then it was worth asking.
>=20
>=20
>> What were your mount options? Defaults? Anything custom like discard,
>> commit=3D, notreelog? Any non-default mount options themselves would n=
ot
>> be the cause of the problem, but might suggest partial ideas for what
>> might have happened.
>>
> fstab states:
> autodefrag,ssd,discard,noatime,defaults,subvol=3D_r_sl14.
> 2,compress=3Dlzo
>=20
> However, I used an initrd, so I'm not sure if that is correct?
>=20
> Ok, digging into init within my initrd, the line where the root partion=

> is mounted:
>   mount -o ro -t $ROOTFS $ROOTDEV /mnt
>=20
> Where $ROOTFS is:
> btrfs -o subvol=3D_r_sl14.2
>=20
> and $ROOTDEV is:
> /dev/disk/by-uuid/6496aabd-d6aa-49e0-96ca-e49c316edd8e
>=20
>=20
>=20
> Pete
>=20


--wFiuvNm5Q32BHGPVgi4ENTKwfgkRBfXa6--

--cYNglGHHEor8HOMHXTgBuzpE03TpNY5x9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwgyswACgkQwj2R86El
/qggmQf9FX+Zb97tPgmJfRTT/+HfNVjFT2uTD9aULQCaeNC3kR1nw0HhakV2GSJz
oAojmAnQYslJ7Q7D2kfJgDmoKhfQATCnr1xppuKnPlkk21R/cJQ3IYgatbZotmdD
+lI5AdvFT1IGsrGzHdba0qU8uMAg+26hxyDtbfT9PFbv0SiOVuo+3vDi5xMaGDON
YzRwhKXlutyDIO5p2aI3Rv8NJsT+Ep0qBbBfK0bNGa1sSCigFAvtSj3rAJ4SsWFR
0qNeVPeOn+kQSenTPCOGpd5g8BBBR14N11rcvbG1UGc5yY+4mGjemGUi53I8oNvy
XjKOl/kjm9lNO2VxNwdIX9fi//l54Q==
=UZJv
-----END PGP SIGNATURE-----

--cYNglGHHEor8HOMHXTgBuzpE03TpNY5x9--
