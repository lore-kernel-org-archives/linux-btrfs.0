Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbFYNDp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 09:03:45 -0400
Date: Thu, 25 Jun 2015 15:03:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Sjoerd <sjoerd@sjomar.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150625130343.GG726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <7324923.Sa0lmcTP0G@hoefnix>
 <20150623144501.GE6761@twin.jikos.cz>
 <2238718.GK9ft1D4VD@hoefnix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2238718.GK9ft1D4VD@hoefnix>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 10:26:05PM +0200, Sjoerd wrote:
> Thanks for the link...I updated it...The updated version breaks the 
> btrfsQuota.sh and btrfsQuota.py script from the wiki though :(

I see, but the scripts are likely to break anytime due to changes in the
qgroup output interfaces. You should rather take them as an example. The
preferred way to is to ehnance the tools but this might be harder than
maintaining own script.
