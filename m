Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:54661 "EHLO
        avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754892AbeD1OOX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 10:14:23 -0400
From: "David C. Partridge" <david.partridge@perdrix.co.uk>
To: <linux-btrfs@vger.kernel.org>
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk> <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com> <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk> <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com> <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk> <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
In-Reply-To: <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
Subject: RE: Problems with btrfs
Date: Sat, 28 Apr 2018 15:06:49 +0100
Message-ID: <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_0063_01D3DF02.894893C0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0063_01D3DF02.894893C0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Here's the log you asked for ...

David

-----Original Message-----
From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
Sent: 28 April 2018 14:54
To: David C. Partridge
Subject: Re: Problems with btrfs



On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 21:38, David C. Partridge wrote:
> Oh! doing a private build from source a bit beyond my skill level :(  =
Are there alternatives like climbing in with a disk editor or is there =
too much to change?

It's possible to only modify that offending tree block.
But I can't ensure the safety, thus I recommend to use =
btrfs-corrupt-block.
Since it's not convenient for you, then let's go that way.

Please provide the following dump:

# btrfs inspect dump-tree -t chunk <device>

Then I could calculate the offset on-disk for you to do a binary dump =
and send that tree block back to me to hand patch it.

>=20
> I'm prepared to install a newer version of btrfs-progs if that will =
fix the problem (assuming I can find a suitable package file).
>=20
> I'm assuming that I'll likely also need to update the kernel?

Not exactly.
If latest btrfs check gives no error after fix, even old kernel should =
handle it well without problem.

But as a generic advice, it's recommended to use latest kernel for btrfs =
if possible.

And currently there is nothing sensitive in the thread =
(btrfs-inspect.log could contain some filenames, but nothing sensitive =
right now), so it's better to CC the mail to mail list, just in case =
some other guy could provide extra help.

(Next mail may be after 8~10 hours, as it's bed time for my timezone)

Thanks,
Qu

>=20
> David
>=20
> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
> Sent: 28 April 2018 14:25
> To: David C. Partridge
> Subject: Re: Problems with btrfs
>=20
>=20
>=20
> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 21:14, David C. Partridge =
wrote:
>> Here's the output from
>>
>> # btrfs inspect dump-tree /dev/mapper/Charon--vg-root | grep -C 20
>> 224304857088
>=20
> Located the problem:
>=20
> 	item 382 key (224304857088 EXTENT_ITEM 16384) itemoff 14495 itemsize =
51
> 		extent refs 1 gen 735989 flags TREE_BLOCK
> 		tree block key (4401028 UNKNOWN.0 0) level 0
>                                 ^^^^^^^^^^^^^^^^^^^
> 		shared block backref parent 140827475968
>=20
> It could be fixed by special crafted btrfs-corrupt-block tool to =
handle it.
> Although this means you need to compile btrfs-progs by yourself with =
special branch.
>=20
> Before patching btrfs-progs, I'd like to double check if other part is =
correct.
>=20
> Please execute the following command:
> # btrfs inspect dump-tree -b 140827475968 /dev/mapper/Charon--vg-root
>=20
> If the output is correct, I could start patching btrfs-corrupt-block =
then.
> But please be aware of that, this could only fix the problem found in =
extent tree, I'm not 100% sure if there will be other problems, as the =
btrfs-progs is pretty old.
>=20
> Thanks,
> Qu
>=20
>>
>> HtH
>> David
>>
>=20


------=_NextPart_000_0063_01D3DF02.894893C0
Content-Type: application/octet-stream;
	name="btrfs-dump-chunk.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="btrfs-dump-chunk.log"

btrfs-progs v4.7.3=0A=
chunk tree=0A=
leaf 302570274816 items 68 free space 8933 generation 849190 owner 3=0A=
fs uuid a0a6c5a6-061f-4c86-bc14-7f9abf3cb57e=0A=
chunk uuid 98c0b1e7-1845-4803-8965-22f0a655353d=0A=
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98=0A=
		dev item devid 1 total_bytes 78852915200 bytes used 68144857088=0A=
		dev uuid 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 124046540800) itemoff 16105 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 51577356288=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 129415249920) itemoff 16025 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 30236737536=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 130488991744) itemoff 15913 =
itemsize 112=0A=
		chunk length 536870912 owner 2 stripe_len 65536=0A=
		type METADATA|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 25941770240=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 26478641152=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 131025862656) itemoff 15833 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 24868028416=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 132099604480) itemoff 15753 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 19499319296=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 133173346304) itemoff 15673 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 16278093824=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 134247088128) itemoff 15593 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 11848908800=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 135320829952) itemoff 15513 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 9701425152=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 136394571776) itemoff 15433 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 8627683328=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 137468313600) itemoff 15353 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 6480199680=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 11 key (FIRST_CHUNK_TREE CHUNK_ITEM 138542055424) itemoff 15273 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 4332716032=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 12 key (FIRST_CHUNK_TREE CHUNK_ITEM 140689539072) itemoff 15161 =
itemsize 112=0A=
		chunk length 536870912 owner 2 stripe_len 65536=0A=
		type METADATA|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 12989759488=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 13526630400=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 13 key (FIRST_CHUNK_TREE CHUNK_ITEM 143373893632) itemoff 15081 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 2148532224=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 14 key (FIRST_CHUNK_TREE CHUNK_ITEM 144447635456) itemoff 15001 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 5406457856=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 15 key (FIRST_CHUNK_TREE CHUNK_ITEM 158406279168) itemoff 14921 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 32384221184=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 16 key (FIRST_CHUNK_TREE CHUNK_ITEM 199376240640) itemoff 14841 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 59093549056=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 17 key (FIRST_CHUNK_TREE CHUNK_ITEM 217663406080) itemoff 14761 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 7553941504=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 18 key (FIRST_CHUNK_TREE CHUNK_ITEM 221958373376) itemoff 14681 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 18425577472=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 19 key (FIRST_CHUNK_TREE CHUNK_ITEM 224105857024) itemoff 14569 =
itemsize 112=0A=
		chunk length 536870912 owner 2 stripe_len 65536=0A=
		type METADATA|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 22720544768=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 23257415680=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 20 key (FIRST_CHUNK_TREE CHUNK_ITEM 226790211584) itemoff 14489 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 27015512064=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 21 key (FIRST_CHUNK_TREE CHUNK_ITEM 230011437056) itemoff 14409 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 31310479360=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 22 key (FIRST_CHUNK_TREE CHUNK_ITEM 232158920704) itemoff 14329 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 34531704832=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 23 key (FIRST_CHUNK_TREE CHUNK_ITEM 236453888000) itemoff 14217 =
itemsize 112=0A=
		chunk length 536870912 owner 2 stripe_len 65536=0A=
		type METADATA|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 38826672128=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 39363543040=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 24 key (FIRST_CHUNK_TREE CHUNK_ITEM 244506951680) itemoff 14137 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 48490348544=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 25 key (FIRST_CHUNK_TREE CHUNK_ITEM 250949402624) itemoff 14057 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 56946065408=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 26 key (FIRST_CHUNK_TREE CHUNK_ITEM 252023144448) itemoff 13977 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 58019807232=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 27 key (FIRST_CHUNK_TREE CHUNK_ITEM 254170628096) itemoff 13897 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 61241032704=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 28 key (FIRST_CHUNK_TREE CHUNK_ITEM 256318111744) itemoff 13817 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 63388516352=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 29 key (FIRST_CHUNK_TREE CHUNK_ITEM 257391853568) itemoff 13737 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 64462258176=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 30 key (FIRST_CHUNK_TREE CHUNK_ITEM 260613079040) itemoff 13657 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 67683483648=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 31 key (FIRST_CHUNK_TREE CHUNK_ITEM 261686820864) itemoff 13577 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 68757225472=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 32 key (FIRST_CHUNK_TREE CHUNK_ITEM 262760562688) itemoff 13497 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 69830967296=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 33 key (FIRST_CHUNK_TREE CHUNK_ITEM 263834304512) itemoff 13417 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 70904709120=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 34 key (FIRST_CHUNK_TREE CHUNK_ITEM 265981788160) itemoff 13337 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 73052192768=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 35 key (FIRST_CHUNK_TREE CHUNK_ITEM 268129271808) itemoff 13257 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 75199676416=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 36 key (FIRST_CHUNK_TREE CHUNK_ITEM 269203013632) itemoff 13177 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 76273418240=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 37 key (FIRST_CHUNK_TREE CHUNK_ITEM 270276755456) itemoff 13097 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 77347160064=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 38 key (FIRST_CHUNK_TREE CHUNK_ITEM 271350497280) itemoff 13017 =
itemsize 80=0A=
		chunk length 939524096 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 50637832192=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 39 key (FIRST_CHUNK_TREE CHUNK_ITEM 272290021376) itemoff 12937 =
itemsize 80=0A=
		chunk length 432013312 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 78420901888=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 40 key (FIRST_CHUNK_TREE CHUNK_ITEM 272722034688) itemoff 12857 =
itemsize 80=0A=
		chunk length 67108864 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 12922650624=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 41 key (FIRST_CHUNK_TREE CHUNK_ITEM 272789143552) itemoff 12777 =
itemsize 80=0A=
		chunk length 67108864 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 16210984960=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 42 key (FIRST_CHUNK_TREE CHUNK_ITEM 272908156928) itemoff 12697 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 53724839936=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 43 key (FIRST_CHUNK_TREE CHUNK_ITEM 273981898752) itemoff 12617 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 37752930304=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 44 key (FIRST_CHUNK_TREE CHUNK_ITEM 275055640576) itemoff 12537 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 21646802944=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 45 key (FIRST_CHUNK_TREE CHUNK_ITEM 276162936832) itemoff 12457 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 135266304=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 46 key (FIRST_CHUNK_TREE CHUNK_ITEM 277236678656) itemoff 12377 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 3222274048=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 47 key (FIRST_CHUNK_TREE CHUNK_ITEM 279384162304) itemoff 12265 =
itemsize 112=0A=
		chunk length 536870912 owner 2 stripe_len 65536=0A=
		type METADATA|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 14063501312=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 14600372224=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 48 key (FIRST_CHUNK_TREE CHUNK_ITEM 279921033216) itemoff 12185 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 15137243136=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 49 key (FIRST_CHUNK_TREE CHUNK_ITEM 281061883904) itemoff 12105 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 17351835648=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 50 key (FIRST_CHUNK_TREE CHUNK_ITEM 282135625728) itemoff 12025 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 20573061120=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 51 key (FIRST_CHUNK_TREE CHUNK_ITEM 283209367552) itemoff 11945 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 23794286592=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 52 key (FIRST_CHUNK_TREE CHUNK_ITEM 284283109376) itemoff 11865 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 28089253888=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 53 key (FIRST_CHUNK_TREE CHUNK_ITEM 286430593024) itemoff 11785 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 33457963008=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 54 key (FIRST_CHUNK_TREE CHUNK_ITEM 287504334848) itemoff 11705 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 35605446656=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 55 key (FIRST_CHUNK_TREE CHUNK_ITEM 288578076672) itemoff 11625 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 36679188480=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 56 key (FIRST_CHUNK_TREE CHUNK_ITEM 289651818496) itemoff 11545 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 39900413952=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 57 key (FIRST_CHUNK_TREE CHUNK_ITEM 290725560320) itemoff 11465 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 40974155776=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 58 key (FIRST_CHUNK_TREE CHUNK_ITEM 291799302144) itemoff 11385 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 42047897600=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 59 key (FIRST_CHUNK_TREE CHUNK_ITEM 292873043968) itemoff 11305 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 43121639424=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 60 key (FIRST_CHUNK_TREE CHUNK_ITEM 293946785792) itemoff 11225 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 44195381248=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 61 key (FIRST_CHUNK_TREE CHUNK_ITEM 295020527616) itemoff 11145 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 45269123072=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 62 key (FIRST_CHUNK_TREE CHUNK_ITEM 296094269440) itemoff 11065 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 46342864896=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 63 key (FIRST_CHUNK_TREE CHUNK_ITEM 297168011264) itemoff 10985 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 47416606720=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 64 key (FIRST_CHUNK_TREE CHUNK_ITEM 298241753088) itemoff 10905 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 49564090368=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 65 key (FIRST_CHUNK_TREE CHUNK_ITEM 299315494912) itemoff 10825 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 52651098112=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 66 key (FIRST_CHUNK_TREE CHUNK_ITEM 301496532992) itemoff 10745 =
itemsize 80=0A=
		chunk length 1073741824 owner 2 stripe_len 65536=0A=
		type DATA num_stripes 1=0A=
			stripe 0 devid 1 offset 29162995712=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
	item 67 key (FIRST_CHUNK_TREE CHUNK_ITEM 302570274816) itemoff 10633 =
itemsize 112=0A=
		chunk length 33554432 owner 2 stripe_len 65536=0A=
		type SYSTEM|DUP num_stripes 2=0A=
			stripe 0 devid 1 offset 68157440=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
			stripe 1 devid 1 offset 101711872=0A=
			dev uuid: 5e27c2ed-872b-4bcf-946f-d7f9e81e2c32=0A=
total bytes 78852915200=0A=
bytes used 26553249792=0A=
uuid a0a6c5a6-061f-4c86-bc14-7f9abf3cb57e=0A=

------=_NextPart_000_0063_01D3DF02.894893C0--

