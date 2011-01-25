From: Magicloud Magiclouds <magicloud.magiclouds@gmail.com>
Subject: Re: How to fasten btrfs?
Date: Tue, 25 Jan 2011 22:28:11 +0800
Message-ID: <AANLkTik_mfFO+ciZbxuuqqRJDkOGoOW=pfjVv0au80TS@mail.gmail.com>
References: <AANLkTikMucRF3e-w_x7HnfjPZ-8EmQyhSfcTCihQZmTg@mail.gmail.com>
	<201101251130.37051.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101251130.37051.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

So you were saying that, even an unlink operation, the system walks
through all file data blocks? I thought unlink wouldn't have to write
too much data.

On Tue, Jan 25, 2011 at 6:30 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Tuesday 25 of January 2011 07:45:02 Magicloud Magiclouds wrote:
>> Hi,
>> =C2=A0 I am using 2.6.36.3 kernel with btrfs, 512MB memory and a ver=
y slow
>> disk, no special options for mounting btrfs except noatime. Now I
>> found it very slow. When I rm a 5GB movie, it took 20 secs.
>
> try mounting with nodatacow and defragment the directory the file res=
ides in
>
> Regards
> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>



--=20
=E7=AB=B9=E5=AF=86=E5=B2=82=E5=A6=A8=E6=B5=81=E6=B0=B4=E8=BF=87
=E5=B1=B1=E9=AB=98=E5=93=AA=E9=98=BB=E9=87=8E=E4=BA=91=E9=A3=9E
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
