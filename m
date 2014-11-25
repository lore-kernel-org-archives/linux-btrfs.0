Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYQNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:13:44 -0500
Date: Tue, 25 Nov 2014 17:13:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] New 'btrfs chunk list' command
Message-ID: <20141125161343.GI26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 04:57:21PM +0100, Goffredo Baroncelli wrote:
> This is a revamp of a my previous patches set[1]. After more than
> year of attempts these patches were never merged, so I tried to
> simplify them and to change a bit the focus. The previous patches set
> had the focus to the disk usage.

The patches have been pending for last releases but I did not manage to
fix all accounting problems in time and did not want to delay the
releaes due to other important fixes. The 'new df' patchset is being
refreshed each time and is part of the integration branches which might
signify that they haven't been lost.
