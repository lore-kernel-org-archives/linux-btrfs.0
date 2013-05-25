Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37505 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab3EYWdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:33:49 -0400
Received: by mail-lb0-f179.google.com with SMTP id r11so5768928lbv.38
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 15:33:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
 <CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
 <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net> <1751895.r3q1HmeO0C@merkaba> <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 26 May 2013 00:33:27 +0200
Message-ID: <CAFWF=a=WXTgELv0hsfqDBPM7n8as3xz7aSj5UdXKonXcOw9ueg@mail.gmail.com>
Subject: Re: Recommended settings for SSD
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Data that already exists will only be compressed on re-write. You can
do it with btrfs fi defrag and a script that traverses the fs to call
defrag on every file. Another good way is the find command that has
been outlined here:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_directory_doesn.27t_work

On Sun, May 26, 2013 at 12:29 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sat, May 25, 2013 at 1:13 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> Am Samstag, 25. Mai 2013, 03:58:12 schrieb Duncan:
>> [...]
>> And can be verified by:
>>
>> martin@merkaba:~> grep ssd /proc/mounts
>> /dev/mapper/merkaba-debian / btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
>> /dev/mapper/merkaba-debian /mnt/debian-zeit btrfs
>> rw,noatime,compress=lzo,ssd,space_cache 0 0
>> /dev/mapper/merkaba-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0
>> 0
>> /dev/mapper/merkaba-home /mnt/home-zeit btrfs
>> rw,noatime,compress=lzo,ssd,space_cache 0 0
>> martin@merkaba:~> grep ssd /etc/fstab
>> martin@merkaba:~#1>
>> [...]
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> I see you are using compression. I don't have compression at the
> moment and I would like to use it. What will happen to the data that
> are already on the partitions? Will it be compressed when I use them?
> Do I have to re-write them? Would it be compressed with btrfs defrag
> command?
>
> Thanks for the information
>
> --
> Caution: breathing may be hazardous to your health.
>
> #include <stdio.h>
> int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
