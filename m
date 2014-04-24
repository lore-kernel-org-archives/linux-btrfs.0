Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57381 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaDXG1K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 02:27:10 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so1809617wgh.12
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 23:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1B72A2CD-1F52-459C-B9AE-639B6937AC0F@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
	<1B72A2CD-1F52-459C-B9AE-639B6937AC0F@colorremedies.com>
Date: Thu, 24 Apr 2014 13:27:08 +0700
Message-ID: <CAG1y0sfa59+U0Mch_3hBHkszs-nUcKxKJ4G=H36U2hH5rm5wGg@mail.gmail.com>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 10:23 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> It sounds like either a grub.cfg misconfiguration, or a failure to correctly build the initrd/initramfs. So I'd post the grub.cfg kernel command line for the boot entry that works and the entry that fails, for comparison.
>
> And then also check and see if whatever utility builds your initrd has been upgraded along with your kernel, maybe there's a bug/regression.
>

I believe the OP mentioned that he's using a distro without initrd,
and that all required modules are built in.

-- 
Fajar


>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
