Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34732 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282Ab3HIOfj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 10:35:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2C3747C067B
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 08:35:39 -0600 (MDT)
Date: Fri, 9 Aug 2013 10:35:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>,
        Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
Message-ID: <20130809143537.GA861@localhost.localdomain>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>
 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
 <20130730204001.GG24583@localhost.localdomain>
 <87eha33v9f.fsf@igel.home>
 <87a9kr3v2p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87a9kr3v2p.fsf@igel.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 02:30:38PM +0200, Andreas Schwab wrote:
> Andreas Schwab <schwab@linux-m68k.org> writes:
> 
> > Josef Bacik <jbacik@fusionio.com> writes:
> >
> >> So stripe_len shouldn't be 0, if it is you have bigger problems :).
> >
> > The bigger problem is that stripe_nr is u64, this is completely bogus.
> > The first operand of do_div must be u32.  This goes through the whole
> > file.
> 
> Of course, what I meant was that the *second* operand must be u32, but
> that doesn't change my point.
> 

Yeah we can change this.  Thanks,

Josef
