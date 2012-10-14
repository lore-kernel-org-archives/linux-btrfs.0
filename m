Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33495 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2JNUWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 16:22:47 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so2680722wey.19
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2012 13:22:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121014121130.04710db1@zee.bluelavalamp.net>
References: <20121014121130.04710db1@zee.bluelavalamp.net>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sun, 14 Oct 2012 22:22:26 +0200
Message-ID: <CAGy7Utghnjr1fTJGbG=FUTgZEDnupY2-nCoo_xfTvU=xJxFvxQ@mail.gmail.com>
Subject: Re: segfault mounting btrfs after drive failure
To: Kevin <kevin@bluelavalamp.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kevin,

On Sun, Oct 14, 2012 at 6:11 PM, Kevin <kevin@bluelavalamp.net> wrote:
> ./btrfs fi sh
> Label: none  uuid: 07b2c489-3e9b-4a99-977d-3b877f75dc84
>         Total devices 9 FS bytes used 5.57TB
>         devid    8 size 1.82TB used 1.82TB path /dev/sdk1
>         devid    7 size 1.36TB used 1.36TB path /dev/sdi1
>         devid   10 size 1.36TB used 1.36TB path /dev/sdh1
>         devid    6 size 1.82TB used 1.82TB path /dev/sdg1
>         devid    5 size 1.82TB used 1.82TB path /dev/sdf1
>         devid    9 size 1.36TB used 1.36TB path /dev/sde1
>         devid    3 size 1.82TB used 1.82TB path /dev/sdd1
>         devid    2 size 1.82TB used 1.82TB path /dev/sdc1
>         devid    1 size 819.51GB used 819.51GB path /dev/sda3
>
> Btrfs v0.20-rc1-37-g91d9eec
>

Let me start this off with the questions that will be asked anyway:

Which kernel version are you running?

Was your filesystem full or nearly full at the time of the drive failure?


Regards,

Bart
