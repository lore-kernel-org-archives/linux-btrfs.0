Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37543 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2HMEtq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 00:49:46 -0400
Received: by qaas11 with SMTP id s11so1619970qaa.19
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Aug 2012 21:49:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL113-DS2059BCB791EE611DDBA0A5B0B00@phx.gbl>
References: <5027DDFC.60504@pocock.com.au>
	<CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
	<COL113-DS2059BCB791EE611DDBA0A5B0B00@phx.gbl>
Date: Mon, 13 Aug 2012 11:49:45 +0700
Message-ID: <CAG1y0sdP1D_ecJ4XGyMGLYDpFoRc_Mkf0zRy0Zet6KpgfZW5VA@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Kyle Gates <kylegates@hotmail.com>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 13, 2012 at 11:19 AM, Kyle Gates <kylegates@hotmail.com> wrote:
> Also, I think the current grub2 has lzo support.

You're right

grub2 (1.99-18) unstable; urgency=low

  [ Colin Watson ]
...
  * Backport from upstream:
    - Add support for LZO compression in btrfs (LP: #727535).

so Ubuntu has it since precise, which is roughly the time I switched
to zfs for rootfs :P

Thanks for letting us know about that.

-- 
Fajar
