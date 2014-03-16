Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaCPMM0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 08:12:26 -0400
Date: Sun, 16 Mar 2014 13:12:24 +0100
From: Arvin Schnell <aschnell@suse.de>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Snapper on Ubuntu
Message-ID: <20140316121224.GA15418@suse.de>
References: <53245E22.1060407@friedels.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <53245E22.1060407@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 15, 2014 at 03:05:22PM +0100, Hendrik Friedel wrote:

> When I install snapper I configure it like this
> snapper -c rt create-config /
> snapper -c home create-config /home
> snapper -c root create-config /root
> snapper -c Video create-config /mnt/BTRFS/Video/

Just a recommendation about the config names. At least on
openSUSE "root" is used for /. I would suggest to use "home_root"
for /root like the pam-snapper module does.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
