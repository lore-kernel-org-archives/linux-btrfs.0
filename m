Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaBTSNs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 13:13:48 -0500
Date: Thu, 20 Feb 2014 19:13:47 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/8] Allow use of get_device_info()
Message-ID: <20140220181347.GX16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52FD1A72.5060307@libero.it>
 <52FD1AD0.70201@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FD1AD0.70201@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 08:19:44PM +0100, Goffredo Baroncelli wrote:
> 
> Allow the use of get_device_info()  for different units.

FYI, I'll move this patch to integration base, it's a simple and
isolated change.
