Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3CKOOW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 10:14:22 -0400
Date: Mon, 11 Mar 2013 15:14:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, sam tygier <samtygier@yahoo.co.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130311141418.GB7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <513CAA25.2010803@gmail.com>
 <khj5l7$ge9$1@ger.gmane.org>
 <20130310234953.GH30771@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130310234953.GH30771@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 11:49:53PM +0000, Hugo Mills wrote:
> > Using an asterisk '*' in something will be used as a command line argument risks having the shell expand it. Sticking to pure alphanumeric names would be better.
> 
>    Yeah, David's just pointed this out on IRC. After a bit of fiddling
> around with various options, I like using X.

I'd like to see something that can exist as na identifier or can be
copy-pasted in one click, but '*' being a shell meta-character is IMO
stronger argument against using it.

>    I'm also going to use lowercase c,s,p, because it seems to be
> easier to read with the different-height characters. So we end up
> with, e.g.
> 
> 1c      (single)
> 2cXs    (RAID-10)
> 1cXs2p  (RAID-6)

This form looks ok to me.

david
