Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42590 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3EZRGW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 13:06:22 -0400
Received: by mail-ie0-f182.google.com with SMTP id a14so16788797iee.27
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 10:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=akw41MyFLAasCx90M6MU7dBU8DVEMDzRMsiEwNMFZMkOA@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
	<pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
	<1751895.r3q1HmeO0C@merkaba>
	<CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
	<CAFWF=a=WXTgELv0hsfqDBPM7n8as3xz7aSj5UdXKonXcOw9ueg@mail.gmail.com>
	<CAAeznTr8t+AnTL9JtXLA+TMg97_MX+63giGEsrP-j4rWFUhYpg@mail.gmail.com>
	<CAFWF=akw41MyFLAasCx90M6MU7dBU8DVEMDzRMsiEwNMFZMkOA@mail.gmail.com>
Date: Sun, 26 May 2013 11:06:22 -0600
Message-ID: <CAE5mzvgVdmckePvkdUomd2fUWFxkdgoQRLgtTWjCQQQ9jYUbEg@mail.gmail.com>
Subject: Re: Recommended settings for SSD
From: cwillu <cwillu@cwillu.com>
To: Harald Glatt <mail@hachre.de>
Cc: Leonidas Spyropoulos <artafinde@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 26, 2013 at 9:16 AM, Harald Glatt <mail@hachre.de> wrote:
> I don't know a better way to check than doing df -h before and
> after... If you use space_cache you have to clear_cache though to make
> the numbers be current for sure each time before looking at df.

Not sure what you're thinking of; space_cache is just a mount-time
optimization, storing and loading a memory structure to disk so that
it doesn't have to be regenerated.

As I understand it, if it's ever wrong, it's a serious bug.
