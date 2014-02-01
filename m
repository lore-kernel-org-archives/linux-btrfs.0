Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58409 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaBATOY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 14:14:24 -0500
Received: by mail-bk0-f49.google.com with SMTP id v15so2440401bkz.8
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 11:14:23 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAFDW0j+MkhJUxR+zePXkewKpbK5qUGxiG-B6mgzPEJNVEEBgxw@mail.gmail.com>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
	<CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
	<20140130215634.GB8796@birch.djwong.org>
	<CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
	<CAFDW0j+7roYdCaCsFoQWUdifhyLCgDL5JAbmEkDeF_Fx2+YdrA@mail.gmail.com>
	<CAL3q7H4cUj3p+mNBciMjoT0QSXfCWmc61QLWKgLNZSKRx0+JbQ@mail.gmail.com>
	<CAFDW0j+MkhJUxR+zePXkewKpbK5qUGxiG-B6mgzPEJNVEEBgxw@mail.gmail.com>
Date: Sat, 1 Feb 2014 19:14:22 +0000
Message-ID: <CAL3q7H6i4uFYRjq8XWGpr1XR2K6+xqKtnbL3D3gUHiydmpCusA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Filipe David Manana <fdmanana@gmail.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 1, 2014 at 5:25 PM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
>> I tried late_initcall too, both when built as a module and as
>> built-in. Seems to work too on my hardware.
> On my i3 (avx) and i7 (avx2) systems it works well too.
> Havent tested other, faster pre avx systems, besides that intel u7300
> system, which gave me troubles, yet.
>
>> Out of curiosity, what error were you getting exactly? Can you paste
>> the stack trace from dmesg?
> I get no error at all. But also no btrfs in /proc/filesystems.
>
> Here a part of the dmesg, but i cant see anything from btrfs there,
> besides my own printk:
>
> printk("hello");
> err = btrfs_hash_init();

Did you find out what err's value was?

That could give some more insight, right now I don't fully understand
what happened.

Thanks

>
> ...
> [    0.488837] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    0.489075] AVX instructions are not detected.
> [    0.489284] AVX instructions are not detected.
> [    0.490126] audit: initializing netlink socket (disabled)
> [    0.490345] type=2000 audit(1391274060.489:1): initialized
> [    0.518163] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    0.518626] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    0.518973] NTFS driver 2.1.30 [Flags: R/W].
> [    0.519312] SGI XFS with security attributes, large block/inode
> numbers, no debug enabled
> [    0.519989] NILFS version 2 loaded
> [    0.520195] hello
> [    0.520654] msgmni has been set to 3985
> [    0.522639] NET: Registered protocol family 38
> [    0.522948] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 250)
> [    0.523364] io scheduler noop registered
> [    0.523582] io scheduler deadline registered
> [    0.523830] io scheduler cfq registered (default)
> ...
>
> And here, if i use late_initcall:
>
> ...
> [    0.992166] Key type dns_resolver registered
> [    0.993168] registered taskstats version 1
> [    0.993752] hello
> [    0.993932] bio: create slab <bio-1> at 1
> [    0.995293] Btrfs loaded
> [    0.996004] rtc_cmos 00:00: setting system clock to 2014-02-01
> 17:09:57 UTC (1391274597)
> [    0.997902] Freeing unused kernel memory: 3060K (ffffffff826f9000 -
> ffffffff829f6000)
> ...
>
> Attached are both full dmesg logs.
>
> Ahmet



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
