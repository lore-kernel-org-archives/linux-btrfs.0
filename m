From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: loop-mount btrfs .19 w/ 2.6.30: btrfs: open_ctree failed
Date: Wed, 22 Jul 2009 18:57:56 +0800
Message-ID: <3d0408630907220357k7e323f16u1c8db807146feb4b@mail.gmail.com>
References: <20090722103003.GC16472@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: btrfs@think-future.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090722103003.GC16472@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

2009/7/22  <btrfs@think-future.com>:
> Hey,
>
> Just tried to mount a btrfs 0.19 in a image file:
>
> dd if=3D/dev/zero of=3Dbtrfs-play.img bs=3D1024k count=3D256
>
> losetup -f btrfs-play.img
> losetup -a
> /dev/loop0: [fd02]:24653 (btrfs-play.img)
>
> mkfs.btrfs -L BTRFStest /dev/loop0
>
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> fs created label BTRFStest on /dev/loop0
> =A0 =A0 =A0 =A0nodesize 4096 leafsize 4096 sectorsize 4096 size 256.0=
0MB
> Btrfs Btrfs v0.19
>
> btrfsctl -A /dev/loop0
> operation complete
> Btrfs Btrfs v0.19
>
> mount -t btrfs /dev/loop0 btrfs-test/
> mount: tipo fs errato, opzione non valida, superblocco su /dev/loop0 =
danneggiato,
> =A0 =A0 =A0 codepage o programma ausiliario mancante, o altro errore
> =A0 =A0 =A0 =A0In alcuni casi si possono trovare informazioni utili i=
n syslog. Provare
> =A0 =A0 =A0 ad esempio 'dmesg | tail'
>
> dmesg | tail
> [140443.202115] device label BTRFS_mypole devid 1 transid 7 /dev/loop=
0
> [140443.202369] BTRFS: couldn't mount because of unsupported optional=
 features (1).
> [140443.202480] btrfs: open_ctree failed
>
> Did I miss something? Using ext3/4 the above works flawlessly..
>
> Probably it's only due to the "open_ctree" problem above. Using kerne=
l 2.6.30 and btrfs-tools 19-2 (debian).
>

There was a disk format change between btrfs-progs v0.18 and v0.19
(between kernel 2.6.30 and 2.6.31).
If your kernel is older than 2.6.31, please use btrfs-progs v0.18.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
