Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:57507 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAMTDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 14:03:53 -0500
Message-ID: <52D43898.5080801@jrs-s.net>
Date: Mon, 13 Jan 2014 14:03:52 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Subject: Re: btrfs send: page allocation failure
References: <52D3E308.7060309@jrs-s.net> <20140113182312.GR6498@twin.jikos.cz> <52D4326B.6040009@jrs-s.net> <20140113185636.GU6498@suse.cz>
In-Reply-To: <20140113185636.GU6498@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, thanks. If kernel memory fragmentation is a big factor, that would 
also explain why it succeeds after a reboot but does not succeed after 
weeks of uptime...

On 01/13/2014 01:56 PM, David Sterba wrote:
> On Mon, Jan 13, 2014 at 01:37:31PM -0500, Jim Salter wrote:
>> What makes you believe that? The bug filed there appears to be related to
>> defragging, which I am not doing either manually or automatically.
> The quota groups are on and the symptoms match the known problem when
> there are lots of backrefs.
> krealloc is on the stack although not mentioned explicitly, called
> through ulist_add_merge. The allocation order is 6 from the OOM report,
> means that somebody wanted a large congiguous chunk of memory, which is
> what the krealloc did and failed. Kernel memory is fragmented and this
> kind of allocations is hard to satisfy in the long run.
>
> david

