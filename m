Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:39553 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3EZKAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 06:00:18 -0400
Received: by mail-la0-f51.google.com with SMTP id lx15so5587412lab.24
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 03:00:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=a=WXTgELv0hsfqDBPM7n8as3xz7aSj5UdXKonXcOw9ueg@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
	<pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
	<1751895.r3q1HmeO0C@merkaba>
	<CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
	<CAFWF=a=WXTgELv0hsfqDBPM7n8as3xz7aSj5UdXKonXcOw9ueg@mail.gmail.com>
Date: Sun, 26 May 2013 11:00:16 +0100
Message-ID: <CAAeznTr8t+AnTL9JtXLA+TMg97_MX+63giGEsrP-j4rWFUhYpg@mail.gmail.com>
Subject: Re: Recommended settings for SSD
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Harald Glatt <mail@hachre.de>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 25, 2013 at 11:33 PM, Harald Glatt <mail@hachre.de> wrote:
> Data that already exists will only be compressed on re-write. You can
> do it with btrfs fi defrag and a script that traverses the fs to call
> defrag on every file. Another good way is the find command that has
> been outlined here:
>
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_directory_doesn.27t_work
>

I tried to my home partition the 'find' command and worked without
errors, not sure if it did compress (how can I check?). I tried also
on the root partition and every file that was in use (obviously) it
didn't defrag it. I am guessing I have to mount the partition from a
LiveCD but since the LiceCD kernel is usually old (in terms of btrfs)
do you reckon there will be any problems?

Thanks
--
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
