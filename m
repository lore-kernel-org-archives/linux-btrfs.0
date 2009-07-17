From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: Ghost file.
Date: Fri, 17 Jul 2009 14:44:46 +0800
Message-ID: <3d0408630907162344o5ed0b1fen807e67c5c87c42fa@mail.gmail.com>
References: <4A539C7B.7000506@mccme.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Raskin Michael <raskin@mccme.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A539C7B.7000506@mccme.ru>
List-ID: <linux-btrfs.vger.kernel.org>

2009/7/8 Raskin Michael <raskin@mccme.ru>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I mentioned a ghost file. Here is the dump (less than 65M):
> http://dev.mccme.ru/~raskin/btrfs.dump
>
> ghost file is:
> 885dj1l4788pymp3bk2f3dz52ggcvw4v-empty/garbage-1/mwave.h.tmp-31838-18=
22528541
>
> It has a name, but stat fails (so no inode, I guess). Also I can crea=
te
> another file with the same name in the directory. I cannot remove the
> file, or containing directory.
>
> fsck output:
>
> root 5 inode 273 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 270 index 2 namelen 4 name attr fil=
etype 0
> error 3
> root 5 inode 274 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 2 namelen 2 name cs filet=
ype 0 error 3
> root 5 inode 275 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 3 namelen 2 name de filet=
ype 0 error 3
> root 5 inode 276 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 4 namelen 2 name es filet=
ype 0 error 3
> root 5 inode 277 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 5 namelen 2 name fr filet=
ype 0 error 3
> root 5 inode 278 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 6 namelen 2 name gl filet=
ype 0 error 3
> root 5 inode 279 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 7 namelen 2 name nl filet=
ype 0 error 3
> root 5 inode 280 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 8 namelen 2 name pl filet=
ype 0 error 3
> root 5 inode 281 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 271 index 9 namelen 2 name sv filet=
ype 0 error 3
> root 5 inode 290 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 272 index 2 namelen 4 name man1 fil=
etype 0
> error 3
> root 5 inode 291 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 272 index 3 namelen 4 name man2 fil=
etype 0
> error 3
> root 5 inode 292 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 272 index 4 namelen 4 name man3 fil=
etype 0
> error 3
> root 5 inode 293 errors 0
> =A0 =A0 =A0 =A0unresolved ref dir 272 index 5 namelen 4 name man5 fil=
etype 0
> error 3
> root 5 inode 316 errors 2000
> =A0 =A0 =A0 =A0unresolved ref dir 353285 index 1288 namelen 28 name
> mwave.h.tmp-31838-1822528541 filetype 1 error 1
> root 5 inode 353285 errors 200
> found 11118575893 bytes used err is 1
> total csum bytes: 10369224
> total tree bytes: 433348608
> total fs tree bytes: 373395456
> btree space waste bytes: 106980960
> file data blocks allocated: 10831892480
> =A0referenced 10617970688
> Btrfs Btrfs v0.19

I suspect these errors were caused by an unknown tree log bug.
Would you please mount btrfs with -o notreelog option from now on,
and check if you still get more errors.

Thank you
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
