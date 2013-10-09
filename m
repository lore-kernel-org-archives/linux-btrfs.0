Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56424 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3JIHBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 03:01:24 -0400
Received: by mail-qa0-f49.google.com with SMTP id i13so360006qae.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 00:01:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <568FD904-9402-47A7-A8F2-32445D20C3D6@colorremedies.com>
References: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com>
	<pan$c82c4$81d08e2c$7fe5940b$26a9f83b@cox.net>
	<36E90B61-31BA-41A2-8DFB-E2F4A65FF287@colorremedies.com>
	<568FD904-9402-47A7-A8F2-32445D20C3D6@colorremedies.com>
Date: Wed, 9 Oct 2013 09:01:23 +0200
Message-ID: <CAKZ=RP9p1aUHZ1OM_Cra4G_uNvEkR18rqvwi6Uco82wOJsfvdQ@mail.gmail.com>
Subject: Re: btrfs device delete problem
From: Alfredo Esteban <aedelatorre@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank a lot for your responses.

I already knew degraded mount but I wanted to solve the problem in a
consistent way and not continuing to mount in degraded mode.

I tried to add another device and "btrfs device delete missing /mnt"
but it failed. I also tried using balance filters and --force option
as Timofei pointed out but it failed too.

So finally I upgraded my kernel to 3.11, generated new raid1
filesystem on devices and copied data back to it.

Thanks again,

Alfredo

2013/10/7 Chris Murphy <lists@colorremedies.com>:
>
> On Oct 7, 2013, at 9:44 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> On Oct 7, 2013, at 4:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>>> Since your btrfs in raid1 mode has two devices currently, you won't be
>>> able to delete one of them as-is.  You will need to ADD a device first
>>> (bringing the total to three devices), optionally do a balance, and THEN
>>> delete the failed/missing/to-be-removed device (bringing the total back
>>> to two, which you never go below that way).
>>
>> Oops that's right, I forgot about this, and I have read the wiki! The other way to do it is to just pull the device, preferably with the file system unmounted. And then use it in degraded mode. I don't know if it's possible to convert a degraded volume, however.
>
> Jeez, do I write much? Disconnect the device you want removed from the volume. Mount the one you want to keep using with -o degraded.
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
