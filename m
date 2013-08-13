Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54129 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab3HMMMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 08:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <87a9kr3v2p.fsf@igel.home>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	<alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	<20130730171329.GF24583@localhost.localdomain>
	<Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	<20130730204001.GG24583@localhost.localdomain>
	<87eha33v9f.fsf@igel.home>
	<87a9kr3v2p.fsf@igel.home>
Date: Tue, 13 Aug 2013 14:12:04 +0200
Message-ID: <CAMuHMdWWz7EmU0-OyM+hnBss4AZjR30tLsRbBVsXF0cy2THMyA@mail.gmail.com>
Subject: Re: btrfs zero divide
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>,
        Joe Perches <joe@perches.com>,
        "Debian GNU/Linux m68k" <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 9, 2013 at 2:30 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Andreas Schwab <schwab@linux-m68k.org> writes:
>> Josef Bacik <jbacik@fusionio.com> writes:
>>> So stripe_len shouldn't be 0, if it is you have bigger problems :).

[ lost context: this is about the first do_div() in __btrfs_map_block() ]

>> The bigger problem is that stripe_nr is u64, this is completely bogus.
>> The first operand of do_div must be u32.  This goes through the whole
>> file.
>
> Of course, what I meant was that the *second* operand must be u32, but
> that doesn't change my point.

I checked all do_div() implementations, and (unless I missed one) m68k and
mn10300 were the only two that didn't truncate base to 32 bits.

Mn10300 is little endian, so I think the problem won't happen there.

Andreas, I'll apply your patch
(http://permalink.gmane.org/gmane.linux.ports.m68k/5008)
with the crash log added to the commit message, so it's appropriate for -stable.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
