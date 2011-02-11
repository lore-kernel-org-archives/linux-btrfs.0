From: Matt <jackdachef@gmail.com>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Fri, 11 Feb 2011 15:54:31 +0000
Message-ID: <AANLkTiknsmEpkA-+BQi0gxtf-B+ooit9ik=sfZZtvTSE@mail.gmail.com>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Lutomirski <andy@luto.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 11, 2011 at 3:08 PM, Andrew Lutomirski <andy@luto.us> wrote=
:
> As I type this, I have an ssh process running that's dumping data int=
o
> a fifo at high speed (maybe 500Mbps) and a tar process that's
> untarring from the same fifo onto btrfs. =A0The btrfs fs is mounted -=
o
> space_cache,compress. =A0This machine has 8GB ram, 8 logical cores, a=
nd
> a fast (i7-2600) CPU, so it's not an issue with the machine strugglin=
g
> under load.
>
> Every few tens of seconds, my system stalls for several seconds.
> These stalls cause keyboard input to be lost, firefox to hang, etc.
>
> Setting tar's ionice priority to best effort / 7 or to idle makes no =
difference.
>
> ionice idle and queue_depth =3D 1 on the disk (a slow 2TB WD) also ma=
kes
> no difference.
>
> max_sectors_kb =3D 64 in addition to the above doesn't help either.
>
> latencytop shows regular instances of 2-7 *second* latency, variously
> in sync_page, start_transaction, btrfs_start_ordered_extent, and
> do_get_write_access (from jbd2 on my ext4 root partition).
>
> echo 3 >drop_caches gave me 7 GB free RAM. =A0I still had stalls when
> 4-5 GB were still free (so it shouldn't be a problem with important
> pages being evicted).
>
> In case it matters, all of my partitions are on LVM on dm-crypt, but
> this machine has AES-NI so the overhead from that should be minimal.
> In fact, overall CPU usage is only about 10%.
>
> What gives? =A0I thought this stuff was supposed to be better on mode=
rn kernels.
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Hi Andrew,

you could try the following patch to speed up dm-crypt:

https://patchwork.kernel.org/patch/365542/

I'm using it on top of a highly-patched 2.6.37 kernel

not sure if exactly that version was included in 2.6.38


there are some additional handles to speed up dm:

e.g. PCRYCONFIG_CRYPTO_PCRYPT=3Dy

Regards

Matt
