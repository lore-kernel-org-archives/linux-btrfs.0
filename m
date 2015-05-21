Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbbEUOkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 10:40:43 -0400
Date: Thu, 21 May 2015 16:40:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fsck.btrfs: Fix bashism and bad getopts processing
Message-ID: <20150521144040.GQ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150521115651.GP23255@twin.jikos.cz>
 <1432212655-6238-1-git-send-email-dimitri.j.ledkov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432212655-6238-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 01:50:55PM +0100, Dimitri John Ledkov wrote:
> First fix == bashism, as that is not accepted by e.g. Debian/Ubuntu
> dash.
> 
> Secondly shift OPTIND, such that last parameter is checked to exist.
> 
> Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>

Applied, thanks.
