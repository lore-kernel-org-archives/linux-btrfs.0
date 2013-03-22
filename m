Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3CVMFF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 08:05:05 -0400
Date: Fri, 22 Mar 2013 13:05:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Simon Kirby <sim@hostway.ca>
Subject: Re: [PATCH v2] Btrfs: Include the device in most error printk()s
Message-ID: <20130322120501.GN31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130319224123.GA4779@hostway.ca>
 <20130321134950.GI31559@twin.jikos.cz>
 <20130321175819.30044.75697@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130321175819.30044.75697@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 21, 2013 at 01:58:19PM -0400, Chris Mason wrote:
> I really like this patch, but we're going to have to sit on it until the
> next merge window.  It's fairly large and we need to stick with things
> that are more clearly bug fixes for now.
> 
> But, I don't have a problem with queuing it into linux-next.  After the
> next rc we can get Josef's tree into the full linux-next for more
> testing.

I agree, this is not for current dev cycle, we may want to tweak the
messages and transform more printks to the enhanced format.

david
