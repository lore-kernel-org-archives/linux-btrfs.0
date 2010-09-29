From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 20:36:45 +0200
Message-ID: <AANLkTinrPbxrqRCwnEc-xJBAs1Dz-Yt_UqeAhEqotzvs@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
	<i7vtdq$ctc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i7vtdq$ctc$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 29 September 2010 19:35, Lubos Kolouch <lubos.kolouch@gmail.com> wro=
te:
> Sebastian 'gonX' Jensen, Wed, 29 Sep 2010 12:48:56 +0200:
>
>> Hey guys,
>>
>> Today I experienced my first checksum error just out of the blue - a=
nd
>> it's not just the 'csum + 1 =3D private' issue, it's a completely
>> different one. Because of this, I am unable to retrieve the data off=
 the
>> drive, even with nodatasum enabled - I simply get an I/O error. Here=
's
>> the dmesg output:
>>
>> [149423.845177] btrfs: setting nodatasum [149423.850339] Btrfs detec=
ted
>> SSD devices, enabling SSD mode [149432.094728] btrfs csum failed ino=
 259
>> off 26701824 csum 3875867041 private 371726550
>> [149432.117938] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.118340] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.125671] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.126075] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>> [149432.135671] btrfs csum failed ino 259 off 26701824 csum 38758670=
41
>> private 371726550
>>
>> I would really like to have the files on the drive retrieved in thei=
r
>> entirety, but if that is not possible then that is also OK. Consider
>> this a bugreport and a question on how to retrieve the data now.
>>
>> Thanks,
>> Sebastian J.
>
> I have seen this now too, on a usb flash drive (yes, with LUKS on it)=
 that
> has been always correctly unmounted and luksClosed. In facts I create=
d
> the fs on it couple of days ago and now I cannot read one file with t=
he
> same error.
>
> I do not need to recover the file, it's just that you are not the onl=
y
> with this error.
>
> Lubos
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Good to hear I am not alone with this. It seemed more like a fluke
than an actual issue since I have no issues reading the drive in
2.6.32

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
