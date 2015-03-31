Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbbCaRFT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 13:05:19 -0400
Date: Tue, 31 Mar 2015 19:05:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc Cousin <cousinmarc@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
Message-ID: <20150331170516.GD6821@suse.cz>
Reply-To: dsterba@suse.cz
References: <550E7917.5030602@gmail.com>
 <20150325011937.GB20767@twin.jikos.cz>
 <55129428.7090508@gmail.com>
 <20150330142532.GI32051@suse.cz>
 <55196740.1000705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55196740.1000705@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 05:09:52PM +0200, Marc Cousin wrote:
> > So it would be good to sample the active threads and see where it's
> > spending the time. It could be the somewhere in the rb-tree representing
> > extents, but that's a guess.
> > 
> I just need to be told how to do that :)
> 
> Something like a perf top ?

for i in `pgrep btrfs`; do
        ps $i
	sudo cat /proc/$i/stack 2>/dev/null
done

and capture samples every second.
