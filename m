Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbaCPRpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 13:45:55 -0400
Date: Sun, 16 Mar 2014 18:45:53 +0100
From: Arvin Schnell <aschnell@suse.de>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Snapper on Ubuntu
Message-ID: <20140316174553.GA7788@suse.de>
References: <53245E22.1060407@friedels.name> <20140316121224.GA15418@suse.de> <5325D822.6020609@friedels.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <5325D822.6020609@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 16, 2014 at 05:58:10PM +0100, Hendrik Friedel wrote:

> > Just a recommendation about the config names. At least on
> > openSUSE "root" is used for /. I would suggest to use "home_root"
> > for /root like the pam-snapper module does.
>
> thanks for the advise.
>
> In fact on a previous try I had -by chance- used exactly this nomenclature. 
> Then I restarted
>
> Now, can I just rename the files in /etc/snapper/configs and the entries in 
> /etc/sysconfig/snapper?

Yes, that should work. Just make sure to kill snapperd before.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
