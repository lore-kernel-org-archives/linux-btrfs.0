Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35991 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbeHAKoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 06:44:12 -0400
Received: by mail-yw0-f175.google.com with SMTP id v197-v6so6895252ywg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2018 01:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Wed, 1 Aug 2018 09:59:28 +0100
Message-ID: <CAMU1PDhnM1vL9OZ-ytw-00vwQXPSTHpCpiB25o3FfoAL-iy0bw@mail.gmail.com>
Subject: Re: BTRFS and databases
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 August 2018 at 04:45, MegaBrutal <megabrutal@gmail.com> wrote:

> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?
>
> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance – the exact CoW
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?

Also note that no data CoW implies no data checksums too.
https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_have_nodatacow_.28or_chattr_.2BC.29_but_still_have_checksumming.3F

Mike
