Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab3CTMlm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 08:41:42 -0400
Date: Wed, 20 Mar 2013 13:41:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130320124140.GT7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130312170312.GO7229@twin.jikos.cz>
 <20130312180124.GB12725@shiny.masoncoding.com>
 <20130315120708.GE7229@twin.jikos.cz>
 <20130315131330.GE1980@localhost.localdomain>
 <20130315191241.GG1980@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130315191241.GG1980@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 03:12:41PM -0400, Josef Bacik wrote:
> I can't reproduce with btrfs-next or btrfs-next ontop of 3.9-rc2.  Can you just
> patch out the skinny metadata patch and see if the problem still happens?

Quick test does not reproduce the problems with 3.9-rc3 + current next,
scrub and fsck are clean. I take it as an OK, but will run the test
during the 3.9 cycle anyway.

david
