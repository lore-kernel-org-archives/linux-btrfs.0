From: Josef Bacik <josef@redhat.com>
Subject: Re: =?UTF-8?B?4oCcYmlvIHRvbyBiaWfigJ0gcmVncmVzc2lvbiBhbmQgc2lsZW4=?=
 =?UTF-8?B?dCBkYXRhIGNvcnJ1cHRpb24gaW4gMy4w?=
Date: Tue, 09 Aug 2011 10:02:25 -0400
Message-ID: <4E413DF1.4090809@redhat.com>
References: <orwreobtuf.fsf@livre.localdomain> <or1uwv7cjz.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <or1uwv7cjz.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2011 06:39 PM, Alexandre Oliva wrote:
> On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:
>=20
>> tl;dr version: 3.0 produces =E2=80=9Cbio too big=E2=80=9D dmesg entr=
ies and silently
>> corrupts data in =E2=80=9Cmeta-raid1/data-single=E2=80=9D configurat=
ions on disks with
>> different max_hw_sectors, where 2.6.38 worked fine.
>=20
> FWIW, I just got the same problem with 2.6.38.  No idea how I hadn't =
hit
> it before, but it's not a 3.0 regression, just a regular (but IMHO ve=
ry
> serious) bug.
>=20

This is worriesome, I will try and find a usb disk with a small
sectorsize and see if I can reproduce.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
