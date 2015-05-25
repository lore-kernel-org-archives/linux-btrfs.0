Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32962 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbEYEUk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 00:20:40 -0400
Received: by wgez8 with SMTP id z8so63094787wge.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 21:20:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
References: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
	<036B4518-F7BF-4C9A-8906-38550D7F125F@plack.net>
	<CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
Date: Mon, 25 May 2015 14:20:39 +1000
Message-ID: <CA+WRLO_qRRXnY+Qwfw83-d6HmrZ3b4cdgCVOX+Vg1EHSKBK=4g@mail.gmail.com>
Subject: Re: Did convert do anything?
From: Gareth Pye <gareth@cerberos.id.au>
To: Anthony Plack <tmy@plack.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I guess it might be relevant that this array was originally created as
raid5 back in the early days of raid5 and converted to raid1 over a
year ago.

On Mon, May 25, 2015 at 2:00 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> 1.
> # btrfs fi sh /data
> Label: none  uuid: b2986e1a-0891-4779-960c-e01f7534c6eb
>         Total devices 6 FS bytes used 4.41TiB
>         devid    1 size 1.81TiB used 1.48TiB path /dev/drbd0
>         devid    2 size 1.81TiB used 1.48TiB path /dev/drbd1
>         devid    3 size 1.81TiB used 1.48TiB path /dev/drbd2
>         devid    4 size 1.81TiB used 1.48TiB path /dev/drbd3
>         devid    5 size 1.81TiB used 1.48TiB path /dev/drbd4
>         devid    6 size 1.81TiB used 1.48TiB path /dev/drbd5
>
>
> 2.
> 18% or 1.1T spare currently. That isn't what I'd call tiny free space.



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
