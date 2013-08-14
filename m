Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49723 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758532Ab3HNSHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 14:07:46 -0400
Message-ID: <1376503665.1949.98.camel@joe-AO722>
Subject: Re: btrfs zero divide
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Zach Brown <zab@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Chris Mason <chris.mason@fusionio.com>,
        scsi <linux-scsi@vger.kernel.org>
Date: Wed, 14 Aug 2013 11:07:46 -0700
In-Reply-To: <CAMuHMdV-nBbhKbVSAAwh5M45-7kz4RJRqfHrCfudRA5dE2CKoA@mail.gmail.com>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	 <20130730171329.GF24583@localhost.localdomain>
	 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	 <20130730204001.GG24583@localhost.localdomain> <87eha33v9f.fsf@igel.home>
	 <20130809180441.GB12314@lenny.home.zabbo.net>
	 <alpine.DEB.2.02.1308131714130.12565@ayla.of.borg>
	 <CAMuHMdXu+j03r_TQWC74e1dZzi6n9DsdBj_gRfrznW-VzzyTHQ@mail.gmail.com>
	 <CAMuHMdV-nBbhKbVSAAwh5M45-7kz4RJRqfHrCfudRA5dE2CKoA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2013-08-14 at 10:56 +0200, Geert Uytterhoeven wrote:
> These bring in the 64-bit divisor from somewhere else, so they're less
> trivial to fix.

Using div64_u64 or div64_s64 could fix it.
Maybe that could be added to do_div too.

