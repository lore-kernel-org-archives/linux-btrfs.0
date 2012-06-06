Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2FFANp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 20:13:45 -0400
Received: by pbbrp8 with SMTP id rp8so8143443pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 17:13:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338941247.11962.16.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
 <1338934303.5780.8.camel@joe2Laptop> <20120605151754.a794ac7c.akpm@linux-foundation.org>
 <1338936572.5780.29.camel@joe2Laptop> <20120605162910.caccb0d4.akpm@linux-foundation.org>
 <1338939316.11962.3.camel@joe2Laptop> <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
 <1338939792.11962.4.camel@joe2Laptop> <CAPXgP10DEsqtz9xbPUQ3xCwdFGTTYyTGSd7yEcU2vUr3SJ83Sw@mail.gmail.com>
 <1338940345.11962.9.camel@joe2Laptop> <20120605165808.cd255b93.akpm@linux-foundation.org>
 <1338941247.11962.16.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 6 Jun 2012 02:13:24 +0200
Message-ID: <CAPXgP12OFnh6FZO4zFGCw=Ea4U6Ne5OoCg_9BPxRX62x0EVnng@mail.gmail.com>
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

On Wed, Jun 6, 2012 at 2:07 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-06-05 at 16:58 -0700, Andrew Morton wrote:
>>  echo "\0014Hello Joe" > /dev/kmsg
>
> # echo -e "\x014Hello Me" > /dev/kmsg
> gives:
> 12,778,4057982669;Hello Me
>
> #echo -e "\x011Hello Me_2" > /dev/kmsg
> gives:
> 12,779,4140452093;Hello Me_2
>
> I didn't change devkmsg_writev so the
> original parsing style for "<.>" is
> unchanged.
>
> from printk.c:
>
> static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
>                              unsigned long count, loff_t pos)
> [...]
>        int level = default_message_loglevel;
> [...]
>        if (line[0] == '<') {
>                char *endp = NULL;
>
>                i = simple_strtoul(line+1, &endp, 10);
>                if (endp && endp[0] == '>') {
>                        level = i & 7;
>                        if (i >> 3)
>                                facility = i >> 3;
>                        endp++;
>                        len -= endp - line;
>                        line = endp;
>                }
>        }
>        line[len] = '\0';
>
>        printk_emit(facility, level, NULL, 0, "%s", line);
> []
>
> level is what matters.
>
> from dmesg -r
>
> <12>[ 2462.339252] \001Hello Andrew
> <9>[ 2516.023444] Hello Andrew
> <12>[ 3046.752764] \x01Hello Kay
> <12>[ 3940.871850] \x01Hello Kay
> <12>[ 4057.982669] Hello Me
> <12>[ 4140.452093] Hello Me_2

The question is what happens if you inject your new binary two-byte
prefix, like:
  echo -e "\x01\x02Hello" > /dev/kmsg

And if that changes the log-level to "2" instead of the default "4"?

(assuming that I read your patch right, otherwise please correct the
bytes, but use the full sequence which your patch will recognize as an
internal level marker; seems your examples are all not triggering that)

Kay
