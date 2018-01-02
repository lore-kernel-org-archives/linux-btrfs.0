Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58830 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753401AbeABA5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jan 2018 19:57:55 -0500
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
To: waxhead@dirtcellar.net, swestrup@gmail.com, linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
 <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com>
 <717c7835-98c8-3c6d-5cc0-fa9ed1ae6200@dirtcellar.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <47441b74-fbf3-78b8-9276-40fdba10102b@gmx.com>
Date: Tue, 2 Jan 2018 08:57:43 +0800
MIME-Version: 1.0
In-Reply-To: <717c7835-98c8-3c6d-5cc0-fa9ed1ae6200@dirtcellar.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NiRDVExNl6NfceePb9i4QIa1Zjt6cyFW2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NiRDVExNl6NfceePb9i4QIa1Zjt6cyFW2
Content-Type: multipart/mixed; boundary="p4TZ6YnvzH6eiiXwWzA4a8hYLBk4FPYyw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: waxhead@dirtcellar.net, swestrup@gmail.com, linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <47441b74-fbf3-78b8-9276-40fdba10102b@gmx.com>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
 <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com>
 <717c7835-98c8-3c6d-5cc0-fa9ed1ae6200@dirtcellar.net>
In-Reply-To: <717c7835-98c8-3c6d-5cc0-fa9ed1ae6200@dirtcellar.net>

--p4TZ6YnvzH6eiiXwWzA4a8hYLBk4FPYyw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8802=E6=97=A5 06:50, waxhead wrote:
> Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8801=E6=97=A5 08:48, Stirling Westrup wrote:
>>> Okay, I want to start this post with a HUGE THANK YOU THANK YOU THANK=

>>> YOU to Nikolay Borisov and most especially to Qu Wenruo!
>>>
>>> Thanks to their tireless help in answering all my dumb questions I
>>> have managed to get my BTRFS working again! As I speak I have the
>>> full, non-degraded, quad of drives mounted and am updating my latest
>>> backup of their contents.
>>>
>>> I had a 4-drive setup with 2x4T and 2x2T drives and one of the 2T
>>> drives failed, and with help I was able to make a 100% recovery of th=
e
>>> lost data. I do have some observations on what I went through though.=

>>> Take this as constructive criticism, or as a point for discussing
>>> additions to the recovery tools:
>>>
>>> 1) I had a 2T drive die with exactly 3 hard-sector errors and those 3=

>>> errors exactly coincided with the 3 super-blocks on the drive.
>>
>> WTF, why all these corruption all happens at btrfs super blocks?!
>>
>> What a coincident.
>>
>>> The
>>> odds against this happening as random independent events is so
>>> unlikely as to be mind-boggling. (Something like odds of 1 in 10^26)
>>
>> Yep, that's also why I was thinking the corruption is much heavier tha=
n
>> our expectation.
>>
>> But if this turns out to be superblocks only, then as long as superblo=
ck
>> can be recovered, you're OK to go.
>>
>>> So, I'm going to guess this wasn't random chance. Its possible that
>>> something inside the drive's layers of firmware is to blame, but it
>>> seems more likely to me that there must be some BTRFS process that
>>> can, under some conditions, try to update all superblocks as quickly
>>> as possible.
>>
>> Btrfs only tries to update its superblock when committing transaction.=

>> And it's only done after all devices are flushed.
>>
>> AFAIK there is nothing strange.
>>
>>> I think it must be that a drive failure during this
>>> window managed to corrupt all three superblocks.
>>
>> Maybe, but at least the first (primary) superblock is written with FUA=

>> flag, unless you enabled libata FUA support (which is disabled by
>> default) AND your driver supports native FUA (not all HDD supports it,=
 I
>> only have a seagate 3.5 HDD supports it), FUA write will be converted =
to
>> write & flush, which should be quite safe.
>>
>> The only timing I can think of is, between the superblock write reques=
t
>> submit and the wait for them.
>>
>> But anyway, btrfs superblocks are the ONLY metadata not protected by
>> CoW, so it is possible something may go wrong at certain timming.
>>
>=20
> So from what I can piece together SSD mode is safer even for regular
> harddisks correct?
>=20
> According to this...
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format#Superblock
>=20
> - There is 3x superblocks for every device.

At most 3x. The 3rd one is for device larger than 256G.

> - The superblocks are updated every 30 seconds if there is any changes.=
=2E.

The interval can be specified by commit=3D mount option.
And 30 is the default.

> - SSD mode will not try to update all superblocks in one go, but update=

> one by one every 30 seconds.

If I didn't miss anything, from write_dev_supers() and
wait_dev_supers(), nothing checkes SSD mount option flag to do anything
different.

So, again if I didn't miss anything, superblock write is the same,
unless you're using nobarrier mount option.

Thanks,
Qu
>=20
> So if SSD mode is enabled even for harddisks then only 60 seconds of
> filesystem history / activity will potentially be lost... this sounds
> like a reasonable trade-off compared to having your entire filesystem
> hampered if your hardware is not perhaps optimal (which is sort of the
> point with BTRFS' checksumming anyway)
>=20
> So would it make sense to enable SSD behavior by default for HDD's ?!
>=20
>>> It may be better to
>>> perform an update-readback-compare on each superblock before moving
>>> onto the next, so as to avoid this particular failure in the future. =
I
>>> doubt this would slow things down much as the superblocks must be
>>> cached in memory anyway.
>>
>> That should be done by block layer, where things like dm-integrity cou=
ld
>> help.
>>
>>>
>>> 2) The recovery tools seem too dumb while thinking they are smarter
>>> than they are. There should be some way to tell the various tools to
>>> consider some subset of the drives in a system as worth considering.
>>
>> My fault, in fact there is a -F option for dump-super, to force it to
>> recognize the bad superblock and output whatever it has.
>>
>> In that case at least we could be able to see if it was really corrupt=
ed
>> or just some bitflip in magic numbers.
>>
>>> Not knowing that a superblock was a single 4096-byte sector, I had
>>> primed my recovery by copying a valid superblock from one drive to th=
e
>>> clone of my broken drive before starting the ddrescue of the failing
>>> drive. I had hoped that I could piece together a valid superblock fro=
m
>>> a good drive, and whatever I could recover from the failing one. In
>>> the end this turned out to be a useful strategy, but meanwhile I had
>>> two drives that both claimed to be drive 2 of 4, and no drive claimin=
g
>>> to be drive 1 of 4. The tools completely failed to deal with this cas=
e
>>> and were consistently preferring to read the bogus drive 2 instead of=

>>> the real drive 2, and it wasn't until I deliberately patched over the=

>>> magic in the cloned drive that I could use the various recovery tools=

>>> without bizarre and spurious errors. I understand how this was never
>>> an anticipated scenario for the recovery process, but if its happened=

>>> once, it could happen again. Just dealing with a failing drive and it=
s
>>> clone both available in one system could cause this.
>>
>> Well, most tools put more focus on not screwing things further, so it'=
s
>> common it's not as smart as user really want.
>>
>> At least, super-recover could take more advantage of using chunk tree =
to
>> regenerate the super if user really want.
>> (Although so far only one case, and that's your case, could take use o=
f
>> this possible new feature though)
>>
>>>
>>> 3) There don't appear to be any tools designed for dumping a full
>>> superblock in hex notation, or for patching a superblock in place.
>>> Seeing as I was forced to use a hex editor to do exactly that, and
>>> then go through hoops to generate a correct CSUM for the patched
>>> block, I would certainly have preferred there to be some sort of
>>> utility to do the patching for me.
>>
>> Mostly because we think current super-recovery is good enough, until
>> your case.
>>
>>>
>>> 4) Despite having lost all 3 superblocks on one drive in a 4-drive
>>> setup (RAID0 Data with RAID1 Metadata), it was possible to derive all=

>>> missing information needed to rebuild the lost superblock from the
>>> existing good drives. I don't know how often it can be done, or if it=

>>> was due to some peculiarity of the particular RAID configuration I wa=
s
>>> using, or what. But seeing as this IS possible at least under some
>>> circumstances, it would be useful to have some recovery tools that
>>> knew what those circumstances were, and could make use of them.
>>
>> In fact, you don't even need any special tool to do the recovery.
>>
>> The basic ro+degraded mount should allow you to recover 75% of your da=
ta.
>> And btrfs-recovery should do pretty much the same.
>>
>> The biggest advantage you have is, your faith and knowledge about only=

>> superblocks are corrupted in the device, which turns out to be a mirac=
le.
>> (While at the point I know your backup supers are also corrupted, I lo=
se
>> the faith)
>>
>> Thanks,
>> Qu
>>
>>>
>>> 5) Finally, I want to comment on the fact that each drive only stored=

>>> up to 3 superblocks. Knowing how important they are to system
>>> integrity, I would have been happy to have had 5 or 10 such blocks, o=
r
>>> had each drive keep one copy of each superblock for each other drive.=

>>> At 4K per superblock, this would seem a trivial amount to store even
>>> in a huge raid with 64 or 128 drives in it. Could there be some metho=
d
>>> introduced for keeping far more redundant metainformation around? I
>>> admit I'm unclear on what the optimal numbers of these things would
>>> be. Certainly if I hadn't lost all 3 superblocks at once, I might hav=
e
>>> thought that number adequate.
>>>
>>> Anyway, I hope no one takes these criticisms the wrong way. I'm a hug=
e
>>> fan of BTRFS and its potential, and I know its still early days for
>>> the code base, and it's yet to fully mature in its recovery and
>>> diagnostic tools. I'm just hoping that these points can contribute in=

>>> some small way and give back some of the help I got in fixing my
>>> system!
>>>
>>>
>>>
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--p4TZ6YnvzH6eiiXwWzA4a8hYLBk4FPYyw--

--NiRDVExNl6NfceePb9i4QIa1Zjt6cyFW2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpK2QcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgGjAf/VqtFOV/Ty5EMnGy4NO5QRmRT
itTQClY4uGfn6+jTw2hb3ioGadT3jeybAXnog78iih7/xo57K8Z+KdN+FP0CI0nW
l2/5SNycbaXajAiA31kEkgsiCmOHw1JFlwm9jn9CpBGWDGuJ+yfRj3GM1mr2P1Z4
+F5bs61RGwk3pOCKTcq9whcIsVUZOKBFjL7TsGjL1asr/+sAeKN7UcucWQ5HSQR5
J9jmpv7t/ntC66n3ZvZVLrHJo5maiVnBAOotH8XvUZPuGUBSxmHJe9+Xb6EHIT0S
tLoH+w4T+nK4jPpADma14mBlqzr8p9/NLa4176WnDz87y8hUEJqH/9ddc0+3oA==
=dXfj
-----END PGP SIGNATURE-----

--NiRDVExNl6NfceePb9i4QIa1Zjt6cyFW2--
