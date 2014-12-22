Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbaLVSir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 13:38:47 -0500
Date: Mon, 22 Dec 2014 19:38:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Terminology (was Re: [PATCH 6/7] Print the summary)
Message-ID: <20141222183845.GE6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
 <1418673780-22000-7-git-send-email-kreijack@inwind.it>
 <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
 <548FAB3A.7060009@pobox.com>
 <20141216090540.GK1442@carfax.org.uk>
 <549269CB.3010806@pobox.com>
 <20141218084131.GA25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141218084131.GA25267@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 18, 2014 at 08:41:31AM +0000, Hugo Mills wrote:
>    As I said at the time, maybe we need to revisit the RAID vocabulary
> completely and move to a more flexible terminology.
> 
>    David -- would you accept the cNsMpP patches if I revisted them?

I personally like the new naming scheme and would like to see it merged,
but I don't know about other devs so more acks are needed. The changes
in code do not apply now, but are fairly easy to forward port so I don't
urge you to do that. I've noticed a few backward compatibility issues
that are not addressed in the patches v2, eg. that the old raid naming
is not accepted in mkfs without an extra option.
