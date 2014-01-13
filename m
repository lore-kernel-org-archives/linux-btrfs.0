Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaAMS4i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 13:56:38 -0500
Date: Mon, 13 Jan 2014 19:56:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Subject: Re: btrfs send: page allocation failure
Message-ID: <20140113185636.GU6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <52D3E308.7060309@jrs-s.net>
 <20140113182312.GR6498@twin.jikos.cz>
 <52D4326B.6040009@jrs-s.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D4326B.6040009@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 01:37:31PM -0500, Jim Salter wrote:
> What makes you believe that? The bug filed there appears to be related to
> defragging, which I am not doing either manually or automatically.

The quota groups are on and the symptoms match the known problem when
there are lots of backrefs.
krealloc is on the stack although not mentioned explicitly, called
through ulist_add_merge. The allocation order is 6 from the OOM report,
means that somebody wanted a large congiguous chunk of memory, which is
what the krealloc did and failed. Kernel memory is fragmented and this
kind of allocations is hard to satisfy in the long run.

david
