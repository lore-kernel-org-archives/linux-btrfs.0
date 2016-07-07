Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35975 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbcGGR5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 13:57:10 -0400
Received: by mail-oi0-f52.google.com with SMTP id f189so33597512oig.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 10:57:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 11:57:08 -0600
Message-ID: <CAJCQCtRV2Eis8h9u_Mpum_pFoLzOQe+LjooO0Y4_AYqwsVBiMA@mail.gmail.com>
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Francesco Turco <fturco@fastmail.fm>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 7:49 AM, Francesco Turco <fturco@fastmail.fm> wrote:

> $ btrfs filesystem show
> /run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3
> $

Try it with sudo. I think it's a bug that 'btrfs fi show' returns
silently for non-root. It should produce an error that root privileges
are needed, or it should work for unprivileged users.




> Btrfs-check reports many errors. I attached the output to this e-mail
> message.
>
> Output from dmesg:
>
> $ dmesg | tail
> [18756.159963] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904

The problem happened before this, so I think we need the entire dmesg.



> I checked this USB flash drive with badblocks in non-destructive
> read-write mode. No errors.

Use F3 to test flash:
http://oss.digirati.com.br/f3/

Some distros have it in their repo, Fedora does. It's a bit
unintuitive what you need to do is use the write binary to write the
test files to the stick (this is destructive) and then use the read
binary to read back the written files.

Read more, and also includes a much faster alternative for GNOME:
https://blogs.gnome.org/hughsie/2015/01/28/detecting-fake-flash/




-- 
Chris Murphy
