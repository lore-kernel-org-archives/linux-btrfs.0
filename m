Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbbACAIq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Jan 2015 19:08:46 -0500
Date: Sat, 3 Jan 2015 01:08:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: scrub wedged (both running and not running at the same time)
Message-ID: <20150103000844.GD6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <m87b4g$v19$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <m87b4g$v19$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2015 at 03:54:55PM -0800, Roger Binns wrote:
> I can't start a scrub because it is running, and can't cancel it
> because it isn't running!  How do I get out of this state?  OS is
> Ubuntu 14.10.

This has been fixed in btrfs-progs 3.16.2 by commit
d5fd05a773e2b19455be7e1208e9003a607483c6
