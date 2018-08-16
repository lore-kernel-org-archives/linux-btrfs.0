Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbeHPQDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:03:53 -0400
Date: Thu, 16 Aug 2018 15:05:15 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
Message-ID: <20180816130515.GR24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <31114.1534417285@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <31114.1534417285@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2018 at 12:01:25PM +0100, David Howells wrote:
> I'm trying to convert btrfs to use the new mount API stuff and I'm finding it
> hard to work out the relationships between some of the arguments, specifically
> datacow, datasum and compress*.
> 
> What I see is that enabling datasum implies enabling datacow and that
> disabling datacow implies disabling datasum - which seems reasonable.
> 
> However, selecting compression implies enabling datacow and datasum, and
> disabling datacow, as one might expect, disables compression - but disabling
> datasum does not.  Is that correct?

No it's not. Compression needs the checksums so nodatasum should disable
compression, which is missing as you found out.

This invalid combination also causes some problems during device
replace, but this was fixed in 4.18, so the missing part are the mount
options.
