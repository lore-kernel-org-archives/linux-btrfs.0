Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48784 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3EZPQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 11:16:31 -0400
Received: by mail-lb0-f176.google.com with SMTP id x10so5942996lbi.7
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 08:16:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAeznTr8t+AnTL9JtXLA+TMg97_MX+63giGEsrP-j4rWFUhYpg@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
 <CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
 <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net> <1751895.r3q1HmeO0C@merkaba>
 <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
 <CAFWF=a=WXTgELv0hsfqDBPM7n8as3xz7aSj5UdXKonXcOw9ueg@mail.gmail.com> <CAAeznTr8t+AnTL9JtXLA+TMg97_MX+63giGEsrP-j4rWFUhYpg@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 26 May 2013 17:16:10 +0200
Message-ID: <CAFWF=akw41MyFLAasCx90M6MU7dBU8DVEMDzRMsiEwNMFZMkOA@mail.gmail.com>
Subject: Re: Recommended settings for SSD
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know a better way to check than doing df -h before and
after... If you use space_cache you have to clear_cache though to make
the numbers be current for sure each time before looking at df.

Old kernel can be a problem. You can use the Arch CDs to do it, they
usually come with the newest kernels.
https://www.archlinux.org/download/

If you need to install anything a quick guide to the package managing:

# Update Repos and Upgrade system:
pacman -Suy

# Install a specific package:
pacman -S packagename

# Search for a package
pacman -Ss search term


On Sun, May 26, 2013 at 12:00 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sat, May 25, 2013 at 11:33 PM, Harald Glatt <mail@hachre.de> wrote:
>> Data that already exists will only be compressed on re-write. You can
>> do it with btrfs fi defrag and a script that traverses the fs to call
>> defrag on every file. Another good way is the find command that has
>> been outlined here:
>>
>> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_directory_doesn.27t_work
>>
>
> I tried to my home partition the 'find' command and worked without
> errors, not sure if it did compress (how can I check?). I tried also
> on the root partition and every file that was in use (obviously) it
> didn't defrag it. I am guessing I have to mount the partition from a
> LiveCD but since the LiceCD kernel is usually old (in terms of btrfs)
> do you reckon there will be any problems?
>
> Thanks
> --
> Caution: breathing may be hazardous to your health.
>
> #include <stdio.h>
> int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
