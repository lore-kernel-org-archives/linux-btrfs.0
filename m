From: "Yo'av Moshe" <bjesus@gmail.com>
Subject: Re: Recovering "parent transid verify failed"
Date: Sun, 25 Mar 2012 12:34:39 +0000
Message-ID: <CAPAyKoz-vstqzaknHnHUQ65PFprzdL+fNdDhxRcF1wHaMaFYOw@mail.gmail.com>
References: <AANLkTik2t4bG_vwveO=5dovOE=6gDH5FKzjANs7cgRWY@mail.gmail.com>
 <AANLkTik8z13+5pKThfCSsTeM_08VDCQiKvHD2GEQLqGb@mail.gmail.com>
 <20110306110257.GF4084@carfax.org.uk> <CAPAyKozRoUaf4OgpdCuc0hNm2fMnON61Z95m1r_QMuHASESyVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPAyKozRoUaf4OgpdCuc0hNm2fMnON61Z95m1r_QMuHASESyVg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Anything new? I'm still trying to fix my FS every once in a while,
none of the tools helps.


 This is what find-root gives:=C2=A0http://pastebin.com/KycgzhaP

 Btrfsck still only gives this:
 # sudo ./btrfsck --repair /dev/sda4
 enabling repair mode
 parent transid verify failed on 216925220864 wanted 135714 found 13571=
3
 parent transid verify failed on 216925220864 wanted 135714 found 13571=
3
 parent transid verify failed on 216925220864 wanted 135714 found 13571=
3
 parent transid verify failed on 216925220864 wanted 135714 found 13571=
3
 Ignoring transid failure
 btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] =3D=3D 0)' failed.

 Anymore details I can give you which will help resolving this? Thanks.

 Yo'av

> =D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A 6 =D7=91=D7=9E=D7=A8=D7=A5 2011 =
11:02, =D7=9E=D7=90=D7=AA Hugo Mills <hugo-lkml@carfax.org.uk>:
>>
>> On Sun, Mar 06, 2011 at 12:28:41PM +0200, Yo'av Moshe wrote:
>> > Hey,
>> > I'd start by saying that I know Btrfs is a still experimental, and=
 so
>> > there's no guarantee that one would be able to help me at all... B=
ut I
>> > thought I'll try anyway :-)
>> >
>> > Few months ago I bought a new laptop and installed ArchLinux on it=
,
>> > with Btrfs on the root filesystem... I know, it's not the smartest
>> > thing to do...
>> > After a few month I had issues with my hibernations scripts, and o=
ne
>> > day I tried to hibernate my computer but it didn't go that well, a=
nd,
>> > well, ever since then my Btrfs partition is not accessible.
>> > I opened up the Btrfs FAQ and saw that the fsck tool should be out=
 by
>> > the end of 2010, and thought "oh well, I could wait until then", a=
nd
>> > went on and installed Ubuntu with Ext4 on another small partition.
>> >
>> > But times goes one and the fsck tool is still in development... I'=
ve
>> > tried using the code from GIT and it didn't work, and I'm starting=
 to
>> > wonder (a) if there's any hope at all and (b) what other step am I
>> > able to do to recover my old Btrfs partition.
>>
>> =C2=A0 Yes, there is hope. This error should be fixable with the new=
 fsck.
>>
>> > When trying to mount the Btrfs parition I get this in dmesg:
>> > [105252.779080] device fsid d14e78a602757297-bf762d859b406ca9 devi=
d 1
>> > transid 135714 /dev/sda4
>> > [105252.818697] parent transid verify failed on 216925220864 wante=
d
>> > 135714 found 135713
>> [snip]
>> > Should I wait for btrfsck to be ready?
>>
>> =C2=A0 Yes.
>>
>> > Am I not using it correctly now?
>>
>> =C2=A0 No, there's not a lot the current version can do right now.
>>
>> > Is there anyway to recover this partition or should I just wipe it=
 and
>> > reinstall Btrfs only when I'm supposed to?..
>> >
>> > Your help is appreciated.
>>
>> =C2=A0 HTH,
>> =C2=A0 Hugo.
>>
>> --
>> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug=
=2Eorg.uk =3D=3D=3D
>> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax=
=2Eorg.uk
>> =C2=A0 =C2=A0 --- "I am the author. You are the audience. I outrank =
you!" ---
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.10 (GNU/Linux)
>>
>> iD8DBQFNc2nhIKyzvlFcI40RAsq2AKCrSZE6nXYIRbxfLThwIH/yEeO/iACggwHZ
>> vXj/K5R746xiMj8x6Ehdzbs=3D
>> =3Dzinf
>> -----END PGP SIGNATURE-----
>>
>
>
>
> --
> Yo'av Moshe



--
Yo'av Moshe
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
