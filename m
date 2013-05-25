Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36404 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3EYW3o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:29:44 -0400
Received: by mail-lb0-f181.google.com with SMTP id w20so5697786lbh.40
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 15:29:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1751895.r3q1HmeO0C@merkaba>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
	<pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
	<1751895.r3q1HmeO0C@merkaba>
Date: Sat, 25 May 2013 23:29:41 +0100
Message-ID: <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
Subject: Re: Recommended settings for SSD
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 25, 2013 at 1:13 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Samstag, 25. Mai 2013, 03:58:12 schrieb Duncan:
> [...]
> And can be verified by:
>
> martin@merkaba:~> grep ssd /proc/mounts
> /dev/mapper/merkaba-debian / btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
> /dev/mapper/merkaba-debian /mnt/debian-zeit btrfs
> rw,noatime,compress=lzo,ssd,space_cache 0 0
> /dev/mapper/merkaba-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0
> 0
> /dev/mapper/merkaba-home /mnt/home-zeit btrfs
> rw,noatime,compress=lzo,ssd,space_cache 0 0
> martin@merkaba:~> grep ssd /etc/fstab
> martin@merkaba:~#1>
> [...]
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I see you are using compression. I don't have compression at the
moment and I would like to use it. What will happen to the data that
are already on the partitions? Will it be compressed when I use them?
Do I have to re-write them? Would it be compressed with btrfs defrag
command?

Thanks for the information

--
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
