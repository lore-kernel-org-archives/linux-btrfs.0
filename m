Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35869 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755511AbcIVQq6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 12:46:58 -0400
Received: by mail-qk0-f177.google.com with SMTP id z190so81744320qkc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 09:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Thu, 22 Sep 2016 12:46:56 -0400
Message-ID: <CAGfcS_kOo49_5OxF0-TodBZjjkKeGsPiYHJFeSa6x=OtB0LfOg@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sep 22, 2016 8:18 AM, "Rich Freeman" <r-btrfs@thefreemanclan.net> wrote:
>
> I have been getting panics consistently after doing a btrfs replace
> operation on a raid1 and rebooting.  I linked a photo of the panic; I
> haven't been able to get a text capture of it.
>
> https://ibin.co/2vx0HhDeViu3.jpg
>
> I'm getting this error on the latest 4.4, 4.1, and even on an old
> 3.18.26 kernel I had lying around.


Apologies for replying out of order, but I lost the reply (the
downside to running btrfs on my mail server).

I was also suspicious of memory but memtestx86 hasn't found anything
in (though I haven't run it longer than 10min). Sysrescuecd is my
normal rescue image and I haven't gotten that to panic, but I haven't
tried to start any services from it. Unfortunately it is openrc based
so getting systemd running on my btrfs image inside a container will
be painful. Maybe I can find a systemd based rescue image that
includes nspawn.

I suspect I'll have the same issue though as several kernels have failed.

I'll do more extensive RAM tests just in case.  However, the
consistency of the error messages suggests a bug to me.

Rich
