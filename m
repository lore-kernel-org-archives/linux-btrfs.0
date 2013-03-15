Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab3COMHL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 08:07:11 -0400
Date: Fri, 15 Mar 2013 13:07:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130315120708.GE7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130312170312.GO7229@twin.jikos.cz>
 <20130312180124.GB12725@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130312180124.GB12725@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 02:01:24PM -0400, Chris Mason wrote:
> Please go back to just 3.9-rc2 and see if you can trigger it.  Josef put
> his skinny extents into btrfs-next/master, which is pretty exciting but
> may be related to these failures.
> 
> I'm unable to reproduce here so far.

Me neither, 3.9-rc2 with top commit (a2362d24764a4e9a3187fc).

david
