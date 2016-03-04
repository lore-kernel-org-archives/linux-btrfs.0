Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbcCDS52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 13:57:28 -0500
Date: Fri, 4 Mar 2016 19:57:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Ondrej Kozina <okozina@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] remove max/min macros from libbtrfs API
Message-ID: <20160304185710.GB30625@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457099171-24095-1-git-send-email-okozina@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457099171-24095-1-git-send-email-okozina@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 04, 2016 at 02:46:10PM +0100, Ondrej Kozina wrote:
> Hello btrfs-progs,
> 
> can we move the min/max macros away from libbtrfs public API? This may cause conflict
> while compiling i.e. snapper with gcc 6.0 (aka with -std=gnu++14). The thing
> is I don't see a point why those macros should be kept in kerncompat.h at all. Such macros
> are used solely in btrfs-progs internals and there's no need to expose them in API.

Yeah, the libbtrfs headers are unfortunatelly not namespace-clean.
