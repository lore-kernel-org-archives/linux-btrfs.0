Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52079 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751763Ab3G3RgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 13:36:10 -0400
Message-ID: <1375205770.2075.121.camel@joe-AO722>
Subject: Re: btrfs zero divide (was: Re: Linux 3.10 problem reports (yes,
 plural))
From: Joe Perches <joe@perches.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Thorsten Glaser <tg@mirbsd.de>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 10:36:10 -0700
In-Reply-To: <20130730171329.GF24583@localhost.localdomain>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	 <20130730171329.GF24583@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-07-30 at 13:13 -0400, Josef Bacik wrote:
> I've looked at all the places we do divides in this function and it
> doesn't look like we're doing this anywhere but I could be blind,

do_div seems a likely suspect...

	/*
	 * stripe_nr counts the total number of stripes we have to stride
	 * to get to this block
	 */
	do_div(stripe_nr, stripe_len);


