Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37181 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2FFA3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 20:29:00 -0400
Received: by pbbrp8 with SMTP id rp8so8156587pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 17:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338941971.11962.20.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
 <1338934303.5780.8.camel@joe2Laptop> <20120605151754.a794ac7c.akpm@linux-foundation.org>
 <1338936572.5780.29.camel@joe2Laptop> <20120605162910.caccb0d4.akpm@linux-foundation.org>
 <1338939316.11962.3.camel@joe2Laptop> <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
 <1338939792.11962.4.camel@joe2Laptop> <CAPXgP10DEsqtz9xbPUQ3xCwdFGTTYyTGSd7yEcU2vUr3SJ83Sw@mail.gmail.com>
 <1338940345.11962.9.camel@joe2Laptop> <20120605165808.cd255b93.akpm@linux-foundation.org>
 <1338941247.11962.16.camel@joe2Laptop> <CAPXgP12OFnh6FZO4zFGCw=Ea4U6Ne5OoCg_9BPxRX62x0EVnng@mail.gmail.com>
 <1338941971.11962.20.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 6 Jun 2012 02:28:39 +0200
Message-ID: <CAPXgP10VE2huY4gGpeFPe=YKYM+nDBfoMgpHnGmQwn0jdPxhbw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 6, 2012 at 2:19 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-06-06 at 02:13 +0200, Kay Sievers wrote:
>> The question is what happens if you inject your new binary two-byte
>> prefix, like:
>>   echo -e "\x01\x02Hello" > /dev/kmsg
>
> It's not a 2 byte binary.
> It's a leading ascii SOH and a standard ascii char
> '0' ... '7' or 'd'.
>
> #define KERN_EMERG      KERN_SOH "0"    /* system is unusable */
> #define KERN_ALERT      KERN_SOH "1"    /* action must be taken immediately */
> etc...

Ok.

>> And if that changes the log-level to "2" instead of the default "4"?
>
> No it doesn't.

So:
   echo -e "\x012Hello" > /dev/kmsg
is still level 4? Sounds all fine then.

> It's not triggering that because devkmsg_writev does
> prefix parsing only on the old "<n>" form.

Yeah, but printk_emit() will not try to parse it? I did not check, but
with your change, the prefix parsing in printk_emit() is still skipped
if a level is given as a parameter to printk_emit(), right?

Kay
