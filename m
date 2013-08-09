Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:39509 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3HIM0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 08:26:49 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Thorsten Glaser <tg@mirbsd.de>, Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	<alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	<20130730171329.GF24583@localhost.localdomain>
	<Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	<20130730204001.GG24583@localhost.localdomain>
Date: Fri, 09 Aug 2013 14:26:36 +0200
In-Reply-To: <20130730204001.GG24583@localhost.localdomain> (Josef Bacik's
	message of "Tue, 30 Jul 2013 16:40:01 -0400")
Message-ID: <87eha33v9f.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fusionio.com> writes:

> So stripe_len shouldn't be 0, if it is you have bigger problems :).

The bigger problem is that stripe_nr is u64, this is completely bogus.
The first operand of do_div must be u32.  This goes through the whole
file.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
