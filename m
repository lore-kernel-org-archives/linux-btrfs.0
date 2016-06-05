Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33416 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbcFEUdF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 16:33:05 -0400
Received: by mail-qk0-f169.google.com with SMTP id n63so80476596qkf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 13:33:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP235FBB8882371723DF217EA925B0@phx.gbl>
References: <BLU436-SMTP235FBB8882371723DF217EA925B0@phx.gbl>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Sun, 5 Jun 2016 16:33:03 -0400
Message-ID: <CAD=QJKg0GVGn06+zurHEy5jx3woNrKcP_XdtDBH2RjStmapKSw@mail.gmail.com>
Subject: Re: check if hardware checksumming works or not
To: Alberto Bursi <alberto.bursi@outlook.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alberto,

On 5 June 2016 at 15:37, Alberto Bursi <alberto.bursi@outlook.it> wrote:
>
> Hi, I'm running Debian ARM on a Marvell Kirkwood-based 2-disk NAS.
>
> Kirkwood SoCs have a XOR engine that can hardware-accelerate crc32c
> checksumming, and from what I see in kernel mailing lists it seems to have a
> linux driver and should be supported.
>
> I wanted to ask if there is a way to test if it is working at all.
>
> How do I force btrfs to use software checksumming for testing purposes?

Is there a mv_xor.ko module you can blacklist?  I'm not familiar with
the platform, but I imagine you'll have to blacklist it and reboot,
because I'm guessing the module can't be removed once it's loaded.

'just a guess,
Nicholas
