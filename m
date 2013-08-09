Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574Ab3HISF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 14:05:29 -0400
Date: Fri, 9 Aug 2013 11:04:41 -0700
From: Zach Brown <zab@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>,
        Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
Message-ID: <20130809180441.GB12314@lenny.home.zabbo.net>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>
 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
 <20130730204001.GG24583@localhost.localdomain>
 <87eha33v9f.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87eha33v9f.fsf@igel.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 02:26:36PM +0200, Andreas Schwab wrote:
> Josef Bacik <jbacik@fusionio.com> writes:
> 
> > So stripe_len shouldn't be 0, if it is you have bigger problems :).
> 
> The bigger problem is that stripe_nr is u64, this is completely bogus.
> The first operand of do_div must be u32.  This goes through the whole
> file.

Definitely.  Can we get some typeof() tricks in the macros to have the
build fail if (when, evidently) someone gets it wrong?

- z
