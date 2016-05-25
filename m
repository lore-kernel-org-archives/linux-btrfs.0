Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36586 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbcEYUgP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 16:36:15 -0400
Received: by mail-wm0-f43.google.com with SMTP id n129so199225890wmn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 13:36:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
References: <45a47ee4db4cc92248f91f1d00e8ed03@www.centurion.link>
	<pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
Date: Wed, 25 May 2016 16:36:13 -0400
Message-ID: <CAD=QJKjfrtBN+nyhOK3mRxv2qkPMhx8Gf1MuuFqzkOYYv2RT=g@mail.gmail.com>
Subject: Re: Some ideas for improvements
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>, Dmitry Katsubo <dma_k@mail.ru>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 May 2016 at 15:03, Duncan <1i5t5.duncan@cox.net> wrote:
> Dmitry Katsubo posted on Wed, 25 May 2016 16:45:41 +0200 as excerpted:
>> btrfs-restore:
>>
>> * It does not restore special files like named pipes and devices.
>> * Hard-linked files are not correctly restored (they all turn into
>> independent replicas).
>> * If the file cannot be read / recovered, it is still created with zero
>> size (I would expect that the file is not created).
>> * I think that the options '-xmS' should be enabled by default
>> (shouldn't it be a goal to restore as much as possible?).
>> * Option that applies (y) to all questions (completely unattended
>> recovery) is missing.
>
> That latter point is a known sore spot that a lot of people have
> complained about.  So it'll almost certainly be addressed eventually, but
> it's a matter of this project vying with all the others so it could be
> awhile.

I'm surprised no one has mentioned, in any of these discussions, what
I believe is the standard method of providing this functionality:
yes | btrfs-restore -options /dev/disk

And if you need it in your initrd on a Debian-like system, put the
following in /etc/initramfs-tools/hooks/yes.hook :

#!/bin/sh

. /usr/share/initramfs-tools/hook-functions

if command -v /usr/bin/yes >/dev/null 2>&1; then
    copy_exec /usr/bin/yes usr/bin/yes
    copy_exec /usr/bin/yes usr/bin/yes
fi

I haven't tested this, but it seems like it would do the trick.

Cheers,
Nicholas
